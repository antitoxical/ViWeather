import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedWeatherBackground extends StatefulWidget {
  final String weatherCondition;
  final bool isDay;

  const AnimatedWeatherBackground({
    Key? key,
    required this.weatherCondition,
    required this.isDay,
  }) : super(key: key);

  @override
  _AnimatedWeatherBackgroundState createState() => _AnimatedWeatherBackgroundState();
}

class _AnimatedWeatherBackgroundState extends State<AnimatedWeatherBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<RainDrop> _rainDrops = [];
  final List<SnowFlake> _snowFlakes = [];
  final List<Cloud> _clouds = [];
  final List<Lightning> _lightnings = [];
  final List<FogParticle> _fogParticles = [];
  final List<Leaf> _leaves = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();

    _initializeAnimationElements();
  }

  void _initializeAnimationElements() {
    _rainDrops.clear();
    _snowFlakes.clear();
    _clouds.clear();
    _lightnings.clear();
    _fogParticles.clear();
    _leaves.clear();

    if (widget.weatherCondition.toLowerCase().contains('rain')) {
      for (int i = 0; i < 50; i++) {
        _rainDrops.add(RainDrop(
          x: math.Random().nextDouble() * 400,
          y: math.Random().nextDouble() * 800,
          speed: 5 + math.Random().nextDouble() * 5,
        ));
      }
    }

    if (widget.weatherCondition.toLowerCase().contains('snow')) {
      for (int i = 0; i < 50; i++) {
        _snowFlakes.add(SnowFlake(
          x: math.Random().nextDouble() * 400,
          y: math.Random().nextDouble() * 800,
          speed: 2 + math.Random().nextDouble() * 3,
          size: 2 + math.Random().nextDouble() * 3,
        ));
      }
    }

    if (widget.weatherCondition.toLowerCase().contains('thunder')) {
      for (int i = 0; i < 3; i++) {
        _lightnings.add(Lightning(
          x: math.Random().nextDouble() * 400,
          y: math.Random().nextDouble() * 200,
          duration: 0.2 + math.Random().nextDouble() * 0.3,
        ));
      }
    }

    if (widget.weatherCondition.toLowerCase().contains('fog')) {
      for (int i = 0; i < 30; i++) {
        _fogParticles.add(FogParticle(
          x: math.Random().nextDouble() * 400,
          y: math.Random().nextDouble() * 800,
          size: 20 + math.Random().nextDouble() * 40,
          speed: 0.5 + math.Random().nextDouble() * 1,
        ));
      }
    }

    if (widget.weatherCondition.toLowerCase().contains('wind')) {
      for (int i = 0; i < 20; i++) {
        _leaves.add(Leaf(
          x: math.Random().nextDouble() * 400,
          y: math.Random().nextDouble() * 800,
          speed: 3 + math.Random().nextDouble() * 5,
          rotation: math.Random().nextDouble() * 360,
        ));
      }
    }

    // Добавляем облака для всех погодных условий
    for (int i = 0; i < 5; i++) {
      _clouds.add(Cloud(
        x: math.Random().nextDouble() * 400,
        y: math.Random().nextDouble() * 200,
        speed: 0.5 + math.Random().nextDouble() * 1,
        size: 50 + math.Random().nextDouble() * 100,
        opacity: 0.7 + math.Random().nextDouble() * 0.3,
      ));
    }
  }

  @override
  void didUpdateWidget(AnimatedWeatherBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weatherCondition != widget.weatherCondition) {
      _initializeAnimationElements();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: WeatherBackgroundPainter(
            weatherCondition: widget.weatherCondition,
            isDay: widget.isDay,
            rainDrops: _rainDrops,
            snowFlakes: _snowFlakes,
            clouds: _clouds,
            lightnings: _lightnings,
            fogParticles: _fogParticles,
            leaves: _leaves,
            animationValue: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class WeatherBackgroundPainter extends CustomPainter {
  final String weatherCondition;
  final bool isDay;
  final List<RainDrop> rainDrops;
  final List<SnowFlake> snowFlakes;
  final List<Cloud> clouds;
  final List<Lightning> lightnings;
  final List<FogParticle> fogParticles;
  final List<Leaf> leaves;
  final double animationValue;

  WeatherBackgroundPainter({
    required this.weatherCondition,
    required this.isDay,
    required this.rainDrops,
    required this.snowFlakes,
    required this.clouds,
    required this.lightnings,
    required this.fogParticles,
    required this.leaves,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Рисуем градиент фона
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: _getBackgroundColors(),
    );
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    // Рисуем облака
    for (var cloud in clouds) {
      _drawCloud(canvas, cloud, size);
    }

    // Рисуем молнии
    if (weatherCondition.toLowerCase().contains('thunder')) {
      for (var lightning in lightnings) {
        _drawLightning(canvas, lightning, size);
      }
    }

    // Рисуем туман
    if (weatherCondition.toLowerCase().contains('fog')) {
      for (var particle in fogParticles) {
        _drawFogParticle(canvas, particle, size);
      }
    }

    // Рисуем листья
    if (weatherCondition.toLowerCase().contains('wind')) {
      for (var leaf in leaves) {
        _drawLeaf(canvas, leaf, size);
      }
    }

    // Рисуем дождь
    if (weatherCondition.toLowerCase().contains('rain')) {
      for (var drop in rainDrops) {
        _drawRainDrop(canvas, drop, size);
      }
    }

    // Рисуем снег
    if (weatherCondition.toLowerCase().contains('snow')) {
      for (var flake in snowFlakes) {
        _drawSnowFlake(canvas, flake, size);
      }
    }
  }

  List<Color> _getBackgroundColors() {
    if (isDay) {
      if (weatherCondition.toLowerCase().contains('rain')) {
        return [Color(0xFF2C3E50), Color(0xFF3498DB)];
      } else if (weatherCondition.toLowerCase().contains('snow')) {
        return [Color(0xFFE0E0E0), Color(0xFFB0C4DE)];
      } else if (weatherCondition.toLowerCase().contains('thunder')) {
        return [Color(0xFF1A1A1A), Color(0xFF2C3E50)];
      } else if (weatherCondition.toLowerCase().contains('fog')) {
        return [Color(0xFFB0C4DE), Color(0xFFE0E0E0)];
      } else {
        return [Color(0xFF87CEEB), Color(0xFFE0F7FA)];
      }
    } else {
      if (weatherCondition.toLowerCase().contains('rain')) {
        return [Color(0xFF1A1A1A), Color(0xFF2C3E50)];
      } else if (weatherCondition.toLowerCase().contains('snow')) {
        return [Color(0xFF2C3E50), Color(0xFF34495E)];
      } else if (weatherCondition.toLowerCase().contains('thunder')) {
        return [Color(0xFF000000), Color(0xFF1A1A1A)];
      } else if (weatherCondition.toLowerCase().contains('fog')) {
        return [Color(0xFF2C3E50), Color(0xFF34495E)];
      } else {
        return [Color(0xFF1A1A1A), Color(0xFF2C3E50)];
      }
    }
  }

  Color getCurrentBackgroundColor() {
    final colors = _getBackgroundColors();
    return colors[0];
  }

  void _drawCloud(Canvas canvas, Cloud cloud, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(cloud.opacity)
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);

    final mainCloud = Path();
    mainCloud.moveTo(cloud.x, cloud.y);
    mainCloud.cubicTo(
      cloud.x + cloud.size * 0.3,
      cloud.y - cloud.size * 0.4,
      cloud.x + cloud.size * 0.7,
      cloud.y - cloud.size * 0.4,
      cloud.x + cloud.size,
      cloud.y,
    );
    mainCloud.cubicTo(
      cloud.x + cloud.size * 1.2,
      cloud.y,
      cloud.x + cloud.size * 1.2,
      cloud.y + cloud.size * 0.3,
      cloud.x + cloud.size,
      cloud.y + cloud.size * 0.3,
    );
    mainCloud.cubicTo(
      cloud.x + cloud.size,
      cloud.y + cloud.size * 0.6,
      cloud.x + cloud.size * 0.7,
      cloud.y + cloud.size * 0.6,
      cloud.x + cloud.size * 0.5,
      cloud.y + cloud.size * 0.6,
    );
    mainCloud.cubicTo(
      cloud.x + cloud.size * 0.3,
      cloud.y + cloud.size * 0.8,
      cloud.x + cloud.size * 0.1,
      cloud.y + cloud.size * 0.6,
      cloud.x,
      cloud.y + cloud.size * 0.3,
    );
    mainCloud.close();

    final additionalClouds = [
      Path()
        ..moveTo(cloud.x + cloud.size * 0.2, cloud.y - cloud.size * 0.2)
        ..cubicTo(
          cloud.x + cloud.size * 0.4,
          cloud.y - cloud.size * 0.4,
          cloud.x + cloud.size * 0.6,
          cloud.y - cloud.size * 0.2,
          cloud.x + cloud.size * 0.8,
          cloud.y - cloud.size * 0.2,
        )
        ..cubicTo(
          cloud.x + cloud.size * 0.9,
          cloud.y - cloud.size * 0.1,
          cloud.x + cloud.size * 0.8,
          cloud.y,
          cloud.x + cloud.size * 0.6,
          cloud.y,
        )
        ..cubicTo(
          cloud.x + cloud.size * 0.4,
          cloud.y + cloud.size * 0.1,
          cloud.x + cloud.size * 0.2,
          cloud.y,
          cloud.x + cloud.size * 0.2,
          cloud.y - cloud.size * 0.2,
        )
        ..close(),
      Path()
        ..moveTo(cloud.x + cloud.size * 0.4, cloud.y + cloud.size * 0.2)
        ..cubicTo(
          cloud.x + cloud.size * 0.6,
          cloud.y + cloud.size * 0.1,
          cloud.x + cloud.size * 0.8,
          cloud.y + cloud.size * 0.2,
          cloud.x + cloud.size * 0.9,
          cloud.y + cloud.size * 0.3,
        )
        ..cubicTo(
          cloud.x + cloud.size * 1.0,
          cloud.y + cloud.size * 0.4,
          cloud.x + cloud.size * 0.9,
          cloud.y + cloud.size * 0.5,
          cloud.x + cloud.size * 0.7,
          cloud.y + cloud.size * 0.4,
        )
        ..cubicTo(
          cloud.x + cloud.size * 0.5,
          cloud.y + cloud.size * 0.3,
          cloud.x + cloud.size * 0.3,
          cloud.y + cloud.size * 0.4,
          cloud.x + cloud.size * 0.4,
          cloud.y + cloud.size * 0.2,
        )
        ..close(),
    ];

    canvas.drawPath(mainCloud, shadowPaint);
    canvas.drawPath(mainCloud, paint);

    for (var additionalCloud in additionalClouds) {
      canvas.drawPath(additionalCloud, paint);
    }
  }

  void _drawLightning(Canvas canvas, Lightning lightning, Size size) {
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(lightning.x, lightning.y);
    path.lineTo(lightning.x + 20, lightning.y + 40);
    path.lineTo(lightning.x - 10, lightning.y + 60);
    path.lineTo(lightning.x + 30, lightning.y + 100);

    canvas.drawPath(path, paint);
  }

  void _drawFogParticle(Canvas canvas, FogParticle particle, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20);

    canvas.drawCircle(
      Offset(particle.x, particle.y),
      particle.size,
      paint,
    );
  }

  void _drawLeaf(Canvas canvas, Leaf leaf, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(leaf.x, leaf.y);
    canvas.rotate(leaf.rotation * math.pi / 180);

    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(5, -10, 10, 0);
    path.quadraticBezierTo(15, 10, 0, 20);
    path.quadraticBezierTo(-15, 10, -10, 0);
    path.quadraticBezierTo(-5, -10, 0, 0);
    path.close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  void _drawRainDrop(Canvas canvas, RainDrop drop, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.6)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(drop.x, drop.y),
      Offset(drop.x, drop.y + 10),
      paint,
    );
  }

  void _drawSnowFlake(Canvas canvas, SnowFlake flake, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(flake.x, flake.y),
      flake.size,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class RainDrop {
  double x;
  double y;
  final double speed;

  RainDrop({
    required this.x,
    required this.y,
    required this.speed,
  });
}

class SnowFlake {
  double x;
  double y;
  final double speed;
  final double size;

  SnowFlake({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
  });
}

class Cloud {
  double x;
  double y;
  final double speed;
  final double size;
  final double opacity;

  Cloud({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
  });
}

class Lightning {
  final double x;
  final double y;
  final double duration;

  Lightning({
    required this.x,
    required this.y,
    required this.duration,
  });
}

class FogParticle {
  double x;
  double y;
  final double size;
  final double speed;

  FogParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}

class Leaf {
  double x;
  double y;
  final double speed;
  final double rotation;

  Leaf({
    required this.x,
    required this.y,
    required this.speed,
    required this.rotation,
  });
} 