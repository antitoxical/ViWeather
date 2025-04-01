import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HumidityCard extends StatelessWidget {
  final double humidity;
  final double dewPoint;

  const HumidityCard({
    required this.humidity,
    required this.dewPoint,
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
              'Влажность',
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
                      '${humidity.toStringAsFixed(0)} %',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Точка росы: ${dewPoint.toStringAsFixed(1)}°',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
                Icon(Icons.water_drop, color: Colors.cyan),
              ],
            ),
          ],
        ),
      ),
    );
  }
}