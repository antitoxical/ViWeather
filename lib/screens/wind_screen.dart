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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDay ? AppColors.clearDayStart : AppColors.clearNightEnd,
      appBar: AppBar(
        title: const Text('Wind Details'),
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
            _buildCurrentWindSection(),
            const SizedBox(height: 24),
            _buildDailySummarySection(),
            const SizedBox(height: 24),
            _buildDailyComparisonSection(),
            const SizedBox(height: 24),
            _buildBeaufortScaleSection(),
            const SizedBox(height: 24),
            _buildWindExplanationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentWindSection() {
    return Card(
      color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${currentWindSpeed.toStringAsFixed(0)} km/h $currentWindDirection',
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Gusts: ${currentWindGusts.toStringAsFixed(0)} km/h',
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

  Widget _buildDailySummarySection() {
    return Card(
      color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Summary',
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Wind is currently ${currentWindSpeed.toStringAsFixed(0)} km/h from the $currentWindDirection. '
                  'Today, wind speeds are 2 to ${maxDailyWind.toStringAsFixed(0)} km/h, '
                  'with gusts up to ${currentWindGusts.toStringAsFixed(0)} km/h.',
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

  Widget _buildDailyComparisonSection() {
    final isHigher = maxDailyWind > yesterdayMaxWind;
    final difference = (maxDailyWind - yesterdayMaxWind).abs();

    return Card(
      color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Comparison',
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The peak wind speed today is ${isHigher ? 'higher' : 'lower'} than yesterday.',
              style: TextStyle(
                color: isDay ? AppColors.textSecondary : Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Today',
                        style: TextStyle(
                          color: isDay ? AppColors.textSecondary : Colors.white70,
                        ),
                      ),
                    ),
                    Text(
                      '${maxDailyWind.toStringAsFixed(0)} km/h',
                      style: TextStyle(
                        color: isDay ? AppColors.textPrimary : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Yesterday',
                        style: TextStyle(
                          color: isDay ? AppColors.textSecondary : Colors.white70,
                        ),
                      ),
                    ),
                    Text(
                      '${yesterdayMaxWind.toStringAsFixed(0)} km/h',
                      style: TextStyle(
                        color: isDay ? AppColors.textPrimary : Colors.white,
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

  Widget _buildBeaufortScaleSection() {
    return Card(
      color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Beaufort Scale',
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildBeaufortScaleTable(),
            const SizedBox(height: 12),
            Text(
              'The Beaufort wind scale expresses how forceful or strong the wind is at a given speed.',
              style: TextStyle(
                color: isDay ? AppColors.textSecondary : Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBeaufortScaleTable() {
    return Table(
      border: TableBorder.all(
        color: isDay ? Colors.grey.shade300 : Colors.grey.shade700,
        width: 0.5,
      ),
      children: const [
        TableRow(
          decoration: BoxDecoration(
            color: Colors.blue, // Header color
          ),
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'bft',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Description',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'km/h',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('0', textAlign: TextAlign.center),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Calm'),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('< 2', textAlign: TextAlign.center),
            ),
          ],
        ),
        TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('1', textAlign: TextAlign.center),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Light air'),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('2 - 5', textAlign: TextAlign.center),
            ),
          ],
        ),
        TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('2', textAlign: TextAlign.center),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Light breeze'),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('6 - 11', textAlign: TextAlign.center),
            ),
          ],
        ),
        TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('3', textAlign: TextAlign.center),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Gentle breeze'),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('12 - 19', textAlign: TextAlign.center),
            ),
          ],
        ),
        TableRow(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('4', textAlign: TextAlign.center),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Moderate breeze'),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('20 - 28', textAlign: TextAlign.center),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWindExplanationSection() {
    return Card(
      color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Wind Speed and Gusts',
              style: TextStyle(
                color: isDay ? AppColors.textPrimary : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The wind speed is calculated using the average over a short period of time. '
                  'Gusts are short bursts of wind above this average. '
                  'A gust typically lasts under 20 seconds.',
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