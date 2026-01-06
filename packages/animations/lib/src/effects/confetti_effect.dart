import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A fun confetti celebration effect.
///
/// Shows colorful confetti pieces falling from the top of the screen.
/// Perfect for rewards, level ups, and achievements.
///
/// Example:
/// ```dart
/// // Show confetti overlay
/// ConfettiOverlay.show(context);
///
/// // Or use as a widget
/// Stack(
///   children: [
///     YourContent(),
///     ConfettiEffect(
///       isPlaying: _showConfetti,
///       onComplete: () => setState(() => _showConfetti = false),
///     ),
///   ],
/// )
/// ```
class ConfettiEffect extends StatefulWidget {
  const ConfettiEffect({
    super.key,
    this.isPlaying = true,
    this.particleCount = 50,
    this.duration = const Duration(milliseconds: 3000),
    this.colors,
    this.onComplete,
  });

  /// Whether the confetti animation is playing.
  final bool isPlaying;

  /// Number of confetti particles.
  final int particleCount;

  /// Duration of the animation.
  final Duration duration;

  /// Colors for confetti pieces. If null, uses default celebration colors.
  final List<Color>? colors;

  /// Called when the animation completes.
  final VoidCallback? onComplete;

  /// Default celebration colors (bright, kid-friendly).
  static const List<Color> defaultColors = [
    Color(0xFFFF6B6B), // Red
    Color(0xFFFFD93D), // Yellow
    Color(0xFF6BCB77), // Green
    Color(0xFF4D96FF), // Blue
    Color(0xFFFF6BD6), // Pink
    Color(0xFFFF9F43), // Orange
  ];

  @override
  State<ConfettiEffect> createState() => _ConfettiEffectState();
}

class _ConfettiEffectState extends State<ConfettiEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_ConfettiParticle> _particles;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _initParticles();

    if (widget.isPlaying) {
      _startAnimation();
    }
  }

  void _initParticles() {
    final colors = widget.colors ?? ConfettiEffect.defaultColors;
    _particles = List.generate(
      widget.particleCount,
      (index) => _ConfettiParticle(
        color: colors[_random.nextInt(colors.length)],
        startX: _random.nextDouble(),
        startDelay: _random.nextDouble() * 0.3,
        fallSpeed: 0.5 + _random.nextDouble() * 0.5,
        wobbleSpeed: 2 + _random.nextDouble() * 3,
        wobbleAmount: 0.05 + _random.nextDouble() * 0.1,
        rotationSpeed: _random.nextDouble() * 4 - 2,
        size: 8 + _random.nextDouble() * 8,
        shape: _ConfettiShape.values[_random.nextInt(_ConfettiShape.values.length)],
      ),
    );
  }

  void _startAnimation() {
    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void didUpdateWidget(ConfettiEffect oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isPlaying && !oldWidget.isPlaying) {
      _controller.reset();
      _initParticles();
      _startAnimation();
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isPlaying && !_controller.isAnimating) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ConfettiPainter(
            particles: _particles,
            progress: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

enum _ConfettiShape { rectangle, circle, triangle }

class _ConfettiParticle {
  _ConfettiParticle({
    required this.color,
    required this.startX,
    required this.startDelay,
    required this.fallSpeed,
    required this.wobbleSpeed,
    required this.wobbleAmount,
    required this.rotationSpeed,
    required this.size,
    required this.shape,
  });

  final Color color;
  final double startX;
  final double startDelay;
  final double fallSpeed;
  final double wobbleSpeed;
  final double wobbleAmount;
  final double rotationSpeed;
  final double size;
  final _ConfettiShape shape;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  final List<_ConfettiParticle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final adjustedProgress = (progress - particle.startDelay).clamp(0.0, 1.0);

      if (adjustedProgress <= 0) continue;

      // Calculate position
      final x = size.width * particle.startX +
          math.sin(adjustedProgress * particle.wobbleSpeed * math.pi * 2) *
              size.width *
              particle.wobbleAmount;
      final y = -particle.size + adjustedProgress * (size.height + particle.size * 2) * particle.fallSpeed;

      // Fade out at the end
      final opacity = adjustedProgress < 0.8 ? 1.0 : (1.0 - adjustedProgress) * 5;

      final paint = Paint()
        ..color = particle.color.withValues(alpha: opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(adjustedProgress * particle.rotationSpeed * math.pi * 2);

      switch (particle.shape) {
        case _ConfettiShape.rectangle:
          canvas.drawRect(
            Rect.fromCenter(
              center: Offset.zero,
              width: particle.size,
              height: particle.size * 0.6,
            ),
            paint,
          );
        case _ConfettiShape.circle:
          canvas.drawCircle(Offset.zero, particle.size / 2, paint);
        case _ConfettiShape.triangle:
          final path = Path()
            ..moveTo(0, -particle.size / 2)
            ..lineTo(particle.size / 2, particle.size / 2)
            ..lineTo(-particle.size / 2, particle.size / 2)
            ..close();
          canvas.drawPath(path, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Shows a confetti overlay on top of the current screen.
class ConfettiOverlay {
  static OverlayEntry? _overlayEntry;

  /// Show confetti celebration.
  ///
  /// The overlay automatically dismisses after the animation completes.
  static void show(
    BuildContext context, {
    int particleCount = 50,
    Duration duration = const Duration(milliseconds: 3000),
    List<Color>? colors,
  }) {
    dismiss();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: IgnorePointer(
          child: ConfettiEffect(
            particleCount: particleCount,
            duration: duration,
            colors: colors,
            onComplete: dismiss,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Manually dismiss the confetti overlay.
  static void dismiss() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
