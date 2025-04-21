import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PressureCard extends StatelessWidget {
  final double pressure;

  const PressureCard({
    required this.pressure,
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
              'Pressure',
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
                      '${pressure.toStringAsFixed(0)} hPa',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Normal pressure',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
                Icon(Icons.speed, color: Colors.teal),
              ],
            ),
          ],
        ),
      ),
    );
  }
}