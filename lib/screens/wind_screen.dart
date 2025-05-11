import 'package:flutter/material.dart';
import 'package:viweather1/theme/app_colors.dart';

class WindDetailScreen extends StatelessWidget {
  final double currentWindSpeed;
  final double currentWindGusts;
  final String currentWindDirection;
  final double maxDailyWind;
  final double yesterdayMaxWind;
  final bool isDay;

  const WindDetailScreen({
    super.key,
    required this.currentWindSpeed,
    required this.currentWindGusts,
    required this.currentWindDirection,
    required this.maxDailyWind,
    required this.yesterdayMaxWind,
    required this.isDay,
  });

  String _getWindDescription(double speed) {
    if (speed < 2) return 'Calm';
    if (speed < 6) return 'Light Breeze';
    if (speed < 12) return 'Moderate Breeze';
    if (speed < 20) return 'Strong Breeze';
    if (speed < 30) return 'High Wind';
    return 'Strong Wind';
  }

  String _getWindEffects(String description) {
    switch (description) {
      case 'Calm':
        return 'Perfect conditions for outdoor activities.';
      case 'Light Breeze':
        return 'Comfortable for most outdoor activities.';
      case 'Moderate Breeze':
        return 'Good for flying kites and sailing.';
      case 'Strong Breeze':
        return 'May affect some outdoor activities.';
      case 'High Wind':
        return 'Consider indoor activities.';
      case 'Strong Wind':
        return 'Stay indoors if possible.';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final windDescription = _getWindDescription(currentWindSpeed);
    final effects = _getWindEffects(windDescription);
    final isHigher = maxDailyWind > yesterdayMaxWind;

    return Scaffold(
      backgroundColor: isDay ? AppColors.clearDayStart : AppColors.clearNightEnd,
      appBar: AppBar(
        title: const Text('Wind',
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
            _buildMainCard(windDescription),
            const SizedBox(height: 16),
            _buildInfoCard('Wind Direction', currentWindDirection, '', Icons.explore),
            const SizedBox(height: 16),
            _buildInfoCard('Wind Gusts', '${currentWindGusts.toStringAsFixed(1)} km/h', '', Icons.air),
            const SizedBox(height: 16),
            _buildInfoCard('Daily Comparison', 
              'Today\'s peak wind is ${isHigher ? 'higher' : 'lower'} than yesterday\'s maximum of ${yesterdayMaxWind.toStringAsFixed(1)} km/h',
              '', Icons.compare_arrows),
            const SizedBox(height: 16),
            _buildInfoCard('Activity Impact', effects, '', Icons.directions_walk),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard(String description) {
    return Container(
      decoration: BoxDecoration(
        color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            '${currentWindSpeed.toStringAsFixed(1)}',
            style: TextStyle(
              color: isDay ? AppColors.textPrimary : Colors.white,
              fontSize: 72,
              fontWeight: FontWeight.w200,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'km/h',
            style: TextStyle(
              color: isDay ? AppColors.textPrimary : Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 16),
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
          if (value.isNotEmpty)
            Text(
              value,
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.w300,
              ),
            ),
          if (description.isNotEmpty) ...[
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
        ],
      ),
    );
  }
}