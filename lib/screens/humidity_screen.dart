import 'package:flutter/material.dart';
import 'package:viweather1/theme/app_colors.dart';
import 'package:viweather1/widgets/hourly_chart.dart';
import 'package:viweather1/models/weather_model.dart';

class HumidityDetailScreen extends StatelessWidget {
  final double humidity;
  final double dewPoint;
  final bool isDay;
  final List<HourlyForecast>? hourlyData;
  final String timezone;

  const HumidityDetailScreen({
    super.key,
    required this.humidity,
    required this.dewPoint,
    required this.isDay,
    this.hourlyData,
    required this.timezone,

  });

  String _getHumidityDescription(double humidity) {
    if (humidity < 30) return 'Very Dry';
    if (humidity < 40) return 'Dry';
    if (humidity < 60) return 'Comfortable';
    if (humidity < 70) return 'Moderately Humid';
    if (humidity < 80) return 'Humid';
    return 'Very Humid';
  }

  String _getDewPointDescription(double dewPoint) {
    if (dewPoint < 10) return 'Very Dry';
    if (dewPoint < 13) return 'Dry';
    if (dewPoint < 16) return 'Comfortable';
    if (dewPoint < 18) return 'Moderately Humid';
    if (dewPoint < 21) return 'Humid';
    return 'Very Humid';
  }

  @override
  Widget build(BuildContext context) {
    final humidityDescription = _getHumidityDescription(humidity);
    final dewPointDescription = _getDewPointDescription(dewPoint);

    return Scaffold(
      backgroundColor: isDay ? AppColors.clearDayStart : AppColors.clearNightEnd,
      appBar: AppBar(
        title: const Text('Humidity',
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
            _buildMainCard(humidityDescription),
            const SizedBox(height: 16),
            if (hourlyData != null && hourlyData!.isNotEmpty) ...[
              Container(
                decoration: BoxDecoration(
                  color: isDay ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Hourly Humidity',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: HourlyChart(
                        hourlyData: hourlyData!,
                        metric: 'Влажность',
                        unit: '%',
                        lineColor: Colors.blueAccent,
                        gradientColor: Colors.blueAccent,
                        valueExtractor: (hour) => hour.humidity?.toDouble() ?? 0.0,
                        timezone: timezone,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            _buildInfoCard('Dew Point', '${dewPoint.toStringAsFixed(1)}°', dewPointDescription, Icons.thermostat),
            const SizedBox(height: 16),
            _buildInfoCard('Comfort Level', _getComfortDescription(humidity, dewPoint), '', Icons.sentiment_satisfied),
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
            '${humidity.toStringAsFixed(0)}%',
            style: TextStyle(
              color: isDay ? AppColors.textPrimary : Colors.white,
              fontSize: 72,
              fontWeight: FontWeight.w200,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: isDay ? AppColors.textPrimary : Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Relative Humidity',
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

  String _getComfortDescription(double humidity, double dewPoint) {
    if (humidity < 30 || dewPoint < 10) {
      return 'The air is very dry. Consider using a humidifier and staying hydrated.';
    } else if (humidity > 70 || dewPoint > 21) {
      return 'The air is very humid. Consider using air conditioning or a dehumidifier.';
    } else {
      return 'The humidity level is comfortable for most people.';
    }
  }
}