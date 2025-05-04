import 'package:flutter/material.dart';
import 'package:viweather1/theme/app_colors.dart';
import 'package:viweather1/widgets/weather_card_base.dart';
import 'package:viweather1/screens/air_quality_screen.dart';

class AirQualityCard extends StatelessWidget {
  final int? aqi;
  final String description;
  final String condition;
  final bool isDay;
  final VoidCallback? onTap;

  const AirQualityCard({
    Key? key,
    this.aqi,
    required this.description,
    this.condition = 'Clear',
    this.isDay = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _showAQIDetails(context),
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
                  'Air Quality',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAQIInfo(),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAQIInfo() {
    if (aqi == null) return const Text('No data available');

    final color = _getAQIColor(aqi!);
    final aqiDescription = _getAQIDescription(aqi!);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          'AQI: ',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          aqi!.toString(),
          style: TextStyle(
            color: color,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          aqiDescription,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showAQIDetails(BuildContext context) {
    if (aqi == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AirQualityDetailScreen(
          aqi: aqi!,
          isDay: isDay,
        ),
      ),
    );
  }

  Color _getAQIColor(int aqi) {
    if (aqi <= 50) return const Color(0xFF4CAF50);
    if (aqi <= 100) return const Color(0xFFFFC107);
    if (aqi <= 150) return const Color(0xFFFF9800);
    if (aqi <= 200) return const Color(0xFFF44336);
    if (aqi <= 300) return const Color(0xFF9C27B0);
    return const Color(0xFF795548);
  }

  String _getAQIDescription(int aqi) {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy for groups';
    if (aqi <= 200) return 'Unhealthy';
    if (aqi <= 300) return 'Very unhealthy';
    return 'Hazardous';
  }
}