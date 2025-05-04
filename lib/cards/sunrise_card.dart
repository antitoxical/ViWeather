import 'package:flutter/material.dart';
import 'package:viweather1/theme/app_colors.dart';
import 'package:viweather1/widgets/weather_card_base.dart';
import 'package:intl/intl.dart';
import 'package:viweather1/screens/sunrise_screen.dart';

class SunriseSunsetCard extends StatelessWidget {
  final DateTime sunrise;
  final DateTime sunset;
  final String condition;
  final bool isDay;
  final VoidCallback? onTap;

  const SunriseSunsetCard({
    super.key,
    required this.sunrise,
    required this.sunset,
    required this.condition,
    this.isDay = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _showSunTimesDetails(context),
      child: WeatherCardBase(
        condition: condition,
        isDay: isDay,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.wb_sunny,
                  color: AppColors.iconColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Sunrise & Sunset',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSunTimes(),
          ],
        ),
      ),
    );
  }

  Widget _buildSunTimes() {
    final timeFormat = DateFormat('HH:mm');
    final sunriseTime = timeFormat.format(sunrise);
    final sunsetTime = timeFormat.format(sunset);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sunriseTime,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Sunrise',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              sunsetTime,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Sunset',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showSunTimesDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SunriseSunsetDetailScreen(
          sunrise: sunrise,
          sunset: sunset,
          isDay: isDay,
        ),
      ),
    );
  }
}