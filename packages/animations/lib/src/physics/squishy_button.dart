import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// A button with physics-based "squishy" press animation.
///
/// When pressed, the button deforms like a soft jelly or stress ball,
/// creating a satisfying tactile feel that kids love.
///
/// Example:
/// ```dart
/// SquishyButton(
///   onPressed: () => print('Pressed!'),
///   child: Container(
///     padding: EdgeInsets.all(24),
///     decoration: BoxDecoration(
///       color: Colors.orange,
///       borderRadius: BorderRadius.circular(16),
///     ),
///     child: Text('Press Me!'),
///   ),
/// )
/// ```
class SquishyButton extends StatefulWidget {
  const SquishyButton({
    super.key,
    required this.child,
    this.onPressed,
    this.enabled = true,
    this.squishFactor = 0.15,
    this.springStiffness = 400.0,
    this.springDamping = 15.0,
  });

  /// The child widget (button content).
  final Widget child;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is enabled.
  final bool enabled;

  /// Maximum deformation percentage (0.0 to 1.0).
  final double squishFactor;

  /// Spring stiffness (higher = faster bounce back).
  final double springStiffness;

  /// Spring damping (higher = less bouncy).
  final double springDamping;

  @override
  State<SquishyButton> createState() => _SquishyButtonState();
}

class _SquishyButtonState extends State<SquishyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _squishAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _squishAnimation = _controller.drive(
      Tween<double>(begin: 0.0, end: 1.0),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.enabled) return;

    setState(() {
      _isPressed = true;
    });

    _animateSquish(1.0);
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.enabled) return;

    setState(() {
      _isPressed = false;
    });

    _animateRelease();
    widget.onPressed?.call();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });

    _animateRelease();
  }

  void _animateSquish(double target) {
    final simulation = SpringSimulation(
      SpringDescription(
        mass: 1.0,
        stiffness: widget.springStiffness,
        damping: widget.springDamping,
      ),
      _controller.value,
      target,
      0.0,
    );

    _controller.animateWith(simulation);
  }

  void _animateRelease() {
    final simulation = SpringSimulation(
      SpringDescription(
        mass: 1.0,
        stiffness: widget.springStiffness * 0.8,
        damping: widget.springDamping * 0.6,
      ),
      _controller.value,
      0.0,
      -2.0, // Initial velocity for bounceback
    );

    _controller.animateWith(simulation);
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    if (reduceMotion) {
      return GestureDetector(
        onTap: widget.enabled ? widget.onPressed : null,
        child: widget.child,
      );
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _squishAnimation,
        builder: (context, child) {
          final squishValue = _squishAnimation.value * widget.squishFactor;

          // Calculate scale based on press direction
          double scaleX = 1.0;
          double scaleY = 1.0;

          if (_isPressed && squishValue > 0) {
            // Squish inward slightly
            scaleX = 1.0 + squishValue * 0.05;
            scaleY = 1.0 - squishValue;
          } else if (squishValue > 0) {
            // Bounce back with overshoot
            scaleX = 1.0 - squishValue * 0.02;
            scaleY = 1.0 + squishValue * 0.1;
          }

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.diagonal3Values(scaleX, scaleY, 1.0),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// A jelly-like container that wobbles when interacted with.
///
/// Similar to SquishyButton but designed for containers that
/// may not be interactive buttons.
///
/// Example:
/// ```dart
/// JellyContainer(
///   child: Card(
///     child: ListTile(title: Text('Wobble me!')),
///   ),
/// )
/// ```
class JellyContainer extends StatefulWidget {
  const JellyContainer({
    super.key,
    required this.child,
    this.wobbleOnTap = true,
    this.wobbleAmount = 0.02,
    this.wobbleDuration = const Duration(milliseconds: 400),
  });

  /// The child widget.
  final Widget child;

  /// Whether to wobble when tapped.
  final bool wobbleOnTap;

  /// Amount of wobble (rotation in radians).
  final double wobbleAmount;

  /// Duration of the wobble animation.
  final Duration wobbleDuration;

  @override
  State<JellyContainer> createState() => _JellyContainerState();
}

class _JellyContainerState extends State<JellyContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _wobbleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.wobbleDuration,
    );

    _wobbleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: widget.wobbleAmount),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.wobbleAmount, end: -widget.wobbleAmount * 0.7),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -widget.wobbleAmount * 0.7, end: widget.wobbleAmount * 0.4),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.wobbleAmount * 0.4, end: -widget.wobbleAmount * 0.2),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -widget.wobbleAmount * 0.2, end: 0.0),
        weight: 25,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _wobble() {
    if (_controller.isAnimating) {
      _controller.reset();
    }
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    if (reduceMotion) {
      return widget.child;
    }

    return GestureDetector(
      onTap: widget.wobbleOnTap ? _wobble : null,
      child: AnimatedBuilder(
        animation: _wobbleAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _wobbleAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
