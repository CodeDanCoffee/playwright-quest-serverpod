import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// A bright page with soft colour blobs and a sprinkle of confetti dots.
///
/// [spotlight] tints the main blob, so each screen can take on the colour
/// of the current act.
class StageBackdrop extends StatelessWidget {
  const StageBackdrop({
    super.key,
    required this.child,
    this.spotlight = Stage.green,
    this.spotlightAlignment = const Alignment(-0.6, -1.1),
  });

  final Widget child;
  final Color spotlight;
  final Alignment spotlightAlignment;

  @override
  Widget build(BuildContext context) {
    Widget blob(Color color, Alignment at, double radius, double alpha) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: at,
            radius: radius,
            colors: [
              color.withValues(alpha: alpha),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Stage.paper),
        blob(spotlight, spotlightAlignment, 1.1, 0.22),
        blob(Stage.pink, const Alignment(1.2, 0.2), 0.8, 0.10),
        blob(Stage.blue, const Alignment(-1.2, 1.1), 0.9, 0.10),
        const RepaintBoundary(child: CustomPaint(painter: _ConfettiDots())),
        child,
      ],
    );
  }
}

class _ConfettiDots extends CustomPainter {
  const _ConfettiDots();

  static const _colors = [
    Stage.green,
    Stage.blue,
    Stage.orange,
    Stage.violet,
    Stage.pink,
    Stage.gold,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(7);
    final paint = Paint();
    final count = (size.width * size.height / 14000).clamp(0, 160).toInt();
    for (var i = 0; i < count; i++) {
      paint.color = _colors[i % _colors.length].withValues(alpha: 0.18);
      canvas.drawCircle(
        Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
        rnd.nextDouble() * 2.5 + 1.5,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Centres content in a phone-width column, so the app also looks right on
/// tablets and desktop browsers.
class PhoneColumn extends StatelessWidget {
  const PhoneColumn({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: child,
      ),
    );
  }
}

/// Scales down slightly while pressed, for a tactile feel.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticLabel,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: enabled ? (_) => setState(() => _down = true) : null,
          onTapUp: enabled ? (_) => setState(() => _down = false) : null,
          onTapCancel: enabled ? () => setState(() => _down = false) : null,
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _down ? 0.96 : 1,
            duration: const Duration(milliseconds: 110),
            curve: Curves.easeOut,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// A chunky, bright call-to-action button with a hard offset shadow.
class SpotlightButton extends StatelessWidget {
  const SpotlightButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = Stage.green,
    this.icon,
    this.busy = false,
  });

  final String label;
  final VoidCallback? onTap;
  final Color color;
  final IconData? icon;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null && !busy;
    return Pressable(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: enabled || busy ? 1 : 0.45,
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Color.lerp(color, Stage.text, 0.35)!,
                offset: const Offset(0, 5),
              ),
              BoxShadow(
                color: color.withValues(alpha: 0.35),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: busy
              ? const SizedBox.square(
                  dimension: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Stage.onAccent,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: Stage.body(
                        17,
                        color: Stage.onAccent,
                        weight: FontWeight.w800,
                      ),
                    ),
                    if (icon != null) ...[
                      const SizedBox(width: 8),
                      Icon(icon, color: Stage.onAccent, size: 20),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

/// Up to three stars, filled according to [stars].
class StarRow extends StatelessWidget {
  const StarRow({super.key, required this.stars, this.size = 16});

  final int stars;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$stars of 3 stars',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 3; i++)
            Icon(
              i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
              size: size,
              color: i < stars ? Stage.gold : Stage.line,
            ),
        ],
      ),
    );
  }
}

/// A solid, pill-shaped tag.
class Tag extends StatelessWidget {
  const Tag(this.text, {super.key, this.color = Stage.textMuted, this.icon});

  final String text;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: Stage.onAccent),
            const SizedBox(width: 5),
          ],
          Text(
            text.toUpperCase(),
            style: Stage.label(color: Stage.onAccent, size: 10),
          ),
        ],
      ),
    );
  }
}
