import 'package:flutter/material.dart';
import 'package:viweather1/theme/app_colors.dart';
import 'package:intl/intl.dart';


class SunriseSunsetDetailScreen extends StatelessWidget {
  final DateTime sunrise;
  final DateTime sunset;
  final bool isDay;

  const SunriseSunsetDetailScreen({
    super.key,
    required this.sunrise,
    required this.sunset,
    required this.isDay,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final sunriseTime = timeFormat.format(sunrise);
    final sunsetTime = timeFormat.format(sunset);
    final dayLength = sunset.difference(sunrise);

    return Scaffold(
      backgroundColor: isDay ? AppColors.clearDayStart : AppColors.clearNightEnd,
      appBar: AppBar(
        title: const Text('Sunrise & Sunset'),
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
            _buildSunTimes(sunriseTime, sunsetTime),
            const SizedBox(height: 24),
            _buildDayLength(dayLength),
            const SizedBox(height: 24),
            _buildSunPositionInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildSunTimes(String sunriseTime, String sunsetTime) {
    return Card(
      color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSunTimeItem(Icons.wb_sunny, 'Sunrise', sunriseTime),
                _buildSunTimeItem(Icons.nightlight_round, 'Sunset', sunsetTime),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSunTimeItem(IconData icon, String label, String time) {
    return Column(
      children: [
        Icon(
          icon,
          color: isDay ? Colors.amber : Colors.yellow,
          size: 48,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isDay ? AppColors.textSecondary : Colors.white70,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          time,
          style: TextStyle(
            color: isDay ? AppColors.textPrimary : Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDayLength(Duration dayLength) {
    final hours = dayLength.inHours;
    final minutes = dayLength.inMinutes.remainder(60);

    return Card(
      color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daylight Duration',
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '$hours h ${minutes}m',
                style: TextStyle(
                  color: isDay ? Colors.amber : Colors.yellow,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Time between sunrise and sunset',
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

  Widget _buildSunPositionInfo() {
    return Card(
      color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Sun Position',
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'The sun\'s position affects temperature and daylight hours. '
                  'Sunrise marks the beginning of daylight when the sun appears above the horizon, '
                  'while sunset is when it disappears below the horizon.',
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