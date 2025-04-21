import 'package:flutter/material.dart';

class AnimatedWeatherIcon extends StatefulWidget {
  final String condition;
  final double size;

  const AnimatedWeatherIcon({
    Key? key,
    required this.condition,
    this.size = 40.0,
  }) : super(key: key);

  @override
  _AnimatedWeatherIconState createState() => _AnimatedWeatherIconState();
}

class _AnimatedWeatherIconState extends State<AnimatedWeatherIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _getWeatherIcon(String condition) {
    final lowerCondition = condition.toLowerCase();
    if (lowerCondition.contains('sun') || lowerCondition.contains('clear')) {
      return Icons.wb_sunny;
    } else if (lowerCondition.contains('rain') || lowerCondition.contains('drizzle')) {
      return Icons.water_drop;
    } else if (lowerCondition.contains('snow')) {
      return Icons.ac_unit;
    } else if (lowerCondition.contains('cloud') || lowerCondition.contains('overcast')) {
      return Icons.cloud;
    } else if (lowerCondition.contains('thunder') || lowerCondition.contains('storm')) {
      return Icons.flash_on;
    } else if (lowerCondition.contains('mist') || lowerCondition.contains('fog')) {
      return Icons.foggy;
    }
    return Icons.wb_sunny;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_animation.value * 5),
          child: Icon(
            _getWeatherIcon(widget.condition),
            color: Colors.white,
            size: widget.size,
          ),
        );
      },
    );
  }
} 