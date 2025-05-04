import 'package:flutter/material.dart';
import 'package:viweather1/theme/app_colors.dart';

class HumidityDetailScreen extends StatelessWidget {
  final double humidity;
  final double dewPoint;
  final bool isDay;

  const HumidityDetailScreen({
    super.key,
    required this.humidity,
    required this.dewPoint,
    required this.isDay,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDay ? AppColors.clearDayStart : AppColors.clearNightEnd,
      appBar: AppBar(
        title: const Text('Humidity Details'),
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
            _buildCurrentHumiditySection(),
            const SizedBox(height: 24),
            _buildDewPointSection(),
            const SizedBox(height: 24),
            _buildHumidityExplanationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentHumiditySection() {
    return Card(
      color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              Icons.water_drop,
              color: isDay ? AppColors.iconColor : Colors.white,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              '${humidity.toStringAsFixed(0)}%',
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Current Humidity',
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

  Widget _buildDewPointSection() {
    return Card(
      color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dew Point',
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${dewPoint.toStringAsFixed(1)}°',
                  style: TextStyle(
                    color: isDay ? AppColors.textPrimary : Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'The dew point is the temperature to which air must be cooled to become saturated with water vapor.',
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

  Widget _buildHumidityExplanationSection() {
    String comfortLevel;
    Color comfortColor;

    if (humidity < 30) {
      comfortLevel = 'Low humidity. May cause dry skin and irritation.';
      comfortColor = Colors.orange;
    } else if (humidity < 60) {
      comfortLevel = 'Comfortable humidity level. Ideal for most activities.';
      comfortColor = Colors.green;
    } else {
      comfortLevel = 'High humidity. May feel muggy and uncomfortable.';
      comfortColor = Colors.blue;
    }

    return Card(
      color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comfort Level',
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              comfortLevel,
              style: TextStyle(
                color: isDay ? comfortColor : Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Relative humidity indicates how much water vapor is in the air compared to the maximum possible at that temperature.',
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
}