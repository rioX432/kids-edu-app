import 'package:flutter/material.dart';

/// Spacing and sizing tokens for kids educational apps.
///
/// Design principles:
/// - Large touch targets (minimum 48dp, prefer 64dp+)
/// - Generous padding for kid-friendly interaction
/// - Rounded, friendly shapes
///
/// Usage:
/// ```dart
/// Padding(padding: AppSpacing.insetMd)
/// Container(
///   decoration: BoxDecoration(
///     borderRadius: AppSpacing.radiusLg,
///   ),
/// )
/// ```
abstract final class AppSpacing {
  // ============================================
  // Spacing Scale (4px base)
  // ============================================

  /// 4px - Minimal spacing
  static const double xs = 4.0;

  /// 8px - Tight spacing
  static const double sm = 8.0;

  /// 16px - Default spacing
  static const double md = 16.0;

  /// 24px - Comfortable spacing
  static const double lg = 24.0;

  /// 32px - Generous spacing
  static const double xl = 32.0;

  /// 48px - Section spacing
  static const double xxl = 48.0;

  /// 64px - Large section spacing
  static const double xxxl = 64.0;

  // ============================================
  // EdgeInsets Presets
  // ============================================

  /// All sides xs (4px)
  static const EdgeInsets insetXs = EdgeInsets.all(xs);

  /// All sides sm (8px)
  static const EdgeInsets insetSm = EdgeInsets.all(sm);

  /// All sides md (16px)
  static const EdgeInsets insetMd = EdgeInsets.all(md);

  /// All sides lg (24px)
  static const EdgeInsets insetLg = EdgeInsets.all(lg);

  /// All sides xl (32px)
  static const EdgeInsets insetXl = EdgeInsets.all(xl);

  /// Horizontal md (16px)
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);

  /// Horizontal lg (24px)
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);

  /// Vertical md (16px)
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);

  /// Vertical lg (24px)
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);

  /// Screen padding (horizontal lg, vertical md)
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  /// Card padding (lg all around)
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);

  /// Button padding (horizontal xl, vertical md)
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: md,
  );

  // ============================================
  // Border Radius (Rounded, Friendly)
  // ============================================

  /// Small radius (8px)
  static const double radiusSmValue = 8.0;

  /// Medium radius (12px)
  static const double radiusMdValue = 12.0;

  /// Large radius (16px)
  static const double radiusLgValue = 16.0;

  /// Extra large radius (24px)
  static const double radiusXlValue = 24.0;

  /// Extra extra large radius (32px)
  static const double radiusXxlValue = 32.0;

  /// Full circle
  static const double radiusFullValue = 999.0;

  /// Small border radius
  static const BorderRadius radiusSm = BorderRadius.all(
    Radius.circular(radiusSmValue),
  );

  /// Medium border radius
  static const BorderRadius radiusMd = BorderRadius.all(
    Radius.circular(radiusMdValue),
  );

  /// Large border radius
  static const BorderRadius radiusLg = BorderRadius.all(
    Radius.circular(radiusLgValue),
  );

  /// Extra large border radius
  static const BorderRadius radiusXl = BorderRadius.all(
    Radius.circular(radiusXlValue),
  );

  /// Extra extra large border radius
  static const BorderRadius radiusXxl = BorderRadius.all(
    Radius.circular(radiusXxlValue),
  );

  /// Full circular border radius
  static const BorderRadius radiusFull = BorderRadius.all(
    Radius.circular(radiusFullValue),
  );

  // ============================================
  // Touch Target Sizes
  // ============================================

  /// Minimum touch target (48px) - WCAG minimum
  static const double touchTargetMin = 48.0;

  /// Preferred touch target (64px) - Kid-friendly
  static const double touchTargetPreferred = 64.0;

  /// Large touch target (80px) - Primary actions
  static const double touchTargetLarge = 80.0;

  /// Extra large touch target (96px) - Main CTA
  static const double touchTargetXl = 96.0;

  // ============================================
  // Component Sizes
  // ============================================

  /// Small avatar (48px)
  static const double avatarSm = 48.0;

  /// Medium avatar (64px)
  static const double avatarMd = 64.0;

  /// Large avatar (96px)
  static const double avatarLg = 96.0;

  /// Extra large avatar (128px)
  static const double avatarXl = 128.0;

  /// Icon size small (24px)
  static const double iconSm = 24.0;

  /// Icon size medium (32px)
  static const double iconMd = 32.0;

  /// Icon size large (48px)
  static const double iconLg = 48.0;

  /// Icon size extra large (64px)
  static const double iconXl = 64.0;

  // ============================================
  // Animation Durations
  // ============================================

  /// Fast animation (150ms)
  static const Duration durationFast = Duration(milliseconds: 150);

  /// Normal animation (300ms)
  static const Duration durationNormal = Duration(milliseconds: 300);

  /// Slow animation (500ms)
  static const Duration durationSlow = Duration(milliseconds: 500);

  /// Very slow animation (800ms) - Celebrations
  static const Duration durationVerySlow = Duration(milliseconds: 800);

  // ============================================
  // Extended Animation Durations (Kids UI/UX)
  // ============================================

  /// Celebration/reward animations (1200ms)
  static const Duration durationCelebration = Duration(milliseconds: 1200);

  /// Page transition animations (400ms)
  static const Duration durationTransition = Duration(milliseconds: 400);

  /// Spring/physics-based animations (600ms)
  static const Duration durationSpring = Duration(milliseconds: 600);

  /// Bounce animations (450ms)
  static const Duration durationBounce = Duration(milliseconds: 450);

  /// Breathing/idle animations (3 seconds)
  static const Duration durationBreathing = Duration(seconds: 3);

  /// Idle wiggle animations (5 seconds delay)
  static const Duration durationIdle = Duration(seconds: 5);

  // ============================================
  // Kids-Specific Touch Targets
  // ============================================

  /// Kids touch target (64px) - Larger than WCAG minimum
  static const double touchTargetKids = 64.0;

  /// Kids large touch target (80px) - Primary actions
  static const double touchTargetKidsLarge = 80.0;
}

/// Gap widget for consistent spacing
class Gap extends StatelessWidget {
  const Gap(this.size, {super.key});

  /// Extra small gap (4px)
  const Gap.xs({super.key}) : size = AppSpacing.xs;

  /// Small gap (8px)
  const Gap.sm({super.key}) : size = AppSpacing.sm;

  /// Medium gap (16px)
  const Gap.md({super.key}) : size = AppSpacing.md;

  /// Large gap (24px)
  const Gap.lg({super.key}) : size = AppSpacing.lg;

  /// Extra large gap (32px)
  const Gap.xl({super.key}) : size = AppSpacing.xl;

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size);
  }
}

/// Horizontal gap widget
class HGap extends StatelessWidget {
  const HGap(this.size, {super.key});

  const HGap.xs({super.key}) : size = AppSpacing.xs;
  const HGap.sm({super.key}) : size = AppSpacing.sm;
  const HGap.md({super.key}) : size = AppSpacing.md;
  const HGap.lg({super.key}) : size = AppSpacing.lg;
  const HGap.xl({super.key}) : size = AppSpacing.xl;

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(width: size);
}

/// Vertical gap widget
class VGap extends StatelessWidget {
  const VGap(this.size, {super.key});

  const VGap.xs({super.key}) : size = AppSpacing.xs;
  const VGap.sm({super.key}) : size = AppSpacing.sm;
  const VGap.md({super.key}) : size = AppSpacing.md;
  const VGap.lg({super.key}) : size = AppSpacing.lg;
  const VGap.xl({super.key}) : size = AppSpacing.xl;

  final double size;

  @override
  Widget build(BuildContext context) => SizedBox(height: size);
}
