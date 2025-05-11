import 'package:flutter/material.dart';
import 'package:viweather1/theme/app_colors.dart';

class AirQualityDetailScreen extends StatelessWidget {
  final int aqi;
  final bool isDay;

  const AirQualityDetailScreen({
    Key? key,
    required this.aqi,
    required this.isDay,
  }) : super(key: key);

  Color _getAQIColor(int aqi) {
    if (aqi <= 50) return const Color(0xFF4CAF50);
    if (aqi <= 100) return const Color(0xFFFFC107);
    if (aqi <= 150) return const Color(0xFFFF9800);
    if (aqi <= 200) return const Color(0xFFF44336);
    if (aqi <= 300) return const Color(0xFF9C27B0);
    return const Color(0xFF795548);
  }

  String _getAQIDescription(int aqi) {
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy for Sensitive Groups';
    if (aqi <= 200) return 'Unhealthy';
    if (aqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  String _getAQIHealthEffects(int aqi) {
    if (aqi <= 50) return 'Air quality is satisfactory with little to no risk.';
    if (aqi <= 100) return 'Acceptable quality, but may affect sensitive individuals.';
    if (aqi <= 150) return 'Members of sensitive groups may experience health effects.';
    if (aqi <= 200) return 'Some members of the general public may experience effects.';
    if (aqi <= 300) return 'Health alert: risk of serious effects for everyone.';
    return 'Health warning of emergency conditions.';
  }

  @override
  Widget build(BuildContext context) {
    final color = _getAQIColor(aqi);
    final aqiDescription = _getAQIDescription(aqi);
    final healthEffects = _getAQIHealthEffects(aqi);

    return Scaffold(
      backgroundColor: isDay ? AppColors.clearDayStart : AppColors.clearNightEnd,
      appBar: AppBar(
        title: const Text('Air Quality',
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
            _buildMainCard(color, aqiDescription),
            const SizedBox(height: 16),
            _buildInfoCard('Health Effects', healthEffects, Icons.health_and_safety),
            const SizedBox(height: 16),
            _buildAQIScaleCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard(Color color, String description) {
    return Container(
      decoration: BoxDecoration(
        color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            aqi.toString(),
            style: TextStyle(
              color: color,
              fontSize: 72,
              fontWeight: FontWeight.w200,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Air Quality Index',
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

  Widget _buildAQIScaleCard() {
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
                Icons.scale,
                color: isDay ? AppColors.textPrimary : Colors.white,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'AQI Scale',
                style: TextStyle(
                  color: isDay ? AppColors.textPrimary : Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAQIScaleItem(0, 50, 'Good', const Color(0xFF4CAF50)),
          _buildAQIScaleItem(51, 100, 'Moderate', const Color(0xFFFFC107)),
          _buildAQIScaleItem(101, 150, 'Unhealthy for Groups', const Color(0xFFFF9800)),
          _buildAQIScaleItem(151, 200, 'Unhealthy', const Color(0xFFF44336)),
          _buildAQIScaleItem(201, 300, 'Very Unhealthy', const Color(0xFF9C27B0)),
          _buildAQIScaleItem(301, 500, 'Hazardous', const Color(0xFF795548)),
        ],
      ),
    );
  }

  Widget _buildAQIScaleItem(int min, int max, String level, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '$min-$max: $level',
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}