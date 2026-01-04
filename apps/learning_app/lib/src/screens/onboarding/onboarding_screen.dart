import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'package:ui_components/ui_components.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';

import '../../providers/app_state_provider.dart';

/// Onboarding screen for first-time users.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // User selections
  String _userName = '';
  CharacterType? _selectedCharacter;
  String _characterName = '';

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: AppSpacing.durationNormal,
        curve: Curves.easeOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: AppSpacing.durationNormal,
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    if (_selectedCharacter == null || _userName.isEmpty) return;

    // Create profile
    final profileRepo = await ref.read(profileRepositoryProvider.future);
    final profile = await profileRepo.create(name: _userName);

    // Create character
    final charRepo = await ref.read(characterRepositoryProvider.future);
    await charRepo.create(
      profileId: profile.id,
      type: _selectedCharacter!,
      name: _characterName.isNotEmpty
          ? _characterName
          : CharacterTypes.fromType(_selectedCharacter!).displayNameJa,
    );

    // Initialize streak
    final streakManager = await ref.read(streakManagerProvider.future);
    await streakManager.recordActivity(profile.id);

    // Navigate to home
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: AppSpacing.insetLg,
              child: DotProgress(
                current: _currentPage,
                total: 3,
              ),
            ),

            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                },
                children: [
                  _WelcomePage(onNext: _nextPage),
                  _NameInputPage(
                    userName: _userName,
                    onNameChanged: (name) => setState(() => _userName = name),
                    onNext: _nextPage,
                    onBack: _previousPage,
                  ),
                  _CharacterSelectPage(
                    selectedCharacter: _selectedCharacter,
                    characterName: _characterName,
                    onCharacterSelected: (type) {
                      setState(() => _selectedCharacter = type);
                    },
                    onNameChanged: (name) {
                      setState(() => _characterName = name);
                    },
                    onComplete: _completeOnboarding,
                    onBack: _previousPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.insetLg,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Welcome illustration
          Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              color: AppColors.learningSecondary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              '🎮',
              style: TextStyle(fontSize: 100),
            ),
          ),
          const VGap.xl(),

          Text(
            'まなびアプリへ\nようこそ！',
            style: AppTypography.displaySmall.copyWith(
              color: AppColors.textPrimaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          const VGap.md(),

          Text(
            'たのしく あそびながら\nいろんなことを おぼえよう！',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(),

          PrimaryButton(
            text: 'はじめる',
            icon: Icons.arrow_forward_rounded,
            onTap: onNext,
          ),
          const VGap.xl(),
        ],
      ),
    );
  }
}

class _NameInputPage extends StatelessWidget {
  const _NameInputPage({
    required this.userName,
    required this.onNameChanged,
    required this.onNext,
    required this.onBack,
  });

  final String userName;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.insetLg,
      child: Column(
        children: [
          const VGap.xl(),

          Text(
            'おなまえを おしえてね',
            style: AppTypography.headlineLarge.copyWith(
              color: AppColors.textPrimaryLight,
            ),
          ),
          const VGap.md(),

          Text(
            'よびたい なまえを いれてね',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
          const VGap.xl(),

          // Name input
          Container(
            padding: AppSpacing.insetMd,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppSpacing.radiusLg,
              border: Border.all(
                color: AppColors.learningPrimary.withValues(alpha: 0.5),
                width: 3,
              ),
            ),
            child: TextField(
              onChanged: onNameChanged,
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'なまえ',
                hintStyle: AppTypography.headlineMedium.copyWith(
                  color: AppColors.textDisabledLight,
                ),
                border: InputBorder.none,
              ),
            ),
          ),

          const Spacer(),

          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'もどる',
                  onTap: onBack,
                ),
              ),
              const HGap.md(),
              Expanded(
                child: PrimaryButton(
                  text: 'つぎへ',
                  onTap: userName.isNotEmpty ? onNext : null,
                  enabled: userName.isNotEmpty,
                ),
              ),
            ],
          ),
          const VGap.xl(),
        ],
      ),
    );
  }
}

class _CharacterSelectPage extends StatelessWidget {
  const _CharacterSelectPage({
    required this.selectedCharacter,
    required this.characterName,
    required this.onCharacterSelected,
    required this.onNameChanged,
    required this.onComplete,
    required this.onBack,
  });

  final CharacterType? selectedCharacter;
  final String characterName;
  final ValueChanged<CharacterType> onCharacterSelected;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onComplete;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.insetLg,
      child: Column(
        children: [
          const VGap.lg(),

          Text(
            'なかまを えらぼう',
            style: AppTypography.headlineLarge.copyWith(
              color: AppColors.textPrimaryLight,
            ),
          ),
          const VGap.md(),

          Text(
            'いっしょに がんばる なかまを えらんでね',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
          const VGap.xl(),

          // Character grid
          CharacterSelector(
            selectedType: selectedCharacter,
            onSelect: onCharacterSelected,
            columns: 2,
          ),
          const VGap.xl(),

          // Character name input (optional)
          if (selectedCharacter != null) ...[
            Text(
              'なかまの なまえ（すきにつけてね）',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
            const VGap.sm(),
            Container(
              padding: AppSpacing.insetMd,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppSpacing.radiusLg,
                border: Border.all(
                  color: AppColors.textDisabledLight,
                  width: 2,
                ),
              ),
              child: TextField(
                onChanged: onNameChanged,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textPrimaryLight,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: CharacterTypes.fromType(selectedCharacter!).displayNameJa,
                  hintStyle: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textDisabledLight,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
          const VGap.xl(),

          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'もどる',
                  onTap: onBack,
                ),
              ),
              const HGap.md(),
              Expanded(
                child: PrimaryButton(
                  text: 'はじめよう！',
                  onTap: selectedCharacter != null ? onComplete : null,
                  enabled: selectedCharacter != null,
                ),
              ),
            ],
          ),
          const VGap.xl(),
        ],
      ),
    );
  }
}
