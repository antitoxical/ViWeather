import 'package:flutter/material.dart';

class AirQualityCard extends StatelessWidget {
  final int aqi;
  final String description;

  const AirQualityCard({
    Key? key,
    required this.aqi,
    required this.description,
  }) : super(key: key);

  Color _getAQIColor(int aqi) {
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.yellow;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.red;
    if (aqi <= 300) return Colors.purple;
    return Colors.brown;
  }

  String _getAQIDescription(int aqi) {
    if (aqi <= 50) return 'Хорошее';
    if (aqi <= 100) return 'Умеренное';
    if (aqi <= 150) return 'Нездоровое для чувствительных групп';
    if (aqi <= 200) return 'Нездоровое';
    if (aqi <= 300) return 'Очень нездоровое';
    return 'Опасное';
  }

  @override
  Widget build(BuildContext context) {
    final color = _getAQIColor(aqi);
    final aqiDescription = _getAQIDescription(aqi);

    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Качество воздуха',
              style: TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AQI: $aqi',
                      style: TextStyle(
                        color: color,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      aqiDescription,
                      style: TextStyle(
                        color: color,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.air,
                  color: color,
                  size: 40,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(color: Colors.white60),
            ),
          ],
        ),
      ),
    );
  }
} 