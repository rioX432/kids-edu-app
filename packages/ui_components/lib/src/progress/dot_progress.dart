import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

/// A dot-based progress indicator for multi-step flows.
///
/// Commonly used for onboarding, tutorials, or page indicators.
class DotProgress extends StatelessWidget {
  const DotProgress({
    super.key,
    required this.current,
    required this.total,
    this.activeColor,
    this.inactiveColor,
    this.dotSize = 12,
    this.spacing = 8,
    this.animated = true,
  });

  /// Current active dot (0-indexed).
  final int current;

  /// Total number of dots.
  final int total;

  /// Color for the active dot.
  final Color? activeColor;

  /// Color for inactive dots.
  final Color? inactiveColor;

  /// Size of each dot.
  final double dotSize;

  /// Spacing between dots.
  final double spacing;

  /// Whether to animate transitions.
  final bool animated;

  @override
  Widget build(BuildContext context) {
    final active = activeColor ?? AppColors.learningPrimary;
    final inactive = inactiveColor ?? AppColors.textDisabledLight;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (index) {
        final isActive = index == current;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing / 2),
          child: animated
              ? AnimatedContainer(
                  duration: AppSpacing.durationNormal,
                  curve: Curves.easeOut,
                  width: isActive ? dotSize * 2 : dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: isActive ? active : inactive.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(dotSize / 2),
                  ),
                )
              : Container(
                  width: isActive ? dotSize * 2 : dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: isActive ? active : inactive.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(dotSize / 2),
                  ),
                ),
        );
      }),
    );
  }
}

/// A circular dot progress that shows completion percentage.
class CircularDotProgress extends StatelessWidget {
  const CircularDotProgress({
    super.key,
    required this.current,
    required this.total,
    this.size = 80,
    this.strokeWidth = 8,
    this.progressColor,
    this.backgroundColor,
    this.child,
  });

  /// Current progress value.
  final int current;

  /// Total/max value.
  final int total;

  /// Size of the circular indicator.
  final double size;

  /// Width of the progress stroke.
  final double strokeWidth;

  /// Color of the progress arc.
  final Color? progressColor;

  /// Background circle color.
  final Color? backgroundColor;

  /// Widget to display in the center.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? current / total : 0.0;
    final color = progressColor ?? AppColors.learningPrimary;
    final bgColor = backgroundColor ?? AppColors.textDisabledLight.withOpacity(0.2);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation(bgColor),
              backgroundColor: Colors.transparent,
            ),
          ),
          // Progress arc
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: AppSpacing.durationSlow,
            curve: Curves.easeOut,
            builder: (context, value, _) {
              return SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  value: value,
                  strokeWidth: strokeWidth,
                  strokeCap: StrokeCap.round,
                  valueColor: AlwaysStoppedAnimation(color),
                  backgroundColor: Colors.transparent,
                ),
              );
            },
          ),
          // Center child
          if (child != null) child!,
        ],
      ),
    );
  }
}
