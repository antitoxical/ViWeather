import 'package:flutter/material.dart';
import 'package:viweather1/theme/app_colors.dart';
import 'package:viweather1/widgets/weather_card_base.dart';
import 'package:viweather1/screens/humidity_screen.dart';
import 'package:viweather1/models/weather_model.dart';


class HumidityCard extends StatelessWidget {
  final double humidity;
  final double dewPoint;
  final String condition;
  final bool isDay;
  final List<HourlyForecast>? hourlyData;
  final VoidCallback? onTap;
  final String timezone;

  const HumidityCard({
    Key? key,
    required this.humidity,
    required this.dewPoint,
    required this.condition,
    required this.isDay,
    required this.timezone,
    this.hourlyData,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _showHumidityDetails(context),
      child: WeatherCardBase(
        condition: condition,
        isDay: isDay,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(

              children: [
                Icon(
                  Icons.water_drop,
                  color: AppColors.iconColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Humidity',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${humidity.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Dew point: ${dewPoint.toStringAsFixed(1)}°',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showHumidityDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HumidityDetailScreen(
          humidity: humidity,
          dewPoint: dewPoint,
          isDay: isDay,
          hourlyData: hourlyData,
          timezone: timezone,
        ),
      ),
    );
  }
}