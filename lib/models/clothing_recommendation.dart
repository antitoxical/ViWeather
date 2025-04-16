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
        mainRecommendation: 'Легкая одежда',
        accessories: ['Шляпа', 'Солнцезащитные очки', 'Солнцезащитный крем'],
        description: 'На улице жарко, выбирайте легкую и светлую одежду',
      );
    } else if (temperature > 15) {
      return ClothingRecommendation(
        mainRecommendation: 'Демисезонная одежда',
        accessories: ['Легкая куртка', 'Зонт'],
        description: 'Температура комфортная, но может быть прохладно вечером',
      );
    } else if (temperature > 5) {
      return ClothingRecommendation(
        mainRecommendation: 'Теплая одежда',
        accessories: ['Теплая куртка', 'Шарф', 'Перчатки'],
        description: 'На улице прохладно, одевайтесь теплее',
      );
    } else {
      return ClothingRecommendation(
        mainRecommendation: 'Зимняя одежда',
        accessories: ['Теплая куртка', 'Шапка', 'Шарф', 'Перчатки', 'Термобелье'],
        description: 'На улице холодно, одевайтесь очень тепло',
      );
    }
  }
} 