import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'package:core/core.dart';

import '../common/tap_feedback.dart';
import 'character_avatar.dart';

/// A grid selector for choosing a character during onboarding.
class CharacterSelector extends StatelessWidget {
  const CharacterSelector({
    super.key,
    required this.onSelect,
    this.selectedType,
    this.columns = 2,
  });

  /// Callback when a character is selected.
  final ValueChanged<CharacterType> onSelect;

  /// Currently selected character type.
  final CharacterType? selectedType;

  /// Number of columns in the grid.
  final int columns;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.9,
      ),
      itemCount: CharacterTypes.all.length,
      itemBuilder: (context, index) {
        final info = CharacterTypes.all[index];
        final isSelected = selectedType == info.type;

        return _CharacterOption(
          info: info,
          isSelected: isSelected,
          onTap: () => onSelect(info.type),
        );
      },
    );
  }
}

class _CharacterOption extends StatelessWidget {
  const _CharacterOption({
    required this.info,
    required this.isSelected,
    required this.onTap,
  });

  final CharacterTypeInfo info;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapFeedback(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppSpacing.durationNormal,
        padding: AppSpacing.insetMd,
        decoration: BoxDecoration(
          color: isSelected
              ? info.color.withOpacity(0.2)
              : AppColors.surfaceLight,
          borderRadius: AppSpacing.radiusXl,
          border: Border.all(
            color: isSelected ? info.color : AppColors.textDisabledLight,
            width: isSelected ? 4 : 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: info.color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: AppSpacing.durationNormal,
              child: Container(
                width: AppSpacing.avatarLg,
                height: AppSpacing.avatarLg,
                decoration: BoxDecoration(
                  color: info.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: info.color.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    info.emoji,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
            ),
            const VGap.md(),

            // Name
            Text(
              info.displayNameJa,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textPrimaryLight,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A horizontal list selector for characters.
class CharacterHorizontalSelector extends StatelessWidget {
  const CharacterHorizontalSelector({
    super.key,
    required this.onSelect,
    this.selectedType,
  });

  final ValueChanged<CharacterType> onSelect;
  final CharacterType? selectedType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.horizontalLg,
        itemCount: CharacterTypes.all.length,
        separatorBuilder: (_, __) => const HGap.md(),
        itemBuilder: (context, index) {
          final info = CharacterTypes.all[index];
          final isSelected = selectedType == info.type;

          return TapFeedback(
            onTap: () => onSelect(info.type),
            child: AnimatedContainer(
              duration: AppSpacing.durationNormal,
              width: 100,
              padding: AppSpacing.insetSm,
              decoration: BoxDecoration(
                color: isSelected
                    ? info.color.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: AppSpacing.radiusXl,
                border: Border.all(
                  color: isSelected ? info.color : Colors.transparent,
                  width: 3,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CharacterAvatar(
                    characterType: info.type,
                    size: CharacterAvatarSize.medium,
                    showEmotionBadge: false,
                  ),
                  const VGap.sm(),
                  Text(
                    info.displayNameJa,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimaryLight,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
