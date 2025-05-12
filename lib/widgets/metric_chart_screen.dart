import 'package:flutter/material.dart';
import 'package:viweather1/models/weather_model.dart';
import 'package:viweather1/widgets/hourly_chart.dart';
import 'package:viweather1/theme/app_colors.dart';

class MetricChartScreen extends StatelessWidget {
  final String title;
  final String metric;
  final String unit;
  final Color lineColor;
  final Color gradientColor;
  final List<HourlyForecast> hourlyData;
  final double Function(HourlyForecast) valueExtractor;
  final String? description;
  final String timezone;

  const MetricChartScreen({
    Key? key,
    required this.title,
    required this.metric,
    required this.unit,
    required this.lineColor,
    required this.gradientColor,
    required this.hourlyData,
    required this.valueExtractor,
    this.description,
    required this.timezone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.textPrimary.withOpacity(0.8),
              AppColors.textSecondary.withOpacity(0.8),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (description != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  description!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
              ),
            Expanded(
              child: HourlyChart(
                hourlyData: hourlyData,
                metric: metric,
                unit: unit,
                lineColor: lineColor,
                gradientColor: gradientColor,
                valueExtractor: valueExtractor,
                timezone: timezone,
              ),
            ),
          ],
        ),
      ),
    );
  }
}