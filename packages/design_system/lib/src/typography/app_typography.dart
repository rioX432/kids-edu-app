import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography tokens for kids educational apps.
///
/// Font choices:
/// - **Display**: M PLUS Rounded 1c - Rounded, playful, Japanese-friendly
/// - **Body**: Noto Sans JP - Clean, readable, full Japanese support
///
/// Usage:
/// ```dart
/// Text('Hello', style: AppTypography.heading1)
/// ```
abstract final class AppTypography {
  // ============================================
  // Font Families
  // ============================================

  /// Display font for headings and playful UI
  /// M PLUS Rounded 1c: Rounded, friendly, full Japanese support
  static TextStyle get _displayBase => GoogleFonts.mPlusRounded1c();

  /// Body font for readable content
  /// Noto Sans JP: Clean, comprehensive Japanese support
  static TextStyle get _bodyBase => GoogleFonts.notoSansJp();

  // ============================================
  // Display Styles (Headings, Titles)
  // ============================================

  /// Heading 1 - App titles, onboarding screens
  /// Size: 60px (3.75rem equivalent)
  static TextStyle get heading1 => _displayBase.copyWith(
        fontSize: 60,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  /// Heading 2 - Section titles, activity titles
  /// Size: 48px (3rem equivalent)
  static TextStyle get heading2 => _displayBase.copyWith(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  /// Heading 3 - Question text, story titles
  /// Size: 36px (2.25rem equivalent)
  static TextStyle get heading3 => _displayBase.copyWith(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  /// Heading 4 - Sub-sections
  /// Size: 28px
  static TextStyle get heading4 => _displayBase.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  // ============================================
  // Body Styles (Readable Content)
  // ============================================

  /// Large body text - Button labels, choice options
  /// Size: 24px (1.5rem equivalent)
  static TextStyle get bodyLarge => _bodyBase.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  /// Regular body text - Story content, descriptions
  /// Size: 20px
  static TextStyle get body => _bodyBase.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        height: 1.6,
      );

  /// Small text - Hints, helper text (use sparingly)
  /// Size: 16px
  static TextStyle get bodySmall => _bodyBase.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  // ============================================
  // Special Styles
  // ============================================

  /// Button text - Large touch targets
  static TextStyle get button => _displayBase.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  /// Choice button text
  static TextStyle get choice => _displayBase.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  /// Character speech bubble text
  static TextStyle get speech => _bodyBase.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  /// Story narration text (picture book)
  static TextStyle get narration => _bodyBase.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.w400,
        height: 1.7,
        letterSpacing: 0.5,
      );

  /// Progress/counter text
  static TextStyle get counter => _displayBase.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.0,
      );

  // ============================================
  // Utility Methods
  // ============================================

  /// Apply color to a text style
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Get TextTheme for Material Design integration
  static TextTheme get textTheme => TextTheme(
        displayLarge: heading1,
        displayMedium: heading2,
        displaySmall: heading3,
        headlineMedium: heading4,
        titleLarge: bodyLarge,
        bodyLarge: body,
        bodyMedium: bodySmall,
        labelLarge: button,
      );
}

/// Extension for easy text styling
extension TextStyleX on TextStyle {
  /// Apply a color to this text style
  TextStyle colored(Color color) => copyWith(color: color);

  /// Make text bold
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);

  /// Make text semi-bold
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  /// Make text medium weight
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
}
