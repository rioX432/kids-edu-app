import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

import '../common/tap_feedback.dart';

/// A large, kid-friendly primary action button.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
    this.color,
    this.fullWidth = true,
  });

  final String text;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isLoading;
  final bool enabled;
  final Color? color;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppColors.learningPrimary;
    final isEnabled = enabled && !isLoading;

    final button = Container(
      constraints: const BoxConstraints(
        minHeight: AppSpacing.touchTargetPreferred,
        minWidth: AppSpacing.touchTargetPreferred,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isEnabled ? buttonColor : buttonColor.withOpacity(0.5),
        borderRadius: AppSpacing.radiusXl,
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: buttonColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading) ...[
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            const HGap.md(),
          ] else if (icon != null) ...[
            Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
            const HGap.sm(),
          ],
          Text(
            text,
            style: AppTypography.button.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );

    return TapFeedback(
      onTap: isEnabled ? onTap : null,
      enabled: isEnabled,
      child: button,
    );
  }
}

/// A secondary/outline button.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.enabled = true,
    this.color,
    this.fullWidth = true,
  });

  final String text;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool enabled;
  final Color? color;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppColors.learningPrimary;

    final button = Container(
      constraints: const BoxConstraints(
        minHeight: AppSpacing.touchTargetPreferred,
        minWidth: AppSpacing.touchTargetPreferred,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: AppSpacing.radiusXl,
        border: Border.all(
          color: enabled ? buttonColor : buttonColor.withOpacity(0.5),
          width: 3,
        ),
      ),
      child: Row(
        mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: enabled ? buttonColor : buttonColor.withOpacity(0.5),
              size: 28,
            ),
            const HGap.sm(),
          ],
          Text(
            text,
            style: AppTypography.button.copyWith(
              color: enabled ? buttonColor : buttonColor.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );

    return TapFeedback(
      onTap: enabled ? onTap : null,
      enabled: enabled,
      child: button,
    );
  }
}
