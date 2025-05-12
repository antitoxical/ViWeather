import 'package:flutter/material.dart';
import 'package:viweather1/models/weather_model.dart';
import 'package:viweather1/theme/app_colors.dart';

class PrecipitationDetailScreen extends StatelessWidget {
  final double precipitation;
  final String description;
  final bool isDay;
  final double? probability;
  final List<HourlyForecast>? hourlyData;

  const PrecipitationDetailScreen({
    super.key,
    required this.precipitation,
    required this.description,
    required this.isDay,
    this.probability,
    this.hourlyData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDay ? AppColors.clearDayStart : AppColors.clearNightEnd,
      appBar: AppBar(
        title: const Text('Precipitation',
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
            _buildInfoCard('Description', description, Icons.info_outline),
            if (probability != null) ...[
              const SizedBox(height: 16),
              _buildInfoCard('Probability', '${probability!.toStringAsFixed(0)}%', Icons.water_drop),
            ],
            const SizedBox(height: 24),
            _buildTypesHeader(),
            const SizedBox(height: 12),
            _buildTypeCard('Rain', 'Liquid water droplets', Icons.beach_access),
            const SizedBox(height: 8),
            _buildTypeCard('Snow', 'Ice crystals', Icons.ac_unit),
            const SizedBox(height: 8),
            _buildTypeCard('Sleet', 'Rain and snow mix', Icons.water),
            const SizedBox(height: 8),
            _buildTypeCard('Hail', 'Solid ice pellets', Icons.grain),
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
            Icons.water_drop,
            color: isDay ? Colors.blue : Colors.lightBlue,
            size: 72,
          ),
          const SizedBox(height: 16),
          Text(
            '${precipitation.toStringAsFixed(1)} mm',
            style: TextStyle(
              color: isDay ? AppColors.textPrimary : Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.w200,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Precipitation Amount',
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

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: isDay ? AppColors.textPrimary : Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDay ? AppColors.textPrimary : Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    color: isDay ? AppColors.textSecondary : Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypesHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Precipitation Types',
        style: TextStyle(
          color: isDay ? AppColors.textPrimary : Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildTypeCard(String name, String desc, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: isDay ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: isDay ? AppColors.textPrimary : Colors.white, size: 28),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: isDay ? AppColors.textPrimary : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                desc,
                style: TextStyle(
                  color: isDay ? AppColors.textSecondary : Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}