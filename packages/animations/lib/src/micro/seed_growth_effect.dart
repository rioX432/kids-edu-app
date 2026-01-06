import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A delightful effect where tapping causes a seed to grow into a flower.
///
/// Perfect for positive reinforcement when children answer correctly.
/// The animation shows: seed → sprout → stem → flower bloom
///
/// Example:
/// ```dart
/// SeedGrowthEffect(
///   onTap: handleCorrectAnswer,
///   flowerType: FlowerType.sunflower,
///   child: AnswerButton(...),
/// )
/// ```
class SeedGrowthEffect extends StatefulWidget {
  const SeedGrowthEffect({
    super.key,
    required this.child,
    this.onTap,
    this.flowerType = FlowerType.daisy,
    this.growthDuration = const Duration(milliseconds: 1200),
    this.enabled = true,
  });

  /// The child widget to wrap.
  final Widget child;

  /// Called when tapped (after growth animation starts).
  final VoidCallback? onTap;

  /// Type of flower to grow.
  final FlowerType flowerType;

  /// Duration of the full growth animation.
  final Duration growthDuration;

  /// Whether the effect is enabled.
  final bool enabled;

  @override
  State<SeedGrowthEffect> createState() => _SeedGrowthEffectState();
}

class _SeedGrowthEffectState extends State<SeedGrowthEffect>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Offset? _growthPosition;

  void _handleTap(TapDownDetails details) {
    if (!widget.enabled) {
      widget.onTap?.call();
      return;
    }

    setState(() {
      _growthPosition = details.localPosition;
    });

    _controller?.dispose();
    _controller = AnimationController(
      vsync: this,
      duration: widget.growthDuration,
    );

    _controller!.forward().then((_) {
      if (mounted) {
        setState(() => _growthPosition = null);
        _controller?.dispose();
        _controller = null;
      }
    });

    widget.onTap?.call();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          if (_growthPosition != null && _controller != null)
            Positioned(
              left: _growthPosition!.dx - 30,
              top: _growthPosition!.dy - 80,
              child: AnimatedBuilder(
                animation: _controller!,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _FlowerGrowthPainter(
                      progress: _controller!.value,
                      flowerType: widget.flowerType,
                    ),
                    size: const Size(60, 100),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// Types of flowers that can grow.
enum FlowerType {
  daisy,
  sunflower,
  tulip,
  rose,
  sakura,
}

class _FlowerGrowthPainter extends CustomPainter {
  _FlowerGrowthPainter({
    required this.progress,
    required this.flowerType,
  });

  final double progress;
  final FlowerType flowerType;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final bottom = size.height;

    // Phase 1: Seed appears (0-0.1)
    // Phase 2: Sprout emerges (0.1-0.3)
    // Phase 3: Stem grows (0.3-0.6)
    // Phase 4: Flower blooms (0.6-1.0)

    // Draw stem
    if (progress > 0.1) {
      final stemProgress = ((progress - 0.1) / 0.5).clamp(0.0, 1.0);
      final stemHeight = 60 * Curves.easeOut.transform(stemProgress);

      final stemPaint = Paint()
        ..color = const Color(0xFF228B22)
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round;

      // Curved stem
      final path = Path();
      path.moveTo(centerX, bottom);

      final controlX = centerX + math.sin(stemProgress * math.pi) * 10;
      path.quadraticBezierTo(
        controlX,
        bottom - stemHeight / 2,
        centerX,
        bottom - stemHeight,
      );

      canvas.drawPath(path, stemPaint..style = PaintingStyle.stroke);

      // Leaves
      if (progress > 0.4) {
        final leafProgress = ((progress - 0.4) / 0.3).clamp(0.0, 1.0);
        _drawLeaf(canvas, centerX - 5, bottom - stemHeight * 0.4, -0.5, leafProgress);
        _drawLeaf(canvas, centerX + 5, bottom - stemHeight * 0.6, 0.5, leafProgress);
      }
    }

    // Draw seed/sprout at bottom
    if (progress < 0.3) {
      final seedProgress = (progress / 0.3).clamp(0.0, 1.0);
      final seedPaint = Paint()..color = const Color(0xFF8B4513);

      // Seed
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(centerX, bottom - 5),
          width: 10 * (1 - seedProgress * 0.5),
          height: 6 * (1 - seedProgress * 0.5),
        ),
        seedPaint,
      );

      // Sprout emerging
      if (progress > 0.1) {
        final sproutProgress = ((progress - 0.1) / 0.2).clamp(0.0, 1.0);
        final sproutPaint = Paint()
          ..color = const Color(0xFF90EE90)
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;

        final sproutHeight = 15 * sproutProgress;
        canvas.drawLine(
          Offset(centerX, bottom - 5),
          Offset(centerX, bottom - 5 - sproutHeight),
          sproutPaint,
        );
      }
    }

    // Draw flower
    if (progress > 0.6) {
      final flowerProgress = ((progress - 0.6) / 0.4).clamp(0.0, 1.0);
      final bloomProgress = Curves.elasticOut.transform(flowerProgress);
      final stemHeight = 60.0;

      switch (flowerType) {
        case FlowerType.daisy:
          _drawDaisy(canvas, centerX, bottom - stemHeight, bloomProgress);
        case FlowerType.sunflower:
          _drawSunflower(canvas, centerX, bottom - stemHeight, bloomProgress);
        case FlowerType.tulip:
          _drawTulip(canvas, centerX, bottom - stemHeight, bloomProgress);
        case FlowerType.rose:
          _drawRose(canvas, centerX, bottom - stemHeight, bloomProgress);
        case FlowerType.sakura:
          _drawSakura(canvas, centerX, bottom - stemHeight, bloomProgress);
      }
    }
  }

  void _drawLeaf(Canvas canvas, double x, double y, double angle, double progress) {
    final leafPaint = Paint()..color = const Color(0xFF228B22);
    final leafSize = 12 * progress;

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(angle);

    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(leafSize * 0.5, -leafSize * 0.3, leafSize, 0);
    path.quadraticBezierTo(leafSize * 0.5, leafSize * 0.3, 0, 0);

    canvas.drawPath(path, leafPaint);
    canvas.restore();
  }

  void _drawDaisy(Canvas canvas, double cx, double cy, double progress) {
    final petalCount = 8;
    final petalLength = 15 * progress;
    final centerRadius = 8 * progress;

    // Petals
    final petalPaint = Paint()..color = Colors.white;
    for (var i = 0; i < petalCount; i++) {
      final angle = (i / petalCount) * math.pi * 2;
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(angle);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(0, -petalLength / 2 - 3),
          width: 8 * progress,
          height: petalLength,
        ),
        petalPaint,
      );
      canvas.restore();
    }

    // Center
    canvas.drawCircle(
      Offset(cx, cy),
      centerRadius,
      Paint()..color = const Color(0xFFFFD700),
    );
  }

  void _drawSunflower(Canvas canvas, double cx, double cy, double progress) {
    final petalCount = 12;
    final petalLength = 18 * progress;
    final centerRadius = 10 * progress;

    // Petals
    final petalPaint = Paint()..color = const Color(0xFFFFD700);
    for (var i = 0; i < petalCount; i++) {
      final angle = (i / petalCount) * math.pi * 2;
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(angle);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(0, -petalLength / 2 - 5),
          width: 7 * progress,
          height: petalLength,
        ),
        petalPaint,
      );
      canvas.restore();
    }

    // Center with seeds pattern
    canvas.drawCircle(
      Offset(cx, cy),
      centerRadius,
      Paint()..color = const Color(0xFF8B4513),
    );

    // Seed dots
    final dotPaint = Paint()..color = const Color(0xFF654321);
    for (var i = 0; i < 5; i++) {
      final angle = (i / 5) * math.pi * 2;
      final r = centerRadius * 0.5;
      canvas.drawCircle(
        Offset(cx + math.cos(angle) * r, cy + math.sin(angle) * r),
        2 * progress,
        dotPaint,
      );
    }
  }

  void _drawTulip(Canvas canvas, double cx, double cy, double progress) {
    final height = 20 * progress;
    final width = 16 * progress;

    // Outer petals
    final outerPaint = Paint()..color = const Color(0xFFFF6B6B);
    canvas.drawPath(
      Path()
        ..moveTo(cx - width / 2, cy)
        ..quadraticBezierTo(cx - width / 2 - 3, cy - height / 2, cx, cy - height)
        ..quadraticBezierTo(cx + width / 2 + 3, cy - height / 2, cx + width / 2, cy)
        ..close(),
      outerPaint,
    );

    // Inner petal
    final innerPaint = Paint()..color = const Color(0xFFFF8C94);
    canvas.drawPath(
      Path()
        ..moveTo(cx - width / 4, cy)
        ..quadraticBezierTo(cx, cy - height * 0.8, cx + width / 4, cy)
        ..close(),
      innerPaint,
    );
  }

  void _drawRose(Canvas canvas, double cx, double cy, double progress) {
    final radius = 12 * progress;

    // Multiple layers of petals
    for (var layer = 3; layer >= 0; layer--) {
      final layerRadius = radius * (1 - layer * 0.2);
      final layerOpacity = 0.7 + layer * 0.1;
      final petalPaint = Paint()
        ..color = Color.fromRGBO(255, 100, 100, layerOpacity);

      for (var i = 0; i < 5; i++) {
        final angle = (i / 5) * math.pi * 2 + layer * 0.3;
        canvas.save();
        canvas.translate(cx, cy);
        canvas.rotate(angle);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(0, -layerRadius / 2),
            width: layerRadius * 0.6,
            height: layerRadius,
          ),
          petalPaint,
        );
        canvas.restore();
      }
    }
  }

  void _drawSakura(Canvas canvas, double cx, double cy, double progress) {
    final petalCount = 5;
    final petalLength = 14 * progress;

    // Cherry blossom petals (notched)
    final petalPaint = Paint()..color = const Color(0xFFFFB7C5);

    for (var i = 0; i < petalCount; i++) {
      final angle = (i / petalCount) * math.pi * 2 - math.pi / 2;
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(angle);

      final path = Path();
      path.moveTo(0, 0);
      path.quadraticBezierTo(-5 * progress, -petalLength * 0.6, 0, -petalLength);
      path.quadraticBezierTo(5 * progress, -petalLength * 0.6, 0, 0);

      // Add notch at the tip
      path.moveTo(-2 * progress, -petalLength + 2);
      path.lineTo(0, -petalLength + 4);
      path.lineTo(2 * progress, -petalLength + 2);

      canvas.drawPath(path, petalPaint);
      canvas.restore();
    }

    // Center
    canvas.drawCircle(
      Offset(cx, cy),
      4 * progress,
      Paint()..color = const Color(0xFFFFE4E1),
    );

    // Stamens
    final stamenPaint = Paint()
      ..color = const Color(0xFFFFD700)
      ..strokeWidth = 1;
    for (var i = 0; i < 5; i++) {
      final angle = (i / 5) * math.pi * 2;
      final length = 6 * progress;
      canvas.drawLine(
        Offset(cx, cy),
        Offset(
          cx + math.cos(angle) * length,
          cy + math.sin(angle) * length,
        ),
        stamenPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_FlowerGrowthPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// A simple wrapper that shows seed growth on correct answers.
///
/// This is a convenience widget that combines SeedGrowthEffect
/// with common answer button patterns.
class GrowthAnswerButton extends StatelessWidget {
  const GrowthAnswerButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isCorrect = false,
    this.flowerType = FlowerType.daisy,
    this.backgroundColor,
    this.textColor,
  });

  final String text;
  final VoidCallback onTap;
  final bool isCorrect;
  final FlowerType flowerType;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SeedGrowthEffect(
      enabled: isCorrect,
      flowerType: flowerType,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor ?? Colors.black87,
          ),
        ),
      ),
    );
  }
}
