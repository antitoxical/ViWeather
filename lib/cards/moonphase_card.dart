import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MoonPhaseCard extends StatelessWidget {
  final double moonIllumination;
  final String moonPhase;

  const MoonPhaseCard({required this.moonIllumination, required this.moonPhase});

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
              'Фаза луны',
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
                      'Освещенность: ${moonIllumination.toStringAsFixed(0)} %',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Фаза: ${(moonPhase)}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                Icon(Icons.nightlight_round, color: Colors.blueGrey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}