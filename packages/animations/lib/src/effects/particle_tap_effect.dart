import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Type of particle effect on tap.
enum TapParticleType {
  /// No particle effect
  none,

  /// Star burst effect
  stars,

  /// Flower petal burst
  flowers,

  /// Sparkle/glitter effect
  sparkles,

  /// Bubble pop effect
  bubbles,

  /// Heart burst (for likes/favorites)
  hearts,
}

/// A widget that shows particle effects when tapped.
///
/// Wrap any widget to add a fun particle burst on tap.
///
/// Example:
/// ```dart
/// ParticleTapEffect(
///   type: TapParticleType.stars,
///   onTap: () => print('Tapped!'),
///   child: PrimaryButton(text: 'Press Me'),
/// )
/// ```
class ParticleTapEffect extends StatefulWidget {
  const ParticleTapEffect({
    super.key,
    required this.child,
    this.type = TapParticleType.stars,
    this.onTap,
    this.enabled = true,
    this.particleCount = 8,
    this.particleColor,
    this.duration = const Duration(milliseconds: 600),
  });

  /// The child widget to wrap.
  final Widget child;

  /// Type of particle effect.
  final TapParticleType type;

  /// Called when the widget is tapped.
  final VoidCallback? onTap;

  /// Whether the effect is enabled.
  final bool enabled;

  /// Number of particles to emit.
  final int particleCount;

  /// Color of particles. If null, uses type-specific defaults.
  final Color? particleColor;

  /// Duration of the particle animation.
  final Duration duration;

  @override
  State<ParticleTapEffect> createState() => _ParticleTapEffectState();
}

class _ParticleTapEffectState extends State<ParticleTapEffect>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Offset? _tapPosition;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _handleTap(TapDownDetails details) {
    if (!widget.enabled || widget.type == TapParticleType.none) {
      widget.onTap?.call();
      return;
    }

    setState(() {
      _tapPosition = details.localPosition;
    });

    // Stop and reset the previous controller if animating
    _controller?.stop();
    _controller?.dispose();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller!.forward().then((_) {
      if (mounted) {
        setState(() {
          _tapPosition = null;
        });
        _controller?.dispose();
        _controller = null;
      }
    });

    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          if (_tapPosition != null && _controller != null)
            Positioned(
              left: _tapPosition!.dx,
              top: _tapPosition!.dy,
              child: AnimatedBuilder(
                animation: _controller!,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _ParticlePainter(
                      progress: _controller!.value,
                      type: widget.type,
                      particleCount: widget.particleCount,
                      color: widget.particleColor,
                    ),
                    size: const Size(100, 100),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.progress,
    required this.type,
    required this.particleCount,
    this.color,
  });

  final double progress;
  final TapParticleType type;
  final int particleCount;
  final Color? color;

  Color get _defaultColor => switch (type) {
        TapParticleType.none => Colors.transparent,
        TapParticleType.stars => const Color(0xFFFFD700),
        TapParticleType.flowers => const Color(0xFFFF69B4),
        TapParticleType.sparkles => const Color(0xFFFFFFFF),
        TapParticleType.bubbles => const Color(0xFF87CEEB),
        TapParticleType.hearts => const Color(0xFFFF6B6B),
      };

  @override
  void paint(Canvas canvas, Size size) {
    if (type == TapParticleType.none) return;

    final particleColor = color ?? _defaultColor;
    final opacity = (1.0 - progress).clamp(0.0, 1.0);

    for (var i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * math.pi * 2;
      final distance = 40.0 * progress;
      final wobble = math.sin(i * 1.5) * 10 * progress;

      final x = math.cos(angle) * (distance + wobble);
      final y = math.sin(angle) * (distance + wobble);

      final paint = Paint()
        ..color = particleColor.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);

      final particleSize = (8.0 * (1.0 - progress * 0.5));

      switch (type) {
        case TapParticleType.none:
          break;
        case TapParticleType.stars:
          _drawStar(canvas, particleSize, paint);
        case TapParticleType.flowers:
          _drawFlower(canvas, particleSize, paint);
        case TapParticleType.sparkles:
          _drawSparkle(canvas, particleSize, paint);
        case TapParticleType.bubbles:
          _drawBubble(canvas, particleSize, paint);
        case TapParticleType.hearts:
          _drawHeart(canvas, particleSize, paint);
      }

      canvas.restore();
    }
  }

  void _drawStar(Canvas canvas, double size, Paint paint) {
    final path = Path();
    for (var i = 0; i < 5; i++) {
      final angle = (i * 4 * math.pi / 5) - math.pi / 2;
      final point = Offset(
        math.cos(angle) * size,
        math.sin(angle) * size,
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawFlower(Canvas canvas, double size, Paint paint) {
    // Draw 5 petals
    for (var i = 0; i < 5; i++) {
      final angle = (i / 5) * math.pi * 2;
      canvas.save();
      canvas.rotate(angle);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(0, -size * 0.5),
          width: size * 0.6,
          height: size,
        ),
        paint,
      );
      canvas.restore();
    }
    // Center
    canvas.drawCircle(Offset.zero, size * 0.3, paint);
  }

  void _drawSparkle(Canvas canvas, double size, Paint paint) {
    // 4-pointed sparkle
    final path = Path();
    for (var i = 0; i < 4; i++) {
      final angle = (i / 4) * math.pi * 2;
      final innerAngle = angle + math.pi / 4;
      final outerPoint = Offset(
        math.cos(angle) * size,
        math.sin(angle) * size,
      );
      final innerPoint = Offset(
        math.cos(innerAngle) * size * 0.3,
        math.sin(innerAngle) * size * 0.3,
      );
      if (i == 0) {
        path.moveTo(outerPoint.dx, outerPoint.dy);
      } else {
        path.lineTo(outerPoint.dx, outerPoint.dy);
      }
      path.lineTo(innerPoint.dx, innerPoint.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawBubble(Canvas canvas, double size, Paint paint) {
    final bubblePaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset.zero, size, bubblePaint);

    // Highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: paint.color.a * 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(-size * 0.3, -size * 0.3),
      size * 0.2,
      highlightPaint,
    );
  }

  void _drawHeart(Canvas canvas, double size, Paint paint) {
    final path = Path();
    path.moveTo(0, size * 0.3);
    path.cubicTo(
      -size,
      -size * 0.5,
      -size * 0.5,
      -size,
      0,
      -size * 0.5,
    );
    path.cubicTo(
      size * 0.5,
      -size,
      size,
      -size * 0.5,
      0,
      size * 0.3,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
