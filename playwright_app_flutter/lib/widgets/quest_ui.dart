import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shared building blocks for the spec-driven screens (sign-in, welcome).

/// Colours from the Playwright Quest design spec (sign-in and welcome).
abstract final class QuestColors {
  static const ink = Color(0xFF26224F);
  // The spec's muted #6e6a8f and faint #8a86a8 fall below 4.5:1 on the
  // lighter backgrounds; these are the nearest shades that pass everywhere.
  static const muted = Color(0xFF6B678C);
  static const faint = Color(0xFF6B6883);
  static const placeholder = Color(0xFF9A96B8);
  static const green = Color(0xFF1FAE5B);
  static const greenHover = Color(0xFF23C064);
  static const greenDark = Color(0xFF16804A);
  static const greenDeeper = Color(0xFF0F5E36);

  /// Dark green text on [paleGreen] (spec #16804a is 4.4:1 there).
  static const greenOnPale = Color(0xFF157C47);
  static const blue = Color(0xFF3D5FC4);
  static const blueDot = Color(0xFF5B7FE6);
  static const orange = Color(0xFFAF601E); // spec #b3621f, darkened for 4.5:1
  static const orangeDot = Color(0xFFE8903F);
  static const error = Color(0xFFD0473C);
  static const inputBorder = Color(0xFFE4E0F3);
  static const inputBg = Color(0xFFFBFAFF);
  static const paleGreen = Color(0xFFE3F5E9);
  static const lightGreen = Color(0xFF9FDCB7);
  static const orangeBg = Color(0xFFFBEEE0);
  static const blueBg = Color(0xFFE6ECFB);
  static const lavender = Color(0xFFF1EEFC);
  static const emptyTrack = Color(0xFFE4E0F3);
  static const divider = Color(0xFFEFEDF7);
}

TextStyle questBaloo(
  double size, {
  Color color = QuestColors.ink,
  double? height,
}) => GoogleFonts.baloo2(
  fontSize: size,
  fontWeight: FontWeight.w800,
  color: color,
  height: height,
);

TextStyle questNunito(
  double size, {
  FontWeight weight = FontWeight.w400,
  Color color = QuestColors.ink,
  double? height,
}) => GoogleFonts.nunito(
  fontSize: size,
  fontWeight: weight,
  color: color,
  height: height,
);

/// Big green pill with a solid "lip" shadow that presses down on tap.
/// It is never disabled or grey; it shows a spinner while busy.
class QuestButton extends StatefulWidget {
  const QuestButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool busy;

  @override
  State<QuestButton> createState() => _QuestButtonState();
}

class _QuestButtonState extends State<QuestButton> {
  bool _pressed = false;
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      child: FocusableActionDetector(
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        onShowHoverHighlight: (v) => setState(() => _hovered = v),
        mouseCursor: SystemMouseCursors.click,
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onPressed();
              return null;
            },
          ),
        },
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 90),
            height: 56,
            transform: Matrix4.translationValues(0, _pressed ? 3 : 0, 0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _hovered ? QuestColors.greenHover : QuestColors.green,
              borderRadius: BorderRadius.circular(99),
              border: _focused
                  ? Border.all(color: QuestColors.ink, width: 2.5)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: QuestColors.greenDark,
                  offset: Offset(0, _pressed ? 1 : 4),
                ),
              ],
            ),
            child: widget.busy
                ? const SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.6,
                      color: Colors.white,
                    ),
                  )
                : ExcludeSemantics(
                    child: Text(
                      widget.label,
                      style: questNunito(
                        17,
                        weight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// A text-only button with at least a 44px hit target.
class QuestLinkButton extends StatelessWidget {
  const QuestLinkButton({
    super.key,
    required this.label,
    required this.style,
    required this.onPressed,
  });

  final String label;
  final TextStyle style;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: const Size(44, 44),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        foregroundColor: style.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(label, style: style),
    );
  }
}

/// The spec's page background: green → lavender → cream.
class QuestBackground extends StatelessWidget {
  const QuestBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE6F4E8), Color(0xFFF6F3FB), Color(0xFFFDF6EE)],
          stops: [0, 0.55, 1],
        ),
      ),
      child: child,
    );
  }
}

/// The Playwright Quest app-icon tile, with a soft shadow so its pale edge
/// stays visible on the pale page backgrounds.
class QuestLogo extends StatelessWidget {
  const QuestLogo({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        // Matches the squircle corners baked into the image.
        borderRadius: BorderRadius.circular(size * 0.24),
        boxShadow: [
          BoxShadow(
            color: QuestColors.ink.withValues(alpha: 0.14),
            blurRadius: size * 0.18,
            offset: Offset(0, size * 0.06),
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/logo.png',
        width: size,
        height: size,
        semanticLabel: 'Playwright Quest logo',
      ),
    );
  }
}
