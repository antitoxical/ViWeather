import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WindCard extends StatelessWidget {
  final double windSpeed;
  final double windGusts;
  final String windDirection;

  const WindCard({
    required this.windSpeed,
    required this.windGusts,
    required this.windDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ветер',
              style: TextStyle(color: Colors.white60),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Скорость: ${windSpeed.toStringAsFixed(1)} км/ч',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Порывы: ${windGusts.toStringAsFixed(1)} км/ч',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Направление: $windDirection',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Icon(Icons.air, color: Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }
}