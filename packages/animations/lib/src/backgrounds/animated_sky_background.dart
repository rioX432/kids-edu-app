import 'dart:math' as math;

import 'package:flutter/material.dart';

/// An animated sky background with floating clouds, sun, and interactive elements.
///
/// This creates a living, breathing background that makes the app feel magical
/// for young children. Clouds drift slowly, the sun pulses with warmth, and
/// tapping elements triggers delightful reactions.
///
/// Example:
/// ```dart
/// AnimatedSkyBackground(
///   child: YourContent(),
///   timeOfDay: TimeOfDay.day,
///   enableInteraction: true,
/// )
/// ```
class AnimatedSkyBackground extends StatefulWidget {
  const AnimatedSkyBackground({
    super.key,
    required this.child,
    this.timeOfDay = SkyTimeOfDay.day,
    this.enableInteraction = true,
    this.cloudCount = 5,
    this.showSun = true,
    this.showStars = false,
    this.onSunTap,
    this.onCloudTap,
  });

  /// The content to display on top of the background.
  final Widget child;

  /// Time of day affects colors and elements shown.
  final SkyTimeOfDay timeOfDay;

  /// Whether tapping clouds/sun triggers effects.
  final bool enableInteraction;

  /// Number of clouds to show.
  final int cloudCount;

  /// Whether to show the sun.
  final bool showSun;

  /// Whether to show twinkling stars (for night mode).
  final bool showStars;

  /// Called when the sun is tapped.
  final VoidCallback? onSunTap;

  /// Called when a cloud is tapped (triggers rain effect).
  final VoidCallback? onCloudTap;

  @override
  State<AnimatedSkyBackground> createState() => _AnimatedSkyBackgroundState();
}

class _AnimatedSkyBackgroundState extends State<AnimatedSkyBackground>
    with TickerProviderStateMixin {
  late final List<_CloudData> _clouds;
  late final AnimationController _cloudController;
  late final AnimationController _sunPulseController;
  final math.Random _random = math.Random();

  // Sun tap effect
  bool _sunTapped = false;
  late final AnimationController _sunBurstController;

  @override
  void initState() {
    super.initState();

    // Initialize clouds with random positions and speeds
    _clouds = List.generate(widget.cloudCount, (index) {
      return _CloudData(
        startX: _random.nextDouble() * 1.5 - 0.25,
        y: 0.05 + _random.nextDouble() * 0.25,
        speed: 0.08 + _random.nextDouble() * 0.08, // Faster clouds!
        scale: 0.8 + _random.nextDouble() * 0.4,
        opacity: 0.6 + _random.nextDouble() * 0.4,
      );
    });

    // Cloud drift animation
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    // Sun pulse animation
    _sunPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    // Sun burst effect on tap
    _sunBurstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _sunPulseController.dispose();
    _sunBurstController.dispose();
    super.dispose();
  }

  void _handleSunTap() {
    if (!widget.enableInteraction) return;

    setState(() => _sunTapped = true);
    _sunBurstController.forward(from: 0).then((_) {
      if (mounted) setState(() => _sunTapped = false);
    });
    widget.onSunTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getSkyColors();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
      child: Stack(
        children: [
          // Stars (for night mode)
          if (widget.showStars) _buildStars(),

          // Clouds
          ..._buildClouds(),

          // Sun or Moon
          if (widget.showSun) _buildSun(),

          // Sun burst effect
          if (_sunTapped) _buildSunBurst(),

          // Main content
          widget.child,
        ],
      ),
    );
  }

  List<Color> _getSkyColors() {
    return switch (widget.timeOfDay) {
      SkyTimeOfDay.day => const [
          Color(0xFF87CEEB), // Light sky blue
          Color(0xFFB0E0E6), // Powder blue
          Color(0xFFF0F8FF), // Alice blue
        ],
      SkyTimeOfDay.sunset => const [
          Color(0xFFFF7F50), // Coral
          Color(0xFFFFB347), // Pastel orange
          Color(0xFFFFE4B5), // Moccasin
        ],
      SkyTimeOfDay.night => const [
          Color(0xFF191970), // Midnight blue
          Color(0xFF483D8B), // Dark slate blue
          Color(0xFF6A5ACD), // Slate blue
        ],
    };
  }

  Widget _buildStars() {
    return CustomPaint(
      painter: _StarsPainter(
        starCount: 50,
        random: _random,
      ),
      size: Size.infinite,
    );
  }

  List<Widget> _buildClouds() {
    return _clouds.asMap().entries.map((entry) {
      final index = entry.key;
      final cloud = entry.value;

      return AnimatedBuilder(
        animation: _cloudController,
        builder: (context, child) {
          // Calculate cloud position based on time
          final progress = (_cloudController.value * cloud.speed + cloud.startX) % 1.5 - 0.25;

          return Positioned(
            left: progress * MediaQuery.of(context).size.width,
            top: cloud.y * MediaQuery.of(context).size.height,
            child: GestureDetector(
              onTap: widget.enableInteraction
                  ? () => _triggerRain(index)
                  : null,
              child: Opacity(
                opacity: cloud.opacity,
                child: Transform.scale(
                  scale: cloud.scale,
                  child: _CloudWidget(
                    color: widget.timeOfDay == SkyTimeOfDay.night
                        ? Colors.grey.shade600
                        : Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }

  void _triggerRain(int cloudIndex) {
    widget.onCloudTap?.call();
    // Rain effect would be triggered here via overlay
  }

  Widget _buildSun() {
    final sunColor = widget.timeOfDay == SkyTimeOfDay.night
        ? Colors.grey.shade300 // Moon
        : const Color(0xFFFFD700); // Sun

    return AnimatedBuilder(
      animation: _sunPulseController,
      builder: (context, child) {
        final scale = 1.0 + (_sunPulseController.value * 0.05);
        final glowRadius = 40.0 + (_sunPulseController.value * 20);

        return Positioned(
          top: 40,
          right: 40,
          child: GestureDetector(
            onTap: _handleSunTap,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: sunColor,
                boxShadow: [
                  BoxShadow(
                    color: sunColor.withValues(alpha: 0.6),
                    blurRadius: glowRadius,
                    spreadRadius: 10,
                  ),
                ],
              ),
              transform: Matrix4.identity()..scale(scale),
              transformAlignment: Alignment.center,
              child: widget.timeOfDay == SkyTimeOfDay.night
                  ? _buildMoonCraters()
                  : null,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMoonCraters() {
    return Stack(
      children: [
        Positioned(
          top: 15,
          left: 20,
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade400.withValues(alpha: 0.5),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 15,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade400.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSunBurst() {
    return AnimatedBuilder(
      animation: _sunBurstController,
      builder: (context, child) {
        return Positioned.fill(
          child: CustomPaint(
            painter: _SunBurstPainter(
              progress: _sunBurstController.value,
              color: const Color(0xFFFFD700),
            ),
          ),
        );
      },
    );
  }
}

/// Time of day for sky colors.
enum SkyTimeOfDay {
  day,
  sunset,
  night,
}

/// Data class for cloud properties.
class _CloudData {
  _CloudData({
    required this.startX,
    required this.y,
    required this.speed,
    required this.scale,
    required this.opacity,
  });

  final double startX;
  final double y;
  final double speed;
  final double scale;
  final double opacity;
}

/// Cloud shape widget.
class _CloudWidget extends StatelessWidget {
  const _CloudWidget({
    this.color = Colors.white,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 60,
      child: CustomPaint(
        painter: _CloudPainter(color: color),
      ),
    );
  }
}

/// Custom painter for fluffy cloud shape.
class _CloudPainter extends CustomPainter {
  _CloudPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw overlapping circles for fluffy cloud effect
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.6), 25, paint);
    canvas.drawCircle(Offset(size.width * 0.45, size.height * 0.4), 35, paint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.5), 30, paint);
    canvas.drawCircle(Offset(size.width * 0.55, size.height * 0.65), 25, paint);
  }

  @override
  bool shouldRepaint(_CloudPainter oldDelegate) => oldDelegate.color != color;
}

/// Custom painter for twinkling stars.
class _StarsPainter extends CustomPainter {
  _StarsPainter({
    required this.starCount,
    required this.random,
  });

  final int starCount;
  final math.Random random;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Use consistent seed for stable positions
    final stableRandom = math.Random(42);

    for (var i = 0; i < starCount; i++) {
      final x = stableRandom.nextDouble() * size.width;
      final y = stableRandom.nextDouble() * size.height * 0.6;
      final radius = 1.0 + stableRandom.nextDouble() * 2;
      final opacity = 0.3 + stableRandom.nextDouble() * 0.7;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint..color = Colors.white.withValues(alpha: opacity),
      );
    }
  }

  @override
  bool shouldRepaint(_StarsPainter oldDelegate) => false;
}

/// Custom painter for sun burst effect on tap.
class _SunBurstPainter extends CustomPainter {
  _SunBurstPainter({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0 || progress == 1) return;

    final center = Offset(size.width - 80, 80); // Sun position
    final maxRadius = size.width * 1.5;
    final currentRadius = maxRadius * Curves.easeOut.transform(progress);
    final opacity = (1 - progress) * 0.3;

    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, currentRadius, paint);

    // Draw rays
    final rayPaint = Paint()
      ..color = color.withValues(alpha: opacity * 0.5)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < 12; i++) {
      final angle = (i / 12) * math.pi * 2;
      final rayLength = currentRadius * 0.3;
      final start = Offset(
        center.dx + math.cos(angle) * currentRadius * 0.5,
        center.dy + math.sin(angle) * currentRadius * 0.5,
      );
      final end = Offset(
        center.dx + math.cos(angle) * (currentRadius * 0.5 + rayLength),
        center.dy + math.sin(angle) * (currentRadius * 0.5 + rayLength),
      );
      canvas.drawLine(start, end, rayPaint);
    }
  }

  @override
  bool shouldRepaint(_SunBurstPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
