class ClothingRecommendation {
  final String mainRecommendation;
  final List<String> accessories;
  final String description;

  ClothingRecommendation({
    required this.mainRecommendation,
    required this.accessories,
    required this.description,
  });

  factory ClothingRecommendation.fromWeather(double temperature, String condition) {
    final lowerCondition = condition.toLowerCase();
    
    if (temperature > 25) {
      return ClothingRecommendation(
        mainRecommendation: 'Light clothing',
        accessories: ['Hat', 'Sunglasses', 'Sunscreen'],
        description: 'It\'s hot outside, choose light and bright clothing',
      );
    } else if (temperature > 15) {
      return ClothingRecommendation(
        mainRecommendation: 'Seasonal clothing',
        accessories: ['Light jacket', 'Umbrella'],
        description: 'Temperature is comfortable, but it might be cool in the evening',
      );
    } else if (temperature > 5) {
      return ClothingRecommendation(
        mainRecommendation: 'Warm clothing',
        accessories: ['Warm jacket', 'Scarf', 'Gloves'],
        description: 'It\'s cool outside, dress warmer',
      );
    } else {
      return ClothingRecommendation(
        mainRecommendation: 'Winter clothing',
        accessories: ['Warm jacket', 'Hat', 'Scarf', 'Gloves', 'Thermal underwear'],
        description: 'It\'s cold outside, dress very warmly',
      );
    }
  }
} 