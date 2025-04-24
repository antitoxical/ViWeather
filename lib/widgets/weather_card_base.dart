import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:viweather1/theme/app_colors.dart';
import 'package:viweather1/theme/weather_gradients.dart';

class WeatherCardBase extends StatelessWidget {
  final String condition;
  final Widget child;
  final double? height;
  final bool isDay;

  const WeatherCardBase({
    super.key,
    required this.condition,
    required this.child,
    this.height,
    this.isDay = true,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: AppColors.cardBackground,
            border: Border.all(
              color: AppColors.cardBorder,
              width: 0.5,
            ),
            gradient: WeatherGradients.getGradient(condition, isDark: !isDay),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }
} 