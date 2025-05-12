import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:viweather1/models/weather_model.dart';

import '../services/weather_service.dart';

class HourlyChart extends StatelessWidget {
  final List<HourlyForecast> hourlyData;
  final String metric;
  final String unit;
  final Color lineColor;
  final Color gradientColor;
  final double Function(HourlyForecast) valueExtractor;
  final String timezone;

  const HourlyChart({
    Key? key,
    required this.hourlyData,
    required this.metric,
    required this.unit,
    required this.lineColor,
    required this.gradientColor,
    required this.valueExtractor,
    required this.timezone,
  }) : super(key: key);

  String? get time => null;

  @override
  Widget build(BuildContext context) {
    // Инициализация timezone данных
    tz.initializeTimeZones();
    final location = tz.getLocation(timezone);
    final now = tz.TZDateTime.now(location);

    // Создаём метки времени (следующие 6 часов)
    final timeLabels = List.generate(6, (index) {
      final time = now.add(Duration(hours: index));
      return DateFormat('HH:mm').format(time);
    });

    // Получаем значения для графика
    final displayValues = <double>[];
    for (int i = 0; i < 6; i++) {
      final targetTime = now.add(Duration(hours: i));

      // Ищем соответствующий прогноз в hourlyData
      final forecast = hourlyData.firstWhere(
            (item) {
          final itemTime = DateTime.tryParse(time!);
          return itemTime?.hour == targetTime.hour;
        },
         // Заглушка если данные не найдены
      );

      // Извлекаем значение с проверкой на null
      final value = valueExtractor(forecast);
      displayValues.add(value.isFinite ? value : 0.0);
    }

    double minValue = displayValues.reduce((a, b) => a < b ? a : b);
    double maxValue = displayValues.reduce((a, b) => a > b ? a : b);

    // Добавляем защиту от нулевого диапазона
    if (minValue == maxValue) {
      minValue -= 1; // уменьшаем минимальное значение на 1
      maxValue += 1; // увеличиваем максимальное значение на 1
    }

    final double range = maxValue - minValue;
    final double minY = minValue - range * 0.1; // 10% padding снизу
    final double maxY = maxValue + range * 0.1; // 10% padding сверху

    // Рассчитываем интервалы сетки
    final double horizontalInterval = (maxY - minY) / 5;
    final double verticalInterval = 1;

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$metric ($unit)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: horizontalInterval > 0 ? horizontalInterval : 1, // Защита от нуля
                  verticalInterval: verticalInterval,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < timeLabels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              timeLabels[value.toInt()],
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: (maxY - minY) / 5,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toStringAsFixed(1)}$unit',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                minX: 0,
                maxX: 5,
                minY: minY,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      displayValues.length,
                          (index) => FlSpot(index.toDouble(), displayValues[index]),
                    ),
                    isCurved: true,
                    color: lineColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: lineColor,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: gradientColor.withOpacity(0.1),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          gradientColor.withOpacity(0.2),
                          gradientColor.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}