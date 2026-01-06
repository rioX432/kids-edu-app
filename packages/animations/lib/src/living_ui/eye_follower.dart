import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Style variants for eyes.
enum EyeStyle {
  /// Large, round cartoon eyes
  round,

  /// Slightly oval/almond shaped
  oval,

  /// Cute dot eyes
  dot,
}

/// A widget that displays eyes that follow the pointer/touch position.
///
/// Creates an engaging, "alive" feeling by having eyes track
/// where the user is touching or pointing.
///
/// Example:
/// ```dart
/// Stack(
///   children: [
///     CharacterFace(),
///     Positioned(
///       left: 50,
///       top: 30,
///       child: EyeFollower(
///         eyeSpacing: 40,
///       ),
///     ),
///   ],
/// )
/// ```
class EyeFollower extends StatefulWidget {
  const EyeFollower({
    super.key,
    this.eyeSize = 32.0,
    this.eyeSpacing = 24.0,
    this.pupilSize,
    this.eyeColor = Colors.white,
    this.pupilColor = Colors.black,
    this.style = EyeStyle.round,
    this.maxLookDistance = 0.3,
    this.blinkInterval = const Duration(seconds: 4),
    this.smoothing = 0.15,
    this.enabled = true,
  });

  /// Size of each eye.
  final double eyeSize;

  /// Space between the two eyes.
  final double eyeSpacing;

  /// Size of the pupil. If null, defaults to eyeSize * 0.4.
  final double? pupilSize;

  /// Color of the eye (sclera).
  final Color eyeColor;

  /// Color of the pupil.
  final Color pupilColor;

  /// Style of the eyes.
  final EyeStyle style;

  /// Maximum distance pupils can move (as fraction of eye size).
  final double maxLookDistance;

  /// How often the eyes blink.
  final Duration blinkInterval;

  /// Smoothing factor for eye movement (0-1, lower = smoother).
  final double smoothing;

  /// Whether eye tracking is enabled.
  final bool enabled;

  @override
  State<EyeFollower> createState() => _EyeFollowerState();
}

class _EyeFollowerState extends State<EyeFollower>
    with TickerProviderStateMixin {
  Offset _lookDirection = Offset.zero;
  Offset _targetLookDirection = Offset.zero;

  late AnimationController _blinkController;
  late Animation<double> _blinkAnimation;
  Timer? _blinkTimer;

  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _setupBlinkAnimation();
    _scheduleNextBlink();
  }

  void _setupBlinkAnimation() {
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _blinkAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.1), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.1, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(
      parent: _blinkController,
      curve: Curves.easeInOut,
    ));
  }

  void _scheduleNextBlink() {
    if (!widget.enabled) return;

    // Add some randomness to blink timing
    final variance = widget.blinkInterval.inMilliseconds ~/ 2;
    final nextBlink = widget.blinkInterval.inMilliseconds +
        _random.nextInt(variance) -
        variance ~/ 2;

    _blinkTimer?.cancel();
    _blinkTimer = Timer(Duration(milliseconds: nextBlink), () {
      if (mounted && widget.enabled) {
        _blink();
      }
    });
  }

  void _blink() {
    _blinkController.forward().then((_) {
      _blinkController.reset();
      _scheduleNextBlink();
    });
  }

  void _updateLookDirection(Offset globalPosition) {
    if (!widget.enabled) return;

    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final localPosition = box.globalToLocal(globalPosition);
    final center = Offset(
      (widget.eyeSize * 2 + widget.eyeSpacing) / 2,
      widget.eyeSize / 2,
    );

    final direction = localPosition - center;
    final distance = direction.distance;

    // Normalize and clamp
    if (distance > 0) {
      final maxDistance = widget.eyeSize * 2;
      final normalizedDistance = (distance / maxDistance).clamp(0.0, 1.0);
      _targetLookDirection = Offset(
        (direction.dx / distance) * normalizedDistance * widget.maxLookDistance,
        (direction.dy / distance) * normalizedDistance * widget.maxLookDistance,
      );
    } else {
      _targetLookDirection = Offset.zero;
    }

    // Smooth interpolation
    setState(() {
      _lookDirection = Offset.lerp(
        _lookDirection,
        _targetLookDirection,
        widget.smoothing,
      )!;
    });
  }

  void _resetLook() {
    setState(() {
      _targetLookDirection = Offset.zero;
    });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return Listener(
      onPointerMove: reduceMotion ? null : (event) => _updateLookDirection(event.position),
      onPointerHover: reduceMotion ? null : (event) => _updateLookDirection(event.position),
      onPointerUp: (_) => _resetLook(),
      onPointerCancel: (_) => _resetLook(),
      child: AnimatedBuilder(
        animation: _blinkAnimation,
        builder: (context, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Eye(
                size: widget.eyeSize,
                pupilSize: widget.pupilSize ?? widget.eyeSize * 0.4,
                eyeColor: widget.eyeColor,
                pupilColor: widget.pupilColor,
                style: widget.style,
                lookDirection: _lookDirection,
                blinkScale: _blinkAnimation.value,
              ),
              SizedBox(width: widget.eyeSpacing),
              _Eye(
                size: widget.eyeSize,
                pupilSize: widget.pupilSize ?? widget.eyeSize * 0.4,
                eyeColor: widget.eyeColor,
                pupilColor: widget.pupilColor,
                style: widget.style,
                lookDirection: _lookDirection,
                blinkScale: _blinkAnimation.value,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Eye extends StatelessWidget {
  const _Eye({
    required this.size,
    required this.pupilSize,
    required this.eyeColor,
    required this.pupilColor,
    required this.style,
    required this.lookDirection,
    required this.blinkScale,
  });

  final double size;
  final double pupilSize;
  final Color eyeColor;
  final Color pupilColor;
  final EyeStyle style;
  final Offset lookDirection;
  final double blinkScale;

  @override
  Widget build(BuildContext context) {
    final pupilOffset = Offset(
      lookDirection.dx * (size - pupilSize) / 2,
      lookDirection.dy * (size - pupilSize) / 2,
    );

    return Transform.scale(
      scaleY: blinkScale,
      child: Container(
        width: size,
        height: style == EyeStyle.oval ? size * 1.2 : size,
        decoration: BoxDecoration(
          color: eyeColor,
          shape: style == EyeStyle.dot ? BoxShape.rectangle : BoxShape.circle,
          borderRadius: style == EyeStyle.oval
              ? BorderRadius.vertical(
                  top: Radius.circular(size / 2),
                  bottom: Radius.circular(size / 3),
                )
              : style == EyeStyle.dot
                  ? BorderRadius.circular(size / 4)
                  : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Transform.translate(
            offset: pupilOffset,
            child: Container(
              width: pupilSize,
              height: pupilSize,
              decoration: BoxDecoration(
                color: pupilColor,
                shape: BoxShape.circle,
              ),
              child: Align(
                alignment: const Alignment(-0.3, -0.3),
                child: Container(
                  width: pupilSize * 0.3,
                  height: pupilSize * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
