import 'package:flutter/material.dart';

/// Intensity level for breathing animation.
enum BreathingIntensity {
  /// Very subtle (1% scale variation) - for background elements
  subtle,

  /// Normal (3% scale variation) - default for most UI
  normal,

  /// Pronounced (6% scale variation) - for characters and buttons
  pronounced,

  /// Bouncy (10% scale variation) - for attention-grabbing elements
  bouncy,

  /// Dramatic (15% scale variation) - for celebrations and rewards
  dramatic,
}

/// A widget that adds a gentle "breathing" animation to its child.
///
/// Creates a subtle scale animation that makes UI elements feel alive,
/// like they're gently breathing. Perfect for:
/// - Character avatars
/// - Buttons that need attention
/// - Interactive elements waiting for input
///
/// Example:
/// ```dart
/// BreathingWidget(
///   child: CharacterAvatar(type: CharacterType.fox),
/// )
///
/// // Or with intensity control
/// BreathingWidget(
///   intensity: BreathingIntensity.pronounced,
///   child: PrimaryButton(text: 'Tap Me!'),
/// )
/// ```
class BreathingWidget extends StatefulWidget {
  const BreathingWidget({
    super.key,
    required this.child,
    this.intensity = BreathingIntensity.normal,
    this.duration,
    this.enabled = true,
  });

  /// The child widget to animate.
  final Widget child;

  /// How pronounced the breathing effect should be.
  final BreathingIntensity intensity;

  /// Duration of one breath cycle. If null, uses default based on intensity.
  final Duration? duration;

  /// Whether the animation is enabled.
  final bool enabled;

  @override
  State<BreathingWidget> createState() => _BreathingWidgetState();
}

class _BreathingWidgetState extends State<BreathingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  double get _scaleAmount => switch (widget.intensity) {
        BreathingIntensity.subtle => 0.01,
        BreathingIntensity.normal => 0.03,
        BreathingIntensity.pronounced => 0.06,
        BreathingIntensity.bouncy => 0.10,
        BreathingIntensity.dramatic => 0.15,
      };

  Duration get _duration =>
      widget.duration ??
      switch (widget.intensity) {
        BreathingIntensity.subtle => const Duration(seconds: 4),
        BreathingIntensity.normal => const Duration(milliseconds: 2500),
        BreathingIntensity.pronounced => const Duration(seconds: 2),
        BreathingIntensity.bouncy => const Duration(milliseconds: 1500),
        BreathingIntensity.dramatic => const Duration(milliseconds: 1200),
      };

  Curve get _curve => switch (widget.intensity) {
        BreathingIntensity.subtle => Curves.easeInOut,
        BreathingIntensity.normal => Curves.easeInOut,
        BreathingIntensity.pronounced => Curves.easeInOutCubic,
        BreathingIntensity.bouncy => Curves.elasticInOut,
        BreathingIntensity.dramatic => Curves.bounceInOut,
      };

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: _duration,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.0 + _scaleAmount,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: _curve,
    ));

    if (widget.enabled) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(BreathingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.value = 0;
      }
    }

    if (widget.intensity != oldWidget.intensity ||
        widget.duration != oldWidget.duration) {
      _controller.dispose();
      _setupAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Respect reduced motion preference
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    if (reduceMotion || !widget.enabled) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// A widget that adds idle wobble/wiggle animation.
///
/// Different from breathing - this adds slight rotation and position
/// variation to draw attention to interactive elements.
///
/// Example:
/// ```dart
/// IdleWiggleWidget(
///   delay: Duration(seconds: 3), // Start wiggling after 3 seconds
///   child: IconButton(...),
/// )
/// ```
class IdleWiggleWidget extends StatefulWidget {
  const IdleWiggleWidget({
    super.key,
    required this.child,
    this.delay = const Duration(seconds: 5),
    this.wiggleDuration = const Duration(milliseconds: 500),
    this.wiggleAngle = 0.05,
    this.enabled = true,
  });

  /// The child widget to animate.
  final Widget child;

  /// Delay before starting to wiggle (resets on interaction).
  final Duration delay;

  /// Duration of one wiggle.
  final Duration wiggleDuration;

  /// Maximum rotation angle in radians.
  final double wiggleAngle;

  /// Whether the animation is enabled.
  final bool enabled;

  @override
  State<IdleWiggleWidget> createState() => _IdleWiggleWidgetState();
}

class _IdleWiggleWidgetState extends State<IdleWiggleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  bool _isWiggling = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.wiggleDuration,
    );

    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: widget.wiggleAngle),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.wiggleAngle, end: -widget.wiggleAngle),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -widget.wiggleAngle, end: 0.0),
        weight: 25,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.enabled) {
      _scheduleWiggle();
    }
  }

  void _scheduleWiggle() {
    Future.delayed(widget.delay, () {
      if (mounted && widget.enabled && !_isWiggling) {
        _startWiggle();
      }
    });
  }

  void _startWiggle() {
    _isWiggling = true;
    _controller.forward().then((_) {
      _controller.reset();
      _isWiggling = false;
      if (mounted && widget.enabled) {
        _scheduleWiggle();
      }
    });
  }

  void _resetIdleTimer() {
    _controller.reset();
    _isWiggling = false;
    _scheduleWiggle();
  }

  @override
  void didUpdateWidget(IdleWiggleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.enabled && !oldWidget.enabled) {
      _scheduleWiggle();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    if (reduceMotion || !widget.enabled) {
      return widget.child;
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => _resetIdleTimer(),
      child: AnimatedBuilder(
        animation: _rotationAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
