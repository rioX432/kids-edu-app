import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

/// An animated container with common animation presets.
class AnimatedAppContainer extends StatelessWidget {
  const AnimatedAppContainer({
    super.key,
    required this.child,
    this.duration,
    this.curve = Curves.easeOut,
    this.padding,
    this.margin,
    this.decoration,
    this.width,
    this.height,
  });

  final Widget child;
  final Duration? duration;
  final Curve curve;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BoxDecoration? decoration;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration ?? AppSpacing.durationNormal,
      curve: curve,
      padding: padding,
      margin: margin,
      decoration: decoration,
      width: width,
      height: height,
      child: child,
    );
  }
}

/// A widget that fades in when first built.
class FadeInWidget extends StatefulWidget {
  const FadeInWidget({
    super.key,
    required this.child,
    this.duration,
    this.delay = Duration.zero,
    this.curve = Curves.easeIn,
  });

  final Widget child;
  final Duration? duration;
  final Duration delay;
  final Curve curve;

  @override
  State<FadeInWidget> createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? AppSpacing.durationNormal,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    if (widget.delay > Duration.zero) {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

/// A widget that scales in with a bounce effect.
class BounceInWidget extends StatefulWidget {
  const BounceInWidget({
    super.key,
    required this.child,
    this.duration,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration? duration;
  final Duration delay;

  @override
  State<BounceInWidget> createState() => _BounceInWidgetState();
}

class _BounceInWidgetState extends State<BounceInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? AppSpacing.durationSlow,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    if (widget.delay > Duration.zero) {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
