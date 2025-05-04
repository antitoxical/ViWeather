import 'package:flutter/material.dart';
import 'package:viweather1/theme/app_colors.dart';
import 'package:viweather1/widgets/weather_card_base.dart';
import 'package:viweather1/screens/moonphase_screen.dart';

class MoonPhaseCard extends StatelessWidget {
  final double moonIllumination;
  final String moonPhase;
  final String condition;
  final bool isDay;
  final VoidCallback? onTap;

  const MoonPhaseCard({
    super.key,
    required this.moonIllumination,
    required this.moonPhase,
    required this.condition,
    this.isDay = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _showMoonPhaseDetails(context),
      child: WeatherCardBase(
        condition: condition,
        isDay: isDay,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.nightlight_round,
                  color: AppColors.iconColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Moon Phase',
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
                      '${moonIllumination.toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Illumination',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      moonPhase,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Phase',
                      style: TextStyle(
                        color: AppColors.textSecondary,
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

  void _showMoonPhaseDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MoonPhaseDetailScreen(
          moonIllumination: moonIllumination,
          moonPhase: moonPhase,
          isDay: isDay,
        ),
      ),
    );
  }
}