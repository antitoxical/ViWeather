import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class PrecipitationCard extends StatelessWidget {
  final double precipitation;
  final String description;

  const PrecipitationCard({required this.precipitation, required this.description});

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
              'Precipitation',
              style: TextStyle(color: Colors.white60),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${precipitation.toStringAsFixed(1)} mm',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                if (precipitation > 0)
                  Icon(Icons.water_drop, color: Colors.white),
              ],
            ),
            SizedBox(height: 8),
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