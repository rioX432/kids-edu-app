import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:design_system/design_system.dart';
import 'package:ui_components/ui_components.dart';
import 'package:core/core.dart';
import 'package:go_router/go_router.dart';

import '../../providers/app_state_provider.dart';

/// Onboarding screen for picture book app (night theme).
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

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

    final profileRepo = ref.read(profileRepositoryProvider);
    final profile = await profileRepo.createProfile(
      name: _userName,
      avatarId: _selectedCharacter!.name,
    );

    final charRepo = ref.read(characterRepositoryProvider);
    await charRepo.createCharacter(
      profileId: profile.id,
      type: _selectedCharacter!,
      name: _characterName.isNotEmpty
          ? _characterName
          : CharacterTypes.fromType(_selectedCharacter!).displayNameJa,
    );

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nightBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: AppSpacing.insetLg,
              child: DotProgress(
                current: _currentPage,
                total: 3,
                activeColor: AppColors.nightAccent,
                inactiveColor: AppColors.nightTextSecondary,
              ),
            ),
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

          // Moon illustration
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  AppColors.nightAccent.withOpacity(0.3),
                  AppColors.nightBackground,
                ],
              ),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              '🌙',
              style: TextStyle(fontSize: 100),
            ),
          ),
          const VGap.xl(),

          Text(
            'えほんアプリへ\nようこそ！',
            style: AppTypography.displaySmall.copyWith(
              color: AppColors.nightTextPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const VGap.md(),

          Text(
            'おやすみまえに\nたのしい おはなしを よもう',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.nightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(),

          PrimaryButton(
            text: 'はじめる',
            icon: Icons.arrow_forward_rounded,
            onTap: onNext,
            color: AppColors.pictureBookAccent,
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
              color: AppColors.nightTextPrimary,
            ),
          ),
          const VGap.xl(),

          Container(
            padding: AppSpacing.insetMd,
            decoration: BoxDecoration(
              color: AppColors.nightSurface,
              borderRadius: AppSpacing.radiusLg,
              border: Border.all(
                color: AppColors.nightAccent.withOpacity(0.5),
                width: 3,
              ),
            ),
            child: TextField(
              onChanged: onNameChanged,
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.nightTextPrimary,
              ),
              textAlign: TextAlign.center,
              cursorColor: AppColors.nightAccent,
              decoration: InputDecoration(
                hintText: 'なまえ',
                hintStyle: AppTypography.headlineMedium.copyWith(
                  color: AppColors.nightTextSecondary.withOpacity(0.5),
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
                  color: AppColors.nightTextSecondary,
                ),
              ),
              const HGap.md(),
              Expanded(
                child: PrimaryButton(
                  text: 'つぎへ',
                  onTap: userName.isNotEmpty ? onNext : null,
                  enabled: userName.isNotEmpty,
                  color: AppColors.pictureBookAccent,
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
            'よみきかせの なかまを えらぼう',
            style: AppTypography.headlineLarge.copyWith(
              color: AppColors.nightTextPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const VGap.xl(),

          CharacterSelector(
            selectedType: selectedCharacter,
            onSelect: onCharacterSelected,
            columns: 2,
          ),
          const VGap.xl(),

          if (selectedCharacter != null) ...[
            Container(
              padding: AppSpacing.insetMd,
              decoration: BoxDecoration(
                color: AppColors.nightSurface,
                borderRadius: AppSpacing.radiusLg,
                border: Border.all(
                  color: AppColors.nightTextSecondary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: TextField(
                onChanged: onNameChanged,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.nightTextPrimary,
                ),
                textAlign: TextAlign.center,
                cursorColor: AppColors.nightAccent,
                decoration: InputDecoration(
                  hintText: CharacterTypes.fromType(selectedCharacter!).displayNameJa,
                  hintStyle: AppTypography.bodyLarge.copyWith(
                    color: AppColors.nightTextSecondary.withOpacity(0.5),
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
                  color: AppColors.nightTextSecondary,
                ),
              ),
              const HGap.md(),
              Expanded(
                child: PrimaryButton(
                  text: 'はじめよう！',
                  onTap: selectedCharacter != null ? onComplete : null,
                  enabled: selectedCharacter != null,
                  color: AppColors.pictureBookAccent,
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
