import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'package:ui_components/ui_components.dart';
import 'package:core/core.dart';
import 'package:animations/animations.dart';

import '../providers/app_state_provider.dart';

/// Home screen showing book shelves and reading options.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterAsync = ref.watch(currentCharacterProvider);

    return Scaffold(
      backgroundColor: AppColors.nightBackground,
      body: SafeArea(
        child: characterAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.nightAccent,
            ),
          ),
          error: (error, stack) => Center(
            child: Text(
              'Error: $error',
              style: TextStyle(color: AppColors.nightTextPrimary),
            ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(context, character),
                  const VGap.xl(),

                  // Character greeting
                  _buildCharacterGreeting(character),
                  const VGap.xl(),

                  // Book categories
                  _buildBookSection(
                    title: 'おすすめの えほん',
                    emoji: '⭐',
                    books: [
                      _BookData('むかしむかし', '🏯', AppColors.pictureBookAccent),
                      _BookData('どうぶつの おはなし', '🦁', AppColors.characterBear),
                      _BookData('ほしの たび', '🌟', AppColors.nightAccent),
                    ],
                  ),
                  const VGap.xl(),

                  _buildBookSection(
                    title: 'あたらしい えほん',
                    emoji: '🆕',
                    books: [
                      _BookData('うみの なかま', '🐠', AppColors.characterPenguin),
                      _BookData('もりの おともだち', '🌲', AppColors.characterFox),
                    ],
                  ),
                  const VGap.xl(),

                  // Bedtime mode button
                  _buildBedtimeModeCard(),
                  const VGap.xl(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Character character) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('🌙', style: TextStyle(fontSize: 28)),
                const HGap.sm(),
                Text(
                  'えほんアプリ',
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.nightTextPrimary,
                  ),
                ),
              ],
            ),
            Text(
              'おやすみまえの よみきかせ',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.nightTextSecondary,
              ),
            ),
          ],
        ),

        // Character avatar
        CharacterAvatar(
          characterType: character.typeInfo?.type ?? CharacterType.fox,
          emotion: CharacterEmotion.sleeping,
          size: CharacterAvatarSize.medium,
        ),
      ],
    );
  }

  Widget _buildCharacterGreeting(Character character) {
    final characterType = character.typeInfo?.type ?? CharacterType.fox;

    return Container(
      padding: AppSpacing.insetLg,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.nightSurface,
            AppColors.nightBackground,
          ],
        ),
        borderRadius: AppSpacing.radiusXl,
        border: Border.all(
          color: AppColors.nightAccent.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          BreathingWidget(
            intensity: BreathingIntensity.subtle,
            child: AnimatedCharacterAvatar(
              characterType: characterType,
              emotion: CharacterEmotion.happy,
              size: CharacterAvatarSize.large,
            ),
          ),
          const HGap.lg(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'こんばんは、${character.displayName}だよ！',
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.nightTextPrimary,
                  ),
                ),
                const VGap.xs(),
                Text(
                  'きょうは どの えほんを よむ？',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.nightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookSection({
    required String title,
    required String emoji,
    required List<_BookData> books,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const HGap.sm(),
            Text(
              title,
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.nightTextPrimary,
              ),
            ),
          ],
        ),
        const VGap.md(),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            separatorBuilder: (_, __) => const HGap.md(),
            itemBuilder: (context, index) {
              final book = books[index];
              return _BookCard(
                title: book.title,
                emoji: book.emoji,
                color: book.color,
                onTap: () {
                  // TODO: Navigate to story reader
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBedtimeModeCard() {
    return IdleWiggleWidget(
      wiggleAngle: 0.01,
      wiggleDuration: const Duration(seconds: 4),
      child: SquishyButton(
        onPressed: () {
          // TODO: Start bedtime mode with timer
        },
        child: Container(
          padding: AppSpacing.insetLg,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.pictureBookAccent.withValues(alpha: 0.3),
                AppColors.nightAccent.withValues(alpha: 0.2),
              ],
            ),
            borderRadius: AppSpacing.radiusXl,
            border: Border.all(
              color: AppColors.pictureBookAccent.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.pictureBookAccent.withValues(alpha: 0.3),
                  borderRadius: AppSpacing.radiusLg,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '😴',
                  style: TextStyle(fontSize: 36),
                ),
              ),
              const HGap.lg(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'おやすみモード',
                      style: AppTypography.headlineSmall.copyWith(
                        color: AppColors.nightTextPrimary,
                      ),
                    ),
                    Text(
                      'タイマーつきで よみきかせ',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.nightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.bedtime_rounded,
                color: AppColors.pictureBookAccent,
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookData {
  const _BookData(this.title, this.emoji, this.color);
  final String title;
  final String emoji;
  final Color color;
}

class _BookCard extends StatelessWidget {
  const _BookCard({
    required this.title,
    required this.emoji,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String emoji;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SquishyButton(
      onPressed: onTap,
      child: JellyContainer(
        wobbleOnTap: false, // SquishyButton handles the tap
        child: Container(
          width: 140,
          padding: AppSpacing.insetMd,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withValues(alpha: 0.3),
                AppColors.nightSurface,
              ],
            ),
            borderRadius: AppSpacing.radiusLg,
            border: Border.all(
              color: color.withValues(alpha: 0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: AppSpacing.radiusMd,
                ),
                alignment: Alignment.center,
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 48),
                ),
              ),
              const VGap.md(),
              Text(
                title,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.nightTextPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
