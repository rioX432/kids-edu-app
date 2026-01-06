import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'package:animations/animations.dart';

/// Demo screen to showcase all animation components.
class AnimationDemoScreen extends StatefulWidget {
  const AnimationDemoScreen({super.key});

  @override
  State<AnimationDemoScreen> createState() => _AnimationDemoScreenState();
}

class _AnimationDemoScreenState extends State<AnimationDemoScreen> {
  double _progress = 0.0;
  bool _showConfetti = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Animation Demo'),
        backgroundColor: AppColors.learningPrimary,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: AppSpacing.insetLg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section 1: BreathingWidget
                _buildSectionTitle('1. BreathingWidget (呼吸アニメーション)'),
                const Text('キャラクターがゆっくり呼吸しているように見えます'),
                const VGap.md(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBreathingDemo('Subtle', BreathingIntensity.subtle),
                    _buildBreathingDemo('Normal', BreathingIntensity.normal),
                    _buildBreathingDemo('Pronounced', BreathingIntensity.pronounced),
                  ],
                ),
                const VGap.xl(),

                // Section 2: SquishyButton
                _buildSectionTitle('2. SquishyButton (ぷにぷにボタン)'),
                const Text('タップすると物理演算でぷにっと変形します'),
                const VGap.md(),
                Center(
                  child: SquishyButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Squishy! 🎉'),
                          duration: Duration(milliseconds: 500),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.learningPrimary,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.learningPrimary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Text(
                        'タップしてね！',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const VGap.xl(),

                // Section 3: JellyContainer
                _buildSectionTitle('3. JellyContainer (ゼリー揺れ)'),
                const Text('タップするとゼリーのように揺れます'),
                const VGap.md(),
                Center(
                  child: JellyContainer(
                    wobbleAmount: 0.03,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.characterCat,
                            AppColors.characterCat.withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '🍮\nタップ！',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                ),
                const VGap.xl(),

                // Section 4: IdleWiggleWidget
                _buildSectionTitle('4. IdleWiggleWidget (注目を引く揺れ)'),
                const Text('ゆっくり左右に揺れて注目を引きます'),
                const VGap.md(),
                Center(
                  child: IdleWiggleWidget(
                    wiggleAngle: 0.03,
                    wiggleDuration: const Duration(seconds: 2),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.rewardGold,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        '⭐ New! ⭐',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const VGap.xl(),

                // Section 5: EyeFollower
                _buildSectionTitle('5. EyeFollower (目が追いかける)'),
                const Text('指やカーソルを追いかけます'),
                const VGap.md(),
                Center(
                  child: Container(
                    width: 200,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.characterFox,
                      borderRadius: BorderRadius.circular(60),
                    ),
                    alignment: Alignment.center,
                    child: const EyeFollower(
                      eyeSize: 40,
                      eyeSpacing: 30,
                      style: EyeStyle.round,
                    ),
                  ),
                ),
                const VGap.xl(),

                // Section 6: CaterpillarProgress
                _buildSectionTitle('6. CaterpillarProgress (あおむし進捗)'),
                const Text('スライダーで進捗を変えてみてね！'),
                const VGap.md(),
                CaterpillarProgress(
                  progress: _progress,
                  onComplete: () {
                    setState(() => _showConfetti = true);
                    Future.delayed(const Duration(seconds: 3), () {
                      if (mounted) setState(() => _showConfetti = false);
                    });
                  },
                ),
                const VGap.md(),
                Slider(
                  value: _progress,
                  onChanged: (value) => setState(() => _progress = value),
                  activeColor: AppColors.learningPrimary,
                ),
                const VGap.xl(),

                // Section 7: ConfettiEffect
                _buildSectionTitle('7. ConfettiEffect (紙吹雪)'),
                const Text('ボタンを押すと紙吹雪が降ります'),
                const VGap.md(),
                Center(
                  child: SquishyButton(
                    onPressed: () {
                      setState(() => _showConfetti = true);
                      Future.delayed(const Duration(seconds: 3), () {
                        if (mounted) setState(() => _showConfetti = false);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.rewardGold,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        '🎊 お祝い！',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const VGap.xl(),

                // Section 8: ParticleTapEffect
                _buildSectionTitle('8. ParticleTapEffect (タップエフェクト)'),
                const Text('タップした場所にパーティクルが出ます'),
                const VGap.md(),
                SizedBox(
                  height: 200,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildParticleDemo('⭐', TapParticleType.stars, AppColors.rewardGold),
                      ),
                      const HGap.sm(),
                      Expanded(
                        child: _buildParticleDemo('🌸', TapParticleType.flowers, AppColors.characterRabbit),
                      ),
                      const HGap.sm(),
                      Expanded(
                        child: _buildParticleDemo('💖', TapParticleType.hearts, AppColors.characterCat),
                      ),
                    ],
                  ),
                ),
                const VGap.xl(),
                const VGap.xl(),
              ],
            ),
          ),

          // Confetti overlay
          if (_showConfetti)
            const Positioned.fill(
              child: IgnorePointer(
                child: ConfettiEffect(
                  particleCount: 100,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: AppTypography.headlineSmall.copyWith(
          color: AppColors.learningPrimary,
        ),
      ),
    );
  }

  Widget _buildBreathingDemo(String label, BreathingIntensity intensity) {
    return Column(
      children: [
        BreathingWidget(
          intensity: intensity,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.characterFox,
              borderRadius: BorderRadius.circular(40),
            ),
            alignment: Alignment.center,
            child: const Text('🦊', style: TextStyle(fontSize: 40)),
          ),
        ),
        const VGap.sm(),
        Text(label, style: AppTypography.caption),
      ],
    );
  }

  Widget _buildParticleDemo(String emoji, TapParticleType type, Color color) {
    return ParticleTapEffect(
      type: type,
      particleColor: color,
      child: Container(
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(emoji, style: const TextStyle(fontSize: 48)),
      ),
    );
  }
}
