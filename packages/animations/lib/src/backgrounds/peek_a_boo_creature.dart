import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A cute creature that peeks out from behind scenery.
///
/// Creates the delightful effect of animals (bunny, squirrel, etc.)
/// peeking out from behind trees, bushes, or hills, encouraging
/// exploration and adding life to backgrounds.
///
/// Example:
/// ```dart
/// PeekABooCreature(
///   type: CreatureType.bunny,
///   position: PeekPosition.bottomLeft,
///   triggerOnTap: true,
/// )
/// ```
class PeekABooCreature extends StatefulWidget {
  const PeekABooCreature({
    super.key,
    this.type = CreatureType.bunny,
    this.position = PeekPosition.bottomRight,
    this.autoPeek = true,
    this.peekInterval = const Duration(seconds: 8),
    this.triggerOnTap = true,
    this.onTap,
    this.size = 60,
  });

  /// Type of creature to show.
  final CreatureType type;

  /// Position where creature peeks from.
  final PeekPosition position;

  /// Whether creature automatically peeks periodically.
  final bool autoPeek;

  /// Interval between auto-peeks.
  final Duration peekInterval;

  /// Whether tapping triggers the creature to peek.
  final bool triggerOnTap;

  /// Called when creature is tapped while peeking.
  final VoidCallback? onTap;

  /// Size of the creature.
  final double size;

  @override
  State<PeekABooCreature> createState() => _PeekABooCreatureState();
}

class _PeekABooCreatureState extends State<PeekABooCreature>
    with TickerProviderStateMixin {
  late final AnimationController _peekController;
  late final AnimationController _blinkController;
  late final Animation<double> _peekAnimation;
  bool _isHiding = true;
  bool _isBlinking = false;

  @override
  void initState() {
    super.initState();

    _peekController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _peekAnimation = CurvedAnimation(
      parent: _peekController,
      curve: Curves.elasticOut,
      reverseCurve: Curves.easeInBack,
    );

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    if (widget.autoPeek) {
      _startAutoPeek();
    }
  }

  void _startAutoPeek() {
    Future.delayed(
      Duration(
        milliseconds: widget.peekInterval.inMilliseconds +
            math.Random().nextInt(3000),
      ),
      () {
        if (mounted && widget.autoPeek) {
          _doPeek();
        }
      },
    );
  }

  void _doPeek() async {
    if (!mounted || !_isHiding) return;

    setState(() => _isHiding = false);
    await _peekController.forward();

    // Blink a few times
    for (var i = 0; i < 2; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      setState(() => _isBlinking = true);
      await _blinkController.forward();
      await _blinkController.reverse();
      setState(() => _isBlinking = false);
    }

    // Wait then hide
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    await _peekController.reverse();
    setState(() => _isHiding = true);

    // Schedule next peek
    if (widget.autoPeek) {
      _startAutoPeek();
    }
  }

  @override
  void dispose() {
    _peekController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _peekAnimation,
      builder: (context, child) {
        final hideOffset = _getHideOffset();
        final currentOffset = Offset.lerp(
          hideOffset,
          Offset.zero,
          _peekAnimation.value,
        )!;

        return Transform.translate(
          offset: currentOffset,
          child: GestureDetector(
            onTap: () {
              if (!_isHiding) {
                widget.onTap?.call();
              } else if (widget.triggerOnTap) {
                _doPeek();
              }
            },
            child: _buildCreature(),
          ),
        );
      },
    );
  }

  Offset _getHideOffset() {
    return switch (widget.position) {
      PeekPosition.bottomLeft => Offset(-widget.size * 0.8, widget.size * 0.5),
      PeekPosition.bottomRight => Offset(widget.size * 0.8, widget.size * 0.5),
      PeekPosition.topLeft => Offset(-widget.size * 0.8, -widget.size * 0.5),
      PeekPosition.topRight => Offset(widget.size * 0.8, -widget.size * 0.5),
    };
  }

  Widget _buildCreature() {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CustomPaint(
        painter: _CreaturePainter(
          type: widget.type,
          isBlinking: _isBlinking,
        ),
      ),
    );
  }
}

/// Types of cute creatures.
enum CreatureType {
  bunny,
  squirrel,
  bird,
  owl,
  hedgehog,
}

/// Position where creature peeks from.
enum PeekPosition {
  bottomLeft,
  bottomRight,
  topLeft,
  topRight,
}

/// Custom painter for creature faces.
class _CreaturePainter extends CustomPainter {
  _CreaturePainter({
    required this.type,
    required this.isBlinking,
  });

  final CreatureType type;
  final bool isBlinking;

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case CreatureType.bunny:
        _paintBunny(canvas, size);
      case CreatureType.squirrel:
        _paintSquirrel(canvas, size);
      case CreatureType.bird:
        _paintBird(canvas, size);
      case CreatureType.owl:
        _paintOwl(canvas, size);
      case CreatureType.hedgehog:
        _paintHedgehog(canvas, size);
    }
  }

  void _paintBunny(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Ears
    final earPaint = Paint()..color = const Color(0xFFFFB6C1);
    final earInnerPaint = Paint()..color = const Color(0xFFFFDADD);

    // Left ear
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - 12, center.dy - 30),
        width: 16,
        height: 35,
      ),
      earPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - 12, center.dy - 28),
        width: 8,
        height: 25,
      ),
      earInnerPaint,
    );

    // Right ear
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + 12, center.dy - 30),
        width: 16,
        height: 35,
      ),
      earPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + 12, center.dy - 28),
        width: 8,
        height: 25,
      ),
      earInnerPaint,
    );

    // Face
    final facePaint = Paint()..color = const Color(0xFFFFE4E1);
    canvas.drawCircle(center, 25, facePaint);

    // Eyes
    _drawEyes(canvas, center, 8, isBlinking);

    // Nose
    final nosePaint = Paint()..color = const Color(0xFFFF69B4);
    canvas.drawCircle(Offset(center.dx, center.dy + 5), 4, nosePaint);

    // Cheeks
    final cheekPaint = Paint()..color = const Color(0xFFFFB6C1).withValues(alpha: 0.5);
    canvas.drawCircle(Offset(center.dx - 18, center.dy + 5), 6, cheekPaint);
    canvas.drawCircle(Offset(center.dx + 18, center.dy + 5), 6, cheekPaint);
  }

  void _paintSquirrel(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Ears
    final earPaint = Paint()..color = const Color(0xFFD2691E);
    canvas.drawCircle(Offset(center.dx - 18, center.dy - 18), 10, earPaint);
    canvas.drawCircle(Offset(center.dx + 18, center.dy - 18), 10, earPaint);

    // Face
    final facePaint = Paint()..color = const Color(0xFFCD853F);
    canvas.drawCircle(center, 25, facePaint);

    // Lighter face area
    final lightPaint = Paint()..color = const Color(0xFFDEB887);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 5), width: 30, height: 25),
      lightPaint,
    );

    // Eyes
    _drawEyes(canvas, Offset(center.dx, center.dy - 3), 8, isBlinking);

    // Nose
    final nosePaint = Paint()..color = const Color(0xFF8B4513);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 8), width: 8, height: 6),
      nosePaint,
    );
  }

  void _paintBird(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Body/face
    final bodyPaint = Paint()..color = const Color(0xFF87CEEB);
    canvas.drawCircle(center, 25, bodyPaint);

    // Belly
    final bellyPaint = Paint()..color = const Color(0xFFE0FFFF);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.dx, center.dy + 8), width: 25, height: 20),
      bellyPaint,
    );

    // Beak
    final beakPaint = Paint()..color = const Color(0xFFFF8C00);
    final beakPath = Path()
      ..moveTo(center.dx - 8, center.dy + 3)
      ..lineTo(center.dx, center.dy + 12)
      ..lineTo(center.dx + 8, center.dy + 3)
      ..close();
    canvas.drawPath(beakPath, beakPaint);

    // Eyes
    _drawEyes(canvas, Offset(center.dx, center.dy - 5), 8, isBlinking);

    // Head tuft
    final tuftPaint = Paint()..color = const Color(0xFF4169E1);
    canvas.drawCircle(Offset(center.dx, center.dy - 28), 6, tuftPaint);
    canvas.drawCircle(Offset(center.dx - 5, center.dy - 25), 4, tuftPaint);
    canvas.drawCircle(Offset(center.dx + 5, center.dy - 25), 4, tuftPaint);
  }

  void _paintOwl(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Ear tufts
    final tuftPaint = Paint()..color = const Color(0xFF8B4513);
    canvas.drawPath(
      Path()
        ..moveTo(center.dx - 25, center.dy - 10)
        ..lineTo(center.dx - 20, center.dy - 30)
        ..lineTo(center.dx - 10, center.dy - 15)
        ..close(),
      tuftPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(center.dx + 25, center.dy - 10)
        ..lineTo(center.dx + 20, center.dy - 30)
        ..lineTo(center.dx + 10, center.dy - 15)
        ..close(),
      tuftPaint,
    );

    // Face
    final facePaint = Paint()..color = const Color(0xFFD2B48C);
    canvas.drawCircle(center, 25, facePaint);

    // Face disc
    final discPaint = Paint()..color = const Color(0xFFF5DEB3);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 40, height: 35),
      discPaint,
    );

    // Big owl eyes
    _drawOwlEyes(canvas, center, isBlinking);

    // Beak
    final beakPaint = Paint()..color = const Color(0xFFFF8C00);
    canvas.drawPath(
      Path()
        ..moveTo(center.dx - 5, center.dy + 5)
        ..lineTo(center.dx, center.dy + 12)
        ..lineTo(center.dx + 5, center.dy + 5)
        ..close(),
      beakPaint,
    );
  }

  void _paintHedgehog(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Spines
    final spinePaint = Paint()..color = const Color(0xFF8B4513);
    for (var i = 0; i < 8; i++) {
      final angle = -math.pi / 2 + (i - 3.5) * 0.3;
      canvas.drawPath(
        Path()
          ..moveTo(
            center.dx + math.cos(angle) * 20,
            center.dy + math.sin(angle) * 20 - 5,
          )
          ..lineTo(
            center.dx + math.cos(angle) * 35,
            center.dy + math.sin(angle) * 35 - 5,
          )
          ..lineTo(
            center.dx + math.cos(angle + 0.15) * 20,
            center.dy + math.sin(angle + 0.15) * 20 - 5,
          )
          ..close(),
        spinePaint,
      );
    }

    // Face
    final facePaint = Paint()..color = const Color(0xFFDEB887);
    canvas.drawCircle(Offset(center.dx, center.dy + 5), 22, facePaint);

    // Eyes
    _drawEyes(canvas, Offset(center.dx, center.dy), 6, isBlinking);

    // Nose
    final nosePaint = Paint()..color = const Color(0xFF2F1810);
    canvas.drawCircle(Offset(center.dx, center.dy + 10), 5, nosePaint);
  }

  void _drawEyes(Canvas canvas, Offset center, double eyeSpacing, bool blinking) {
    final eyeWhitePaint = Paint()..color = Colors.white;
    final eyePupilPaint = Paint()..color = Colors.black;
    final eyeHighlightPaint = Paint()..color = Colors.white;

    if (blinking) {
      // Draw closed eyes (lines)
      final linePaint = Paint()
        ..color = Colors.black
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawArc(
        Rect.fromCenter(center: Offset(center.dx - eyeSpacing, center.dy), width: 10, height: 6),
        0,
        math.pi,
        false,
        linePaint,
      );
      canvas.drawArc(
        Rect.fromCenter(center: Offset(center.dx + eyeSpacing, center.dy), width: 10, height: 6),
        0,
        math.pi,
        false,
        linePaint,
      );
    } else {
      // Left eye
      canvas.drawCircle(Offset(center.dx - eyeSpacing, center.dy), 6, eyeWhitePaint);
      canvas.drawCircle(Offset(center.dx - eyeSpacing + 1, center.dy + 1), 3, eyePupilPaint);
      canvas.drawCircle(Offset(center.dx - eyeSpacing - 1, center.dy - 2), 1.5, eyeHighlightPaint);

      // Right eye
      canvas.drawCircle(Offset(center.dx + eyeSpacing, center.dy), 6, eyeWhitePaint);
      canvas.drawCircle(Offset(center.dx + eyeSpacing + 1, center.dy + 1), 3, eyePupilPaint);
      canvas.drawCircle(Offset(center.dx + eyeSpacing - 1, center.dy - 2), 1.5, eyeHighlightPaint);
    }
  }

  void _drawOwlEyes(Canvas canvas, Offset center, bool blinking) {
    final eyeWhitePaint = Paint()..color = const Color(0xFFFFF8DC);
    final eyeIrisPaint = Paint()..color = const Color(0xFFFF8C00);
    final eyePupilPaint = Paint()..color = Colors.black;
    final eyeHighlightPaint = Paint()..color = Colors.white;

    if (blinking) {
      final linePaint = Paint()
        ..color = Colors.black
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      canvas.drawArc(
        Rect.fromCenter(center: Offset(center.dx - 10, center.dy - 3), width: 14, height: 8),
        0,
        math.pi,
        false,
        linePaint,
      );
      canvas.drawArc(
        Rect.fromCenter(center: Offset(center.dx + 10, center.dy - 3), width: 14, height: 8),
        0,
        math.pi,
        false,
        linePaint,
      );
    } else {
      // Left eye (big owl eyes)
      canvas.drawCircle(Offset(center.dx - 10, center.dy - 3), 10, eyeWhitePaint);
      canvas.drawCircle(Offset(center.dx - 10, center.dy - 3), 7, eyeIrisPaint);
      canvas.drawCircle(Offset(center.dx - 10, center.dy - 2), 4, eyePupilPaint);
      canvas.drawCircle(Offset(center.dx - 12, center.dy - 5), 2, eyeHighlightPaint);

      // Right eye
      canvas.drawCircle(Offset(center.dx + 10, center.dy - 3), 10, eyeWhitePaint);
      canvas.drawCircle(Offset(center.dx + 10, center.dy - 3), 7, eyeIrisPaint);
      canvas.drawCircle(Offset(center.dx + 10, center.dy - 2), 4, eyePupilPaint);
      canvas.drawCircle(Offset(center.dx + 8, center.dy - 5), 2, eyeHighlightPaint);
    }
  }

  @override
  bool shouldRepaint(_CreaturePainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.isBlinking != isBlinking;
}
