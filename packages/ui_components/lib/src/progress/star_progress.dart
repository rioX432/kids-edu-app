import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

/// A star-based progress indicator for quiz/lesson completion.
///
/// Shows filled stars for completed steps and empty stars for remaining.
class StarProgress extends StatelessWidget {
  const StarProgress({
    super.key,
    required this.current,
    required this.total,
    this.size = StarProgressSize.medium,
    this.filledColor,
    this.emptyColor,
    this.animated = true,
  });

  /// Current progress (0 to total).
  final int current;

  /// Total number of stars.
  final int total;

  /// Size of the stars.
  final StarProgressSize size;

  /// Color for filled stars.
  final Color? filledColor;

  /// Color for empty stars.
  final Color? emptyColor;

  /// Whether to animate star fill.
  final bool animated;

  double get _starSize {
    switch (size) {
      case StarProgressSize.small:
        return 24;
      case StarProgressSize.medium:
        return 32;
      case StarProgressSize.large:
        return 48;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (index) {
        final isFilled = index < current;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: size == StarProgressSize.small ? 2 : 4),
          child: animated
              ? _AnimatedStar(
                  isFilled: isFilled,
                  size: _starSize,
                  filledColor: filledColor ?? AppColors.rewardGold,
                  emptyColor: emptyColor ?? AppColors.textDisabledLight,
                  delay: Duration(milliseconds: index * 100),
                )
              : _StaticStar(
                  isFilled: isFilled,
                  size: _starSize,
                  filledColor: filledColor ?? AppColors.rewardGold,
                  emptyColor: emptyColor ?? AppColors.textDisabledLight,
                ),
        );
      }),
    );
  }
}

enum StarProgressSize {
  small,
  medium,
  large,
}

class _StaticStar extends StatelessWidget {
  const _StaticStar({
    required this.isFilled,
    required this.size,
    required this.filledColor,
    required this.emptyColor,
  });

  final bool isFilled;
  final double size;
  final Color filledColor;
  final Color emptyColor;

  @override
  Widget build(BuildContext context) {
    return Icon(
      isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
      size: size,
      color: isFilled ? filledColor : emptyColor,
    );
  }
}

class _AnimatedStar extends StatefulWidget {
  const _AnimatedStar({
    required this.isFilled,
    required this.size,
    required this.filledColor,
    required this.emptyColor,
    required this.delay,
  });

  final bool isFilled;
  final double size;
  final Color filledColor;
  final Color emptyColor;
  final Duration delay;

  @override
  State<_AnimatedStar> createState() => _AnimatedStarState();
}

class _AnimatedStarState extends State<_AnimatedStar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _showFilled = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppSpacing.durationNormal,
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    if (widget.isFilled) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          setState(() => _showFilled = true);
          _controller.forward();
        }
      });
    }
  }

  @override
  void didUpdateWidget(_AnimatedStar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFilled && !oldWidget.isFilled) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          setState(() => _showFilled = true);
          _controller.forward(from: 0);
        }
      });
    } else if (!widget.isFilled && oldWidget.isFilled) {
      setState(() => _showFilled = false);
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
      scale: _scaleAnimation,
      child: Icon(
        _showFilled ? Icons.star_rounded : Icons.star_outline_rounded,
        size: widget.size,
        color: _showFilled ? widget.filledColor : widget.emptyColor,
      ),
    );
  }
}
