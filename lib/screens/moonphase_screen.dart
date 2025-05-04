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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDay ? AppColors.clearDayStart : AppColors.clearNightEnd,
      appBar: AppBar(
        title: const Text('Moon Phase'),
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
            _buildMoonPhaseSection(),
            const SizedBox(height: 24),
            _buildMoonIlluminationSection(),
            const SizedBox(height: 24),
            _buildMoonPhaseExplanation(),
          ],
        ),
      ),
    );
  }

  Widget _buildMoonPhaseSection() {
    return Card(
      color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              Icons.nightlight_round,
              color: isDay ? AppColors.iconColor : Colors.white,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              moonPhase,
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Current Moon Phase',
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

  Widget _buildMoonIlluminationSection() {
    return Card(
      color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Illumination',
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: moonIllumination / 100,
              backgroundColor: isDay ? Colors.grey[300] : Colors.grey[700],
              color: isDay ? Colors.blue : Colors.lightBlue,
              minHeight: 20,
            ),
            const SizedBox(height: 8),
            Text(
              '${moonIllumination.toStringAsFixed(0)}% illuminated',
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoonPhaseExplanation() {
    return Card(
      color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Moon Phases',
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The moon goes through 8 distinct phases during its 29.5-day cycle: New Moon, Waxing Crescent, First Quarter, Waxing Gibbous, Full Moon, Waning Gibbous, Last Quarter, and Waning Crescent.',
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