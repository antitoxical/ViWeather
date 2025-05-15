import 'package:flutter/material.dart';
import 'package:viweather1/theme/app_colors.dart';
import 'package:viweather1/models/weather_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:viweather1/widgets/pressure_chart.dart';

class PressureDetailScreen extends StatelessWidget {
  final double pressure;
  final bool isDay;
  final List<HourlyForecast>? hourlyData;
  final String timezone;


  const PressureDetailScreen({
    super.key,
    required this.pressure,
    required this.isDay,
    this.hourlyData,
    required this.timezone,
  });

  String _getPressureLevel(double pressure) {
    if (pressure < 1000) return 'Low';
    if (pressure < 1013) return 'Below Normal';
    if (pressure < 1020) return 'Normal';
    if (pressure < 1030) return 'Above Normal';
    return 'High';
  }

  String _getPressureDescription(String level) {
    switch (level) {
      case 'Low':
        return 'Low pressure often brings unsettled weather with clouds and precipitation.';
      case 'Below Normal':
        return 'Slightly below normal pressure may indicate changing weather conditions.';
      case 'Normal':
        return 'Normal pressure indicates stable weather conditions.';
      case 'Above Normal':
        return 'Slightly above normal pressure usually brings clear, dry weather.';
      case 'High':
        return 'High pressure typically brings clear skies and stable weather.';
      default:
        return '';
    }
  }

  String _getPressureEffects(String level) {
    switch (level) {
      case 'Low':
        return 'May cause headaches and fatigue in sensitive individuals.';
      case 'Below Normal':
        return 'Generally well-tolerated by most people.';
      case 'Normal':
        return 'Optimal conditions for most activities.';
      case 'Above Normal':
        return 'May improve mood and energy levels.';
      case 'High':
        return 'Excellent conditions for outdoor activities.';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final pressureLevel = _getPressureLevel(pressure);
    final description = _getPressureDescription(pressureLevel);
    final effects = _getPressureEffects(pressureLevel);


    return Scaffold(
      backgroundColor: isDay ? AppColors.clearDayStart : AppColors.clearNightEnd,
      appBar: AppBar(
        title: const Text('Pressure',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w300,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildMainCard(pressureLevel),

            const SizedBox(height: 16),
            if (hourlyData != null && hourlyData!.isNotEmpty)
              PressureChart(
                pressures: hourlyData!.map((h) => h.pressure?.toDouble() ?? 0.0).toList(),
                timezone: timezone,
                isDay: isDay,
              ),
            const SizedBox(height: 16),
            _buildInfoCard('Weather Impact', description, Icons.cloud),
            const SizedBox(height: 16),
            _buildInfoCard('Health Effects', effects, Icons.health_and_safety),
          ],
        ),
      ),
    );
  }


  Widget _buildMainCard(String level) {
    return Container(
      decoration: BoxDecoration(
        color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            '${pressure.toStringAsFixed(0)}',
            style: TextStyle(
              color: isDay ? AppColors.textPrimary : Colors.white,
              fontSize: 72,
              fontWeight: FontWeight.w200,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'hPa',
            style: TextStyle(
              color: isDay ? AppColors.textPrimary : Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            level,
            style: TextStyle(
              color: isDay ? AppColors.textSecondary : Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: isDay ? AppColors.textPrimary : Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: isDay ? AppColors.textPrimary : Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: TextStyle(
              color: isDay ? AppColors.textSecondary : Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}