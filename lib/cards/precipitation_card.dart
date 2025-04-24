import 'package:flutter/material.dart';
import 'package:viweather1/theme/app_colors.dart';
import 'package:viweather1/widgets/weather_card_base.dart';

class PrecipitationCard extends StatelessWidget {
  final double precipitation;
  final String description;
  final String condition;
  final bool isDay;

  const PrecipitationCard({
    super.key,
    required this.precipitation,
    required this.description,
    required this.condition,
    this.isDay = true,
  });

  @override
  Widget build(BuildContext context) {
    return WeatherCardBase(
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
                'Precipitation',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${precipitation.toStringAsFixed(1)} mm',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}