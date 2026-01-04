import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

import '../common/tap_feedback.dart';

/// A circular icon button for navigation and actions.
class IconActionButton extends StatelessWidget {
  const IconActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = IconActionButtonSize.medium,
    this.color,
    this.backgroundColor,
    this.enabled = true,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final IconActionButtonSize size;
  final Color? color;
  final Color? backgroundColor;
  final bool enabled;

  double get _size {
    switch (size) {
      case IconActionButtonSize.small:
        return AppSpacing.touchTargetMin;
      case IconActionButtonSize.medium:
        return AppSpacing.touchTargetPreferred;
      case IconActionButtonSize.large:
        return AppSpacing.touchTargetLarge;
    }
  }

  double get _iconSize {
    switch (size) {
      case IconActionButtonSize.small:
        return AppSpacing.iconSm;
      case IconActionButtonSize.medium:
        return AppSpacing.iconMd;
      case IconActionButtonSize.large:
        return AppSpacing.iconLg;
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? AppColors.textPrimaryLight;
    final bgColor = backgroundColor ?? AppColors.surfaceLight;

    final button = Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: enabled ? bgColor : bgColor.withOpacity(0.5),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: enabled ? iconColor : iconColor.withOpacity(0.5),
        size: _iconSize,
      ),
    );

    return TapFeedback(
      onTap: enabled ? onTap : null,
      enabled: enabled,
      child: button,
    );
  }
}

enum IconActionButtonSize {
  small,
  medium,
  large,
}

/// A navigation back button.
class BackButton extends StatelessWidget {
  const BackButton({
    super.key,
    this.onTap,
    this.color,
  });

  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconActionButton(
      icon: Icons.arrow_back_rounded,
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      color: color,
    );
  }
}

/// A navigation forward/next button.
class ForwardButton extends StatelessWidget {
  const ForwardButton({
    super.key,
    required this.onTap,
    this.color,
  });

  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconActionButton(
      icon: Icons.arrow_forward_rounded,
      onTap: onTap,
      color: color,
    );
  }
}

/// A close/dismiss button.
/// Named AppCloseButton to avoid conflict with Flutter's CloseButton.
class AppCloseButton extends StatelessWidget {
  const AppCloseButton({
    super.key,
    this.onTap,
    this.color,
  });

  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconActionButton(
      icon: Icons.close_rounded,
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      color: color,
      size: IconActionButtonSize.small,
    );
  }
}
