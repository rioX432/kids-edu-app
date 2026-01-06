import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Rainbow wipe page transition.
///
/// Creates a vibrant, animated rainbow that arcs across the screen,
/// wiping away the old content and painting in the new content.
/// Perfect for cheerful, celebratory navigation moments.
///
/// Best for: Activity completion, reward screens, level transitions
class RainbowWipeTransitionPage<T> extends CustomTransitionPage<T> {
  RainbowWipeTransitionPage({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
    this.direction = RainbowDirection.leftToRight,
  }) : super(
          transitionDuration: const Duration(milliseconds: 800),
          reverseTransitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              _RainbowWipeTransition(
            animation: animation,
            direction: direction,
            child: child,
          ),
        );

  final RainbowDirection direction;
}

enum RainbowDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
}

class _RainbowWipeTransition extends StatelessWidget {
  const _RainbowWipeTransition({
    required this.animation,
    required this.direction,
    required this.child,
  });

  final Animation<double> animation;
  final RainbowDirection direction;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // New content (fades in behind rainbow)
        FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: const Interval(0.3, 0.7, curve: Curves.easeIn),
          ),
          child: child,
        ),

        // Rainbow wipe overlay
        AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            return CustomPaint(
              painter: _RainbowWipePainter(
                progress: animation.value,
                direction: direction,
              ),
              size: Size.infinite,
            );
          },
        ),
      ],
    );
  }
}

class _RainbowWipePainter extends CustomPainter {
  _RainbowWipePainter({
    required this.progress,
    required this.direction,
  });

  final double progress;
  final RainbowDirection direction;

  static const List<Color> rainbowColors = [
    Color(0xFFFF6B6B), // Red
    Color(0xFFFF9F43), // Orange
    Color(0xFFFFD93D), // Yellow
    Color(0xFF6BCB77), // Green
    Color(0xFF4D96FF), // Blue
    Color(0xFF9B59B6), // Purple
    Color(0xFFE91E63), // Pink
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    // Calculate the wave position based on progress
    // The wave should sweep across and then exit
    final adjustedProgress = Curves.easeInOutCubic.transform(progress);
    final waveWidth = size.width * 0.4; // Width of the rainbow band
    final startOffset = -waveWidth;
    final endOffset = size.width + waveWidth;
    final currentPosition = startOffset + (endOffset - startOffset) * adjustedProgress;

    // Draw multiple arcs for each color
    for (var i = 0; i < rainbowColors.length; i++) {
      final paint = Paint()
        ..color = rainbowColors[i].withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = waveWidth / rainbowColors.length
        ..strokeCap = StrokeCap.round;

      final arcOffset = (i - rainbowColors.length / 2) * (waveWidth / rainbowColors.length);

      switch (direction) {
        case RainbowDirection.leftToRight:
          _drawVerticalArc(canvas, size, currentPosition + arcOffset, paint);
        case RainbowDirection.rightToLeft:
          _drawVerticalArc(canvas, size, size.width - currentPosition + arcOffset, paint);
        case RainbowDirection.topToBottom:
          _drawHorizontalArc(canvas, size, currentPosition + arcOffset, paint);
        case RainbowDirection.bottomToTop:
          _drawHorizontalArc(canvas, size, size.height - currentPosition + arcOffset, paint);
      }
    }

    // Add sparkle effects along the rainbow
    _drawSparkles(canvas, size, currentPosition);
  }

  void _drawVerticalArc(Canvas canvas, Size size, double x, Paint paint) {
    final path = Path();

    // Create a wavy vertical line
    path.moveTo(x, -50);

    for (var y = -50.0; y <= size.height + 50; y += 20) {
      final waveOffset = math.sin(y / 80 + progress * math.pi * 2) * 30;
      path.lineTo(x + waveOffset, y);
    }

    canvas.drawPath(path, paint);
  }

  void _drawHorizontalArc(Canvas canvas, Size size, double y, Paint paint) {
    final path = Path();

    path.moveTo(-50, y);

    for (var x = -50.0; x <= size.width + 50; x += 20) {
      final waveOffset = math.sin(x / 80 + progress * math.pi * 2) * 30;
      path.lineTo(x, y + waveOffset);
    }

    canvas.drawPath(path, paint);
  }

  void _drawSparkles(Canvas canvas, Size size, double position) {
    final random = math.Random(42); // Fixed seed for consistent sparkles
    final sparklePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 15; i++) {
      final sparkleY = random.nextDouble() * size.height;
      final sparkleOffset = random.nextDouble() * 60 - 30;
      final sparkleX = position + sparkleOffset;

      if (sparkleX < 0 || sparkleX > size.width) continue;

      final sparkleSize = 2 + random.nextDouble() * 4;
      final sparkleOpacity = 0.5 + random.nextDouble() * 0.5;

      canvas.drawCircle(
        Offset(sparkleX, sparkleY),
        sparkleSize,
        sparklePaint..color = Colors.white.withValues(alpha: sparkleOpacity),
      );
    }
  }

  @override
  bool shouldRepaint(_RainbowWipePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// A simpler, faster rainbow reveal effect.
///
/// Instead of a wipe, this creates expanding rainbow circles from the center.
/// Good for celebratory reveals.
class RainbowBurstTransitionPage<T> extends CustomTransitionPage<T> {
  RainbowBurstTransitionPage({
    required super.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  }) : super(
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              _RainbowBurstTransition(
            animation: animation,
            child: child,
          ),
        );
}

class _RainbowBurstTransition extends StatelessWidget {
  const _RainbowBurstTransition({
    required this.animation,
    required this.child,
  });

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // New content
        child,

        // Rainbow burst overlay (fades out as it expands)
        AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            return CustomPaint(
              painter: _RainbowBurstPainter(
                progress: animation.value,
              ),
              size: Size.infinite,
            );
          },
        ),
      ],
    );
  }
}

class _RainbowBurstPainter extends CustomPainter {
  _RainbowBurstPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.sqrt(size.width * size.width + size.height * size.height);

    // Fade out as it expands
    final opacity = (1 - progress).clamp(0.0, 1.0) * 0.6;

    // Draw concentric rainbow circles
    final colors = [
      const Color(0xFFFF6B6B),
      const Color(0xFFFF9F43),
      const Color(0xFFFFD93D),
      const Color(0xFF6BCB77),
      const Color(0xFF4D96FF),
      const Color(0xFF9B59B6),
    ];

    for (var i = 0; i < colors.length; i++) {
      final radius = maxRadius * progress * (1 + i * 0.05);
      final paint = Paint()
        ..color = colors[i].withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_RainbowBurstPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
