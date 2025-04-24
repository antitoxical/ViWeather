import 'package:flutter/material.dart';
import 'package:viweather1/theme/app_colors.dart';

class WeatherGradients {
  static List<Color> getGradientColors(String condition, {bool isDay = true}) {
    final lowerCondition = condition.toLowerCase();
    
    if (isDay) {
      if (lowerCondition.contains('rain')) {
        return [AppColors.rainyDayStart, AppColors.rainyDayEnd];
      } else if (lowerCondition.contains('cloud') || lowerCondition.contains('overcast')) {
        return [AppColors.cloudyDayStart, AppColors.cloudyDayEnd];
      } else {
        return [AppColors.clearDayStart, AppColors.clearDayEnd];
      }
    } else {
      if (lowerCondition.contains('rain')) {
        return [AppColors.rainyNightStart, AppColors.rainyNightEnd];
      } else if (lowerCondition.contains('cloud') || lowerCondition.contains('overcast')) {
        return [AppColors.cloudyNightStart, AppColors.cloudyNightEnd];
      } else {
        return [AppColors.clearNightStart, AppColors.clearNightEnd];
      }
    }
  }

  static Gradient getGradient(String condition, {bool isDark = false}) {
    final colors = getGradientColors(condition, isDay: !isDark);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        colors[0].withOpacity(0.3),
        colors[1].withOpacity(0.3),
      ],
    );
  }
} 