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
              'Wind',
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
                      'Speed: ${windSpeed.toStringAsFixed(1)} km/h',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Gusts: ${windGusts.toStringAsFixed(1)} km/h',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Direction: $windDirection',
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