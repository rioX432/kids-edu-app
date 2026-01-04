import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

import '../common/tap_feedback.dart';

/// State of a choice button in a quiz.
enum ChoiceButtonState {
  /// Default unselected state.
  idle,

  /// User has selected this choice.
  selected,

  /// This choice was correct.
  correct,

  /// This choice was incorrect.
  incorrect,

  /// Disabled (e.g., after answer revealed).
  disabled,
}

/// A large, kid-friendly button for quiz choices.
///
/// Features:
/// - Large touch target (minimum 64dp height)
/// - Visual feedback on press
/// - Distinct states for correct/incorrect answers
/// - Optional icon on the left
class ChoiceButton extends StatelessWidget {
  const ChoiceButton({
    super.key,
    required this.text,
    required this.onTap,
    this.state = ChoiceButtonState.idle,
    this.icon,
    this.iconWidget,
  });

  /// The text to display on the button.
  final String text;

  /// Callback when button is tapped.
  final VoidCallback? onTap;

  /// Current state of the button.
  final ChoiceButtonState state;

  /// Optional emoji or text icon.
  final String? icon;

  /// Optional widget icon (takes precedence over [icon]).
  final Widget? iconWidget;

  bool get _isInteractive =>
      state == ChoiceButtonState.idle || state == ChoiceButtonState.selected;

  Color _getBackgroundColor() {
    switch (state) {
      case ChoiceButtonState.idle:
        return AppColors.surfaceLight;
      case ChoiceButtonState.selected:
        return AppColors.learningSecondary;
      case ChoiceButtonState.correct:
        return AppColors.success;
      case ChoiceButtonState.incorrect:
        return AppColors.errorGentle;
      case ChoiceButtonState.disabled:
        return AppColors.surfaceLight.withOpacity(0.5);
    }
  }

  Color _getBorderColor() {
    switch (state) {
      case ChoiceButtonState.idle:
        return AppColors.textDisabledLight;
      case ChoiceButtonState.selected:
        return AppColors.learningPrimary;
      case ChoiceButtonState.correct:
        return AppColors.successDark;
      case ChoiceButtonState.incorrect:
        return AppColors.errorBorder;
      case ChoiceButtonState.disabled:
        return AppColors.textDisabledLight.withOpacity(0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor();
    final borderColor = _getBorderColor();

    Widget button = Container(
      constraints: const BoxConstraints(
        minHeight: AppSpacing.touchTargetPreferred,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppSpacing.radiusXl,
        border: Border.all(
          color: borderColor,
          width: 4,
        ),
        boxShadow: state == ChoiceButtonState.selected ||
                state == ChoiceButtonState.correct
            ? [
                BoxShadow(
                  color: borderColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Icon
          if (iconWidget != null || icon != null) ...[
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: AppSpacing.radiusLg,
              ),
              alignment: Alignment.center,
              child: iconWidget ??
                  Text(
                    icon!,
                    style: const TextStyle(fontSize: 32),
                  ),
            ),
            const HGap.md(),
          ],

          // Text
          Expanded(
            child: Text(
              text,
              style: AppTypography.choice.copyWith(
                color: state == ChoiceButtonState.disabled
                    ? AppColors.textDisabledLight
                    : AppColors.textPrimaryLight,
              ),
            ),
          ),

          // State indicator
          if (state == ChoiceButtonState.correct)
            _buildStateIndicator(
              icon: Icons.check,
              color: AppColors.successDark,
              animate: true,
            ),
          if (state == ChoiceButtonState.incorrect)
            _buildStateIndicator(
              icon: Icons.close,
              color: AppColors.errorBorder,
              animate: false,
            ),
        ],
      ),
    );

    if (_isInteractive) {
      return TapFeedback(
        onTap: onTap,
        child: button,
      );
    }

    return button;
  }

  Widget _buildStateIndicator({
    required IconData icon,
    required Color color,
    required bool animate,
  }) {
    final indicator = Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 28,
      ),
    );

    if (animate) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: AppSpacing.durationSlow,
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: indicator,
      );
    }

    return indicator;
  }
}
