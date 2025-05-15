import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:viweather1/theme/app_colors.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:viweather1/widgets/weather_card_base.dart';


class HumidityChart extends StatelessWidget {
  final List<double> humidities;
  final String timezone;
  final bool isDay;

  const HumidityChart({
    Key? key,
    required this.humidities,
    required this.timezone,
    required this.isDay,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    if (humidities.length != 24) {
      print('Warning: Expected 24 humidity values, got {humidities.length}');
      return const Center(child: Text('Insufficient data to build the chart'));
    }
    tz.initializeTimeZones();
    final now = tz.TZDateTime.now(tz.getLocation(timezone));
    final List<String> timeLabels = List.generate(6, (index) {
      final hour = (now.hour + index) % 24;
      final formattedHour = hour.toString().padLeft(2, '0');
      return '$formattedHour:00';
    });
    final displayHumidities = List<double>.generate(6, (index) {
      final hourIndex = (now.hour + index) % 24;
      return humidities[hourIndex];
    });
    return Container(

      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Humidity by Hour',
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
                  horizontalInterval: 5,
                  verticalInterval: 1,
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
                      interval: 5,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}%',
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
                minY: displayHumidities.reduce((a, b) => a < b ? a : b) - 5,
                maxY: displayHumidities.reduce((a, b) => a > b ? a : b) + 5,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      displayHumidities.length,
                          (index) => FlSpot(index.toDouble(), displayHumidities[index]),
                    ),
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.blue,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.1),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.blue.withOpacity(0.2),
                          Colors.blue.withOpacity(0.0),
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
