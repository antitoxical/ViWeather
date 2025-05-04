import 'package:flutter/material.dart';
import 'package:viweather1/theme/app_colors.dart';

class PressureDetailScreen extends StatelessWidget {
  final double pressure;
  final bool isDay;

  const PressureDetailScreen({
    super.key,
    required this.pressure,
    required this.isDay,
  });

  @override
  Widget build(BuildContext context) {
    final pressureLevel = _getPressureLevel(pressure);

    return Scaffold(
      backgroundColor: isDay ? AppColors.clearDayStart : AppColors.clearNightEnd,
      appBar: AppBar(
        title: const Text('Atmospheric Pressure'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDay ? AppColors.textPrimary : Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPressureValueSection(),
            const SizedBox(height: 24),
            _buildPressureLevelSection(pressureLevel),
            const SizedBox(height: 24),
            _buildPressureExplanationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPressureValueSection() {
    return Card(
      color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              Icons.speed,
              color: isDay ? AppColors.iconColor : Colors.white,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              '${pressure.toStringAsFixed(0)} hPa',
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Atmospheric Pressure',
              style: TextStyle(
                color: isDay ? AppColors.textSecondary : Colors.white70,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPressureLevelSection(String pressureLevel) {
    Color levelColor;

    if (pressureLevel == 'Low') {
      levelColor = Colors.red;
    } else if (pressureLevel == 'High') {
      levelColor = Colors.blue;
    } else {
      levelColor = Colors.green;
    }

    return Card(
      color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pressure Level',
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                pressureLevel,
                style: TextStyle(
                  color: isDay ? levelColor : Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getPressureDescription(pressureLevel),
              style: TextStyle(
                color: isDay ? AppColors.textSecondary : Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPressureExplanationSection() {
    return Card(
      color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Atmospheric Pressure',
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Atmospheric pressure is the force exerted by the weight of the atmosphere. '
                  'Standard pressure at sea level is 1013.25 hPa. Changes in pressure often indicate upcoming weather changes.',
              style: TextStyle(
                color: isDay ? AppColors.textSecondary : Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPressureLevel(double pressure) {
    if (pressure < 1000) return 'Low';
    if (pressure > 1020) return 'High';
    return 'Normal';
  }

  String _getPressureDescription(String level) {
    switch (level) {
      case 'Low':
        return 'Low pressure often brings clouds, wind and precipitation.';
      case 'High':
        return 'High pressure usually means fair weather with clear skies.';
      default:
        return 'Normal pressure with typical weather conditions.';
    }
  }
}