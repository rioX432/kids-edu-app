import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Types of haptic feedback patterns for different interactions.
enum HapticPattern {
  /// Light tap - for regular button presses
  light,

  /// Medium impact - for selections
  medium,

  /// Heavy impact - for important actions
  heavy,

  /// Success pattern - for correct answers
  success,

  /// Error pattern - for wrong answers
  error,

  /// Warning pattern - for alerts
  warning,

  /// Selection changed
  selection,
}

/// Helper class for consistent haptic feedback across the app.
///
/// Provides kid-friendly haptic patterns that make interactions
/// feel more tangible and rewarding.
class HapticHelper {
  HapticHelper._();

  /// Trigger haptic feedback with the specified pattern.
  static Future<void> feedback(HapticPattern pattern) async {
    switch (pattern) {
      case HapticPattern.light:
        await HapticFeedback.lightImpact();
      case HapticPattern.medium:
        await HapticFeedback.mediumImpact();
      case HapticPattern.heavy:
        await HapticFeedback.heavyImpact();
      case HapticPattern.success:
        // Double light tap for success
        await HapticFeedback.lightImpact();
        await Future.delayed(const Duration(milliseconds: 100));
        await HapticFeedback.lightImpact();
      case HapticPattern.error:
        // Single heavy for error
        await HapticFeedback.heavyImpact();
      case HapticPattern.warning:
        // Medium tap
        await HapticFeedback.mediumImpact();
      case HapticPattern.selection:
        await HapticFeedback.selectionClick();
    }
  }

  /// Quick light tap feedback
  static Future<void> tap() => HapticFeedback.lightImpact();

  /// Feedback for correct answer
  static Future<void> correct() => feedback(HapticPattern.success);

  /// Feedback for wrong answer
  static Future<void> wrong() => feedback(HapticPattern.error);
}

/// A widget that provides rich visual and haptic feedback on touch.
///
/// Combines multiple feedback mechanisms:
/// - Scale animation (press down effect)
/// - Opacity change
/// - Haptic feedback
/// - Optional glow effect
///
/// Example:
/// ```dart
/// RichTouchFeedback(
///   onTap: doSomething,
///   hapticPattern: HapticPattern.light,
///   child: MyButton(),
/// )
/// ```
class RichTouchFeedback extends StatefulWidget {
  const RichTouchFeedback({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.hapticPattern = HapticPattern.light,
    this.scaleDown = 0.95,
    this.opacityDown = 0.8,
    this.showGlow = false,
    this.glowColor,
    this.enabled = true,
    this.duration = const Duration(milliseconds: 100),
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final HapticPattern hapticPattern;
  final double scaleDown;
  final double opacityDown;
  final bool showGlow;
  final Color? glowColor;
  final bool enabled;
  final Duration duration;

  @override
  State<RichTouchFeedback> createState() => _RichTouchFeedbackState();
}

class _RichTouchFeedbackState extends State<RichTouchFeedback>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleDown,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: widget.opacityDown,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled) return;
    _controller.forward();
    HapticHelper.feedback(widget.hapticPattern);
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enabled) return;
    _controller.reverse();
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: widget.showGlow
                  ? Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: (widget.glowColor ?? Colors.white)
                                .withValues(alpha: _glowAnimation.value * 0.5),
                            blurRadius: 20 * _glowAnimation.value,
                            spreadRadius: 5 * _glowAnimation.value,
                          ),
                        ],
                      ),
                      child: child,
                    )
                  : child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// A bouncy tap feedback widget that provides a fun "pop" effect.
///
/// The widget briefly scales up slightly before scaling down,
/// creating a playful bouncy feel perfect for kids apps.
class BouncyTapFeedback extends StatefulWidget {
  const BouncyTapFeedback({
    super.key,
    required this.child,
    this.onTap,
    this.enabled = true,
    this.bounceScale = 1.1,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;
  final double bounceScale;

  @override
  State<BouncyTapFeedback> createState() => _BouncyTapFeedbackState();
}

class _BouncyTapFeedbackState extends State<BouncyTapFeedback>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: widget.bounceScale),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.bounceScale, end: 0.95),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.95, end: 1.0),
        weight: 40,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.enabled) return;

    HapticHelper.tap();
    _controller.forward(from: 0);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// A ripple effect that follows the finger during drag.
///
/// Shows a trail of circles/stars as the child follows touch movement.
class DragTrailEffect extends StatefulWidget {
  const DragTrailEffect({
    super.key,
    required this.child,
    this.trailColor,
    this.trailType = TrailType.circles,
    this.enabled = true,
  });

  final Widget child;
  final Color? trailColor;
  final TrailType trailType;
  final bool enabled;

  @override
  State<DragTrailEffect> createState() => _DragTrailEffectState();
}

enum TrailType {
  circles,
  stars,
  sparkles,
}

class _DragTrailEffectState extends State<DragTrailEffect> {
  final List<_TrailPoint> _trailPoints = [];

  void _updateTrail(Offset position) {
    if (!widget.enabled) return;

    setState(() {
      _trailPoints.add(_TrailPoint(
        position: position,
        createdAt: DateTime.now(),
      ));

      // Remove old points
      final now = DateTime.now();
      _trailPoints.removeWhere(
        (p) => now.difference(p.createdAt).inMilliseconds > 500,
      );
    });
  }

  void _clearTrail() {
    setState(() => _trailPoints.clear());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) => _updateTrail(details.localPosition),
      onPanEnd: (_) => _clearTrail(),
      child: Stack(
        children: [
          // Trail points
          CustomPaint(
            painter: _TrailPainter(
              points: _trailPoints,
              color: widget.trailColor ?? Colors.yellow,
              type: widget.trailType,
            ),
            size: Size.infinite,
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _TrailPoint {
  _TrailPoint({required this.position, required this.createdAt});
  final Offset position;
  final DateTime createdAt;
}

class _TrailPainter extends CustomPainter {
  _TrailPainter({
    required this.points,
    required this.color,
    required this.type,
  });

  final List<_TrailPoint> points;
  final Color color;
  final TrailType type;

  @override
  void paint(Canvas canvas, Size size) {
    final now = DateTime.now();

    for (final point in points) {
      final age = now.difference(point.createdAt).inMilliseconds / 500;
      final opacity = (1 - age).clamp(0.0, 1.0);
      final pointSize = 10 * (1 - age * 0.5);

      final paint = Paint()
        ..color = color.withValues(alpha: opacity * 0.8)
        ..style = PaintingStyle.fill;

      switch (type) {
        case TrailType.circles:
          canvas.drawCircle(point.position, pointSize, paint);
        case TrailType.stars:
          _drawStar(canvas, point.position, pointSize, paint);
        case TrailType.sparkles:
          _drawSparkle(canvas, point.position, pointSize, paint);
      }
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    for (var i = 0; i < 5; i++) {
      final angle = (i * 4 * 3.14159 / 5) - 3.14159 / 2;
      final point = Offset(
        center.dx + size * 0.8 * (i == 0 ? 1 : 1) * (i % 2 == 0 ? 1 : 0.4) *
            (i == 0 ? 1 : 1) *
            (angle.isNaN ? 0 : 1) *
            (size > 0 ? 1 : 0),
        center.dy,
      );
      if (i == 0) {
        path.moveTo(
          center.dx + size * 0.8 * (3.14159 / 2).abs(),
          center.dy - size * 0.8,
        );
      }
    }
    canvas.drawCircle(center, size, paint); // Simplified
  }

  void _drawSparkle(Canvas canvas, Offset center, double size, Paint paint) {
    // 4-pointed sparkle
    final path = Path();
    path.moveTo(center.dx, center.dy - size);
    path.lineTo(center.dx + size * 0.3, center.dy);
    path.lineTo(center.dx + size, center.dy);
    path.lineTo(center.dx + size * 0.3, center.dy);
    path.lineTo(center.dx, center.dy + size);
    path.lineTo(center.dx - size * 0.3, center.dy);
    path.lineTo(center.dx - size, center.dy);
    path.lineTo(center.dx - size * 0.3, center.dy);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TrailPainter oldDelegate) => true;
}
