import 'package:flutter/material.dart';
import 'package:viweather1/theme/app_colors.dart';
import 'package:viweather1/widgets/weather_card_base.dart';
import 'package:viweather1/screens/precipitation_screen.dart';
import 'package:viweather1/models/weather_model.dart';

class PrecipitationCard extends StatelessWidget {
  final double precipitation;
  final String description;
  final String condition;
  final bool isDay;
  final List<HourlyForecast>? hourlyData;
  final VoidCallback? onTap;

  const PrecipitationCard({
    Key? key,
    required this.precipitation,
    required this.description,
    required this.condition,
    required this.isDay,
    this.hourlyData,
    this.onTap,
  }) : super(key: key);

  String _getPrecipitationDescription(double amount) {
    if (amount == 0) return 'No precipitation';
    if (amount < 0.5) return 'Light precipitation';
    if (amount < 4) return 'Moderate precipitation';
    if (amount < 8) return 'Heavy precipitation';
    return 'Very heavy precipitation';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _showPrecipitationDetails(context),
      child: WeatherCardBase(
        condition: condition,
        isDay: isDay,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.water_drop_outlined,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      _getPrecipitationDescription(precipitation),
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

  void _showPrecipitationDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PrecipitationDetailScreen(
          precipitation: precipitation,
          description: description,
          isDay: isDay,
          hourlyData: hourlyData,
        ),
      ),
    );
  }
}