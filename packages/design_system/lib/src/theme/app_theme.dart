import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../typography/app_typography.dart';
import '../spacing/app_spacing.dart';

/// App type for theme selection
enum AppType {
  /// Learning app - Energetic, cheerful theme
  learning,

  /// Picture book app - Calm, relaxing theme
  pictureBook,
}

/// Theme configuration for kids educational apps.
///
/// Usage:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.learning(),
///   // or
///   theme: AppTheme.pictureBook(),
///   // or for night mode
///   theme: AppTheme.pictureBook(nightMode: true),
/// )
/// ```
abstract final class AppTheme {
  /// Learning app theme (energetic, cheerful)
  static ThemeData learning() {
    return _buildTheme(
      primary: AppColors.learningPrimary,
      secondary: AppColors.learningSecondary,
      tertiary: AppColors.learningTertiary,
      background: AppColors.backgroundLight,
      surface: AppColors.surfaceLight,
      textPrimary: AppColors.textPrimaryLight,
      textSecondary: AppColors.textSecondaryLight,
      brightness: Brightness.light,
    );
  }

  /// Picture book app theme (calm, relaxing)
  static ThemeData pictureBook({bool nightMode = false}) {
    if (nightMode) {
      return _buildTheme(
        primary: AppColors.bookNightPrimary,
        secondary: AppColors.bookNightSecondary,
        tertiary: AppColors.bookTertiary,
        background: AppColors.bookNightBackground,
        surface: AppColors.bookNightSurface,
        textPrimary: AppColors.bookNightText,
        textSecondary: AppColors.textSecondaryDark,
        brightness: Brightness.dark,
      );
    }

    return _buildTheme(
      primary: AppColors.bookPrimary,
      secondary: AppColors.bookSecondary,
      tertiary: AppColors.bookTertiary,
      background: AppColors.backgroundLight,
      surface: AppColors.surfaceLight,
      textPrimary: AppColors.textPrimaryLight,
      textSecondary: AppColors.textSecondaryLight,
      brightness: Brightness.light,
    );
  }

  /// Build theme with given colors
  static ThemeData _buildTheme({
    required Color primary,
    required Color secondary,
    required Color tertiary,
    required Color background,
    required Color surface,
    required Color textPrimary,
    required Color textSecondary,
    required Brightness brightness,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: Colors.white,
      secondary: secondary,
      onSecondary: textPrimary,
      tertiary: tertiary,
      onTertiary: Colors.white,
      error: AppColors.errorGentle,
      onError: textPrimary,
      surface: surface,
      onSurface: textPrimary,
      surfaceContainerHighest: background,
      outline: AppColors.textDisabledLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,

      // Typography
      textTheme: AppTypography.textTheme.apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.heading4.copyWith(color: textPrimary),
      ),

      // Card
      cardTheme: CardThemeData(
        color: surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.radiusXl,
        ),
        margin: AppSpacing.insetMd,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          textStyle: AppTypography.button,
          padding: AppSpacing.buttonPadding,
          minimumSize: const Size(
            AppSpacing.touchTargetPreferred,
            AppSpacing.touchTargetPreferred,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.radiusXl,
          ),
          elevation: 2,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: AppTypography.button,
          padding: AppSpacing.buttonPadding,
          minimumSize: const Size(
            AppSpacing.touchTargetMin,
            AppSpacing.touchTargetMin,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.radiusLg,
          ),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          textStyle: AppTypography.button,
          padding: AppSpacing.buttonPadding,
          minimumSize: const Size(
            AppSpacing.touchTargetPreferred,
            AppSpacing.touchTargetPreferred,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppSpacing.radiusXl,
          ),
          side: BorderSide(color: primary, width: 3),
        ),
      ),

      // Icon Button
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size(
            AppSpacing.touchTargetPreferred,
            AppSpacing.touchTargetPreferred,
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.radiusXl,
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.radiusXl,
        ),
        titleTextStyle: AppTypography.heading3.copyWith(color: textPrimary),
        contentTextStyle: AppTypography.body.copyWith(color: textSecondary),
      ),

      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXlValue),
          ),
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: textPrimary,
        contentTextStyle: AppTypography.body.copyWith(color: surface),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.radiusLg,
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Progress Indicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: AppColors.textDisabledLight,
        circularTrackColor: AppColors.textDisabledLight,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.textDisabledLight,
        thickness: 1,
        space: AppSpacing.md,
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: AppSpacing.radiusLg,
          borderSide: BorderSide(color: AppColors.textDisabledLight, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSpacing.radiusLg,
          borderSide: BorderSide(color: AppColors.textDisabledLight, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSpacing.radiusLg,
          borderSide: BorderSide(color: primary, width: 3),
        ),
        contentPadding: AppSpacing.insetLg,
        labelStyle: AppTypography.bodySmall.copyWith(color: textSecondary),
        hintStyle: AppTypography.body.copyWith(color: textSecondary),
      ),

      // Page transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

/// Extension to access app-specific theme properties
extension AppThemeExtension on ThemeData {
  /// Get the semantic success color
  Color get successColor => AppColors.success;

  /// Get the semantic error color (gentle)
  Color get errorGentleColor => AppColors.errorGentle;

  /// Get character colors
  List<Color> get characterColors => AppColors.characterColors;
}
