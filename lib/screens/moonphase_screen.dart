import 'package:flutter/material.dart';
import 'package:viweather1/theme/app_colors.dart';

class MoonPhaseDetailScreen extends StatelessWidget {
  final double moonIllumination;
  final String moonPhase;
  final bool isDay;

  const MoonPhaseDetailScreen({
    super.key,
    required this.moonIllumination,
    required this.moonPhase,
    required this.isDay,
  });

  String _getMoonPhaseDescription(String phase) {
    switch (phase.toLowerCase()) {
      case 'new moon':
        return 'The moon is not visible from Earth.';
      case 'waxing crescent':
        return 'A thin crescent of the moon is visible, growing larger each night.';
      case 'first quarter':
        return 'Half of the moon is visible, growing larger each night.';
      case 'waxing gibbous':
        return 'More than half of the moon is visible, growing larger each night.';
      case 'full moon':
        return 'The entire moon is visible from Earth.';
      case 'waning gibbous':
        return 'More than half of the moon is visible, growing smaller each night.';
      case 'last quarter':
        return 'Half of the moon is visible, growing smaller each night.';
      case 'waning crescent':
        return 'A thin crescent of the moon is visible, growing smaller each night.';
      default:
        return '';
    }
  }

  String _getMoonPhaseEffects(String phase) {
    switch (phase.toLowerCase()) {
      case 'new moon':
        return 'Best time for new beginnings and setting intentions.';
      case 'waxing crescent':
        return 'Good time for growth and development.';
      case 'first quarter':
        return 'Time for action and making decisions.';
      case 'waxing gibbous':
        return 'Focus on refinement and preparation.';
      case 'full moon':
        return 'Peak energy, good for completion and celebration.';
      case 'waning gibbous':
        return 'Time for gratitude and sharing.';
      case 'last quarter':
        return 'Good for release and letting go.';
      case 'waning crescent':
        return 'Time for rest and reflection.';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final description = _getMoonPhaseDescription(moonPhase);
    final effects = _getMoonPhaseEffects(moonPhase);

    return Scaffold(
      backgroundColor: isDay ? AppColors.clearDayStart : AppColors.clearNightEnd,
      appBar: AppBar(
        title: const Text('Moon Phase',
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
            _buildMainCard(),
            const SizedBox(height: 16),
            _buildInfoCard('Illumination', '${(moonIllumination * 100).toStringAsFixed(0)}%', '', Icons.brightness_6),
            const SizedBox(height: 16),
            _buildInfoCard('Description', description, '', Icons.info_outline),
            const SizedBox(height: 16),
            _buildInfoCard('Effects', effects, '', Icons.auto_awesome),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      decoration: BoxDecoration(
        color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.nightlight_round,
            color: isDay ? AppColors.textPrimary : Colors.white,
            size: 72,
          ),
          const SizedBox(height: 16),
          Text(
            moonPhase,
            style: TextStyle(
              color: isDay ? AppColors.textPrimary : Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Current Phase',
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