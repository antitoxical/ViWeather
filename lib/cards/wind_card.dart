import 'package:flutter/material.dart';
import 'package:viweather1/theme/app_colors.dart';
import 'package:viweather1/widgets/weather_card_base.dart';
import 'package:viweather1/screens/wind_screen.dart';
import 'package:viweather1/models/weather_model.dart';

class WindCard extends StatelessWidget {
  final double windSpeed;
  final double windGusts;
  final String windDirection;
  final String condition;
  final bool isDay;
  final double maxDailyWind;
  final double yesterdayMaxWind;
  final VoidCallback? onTap;
  final List<HourlyForecast>? hourlyData;
  final String timezone;


  const WindCard({
    Key? key,
    required this.windSpeed,
    required this.windGusts,
    required this.windDirection,
    required this.condition,
    required this.maxDailyWind,
    required this.yesterdayMaxWind,
    required this.timezone,
    this.isDay = true,
    this.onTap,
    this.hourlyData,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _showWindDetails(context),
      child: WeatherCardBase(
        condition: condition,
        isDay: isDay,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.air,
                  color: AppColors.iconColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Wind',
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
                      '${windSpeed.toStringAsFixed(1)} km/h',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Wind Gusts ${windGusts.toStringAsFixed(1)} km/h',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Wind Direction: $windDirection',
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

  void _showWindDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WindDetailScreen(
          currentWindSpeed: windSpeed,
          currentWindGusts: windGusts,
          currentWindDirection: windDirection,
          maxDailyWind: maxDailyWind,
          yesterdayMaxWind: yesterdayMaxWind,
          isDay: isDay,
          hourlyData: hourlyData,
          timezone:timezone,
        ),
      ),
    );
  }
}