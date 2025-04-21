import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viweather1/services/weather_service.dart';
import 'package:intl/intl.dart';

class SunriseSunsetCard extends StatelessWidget {
  final DateTime sunrise;
  final DateTime sunset;

  const SunriseSunsetCard({required this.sunrise, required this.sunset});

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('HH:mm');
    final sunriseTime = timeFormat.format(sunrise);
    final sunsetTime = timeFormat.format(sunset);

    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sunrise/Sunset', style: TextStyle(color: Colors.white60)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sunrise: $sunriseTime', style: TextStyle(color: Colors.white)),
                    Text('Sunset: $sunsetTime', style: TextStyle(color: Colors.white)),
                  ],
                ),
                Icon(Icons.wb_sunny, color: Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }
}