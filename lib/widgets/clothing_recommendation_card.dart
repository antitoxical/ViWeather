import 'package:flutter/material.dart';
import 'package:viweather1/models/clothing_recommendation.dart';

class ClothingRecommendationCard extends StatelessWidget {
  final double temperature;
  final String condition;

  const ClothingRecommendationCard({
    Key? key,
    required this.temperature,
    required this.condition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recommendation = ClothingRecommendation.fromWeather(temperature, condition);

    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.checkroom,
                  color: Colors.blue[300],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Рекомендации по одежде',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              recommendation.mainRecommendation,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              recommendation.description,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Рекомендуемые аксессуары:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recommendation.accessories.map((accessory) {
                return Chip(
                  label: Text(
                    accessory,
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blue[900],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
} 