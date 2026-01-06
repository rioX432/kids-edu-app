import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart';
import 'package:animations/animations.dart';
import 'package:go_router/go_router.dart';

/// Demo screen to showcase all animation components.
class AnimationDemoScreen extends StatefulWidget {
  const AnimationDemoScreen({super.key});

  @override
  State<AnimationDemoScreen> createState() => _AnimationDemoScreenState();
}

class _AnimationDemoScreenState extends State<AnimationDemoScreen> {
  double _progress = 0.0;
  bool _showConfetti = false;
  bool _showSkyDemo = false;
  bool _showStickerDemo = false;
  SkyTimeOfDay _skyTime = SkyTimeOfDay.day;

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
                // NEW: Section 0 - Interactive Sky Background
                _buildSectionTitle('0. AnimatedSkyBackground (動く空)'),
                const Text('雲が流れ、太陽をタップすると光が広がります'),
                const VGap.md(),
                Center(
                  child: SquishyButton(
                    onPressed: () => setState(() => _showSkyDemo = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF87CEEB), Color(0xFFB0E0E6)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        '🌤️ 空のデモを開く',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const VGap.xl(),

                // Section 1: BreathingWidget (Enhanced)
                _buildSectionTitle('1. BreathingWidget (呼吸アニメーション)'),
                const Text('強度が5段階になりました！'),
                const VGap.md(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildBreathingDemo('Subtle', BreathingIntensity.subtle),
                      const HGap.md(),
                      _buildBreathingDemo('Normal', BreathingIntensity.normal),
                      const HGap.md(),
                      _buildBreathingDemo('Pronounced', BreathingIntensity.pronounced),
                      const HGap.md(),
                      _buildBreathingDemo('Bouncy', BreathingIntensity.bouncy),
                      const HGap.md(),
                      _buildBreathingDemo('Dramatic', BreathingIntensity.dramatic),
                    ],
                  ),
                ),
                const VGap.xl(),

                // NEW: Section 1.5 - PeekABooCreature
                _buildSectionTitle('1.5. PeekABooCreature (ひょっこり動物)'),
                const Text('タップすると動物がひょっこり顔を出します'),
                const VGap.md(),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFF90EE90).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF228B22), width: 2),
                  ),
                  child: Stack(
                    children: [
                      // Ground/grass decoration
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 60,
                          decoration: const BoxDecoration(
                            color: Color(0xFF228B22),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(14),
                              bottomRight: Radius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      // Creatures
                      const Positioned(
                        bottom: 40,
                        left: 20,
                        child: PeekABooCreature(
                          type: CreatureType.bunny,
                          position: PeekPosition.bottomLeft,
                          autoPeek: true,
                          peekInterval: Duration(seconds: 5),
                        ),
                      ),
                      const Positioned(
                        bottom: 40,
                        right: 20,
                        child: PeekABooCreature(
                          type: CreatureType.squirrel,
                          position: PeekPosition.bottomRight,
                          autoPeek: true,
                          peekInterval: Duration(seconds: 7),
                        ),
                      ),
                      const Positioned(
                        top: 20,
                        right: 60,
                        child: PeekABooCreature(
                          type: CreatureType.bird,
                          position: PeekPosition.topRight,
                          autoPeek: true,
                          peekInterval: Duration(seconds: 6),
                          size: 50,
                        ),
                      ),
                      const Positioned(
                        top: 30,
                        left: 80,
                        child: PeekABooCreature(
                          type: CreatureType.owl,
                          position: PeekPosition.topLeft,
                          autoPeek: true,
                          peekInterval: Duration(seconds: 8),
                          size: 55,
                        ),
                      ),
                      // Instructions
                      const Center(
                        child: Text(
                          'タップしてみてね！\n(自動でも出てきます)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(color: Colors.black45, blurRadius: 4),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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

                // NEW: Section 9 - Flying Sticker
                _buildSectionTitle('9. FlyingSticker (飛ぶシール)'),
                const Text('シールが飛んでコレクションに入ります'),
                const VGap.md(),
                Center(
                  child: SquishyButton(
                    onPressed: () => setState(() => _showStickerDemo = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B6B), Color(0xFFFF9F43)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        '🌟 シールをゲット！',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const VGap.md(),
                // Sticker types preview
                SizedBox(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStickerPreview(StickerType.star),
                      _buildStickerPreview(StickerType.heart),
                      _buildStickerPreview(StickerType.flower),
                      _buildStickerPreview(StickerType.rainbow),
                      _buildStickerPreview(StickerType.crown),
                    ],
                  ),
                ),
                const VGap.xl(),

                // NEW: Section 10 - Rainbow Transition Demo
                _buildSectionTitle('10. RainbowWipe (虹遷移)'),
                const Text('画面遷移で虹が走ります'),
                const VGap.md(),
                Center(
                  child: SquishyButton(
                    onPressed: () {
                      context.push('/animation-demo/rainbow-demo');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF6B6B),
                            Color(0xFFFF9F43),
                            Color(0xFFFFD93D),
                            Color(0xFF6BCB77),
                            Color(0xFF4D96FF),
                            Color(0xFF9B59B6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        '🌈 虹遷移デモ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const VGap.xl(),

                // ===============================
                // Phase 4: マイクロインタラクション
                // ===============================

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.learningPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '🎵 Phase 4: マイクロインタラクション',
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.learningPrimary,
                    ),
                  ),
                ),
                const VGap.xl(),

                // Section 11: SeedGrowthEffect
                _buildSectionTitle('11. SeedGrowthEffect (種→花)'),
                const Text('タップすると種が花に成長します（正解演出）'),
                const VGap.md(),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildFlowerDemo('デイジー', FlowerType.daisy),
                    _buildFlowerDemo('ひまわり', FlowerType.sunflower),
                    _buildFlowerDemo('チューリップ', FlowerType.tulip),
                    _buildFlowerDemo('バラ', FlowerType.rose),
                    _buildFlowerDemo('さくら', FlowerType.sakura),
                  ],
                ),
                const VGap.xl(),

                // Section 12: MusicalTapWidget
                _buildSectionTitle('12. MusicalTapWidget (音階タップ)'),
                const Text('色をタップすると音符が表示されます'),
                const VGap.md(),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: MusicalColorRow(
                    buttonSize: 40,
                    onNoteTap: (note) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('♪ ${_noteToName(note)}'),
                          duration: const Duration(milliseconds: 400),
                        ),
                      );
                    },
                  ),
                ),
                const VGap.xl(),

                // Section 13: BouncyTapFeedback
                _buildSectionTitle('13. BouncyTapFeedback (バウンス)'),
                const Text('タップするとポヨンと弾みます'),
                const VGap.md(),
                Center(
                  child: BouncyTapFeedback(
                    bounceScale: 1.15,
                    onTap: () {
                      HapticHelper.tap();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.characterRabbit,
                            AppColors.characterRabbit.withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.characterRabbit.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Text(
                        '🐰 ポヨン！',
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

                // Section 14: RichTouchFeedback
                _buildSectionTitle('14. RichTouchFeedback (リッチタッチ)'),
                const Text('押すと縮小＋グロー効果'),
                const VGap.md(),
                Center(
                  child: RichTouchFeedback(
                    scaleDown: 0.92,
                    showGlow: true,
                    glowColor: AppColors.rewardGold,
                    hapticPattern: HapticPattern.medium,
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 24,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.rewardGold,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Text(
                        '✨ 押してみて',
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

          // Sky Demo overlay
          if (_showSkyDemo) _buildSkyDemoOverlay(),

          // Sticker Demo overlay
          if (_showStickerDemo) _buildStickerDemoOverlay(),
        ],
      ),
    );
  }

  Widget _buildSkyDemoOverlay() {
    return Positioned.fill(
      child: AnimatedSkyBackground(
        timeOfDay: _skyTime,
        enableInteraction: true,
        showStars: _skyTime == SkyTimeOfDay.night,
        onSunTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('☀️ 太陽をタップしました！'),
              duration: Duration(milliseconds: 800),
            ),
          );
        },
        onCloudTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('☁️ 雲をタップしました！'),
              duration: Duration(milliseconds: 800),
            ),
          );
        },
        child: SafeArea(
          child: Column(
            children: [
              // Close button and time controls
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SquishyButton(
                      onPressed: () => setState(() => _showSkyDemo = false),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.black54),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTimeButton('☀️', SkyTimeOfDay.day),
                          const SizedBox(width: 8),
                          _buildTimeButton('🌅', SkyTimeOfDay.sunset),
                          const SizedBox(width: 8),
                          _buildTimeButton('🌙', SkyTimeOfDay.night),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Instructions
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  '☁️ 雲が動いています\n☀️ 太陽をタップしてみて！\n🌙 時間帯を変えてみて！',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeButton(String emoji, SkyTimeOfDay time) {
    final isSelected = _skyTime == time;
    return GestureDetector(
      onTap: () => setState(() => _skyTime = time),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.learningPrimary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      ),
    );
  }

  Widget _buildStickerDemoOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => _showStickerDemo = false),
        child: Container(
          color: Colors.black54,
          child: Stack(
            children: [
              // Target position indicator
              Positioned(
                top: 50,
                right: 30,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.rewardGold, width: 3),
                  ),
                  alignment: Alignment.center,
                  child: const Text('📚', style: TextStyle(fontSize: 30)),
                ),
              ),
              // Flying stickers
              StickerCelebration(
                stickers: const [
                  AnimatedSticker(type: StickerType.star),
                  AnimatedSticker(type: StickerType.heart),
                  AnimatedSticker(type: StickerType.flower),
                  AnimatedSticker(type: StickerType.crown),
                  AnimatedSticker(type: StickerType.sparkle),
                ],
                collectionPosition: const Offset(
                  // Position near top-right (book icon)
                  360, // Approximate position
                  80,
                ),
                staggerDelay: const Duration(milliseconds: 200),
                onComplete: () {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (mounted) setState(() => _showStickerDemo = false);
                  });
                },
              ),
              // Instructions
              const Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'シールがコレクションに飛んでいきます！\nタップで閉じる',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.characterFox,
              borderRadius: BorderRadius.circular(35),
            ),
            alignment: Alignment.center,
            child: const Text('🦊', style: TextStyle(fontSize: 36)),
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

  Widget _buildStickerPreview(StickerType type) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(4),
      child: AnimatedSticker(type: type),
    );
  }

  Widget _buildFlowerDemo(String label, FlowerType type) {
    return SeedGrowthEffect(
      flowerType: type,
      onTap: () {
        HapticHelper.correct();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade200, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  String _noteToName(MusicalNote note) => switch (note) {
        MusicalNote.c4 => 'ド (C4)',
        MusicalNote.d4 => 'レ (D4)',
        MusicalNote.e4 => 'ミ (E4)',
        MusicalNote.f4 => 'ファ (F4)',
        MusicalNote.g4 => 'ソ (G4)',
        MusicalNote.a4 => 'ラ (A4)',
        MusicalNote.b4 => 'シ (B4)',
        MusicalNote.c5 => 'ド (C5)',
      };
}

/// Demo screen for rainbow transition
class RainbowDemoScreen extends StatelessWidget {
  const RainbowDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFE4E1),
              Color(0xFFFFF0F5),
              Color(0xFFE6E6FA),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🌈',
                  style: TextStyle(fontSize: 100),
                ),
                const SizedBox(height: 24),
                Text(
                  '虹遷移で到着！',
                  style: AppTypography.headlineLarge.copyWith(
                    color: AppColors.learningPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '戻るボタンを押すと\nまた虹遷移で戻ります',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 48),
                SquishyButton(
                  onPressed: () => context.pop(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF6B6B),
                          Color(0xFFFF9F43),
                          Color(0xFFFFD93D),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Text(
                      '🌈 戻る',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
