import 'package:flutter/material.dart';
import 'package:viweather1/theme/app_colors.dart';

class PrecipitationDetailScreen extends StatelessWidget {
  final double precipitation;
  final String description;
  final bool isDay;

  const PrecipitationDetailScreen({
    super.key,
    required this.precipitation,
    required this.description,
    required this.isDay,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDay ? AppColors.clearDayStart : AppColors.clearNightEnd,
      appBar: AppBar(
        title: const Text('Precipitation'),
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
            _buildPrecipitationAmountSection(),
            const SizedBox(height: 24),
            _buildPrecipitationDescriptionSection(),
            const SizedBox(height: 24),
            _buildPrecipitationTypesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrecipitationAmountSection() {
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
              '${precipitation.toStringAsFixed(1)} mm',
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Precipitation Amount',
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

  Widget _buildPrecipitationDescriptionSection() {
    return Card(
      color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
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

  Widget _buildPrecipitationTypesSection() {
    return Card(
      color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Precipitation Types',
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildPrecipitationTypeItem('Rain', 'Liquid water droplets'),
            const Divider(),
            _buildPrecipitationTypeItem('Snow', 'Ice crystals'),
            const Divider(),
            _buildPrecipitationTypeItem('Sleet', 'Rain and snow mix'),
            const Divider(),
            _buildPrecipitationTypeItem('Hail', 'Solid ice pellets'),
          ],
        ),
      ),
    );
  }

  Widget _buildPrecipitationTypeItem(String type, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            _getPrecipitationIcon(type),
            color: isDay ? AppColors.iconColor : Colors.white,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyle(
                    color: isDay ? AppColors.textPrimary : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: isDay ? AppColors.textSecondary : Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPrecipitationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'rain':
        return Icons.beach_access;
      case 'snow':
        return Icons.ac_unit;
      case 'sleet':
        return Icons.water;
      case 'hail':
        return Icons.grain;
      default:
        return Icons.water_drop;
    }
  }
}