import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'package:ui_components/ui_components.dart';
import 'package:core/core.dart';

import '../providers/app_state_provider.dart';

/// Home screen showing character and daily activities.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterAsync = ref.watch(currentCharacterProvider);
    final streakAsync = ref.watch(streakDataProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: characterAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
            child: Text('Error: $error'),
          ),
          data: (character) {
            if (character == null) {
              return const Center(
                child: Text('No character found'),
              );
            }

            return SingleChildScrollView(
              padding: AppSpacing.insetLg,
              child: Column(
                children: [
                  // Header with streak
                  _buildHeader(context, streakAsync),
                  const VGap.xl(),

                  // Character display
                  _buildCharacterSection(character),
                  const VGap.xl(),

                  // Daily activities
                  _buildActivitiesSection(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AsyncValue<StreakData?> streakAsync) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Greeting
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'こんにちは！',
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
            Text(
              'きょうも がんばろう！',
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),

        // Streak badge
        streakAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
          data: (streak) {
            if (streak == null) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.rewardGold.withOpacity(0.2),
                borderRadius: AppSpacing.radiusLg,
                border: Border.all(
                  color: AppColors.rewardGold,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 24)),
                  const HGap.xs(),
                  Text(
                    '${streak.currentStreak}にち',
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.rewardGold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCharacterSection(Character character) {
    final info = CharacterTypes.fromType(character.type);

    return Container(
      padding: AppSpacing.insetXl,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            info.color.withOpacity(0.2),
            info.color.withOpacity(0.1),
          ],
        ),
        borderRadius: AppSpacing.radiusXxl,
        border: Border.all(
          color: info.color.withOpacity(0.3),
          width: 3,
        ),
      ),
      child: Column(
        children: [
          // Animated character
          AnimatedCharacterAvatar(
            characterType: character.type,
            emotion: CharacterEmotion.happy,
            size: CharacterAvatarSize.extraLarge,
          ),
          const VGap.md(),

          // Character name
          Text(
            character.name,
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textPrimaryLight,
            ),
          ),
          const VGap.xs(),

          // Level
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: info.color,
              borderRadius: AppSpacing.radiusMd,
            ),
            child: Text(
              'レベル ${character.level}',
              style: AppTypography.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const VGap.md(),

          // XP progress
          LinearStepProgress(
            progress: character.xp / character.xpForNextLevel,
            progressColor: info.color,
            showPercentage: false,
          ),
          const VGap.xs(),
          Text(
            'あと ${character.xpForNextLevel - character.xp} XP でレベルアップ！',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'きょうの あそび',
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.textPrimaryLight,
          ),
        ),
        const VGap.md(),

        // Activity cards
        _ActivityCard(
          emoji: '🔢',
          title: 'かず',
          subtitle: 'すうじを おぼえよう',
          color: AppColors.learningPrimary,
          onTap: () {
            // TODO: Navigate to number learning
          },
        ),
        const VGap.md(),

        _ActivityCard(
          emoji: '🔤',
          title: 'もじ',
          subtitle: 'ひらがなを かこう',
          color: AppColors.characterCat,
          onTap: () {
            // TODO: Navigate to hiragana learning
          },
        ),
        const VGap.md(),

        _ActivityCard(
          emoji: '🎨',
          title: 'いろ',
          subtitle: 'いろを おぼえよう',
          color: AppColors.characterRabbit,
          onTap: () {
            // TODO: Navigate to color learning
          },
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TapFeedback(
      onTap: onTap,
      child: Container(
        padding: AppSpacing.insetLg,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppSpacing.radiusXl,
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: AppSpacing.radiusLg,
              ),
              alignment: Alignment.center,
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 36),
              ),
            ),
            const HGap.lg(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.headlineSmall.copyWith(
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              color: color,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
