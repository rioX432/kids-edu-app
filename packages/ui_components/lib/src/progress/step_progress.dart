import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

/// A step-based progress indicator showing completed/current/upcoming steps.
///
/// Used for multi-screen flows like onboarding or lesson sections.
class StepProgress extends StatelessWidget {
  const StepProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.activeColor,
    this.completedColor,
    this.inactiveColor,
    this.showLabels = false,
    this.labels,
    this.height = 8,
  });

  /// Current step (1-indexed).
  final int currentStep;

  /// Total number of steps.
  final int totalSteps;

  /// Color for the current step.
  final Color? activeColor;

  /// Color for completed steps.
  final Color? completedColor;

  /// Color for upcoming steps.
  final Color? inactiveColor;

  /// Whether to show step labels.
  final bool showLabels;

  /// Optional labels for each step.
  final List<String>? labels;

  /// Height of the progress bar.
  final double height;

  @override
  Widget build(BuildContext context) {
    final active = activeColor ?? AppColors.learningPrimary;
    final completed = completedColor ?? AppColors.success;
    final inactive = inactiveColor ?? AppColors.textDisabledLight.withOpacity(0.3);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: List.generate(totalSteps * 2 - 1, (index) {
            // Connector between steps
            if (index.isOdd) {
              final stepBefore = (index ~/ 2) + 1;
              final isCompleted = stepBefore < currentStep;

              return Expanded(
                child: AnimatedContainer(
                  duration: AppSpacing.durationNormal,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isCompleted ? completed : inactive,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }

            // Step circle
            final stepNumber = (index ~/ 2) + 1;
            final isCompleted = stepNumber < currentStep;
            final isCurrent = stepNumber == currentStep;

            return _StepCircle(
              stepNumber: stepNumber,
              isCompleted: isCompleted,
              isCurrent: isCurrent,
              activeColor: active,
              completedColor: completed,
              inactiveColor: inactive,
            );
          }),
        ),
        if (showLabels && labels != null && labels!.length == totalSteps) ...[
          const VGap.sm(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels!.asMap().entries.map((entry) {
              final stepNumber = entry.key + 1;
              final isCompleted = stepNumber < currentStep;
              final isCurrent = stepNumber == currentStep;

              return Text(
                entry.value,
                style: AppTypography.caption.copyWith(
                  color: isCurrent
                      ? active
                      : isCompleted
                          ? completed
                          : AppColors.textSecondaryLight,
                  fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.stepNumber,
    required this.isCompleted,
    required this.isCurrent,
    required this.activeColor,
    required this.completedColor,
    required this.inactiveColor,
  });

  final int stepNumber;
  final bool isCompleted;
  final bool isCurrent;
  final Color activeColor;
  final Color completedColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color borderColor;
    Widget child;

    if (isCompleted) {
      backgroundColor = completedColor;
      borderColor = completedColor;
      child = const Icon(
        Icons.check_rounded,
        color: Colors.white,
        size: 18,
      );
    } else if (isCurrent) {
      backgroundColor = activeColor;
      borderColor = activeColor;
      child = Text(
        '$stepNumber',
        style: AppTypography.bodySmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      );
    } else {
      backgroundColor = Colors.white;
      borderColor = inactiveColor;
      child = Text(
        '$stepNumber',
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.textSecondaryLight,
          fontWeight: FontWeight.w500,
        ),
      );
    }

    return AnimatedContainer(
      duration: AppSpacing.durationNormal,
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 3,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: activeColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(child: child),
    );
  }
}

/// A simple linear progress bar.
class LinearStepProgress extends StatelessWidget {
  const LinearStepProgress({
    super.key,
    required this.progress,
    this.height = 12,
    this.progressColor,
    this.backgroundColor,
    this.showPercentage = false,
    this.animated = true,
  });

  /// Progress value from 0.0 to 1.0.
  final double progress;

  /// Height of the progress bar.
  final double height;

  /// Color of the filled portion.
  final Color? progressColor;

  /// Background color.
  final Color? backgroundColor;

  /// Whether to show percentage text.
  final bool showPercentage;

  /// Whether to animate changes.
  final bool animated;

  @override
  Widget build(BuildContext context) {
    final color = progressColor ?? AppColors.learningPrimary;
    final bgColor = backgroundColor ?? AppColors.textDisabledLight.withOpacity(0.2);
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (showPercentage) ...[
          Text(
            '${(clampedProgress * 100).round()}%',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          const VGap.xs(),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth * clampedProgress;

              return Align(
                alignment: Alignment.centerLeft,
                child: animated
                    ? AnimatedContainer(
                        duration: AppSpacing.durationNormal,
                        curve: Curves.easeOut,
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(height / 2),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(height / 2),
                        ),
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}
