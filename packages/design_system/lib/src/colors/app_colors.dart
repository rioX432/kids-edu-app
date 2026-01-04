import 'package:flutter/material.dart';

/// Color tokens for kids educational apps.
///
/// Usage:
/// ```dart
/// Container(color: AppColors.learningPrimary)
/// ```
abstract final class AppColors {
  // ============================================
  // Base Colors - Light Mode
  // ============================================

  /// Main background color (warm white)
  static const Color backgroundLight = Color(0xFFFFFBF5);

  /// Surface color for cards, modals (pure white)
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// Primary text color
  static const Color textPrimaryLight = Color(0xFF2D2D2D);

  /// Secondary text color
  static const Color textSecondaryLight = Color(0xFF6B6B6B);

  /// Disabled/placeholder text color
  static const Color textDisabledLight = Color(0xFFD1D1D1);

  // ============================================
  // Base Colors - Dark Mode
  // ============================================

  /// Dark mode background
  static const Color backgroundDark = Color(0xFF1A1C2E);

  /// Dark mode surface
  static const Color surfaceDark = Color(0xFF252841);

  /// Dark mode primary text
  static const Color textPrimaryDark = Color(0xFFF5F5F5);

  /// Dark mode secondary text
  static const Color textSecondaryDark = Color(0xFFB8B8B8);

  /// Dark mode disabled text
  static const Color textDisabledDark = Color(0xFF4A4A5A);

  // ============================================
  // Learning App Colors - Energetic & Cheerful
  // ============================================

  /// Learning app primary accent (orange)
  static const Color learningPrimary = Color(0xFFFF8C42);

  /// Learning app secondary accent (yellow)
  static const Color learningSecondary = Color(0xFFFFD93D);

  /// Learning app tertiary accent (pink)
  static const Color learningTertiary = Color(0xFFFF6B9D);

  /// Learning app gradient
  static const LinearGradient learningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [learningSecondary, learningPrimary],
  );

  // ============================================
  // Picture Book App Colors - Calm & Relaxing
  // ============================================

  /// Picture book app primary accent (purple)
  static const Color bookPrimary = Color(0xFF7B68EE);

  /// Picture book app secondary accent (blue)
  static const Color bookSecondary = Color(0xFF4A90E2);

  /// Picture book app tertiary accent (lavender)
  static const Color bookTertiary = Color(0xFF9B8FD9);

  /// Picture book app gradient
  static const LinearGradient bookGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bookTertiary, bookPrimary],
  );

  // ============================================
  // Picture Book Night Mode
  // ============================================

  /// Night mode primary (dimmed purple)
  static const Color bookNightPrimary = Color(0xFF5B4DB8);

  /// Night mode secondary (dimmed blue)
  static const Color bookNightSecondary = Color(0xFF3A6FA8);

  /// Night mode background (very dark)
  static const Color bookNightBackground = Color(0xFF0F1119);

  /// Night mode surface
  static const Color bookNightSurface = Color(0xFF1C1E2E);

  /// Night mode text
  static const Color bookNightText = Color(0xFFE8E8F0);

  // ============================================
  // Night Mode Aliases (for picture book app)
  // ============================================

  /// Night mode background alias
  static const Color nightBackground = bookNightBackground;

  /// Night mode surface alias
  static const Color nightSurface = bookNightSurface;

  /// Night mode accent
  static const Color nightAccent = bookNightPrimary;

  /// Night mode primary text
  static const Color nightTextPrimary = bookNightText;

  /// Night mode secondary text
  static const Color nightTextSecondary = Color(0xFFB0B0C0);

  /// Picture book accent alias
  static const Color pictureBookAccent = bookPrimary;

  // ============================================
  // Reward Colors
  // ============================================

  /// Gold color for rewards/stars
  static const Color rewardGold = Color(0xFFFFD700);

  /// Silver color for rewards
  static const Color rewardSilver = Color(0xFFC0C0C0);

  // ============================================
  // Character Type Colors
  // ============================================

  /// Fox character color
  static const Color characterFox = Color(0xFFFF9F6E);

  /// Bear character color
  static const Color characterBear = Color(0xFF8B4513);

  /// Rabbit character color
  static const Color characterRabbit = Color(0xFFFFB6C1);

  /// Penguin character color
  static const Color characterPenguin = Color(0xFF4A90E2);

  /// Cat character color
  static const Color characterCat = Color(0xFFFFD93D);

  /// Dog character color
  static const Color characterDog = Color(0xFFC9A0DC);

  // ============================================
  // Semantic Colors
  // ============================================

  /// Success/correct answer (celebratory green)
  static const Color success = Color(0xFF6BCF7E);

  /// Success darker variant
  static const Color successDark = Color(0xFF4CAF50);

  /// Error/incorrect (gentle pink - not scary)
  static const Color errorGentle = Color(0xFFFFB3BA);

  /// Error border
  static const Color errorBorder = Color(0xFFFF8A80);

  // ============================================
  // Character Colors
  // ============================================

  /// Character color 1 (warm orange)
  static const Color character1 = Color(0xFFFF9F6E);

  /// Character color 2 (sky blue)
  static const Color character2 = Color(0xFF7EC8E3);

  /// Character color 3 (sunny yellow)
  static const Color character3 = Color(0xFFFFD66E);

  /// Character color 4 (soft purple)
  static const Color character4 = Color(0xFFC9A0DC);

  /// List of all character colors for selection
  static const List<Color> characterColors = [
    character1,
    character2,
    character3,
    character4,
  ];
}

/// Extension to provide easy access to color schemes
extension AppColorScheme on BuildContext {
  /// Get learning app color scheme
  LearningColorScheme get learningColors => const LearningColorScheme();

  /// Get picture book app color scheme
  BookColorScheme get bookColors => const BookColorScheme();
}

/// Color scheme for Learning App
class LearningColorScheme {
  const LearningColorScheme();

  Color get primary => AppColors.learningPrimary;
  Color get secondary => AppColors.learningSecondary;
  Color get tertiary => AppColors.learningTertiary;
  LinearGradient get gradient => AppColors.learningGradient;
}

/// Color scheme for Picture Book App
class BookColorScheme {
  const BookColorScheme({this.isNightMode = false});

  final bool isNightMode;

  Color get primary =>
      isNightMode ? AppColors.bookNightPrimary : AppColors.bookPrimary;
  Color get secondary =>
      isNightMode ? AppColors.bookNightSecondary : AppColors.bookSecondary;
  Color get background =>
      isNightMode ? AppColors.bookNightBackground : AppColors.backgroundLight;
  Color get surface =>
      isNightMode ? AppColors.bookNightSurface : AppColors.surfaceLight;
  Color get text =>
      isNightMode ? AppColors.bookNightText : AppColors.textPrimaryLight;
  LinearGradient get gradient => AppColors.bookGradient;
}
