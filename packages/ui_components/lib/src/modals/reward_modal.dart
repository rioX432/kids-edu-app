import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';

import '../buttons/primary_button.dart';
import '../progress/star_progress.dart';

/// A celebratory modal shown when the child completes a lesson or earns a reward.
class RewardModal extends StatefulWidget {
  const RewardModal({
    super.key,
    required this.title,
    required this.message,
    this.emoji = '🎉',
    this.starsEarned = 0,
    this.maxStars = 3,
    this.reward,
    this.onDismiss,
    this.dismissText = 'やったね！',
  });

  /// Title text (e.g., "すごい！", "よくできました！")
  final String title;

  /// Message text.
  final String message;

  /// Celebratory emoji to display.
  final String emoji;

  /// Number of stars earned.
  final int starsEarned;

  /// Maximum stars possible.
  final int maxStars;

  /// Optional reward widget to display.
  final Widget? reward;

  /// Callback when modal is dismissed.
  final VoidCallback? onDismiss;

  /// Text for the dismiss button.
  final String dismissText;

  /// Shows the reward modal as a dialog.
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String emoji = '🎉',
    int starsEarned = 0,
    int maxStars = 3,
    Widget? reward,
    VoidCallback? onDismiss,
    String dismissText = 'やったね！',
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      transitionDuration: AppSpacing.durationNormal,
      pageBuilder: (context, animation, secondaryAnimation) {
        return RewardModal(
          title: title,
          message: message,
          emoji: emoji,
          starsEarned: starsEarned,
          maxStars: maxStars,
          reward: reward,
          onDismiss: onDismiss ?? () => Navigator.of(context).pop(),
          dismissText: dismissText,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<RewardModal> createState() => _RewardModalState();
}

class _RewardModalState extends State<RewardModal>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late AnimationController _confettiController;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.2), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 0.95), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.05), weight: 25),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 25),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeOut,
    ));

    _confettiController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _bounceController.forward();
    _confettiController.forward();
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.horizontalLg,
        child: ScaleTransition(
          scale: _bounceAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 340),
              padding: AppSpacing.insetXl,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppSpacing.radiusXxl,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.rewardGold.withOpacity(0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Emoji
                  Text(
                    widget.emoji,
                    style: const TextStyle(fontSize: 72),
                  ),
                  const VGap.md(),

                  // Title
                  Text(
                    widget.title,
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.textPrimaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const VGap.sm(),

                  // Message
                  Text(
                    widget.message,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  // Stars
                  if (widget.starsEarned > 0) ...[
                    const VGap.lg(),
                    StarProgress(
                      current: widget.starsEarned,
                      total: widget.maxStars,
                      size: StarProgressSize.large,
                    ),
                  ],

                  // Reward
                  if (widget.reward != null) ...[
                    const VGap.lg(),
                    Container(
                      padding: AppSpacing.insetMd,
                      decoration: BoxDecoration(
                        color: AppColors.rewardGold.withOpacity(0.1),
                        borderRadius: AppSpacing.radiusLg,
                        border: Border.all(
                          color: AppColors.rewardGold.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: widget.reward,
                    ),
                  ],

                  const VGap.xl(),

                  // Dismiss button
                  PrimaryButton(
                    text: widget.dismissText,
                    onTap: widget.onDismiss,
                    color: AppColors.rewardGold,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A simple stamp earned notification.
class StampEarnedModal extends StatelessWidget {
  const StampEarnedModal({
    super.key,
    required this.stampEmoji,
    required this.stampName,
    this.onDismiss,
  });

  final String stampEmoji;
  final String stampName;
  final VoidCallback? onDismiss;

  static Future<void> show(
    BuildContext context, {
    required String stampEmoji,
    required String stampName,
    VoidCallback? onDismiss,
  }) {
    return RewardModal.show(
      context,
      title: 'スタンプゲット！',
      message: stampName,
      emoji: stampEmoji,
      dismissText: 'うれしい！',
      onDismiss: onDismiss,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RewardModal(
      title: 'スタンプゲット！',
      message: stampName,
      emoji: stampEmoji,
      dismissText: 'うれしい！',
      onDismiss: onDismiss,
    );
  }
}

/// Level up celebration modal.
class LevelUpModal extends StatelessWidget {
  const LevelUpModal({
    super.key,
    required this.newLevel,
    required this.characterEmoji,
    this.onDismiss,
  });

  final int newLevel;
  final String characterEmoji;
  final VoidCallback? onDismiss;

  static Future<void> show(
    BuildContext context, {
    required int newLevel,
    required String characterEmoji,
    VoidCallback? onDismiss,
  }) {
    return RewardModal.show(
      context,
      title: 'レベルアップ！',
      message: 'レベル $newLevel になったよ！',
      emoji: characterEmoji,
      dismissText: 'やったー！',
      onDismiss: onDismiss,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RewardModal(
      title: 'レベルアップ！',
      message: 'レベル $newLevel になったよ！',
      emoji: characterEmoji,
      dismissText: 'やったー！',
      onDismiss: onDismiss,
    );
  }
}
