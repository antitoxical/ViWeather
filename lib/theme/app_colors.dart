import 'package:flutter/material.dart';

class AppColors {
  // Text colors
  static const Color textPrimary = Colors.white;
  static final Color textSecondary = Colors.white.withOpacity(0.85);
  
  // Icon colors
  static final Color iconColor = Colors.white.withOpacity(0.85);
  
  // Card colors
  static final Color cardBackground = Colors.black.withOpacity(0.2);
  static final Color cardBorder = Colors.white.withOpacity(0.1);
  
  // Gradient colors for different weather conditions
  static const Color clearDayStart = Color(0xFF87CEEB);
  static const Color clearDayEnd = Color(0xFFE0F7FA);
  static const Color clearNightStart = Color(0xFF1A1A1A);
  static const Color clearNightEnd = Color(0xFF2C3E50);
  
  static const Color cloudyDayStart = Color(0xFFB0C4DE);
  static const Color cloudyDayEnd = Color(0xFFE0E0E0);
  static const Color cloudyNightStart = Color(0xFF2C3E50);
  static const Color cloudyNightEnd = Color(0xFF34495E);
  
  static const Color rainyDayStart = Color(0xFF2C3E50);
  static const Color rainyDayEnd = Color(0xFF3498DB);
  static const Color rainyNightStart = Color(0xFF1A1A1A);
  static const Color rainyNightEnd = Color(0xFF2C3E50);
  
  // Цвета текста
  static Color textYellow = const Color(0xFFEBC700);
  
  // Акцентные цвета
  static Color accent = const Color(0xFF58A6FF);
  static Color accentLight = const Color(0xFF58A6FF).withOpacity(0.7);
  
  // Цвета для специальных состояний
  static Color error = Colors.red;
  static Color success = Colors.green;
  static Color warning = Colors.orange;
} 