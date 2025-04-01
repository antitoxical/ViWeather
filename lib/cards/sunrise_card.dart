import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viweather1/services/weather_service.dart';

class SunriseSunsetCard extends StatelessWidget {
  final DateTime sunrise;
  final DateTime sunset;

  const SunriseSunsetCard({required this.sunrise, required this.sunset});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Восход/Закат', style: TextStyle(color: Colors.white60)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Восход: $sunrise', style: TextStyle(color: Colors.white)),
                    Text('Закат: $sunset', style: TextStyle(color: Colors.white)),
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