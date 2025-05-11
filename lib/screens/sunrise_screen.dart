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
    final hours = dayLength.inHours;
    final minutes = dayLength.inMinutes.remainder(60);

    return Scaffold(
      backgroundColor: isDay ? AppColors.clearDayStart : AppColors.clearNightEnd,
      appBar: AppBar(
        title: const Text('Sun',
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
            _buildMainCard(sunriseTime, sunsetTime),
            const SizedBox(height: 16),
            _buildInfoCard('Day Length', '$hours h ${minutes}m', 'Time between sunrise and sunset', Icons.timer),
            const SizedBox(height: 16),
            _buildInfoCard('Solar Noon', _calculateSolarNoon(sunrise, sunset), 'The midpoint between sunrise and sunset', Icons.wb_sunny),
            const SizedBox(height: 16),
            _buildInfoCard('Civil Twilight', _calculateCivilTwilight(sunrise, sunset), 'Time when the sun is 6° below the horizon', Icons.brightness_4),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard(String sunriseTime, String sunsetTime) {
    return Container(
      decoration: BoxDecoration(
        color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeItem(Icons.wb_sunny, 'Sunrise', sunriseTime),
              _buildTimeItem(Icons.nightlight_round, 'Sunset', sunsetTime),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeItem(IconData icon, String label, String time) {
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
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          time,
          style: TextStyle(
            color: isDay ? AppColors.textPrimary : Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, String description, IconData icon) {
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
            value,
            style: TextStyle(
              color: isDay ? AppColors.textPrimary : Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
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

  String _calculateSolarNoon(DateTime sunrise, DateTime sunset) {
    final solarNoon = sunrise.add(sunset.difference(sunrise) ~/ 2);
    return DateFormat('HH:mm').format(solarNoon);
  }

  String _calculateCivilTwilight(DateTime sunrise, DateTime sunset) {
    final morningTwilight = sunrise.subtract(const Duration(minutes: 30));
    final eveningTwilight = sunset.add(const Duration(minutes: 30));
    return '${DateFormat('HH:mm').format(morningTwilight)} - ${DateFormat('HH:mm').format(eveningTwilight)}';
  }
}