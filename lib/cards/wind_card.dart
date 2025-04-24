import 'package:flutter/material.dart';
import 'package:viweather1/theme/app_colors.dart';
import 'package:viweather1/widgets/weather_card_base.dart';

class WindCard extends StatelessWidget {
  final double windSpeed;
  final double windGusts;
  final String windDirection;
  final String condition;
  final bool isDay;

  const WindCard({
    super.key,
    required this.windSpeed,
    required this.windGusts,
    required this.windDirection,
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
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Wind Speed',
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
                    '${windGusts.toStringAsFixed(1)} km/h',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Wind Gusts',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Transform.rotate(
                angle: _getWindDirectionAngle(windDirection),
                child: Icon(
                  Icons.navigation,
                  color: AppColors.iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                windDirection,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _getWindDirectionAngle(String direction) {
    final directions = {
      'N': 0,
      'NNE': 22.5,
      'NE': 45,
      'ENE': 67.5,
      'E': 90,
      'ESE': 112.5,
      'SE': 135,
      'SSE': 157.5,
      'S': 180,
      'SSW': 202.5,
      'SW': 225,
      'WSW': 247.5,
      'W': 270,
      'WNW': 292.5,
      'NW': 315,
      'NNW': 337.5,
    };
    
    return (directions[direction] ?? 0) * (3.14159265359 / 180.0);
  }
}