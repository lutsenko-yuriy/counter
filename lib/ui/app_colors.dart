import 'package:flutter/painting.dart';

/// Centralized color palette derived from the mechanical tally counter design.
class AppColors {
  AppColors._();

  /// Cream — scaffold background, app bar (Material), display inner.
  static const cream = Color(0xFFF5F0E0);

  /// Slightly lighter cream — card and counter row backgrounds.
  static const cardCream = Color(0xFFFAF6ED);

  /// Metallic silver — Cupertino nav bar background, tally counter body.
  static const silver = Color(0xFFB0B0B0);

  /// Steel — FAB background, secondary icons, add-counter button.
  static const steel = Color(0xFF888888);

  /// Dark steel — primary color, +/- buttons.
  static const darkSteel = Color(0xFF666666);

  /// Near black — primary text.
  static const textPrimary = Color(0xFF222222);

  /// Dark grey — app bar foreground, secondary text.
  static const textSecondary = Color(0xFF333333);

  /// Medium grey — muted labels, hints.
  static const textMuted = Color(0xFF555555);

  /// Cupertino action text color.
  static const cupertinoAction = Color(0xFF444444);
}
