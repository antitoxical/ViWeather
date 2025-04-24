import 'package:flutter/material.dart';
import 'package:viweather1/theme/app_colors.dart';
import 'package:viweather1/widgets/weather_card_base.dart';

class PressureCard extends StatelessWidget {
  final double pressure;
  final String condition;
  final bool isDay;

  const PressureCard({
    super.key,
    required this.pressure,
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
                Icons.speed,
                color: AppColors.iconColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Pressure',
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
            '${pressure.toStringAsFixed(0)} hPa',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Normal pressure',
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