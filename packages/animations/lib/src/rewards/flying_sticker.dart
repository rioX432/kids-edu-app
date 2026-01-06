import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A sticker that flies from a source position to a collection point.
///
/// Creates the satisfying effect of earning a reward and watching it
/// fly into your collection. Includes:
/// - Curved flight path with easing
/// - Scale and rotation during flight
/// - Landing bounce effect
/// - Optional particle trail
///
/// Example:
/// ```dart
/// FlyingSticker(
///   sticker: Image.asset('assets/stickers/star.png'),
///   startPosition: tapPosition,
///   endPosition: stickerBookPosition,
///   onComplete: () => updateStickerCount(),
/// )
/// ```
class FlyingSticker extends StatefulWidget {
  const FlyingSticker({
    super.key,
    required this.sticker,
    required this.startPosition,
    required this.endPosition,
    this.duration = const Duration(milliseconds: 800),
    this.showTrail = true,
    this.onComplete,
    this.size = 60,
  });

  /// The sticker widget to animate.
  final Widget sticker;

  /// Starting position (usually where the user earned the reward).
  final Offset startPosition;

  /// Ending position (the collection/sticker book location).
  final Offset endPosition;

  /// Duration of the flight animation.
  final Duration duration;

  /// Whether to show a sparkle trail behind the sticker.
  final bool showTrail;

  /// Called when the animation completes.
  final VoidCallback? onComplete;

  /// Size of the sticker during flight.
  final double size;

  @override
  State<FlyingSticker> createState() => _FlyingStickerState();
}

class _FlyingStickerState extends State<FlyingSticker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _positionAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _rotationAnimation;
  late final Animation<double> _trailOpacity;

  final List<_TrailParticle> _trailParticles = [];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Curved flight path using a quadratic bezier approximation
    final controlPoint = Offset(
      (widget.startPosition.dx + widget.endPosition.dx) / 2,
      math.min(widget.startPosition.dy, widget.endPosition.dy) - 100,
    );

    _positionAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: widget.startPosition, end: controlPoint)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: controlPoint, end: widget.endPosition)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);

    // Scale: grow at start, shrink at end
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.5, end: 1.3),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.3, end: 1.0),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.8),
        weight: 20,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Rotation during flight
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: math.pi * 2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Trail fades as sticker moves
    _trailOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    ));

    _controller.addListener(_updateTrail);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    _controller.forward();
  }

  void _updateTrail() {
    if (!widget.showTrail) return;

    // Add new particles along the path
    if (_controller.value < 0.9) {
      _trailParticles.add(_TrailParticle(
        position: _positionAnimation.value,
        createdAt: _controller.value,
      ));
    }

    // Remove old particles
    _trailParticles.removeWhere((p) => _controller.value - p.createdAt > 0.3);
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
        return Stack(
          children: [
            // Trail particles
            if (widget.showTrail)
              ..._trailParticles.map((particle) {
                final age = _controller.value - particle.createdAt;
                final opacity = (1 - age / 0.3).clamp(0.0, 1.0) * _trailOpacity.value;
                final size = widget.size * 0.3 * (1 - age / 0.3);

                return Positioned(
                  left: particle.position.dx - size / 2,
                  top: particle.position.dy - size / 2,
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.yellow.withValues(alpha: opacity * 0.6),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withValues(alpha: opacity * 0.4),
                          blurRadius: size,
                        ),
                      ],
                    ),
                  ),
                );
              }),

            // Main sticker
            Positioned(
              left: _positionAnimation.value.dx - widget.size / 2,
              top: _positionAnimation.value.dy - widget.size / 2,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: SizedBox(
                    width: widget.size,
                    height: widget.size,
                    child: widget.sticker,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TrailParticle {
  _TrailParticle({
    required this.position,
    required this.createdAt,
  });

  final Offset position;
  final double createdAt;
}

/// A celebration overlay that shows multiple stickers flying to collection.
///
/// Perfect for completing a level or earning multiple rewards at once.
class StickerCelebration extends StatefulWidget {
  const StickerCelebration({
    super.key,
    required this.stickers,
    required this.collectionPosition,
    this.onComplete,
    this.staggerDelay = const Duration(milliseconds: 150),
  });

  /// List of sticker widgets to animate.
  final List<Widget> stickers;

  /// Position where all stickers should fly to.
  final Offset collectionPosition;

  /// Called when all stickers have landed.
  final VoidCallback? onComplete;

  /// Delay between each sticker starting its animation.
  final Duration staggerDelay;

  @override
  State<StickerCelebration> createState() => _StickerCelebrationState();
}

class _StickerCelebrationState extends State<StickerCelebration> {
  final List<_StickerData> _activeStickers = [];
  int _completedCount = 0;
  final math.Random _random = math.Random();
  bool _hasStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasStarted) {
      _hasStarted = true;
      _startCelebration();
    }
  }

  void _startCelebration() async {
    final size = MediaQuery.of(context).size;

    for (var i = 0; i < widget.stickers.length; i++) {
      if (!mounted) return;

      // Random start position around the center
      final startX = _random.nextDouble() * 200 - 100;
      final startY = _random.nextDouble() * 200 - 100;

      setState(() {
        _activeStickers.add(_StickerData(
          sticker: widget.stickers[i],
          startPosition: Offset(
            size.width / 2 + startX,
            size.height / 2 + startY,
          ),
        ));
      });

      await Future.delayed(widget.staggerDelay);
    }
  }

  void _onStickerComplete() {
    _completedCount++;
    if (_completedCount >= widget.stickers.length) {
      widget.onComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _activeStickers.map((data) {
        return FlyingSticker(
          sticker: data.sticker,
          startPosition: data.startPosition,
          endPosition: widget.collectionPosition,
          onComplete: _onStickerComplete,
        );
      }).toList(),
    );
  }
}

class _StickerData {
  _StickerData({
    required this.sticker,
    required this.startPosition,
  });

  final Widget sticker;
  final Offset startPosition;
}

/// A simple animated sticker that can be used in the FlyingSticker widget.
class AnimatedSticker extends StatelessWidget {
  const AnimatedSticker({
    super.key,
    required this.type,
    this.color,
    this.size = 60,
  });

  final StickerType type;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _StickerPainter(type: type, color: color),
      ),
    );
  }
}

enum StickerType {
  star,
  heart,
  flower,
  rainbow,
  crown,
  sparkle,
}

class _StickerPainter extends CustomPainter {
  _StickerPainter({required this.type, this.color});

  final StickerType type;
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 2;

    switch (type) {
      case StickerType.star:
        _drawStar(canvas, center, radius);
      case StickerType.heart:
        _drawHeart(canvas, center, radius);
      case StickerType.flower:
        _drawFlower(canvas, center, radius);
      case StickerType.rainbow:
        _drawRainbow(canvas, center, radius);
      case StickerType.crown:
        _drawCrown(canvas, center, radius);
      case StickerType.sparkle:
        _drawSparkle(canvas, center, radius);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = color ?? const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    final path = Path();
    for (var i = 0; i < 5; i++) {
      final outerAngle = (i * 4 * math.pi / 5) - math.pi / 2;
      final innerAngle = outerAngle + math.pi / 5;

      final outerPoint = Offset(
        center.dx + math.cos(outerAngle) * radius,
        center.dy + math.sin(outerAngle) * radius,
      );
      final innerPoint = Offset(
        center.dx + math.cos(innerAngle) * radius * 0.4,
        center.dy + math.sin(innerAngle) * radius * 0.4,
      );

      if (i == 0) {
        path.moveTo(outerPoint.dx, outerPoint.dy);
      } else {
        path.lineTo(outerPoint.dx, outerPoint.dy);
      }
      path.lineTo(innerPoint.dx, innerPoint.dy);
    }
    path.close();

    // Shadow
    canvas.drawPath(
      path.shift(const Offset(2, 2)),
      Paint()..color = Colors.black.withValues(alpha: 0.2),
    );

    canvas.drawPath(path, paint);

    // Shine
    canvas.drawCircle(
      Offset(center.dx - radius * 0.2, center.dy - radius * 0.2),
      radius * 0.15,
      Paint()..color = Colors.white.withValues(alpha: 0.6),
    );
  }

  void _drawHeart(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = color ?? const Color(0xFFFF6B6B)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(center.dx, center.dy + radius * 0.4);

    // Left curve
    path.cubicTo(
      center.dx - radius * 1.2,
      center.dy - radius * 0.2,
      center.dx - radius * 0.6,
      center.dy - radius,
      center.dx,
      center.dy - radius * 0.4,
    );

    // Right curve
    path.cubicTo(
      center.dx + radius * 0.6,
      center.dy - radius,
      center.dx + radius * 1.2,
      center.dy - radius * 0.2,
      center.dx,
      center.dy + radius * 0.4,
    );

    canvas.drawPath(
      path.shift(const Offset(2, 2)),
      Paint()..color = Colors.black.withValues(alpha: 0.2),
    );

    canvas.drawPath(path, paint);

    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.3),
      radius * 0.12,
      Paint()..color = Colors.white.withValues(alpha: 0.5),
    );
  }

  void _drawFlower(Canvas canvas, Offset center, double radius) {
    final petalPaint = Paint()
      ..color = color ?? const Color(0xFFFF69B4)
      ..style = PaintingStyle.fill;

    // Petals
    for (var i = 0; i < 5; i++) {
      final angle = (i / 5) * math.pi * 2 - math.pi / 2;
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(0, -radius * 0.5),
          width: radius * 0.6,
          height: radius * 0.9,
        ),
        petalPaint,
      );
      canvas.restore();
    }

    // Center
    canvas.drawCircle(
      center,
      radius * 0.3,
      Paint()..color = const Color(0xFFFFD700),
    );
  }

  void _drawRainbow(Canvas canvas, Offset center, double radius) {
    const colors = [
      Color(0xFFFF6B6B),
      Color(0xFFFF9F43),
      Color(0xFFFFD93D),
      Color(0xFF6BCB77),
      Color(0xFF4D96FF),
      Color(0xFF9B59B6),
    ];

    final strokeWidth = radius / colors.length;

    for (var i = 0; i < colors.length; i++) {
      final arcRadius = radius - (i * strokeWidth);
      canvas.drawArc(
        Rect.fromCenter(center: center, width: arcRadius * 2, height: arcRadius * 2),
        math.pi,
        math.pi,
        false,
        Paint()
          ..color = colors[i]
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  void _drawCrown(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = color ?? const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(center.dx - radius, center.dy + radius * 0.3);
    path.lineTo(center.dx - radius * 0.6, center.dy - radius * 0.3);
    path.lineTo(center.dx - radius * 0.3, center.dy);
    path.lineTo(center.dx, center.dy - radius * 0.8);
    path.lineTo(center.dx + radius * 0.3, center.dy);
    path.lineTo(center.dx + radius * 0.6, center.dy - radius * 0.3);
    path.lineTo(center.dx + radius, center.dy + radius * 0.3);
    path.close();

    canvas.drawPath(
      path.shift(const Offset(2, 2)),
      Paint()..color = Colors.black.withValues(alpha: 0.2),
    );

    canvas.drawPath(path, paint);

    // Gems
    canvas.drawCircle(
      Offset(center.dx, center.dy - radius * 0.4),
      radius * 0.12,
      Paint()..color = const Color(0xFFFF6B6B),
    );
    canvas.drawCircle(
      Offset(center.dx - radius * 0.45, center.dy - radius * 0.1),
      radius * 0.08,
      Paint()..color = const Color(0xFF4D96FF),
    );
    canvas.drawCircle(
      Offset(center.dx + radius * 0.45, center.dy - radius * 0.1),
      radius * 0.08,
      Paint()..color = const Color(0xFF4D96FF),
    );
  }

  void _drawSparkle(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = color ?? Colors.white
      ..style = PaintingStyle.fill;

    // 4-pointed sparkle
    final path = Path();
    path.moveTo(center.dx, center.dy - radius);
    path.lineTo(center.dx + radius * 0.2, center.dy - radius * 0.2);
    path.lineTo(center.dx + radius, center.dy);
    path.lineTo(center.dx + radius * 0.2, center.dy + radius * 0.2);
    path.lineTo(center.dx, center.dy + radius);
    path.lineTo(center.dx - radius * 0.2, center.dy + radius * 0.2);
    path.lineTo(center.dx - radius, center.dy);
    path.lineTo(center.dx - radius * 0.2, center.dy - radius * 0.2);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_StickerPainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.color != color;
}
