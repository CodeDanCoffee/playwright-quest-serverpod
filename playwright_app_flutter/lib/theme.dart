import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A bright, happy palette: white cards on warm paper with candy accents.
abstract final class Stage {
  // Neutrals
  static const paper = Color(0xFFFFFAF2);
  static const card = Colors.white;
  static const cardTint = Color(0xFFF3EFFD);
  static const line = Color(0xFFE7E1F3);
  static const text = Color(0xFF2A2350);
  static const textMuted = Color(0xFF6F6893);

  /// Text and icons on top of a bright accent fill.
  static const onAccent = Colors.white;

  // Candy accents
  static const green = Color(0xFF1FAF5A); // Playwright green
  static const blue = Color(0xFF2F86F6);
  static const orange = Color(0xFFFF8A1F);
  static const violet = Color(0xFF8C5CF6);
  static const pink = Color(0xFFFF5C8A);
  static const coral = Color(0xFFF2545B);

  /// Sunny yellow for stars and XP fills. Use [goldText] for text.
  static const gold = Color(0xFFFFC23D);
  static const goldText = Color(0xFFB36B00);

  static const correct = green;
  static const wrong = coral;

  /// Each tier (act) has its own colour.
  static Color tierAccent(String tierId) => switch (tierId) {
    'beginner' => green,
    'intermediate' => blue,
    'advanced' => orange,
    'expert' => violet,
    _ => pink,
  };

  /// A cheerful two-colour gradient partner for each tier's accent.
  static Color tierPartner(String tierId) => switch (tierId) {
    'beginner' => const Color(0xFF14B8A6), // teal
    'intermediate' => violet,
    'advanced' => pink,
    'expert' => pink,
    _ => violet,
  };

  /// A darker shade of [color] that stays readable as text on white.
  static Color deep(Color color) => Color.lerp(color, text, 0.3)!;

  static TextStyle display(double size, {Color color = text}) =>
      GoogleFonts.baloo2(
        fontSize: size,
        fontWeight: FontWeight.w700,
        height: 1.15,
        color: color,
        letterSpacing: -0.2,
      );

  static TextStyle body(
    double size, {
    Color color = text,
    FontWeight weight = FontWeight.w500,
  }) => GoogleFonts.nunito(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: 1.4,
  );

  /// Small uppercase label, like a ticket stub.
  static TextStyle label({Color color = textMuted, double size = 11}) =>
      GoogleFonts.nunito(
        fontSize: size,
        fontWeight: FontWeight.w800,
        letterSpacing: 2.2,
        color: color,
      );

  static TextStyle code(double size, {Color color = text}) =>
      GoogleFonts.jetBrainsMono(fontSize: size, color: color, height: 1.5);
}

ThemeData buildStageTheme() {
  final base = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Stage.green,
      brightness: Brightness.light,
      surface: Stage.card,
      primary: Stage.green,
      secondary: Stage.blue,
      error: Stage.coral,
    ),
    scaffoldBackgroundColor: Stage.paper,
  );
  return base.copyWith(
    textTheme: GoogleFonts.nunitoTextTheme(
      base.textTheme,
    ).apply(bodyColor: Stage.text, displayColor: Stage.text),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Stage.text,
      contentTextStyle: Stage.body(14, color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
