import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';

/// Size options for character avatar.
enum CharacterAvatarSize {
  /// 48px - for lists, small indicators
  small,

  /// 64px - for normal display
  medium,

  /// 96px - for featured display
  large,

  /// 128px - for main character display
  extraLarge,
}

/// A circular avatar displaying the character with emotion.
class CharacterAvatar extends StatelessWidget {
  const CharacterAvatar({
    super.key,
    required this.characterType,
    this.emotion = CharacterEmotion.happy,
    this.size = CharacterAvatarSize.medium,
    this.accessoryId,
    this.showEmotionBadge = true,
    this.onTap,
  });

  /// The character type to display.
  final CharacterType characterType;

  /// Current emotion to display.
  final CharacterEmotion emotion;

  /// Size of the avatar.
  final CharacterAvatarSize size;

  /// Optional accessory ID to display.
  final String? accessoryId;

  /// Whether to show the emotion badge.
  final bool showEmotionBadge;

  /// Optional tap callback.
  final VoidCallback? onTap;

  double get _size {
    switch (size) {
      case CharacterAvatarSize.small:
        return AppSpacing.avatarSm;
      case CharacterAvatarSize.medium:
        return AppSpacing.avatarMd;
      case CharacterAvatarSize.large:
        return AppSpacing.avatarLg;
      case CharacterAvatarSize.extraLarge:
        return AppSpacing.avatarXl;
    }
  }

  double get _emojiSize {
    switch (size) {
      case CharacterAvatarSize.small:
        return 24;
      case CharacterAvatarSize.medium:
        return 32;
      case CharacterAvatarSize.large:
        return 48;
      case CharacterAvatarSize.extraLarge:
        return 64;
    }
  }

  double get _badgeSize {
    switch (size) {
      case CharacterAvatarSize.small:
        return 20;
      case CharacterAvatarSize.medium:
        return 24;
      case CharacterAvatarSize.large:
        return 32;
      case CharacterAvatarSize.extraLarge:
        return 40;
    }
  }

  String get _emotionEmoji {
    switch (emotion) {
      case CharacterEmotion.happy:
        return '😊';
      case CharacterEmotion.excited:
        return '🤩';
      case CharacterEmotion.thinking:
        return '🤔';
      case CharacterEmotion.sleeping:
        return '😴';
      case CharacterEmotion.sad:
        return '😢';
      case CharacterEmotion.encouraging:
        return '💪';
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = CharacterTypes.fromType(characterType);

    Widget avatar = Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: info.color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: info.color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          info.emoji,
          style: TextStyle(fontSize: _emojiSize),
        ),
      ),
    );

    if (showEmotionBadge) {
      avatar = Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            right: -4,
            bottom: -4,
            child: Container(
              width: _badgeSize,
              height: _badgeSize,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.textDisabledLight,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _emotionEmoji,
                  style: TextStyle(fontSize: _badgeSize * 0.6),
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    return avatar;
  }
}

/// An animated character avatar that blinks and breathes.
class AnimatedCharacterAvatar extends StatefulWidget {
  const AnimatedCharacterAvatar({
    super.key,
    required this.characterType,
    this.emotion = CharacterEmotion.happy,
    this.size = CharacterAvatarSize.large,
  });

  final CharacterType characterType;
  final CharacterEmotion emotion;
  final CharacterAvatarSize size;

  @override
  State<AnimatedCharacterAvatar> createState() =>
      _AnimatedCharacterAvatarState();
}

class _AnimatedCharacterAvatarState extends State<AnimatedCharacterAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _breathController;
  late Animation<double> _breathAnimation;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _breathAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _breathController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _breathAnimation,
      child: CharacterAvatar(
        characterType: widget.characterType,
        emotion: widget.emotion,
        size: widget.size,
      ),
    );
  }
}
