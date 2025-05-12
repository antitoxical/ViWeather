import 'package:flutter/material.dart';
import 'package:viweather1/theme/app_colors.dart';
import 'package:viweather1/widgets/weather_card_base.dart';
import 'package:viweather1/screens/pressure_screen.dart';
import 'package:viweather1/models/weather_model.dart';

class PressureCard extends StatelessWidget {
  final double pressure;
  final String condition;
  final bool isDay;
  final List<HourlyForecast>? hourlyData;
  final VoidCallback? onTap;
  final String timezone;


  const PressureCard({
    Key? key,
    required this.pressure,
    required this.condition,
    required this.isDay,
    this.hourlyData,
    this.onTap,
    required this.timezone,

  }) : super(key: key);

  String _getPressureDescription(double pressure) {
    if (pressure < 1000) return 'Very low';
    if (pressure < 1013) return 'Low';
    if (pressure < 1020) return 'Normal';
    if (pressure < 1030) return 'Increased';
    return 'High';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _showPressureDetails(context),
      child: WeatherCardBase(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${pressure.toStringAsFixed(0)} mpa',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getPressureDescription(pressure),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
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

  void _showPressureDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PressureDetailScreen(
          pressure: pressure,
          isDay: isDay,
          hourlyData: hourlyData,
          timezone: timezone,
        ),
      ),
    );
  }
}