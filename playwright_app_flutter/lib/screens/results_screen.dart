import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:playwright_app_client/playwright_app_client.dart';

import '../game/game_controller.dart';
import '../theme.dart';
import '../widgets/code_block.dart';
import '../widgets/stage.dart';
import 'home_screen.dart';
import 'quiz_screen.dart';

/// The curtain call: stars, XP and a review of every answer.
class ResultsScreen extends StatefulWidget {
  const ResultsScreen({
    super.key,
    required this.lesson,
    required this.result,
    required this.answers,
  });

  final Lesson lesson;
  final LessonResult result;
  final List<int> answers;

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with SingleTickerProviderStateMixin {
  late final _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..forward();

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  String get _headline => switch (widget.result.stars) {
    3 => 'Standing ovation!',
    2 => 'Great performance!',
    1 => 'Scene passed!',
    _ => 'Rehearsal needed',
  };

  String get _subline => switch (widget.result.stars) {
    3 => 'A perfect score. You really know this scene.',
    2 => 'Almost flawless. Replay for the third star.',
    1 => 'You passed. Review the misses below to level up.',
    _ => 'Score 60% or more to pass. Read the explanations and try again!',
  };

  @override
  Widget build(BuildContext context) {
    final r = widget.result;
    final game = GameScope.of(context);
    final accent = Stage.tierAccent(widget.lesson.tierId);
    final unlocked = r.unlockedLessonId == null
        ? null
        : game.allLessons.where((l) => l.id == r.unlockedLessonId).firstOrNull;
    final passed = r.stars > 0;

    return Scaffold(
      body: StageBackdrop(
        spotlight: passed ? Stage.gold : Stage.coral,
        spotlightAlignment: const Alignment(0, -1),
        child: Stack(
          children: [
            if (passed)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _intro,
                    builder: (_, _) => CustomPaint(
                      painter: _ConfettiPainter(progress: _intro.value),
                    ),
                  ),
                ),
              ),
            SafeArea(
              child: PhoneColumn(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
                  children: [
                    _AnimatedStars(stars: r.stars, controller: _intro),
                    const SizedBox(height: 18),
                    Text(
                      _headline,
                      style: Stage.display(36),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _subline,
                      style: Stage.body(15, color: Stage.textMuted),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        _ScoreTile(
                          label: 'Correct',
                          value: '${r.correct}/${r.total}',
                          color: accent,
                        ),
                        const SizedBox(width: 10),
                        _ScoreTile(
                          label: 'XP earned',
                          value: '+${r.xpEarned}',
                          color: Stage.gold,
                        ),
                        const SizedBox(width: 10),
                        _ScoreTile(
                          label: 'Streak',
                          value: '${r.stats.currentStreak}🔥',
                          color: Stage.coral,
                        ),
                      ],
                    ),
                    if (r.isNewBest && r.stars > 0 && r.xpEarned > 0) ...[
                      const SizedBox(height: 12),
                      Center(
                        child: Tag(
                          'New personal best',
                          color: Stage.orange,
                          icon: Icons.emoji_events_rounded,
                        ),
                      ),
                    ],
                    if (unlocked != null) ...[
                      const SizedBox(height: 18),
                      _UnlockBanner(lesson: unlocked, game: game),
                    ],
                    const SizedBox(height: 22),
                    if (unlocked != null)
                      SpotlightButton(
                        label: 'Next scene: ${unlocked.title}',
                        icon: Icons.arrow_forward_rounded,
                        color: Stage.tierAccent(unlocked.tierId),
                        onTap: () => Navigator.of(
                          context,
                        ).pushReplacement(lessonRoute(unlocked)),
                      )
                    else
                      SpotlightButton(
                        label: 'Back to the map',
                        icon: Icons.map_rounded,
                        color: accent,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => QuizScreen(lesson: widget.lesson),
                        ),
                      ),
                      icon: const Icon(Icons.replay_rounded),
                      label: const Text('Play again'),
                      style: TextButton.styleFrom(
                        foregroundColor: Stage.text,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 26),
                    Text('📝  REVIEW YOUR ANSWERS', style: Stage.label()),
                    const SizedBox(height: 10),
                    for (final (i, q) in widget.lesson.questions!.indexed)
                      _ReviewTile(
                        number: i + 1,
                        question: q,
                        chosen: widget.answers[i],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedStars extends StatelessWidget {
  const _AnimatedStars({required this.stars, required this.controller});

  final int stars;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < 3; i++)
            AnimatedBuilder(
              animation: controller,
              builder: (_, _) {
                final start = 0.1 + i * 0.18;
                final t = Curves.elasticOut.transform(
                  ((controller.value - start) / 0.45).clamp(0.0, 1.0),
                );
                final earned = i < stars;
                return Padding(
                  padding: EdgeInsets.only(bottom: i == 1 ? 22 : 0),
                  child: Transform.rotate(
                    angle: (i - 1) * 0.25,
                    child: Transform.scale(
                      scale: earned ? t : 1,
                      child: Icon(
                        earned
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: i == 1 ? 92 : 72,
                        color: earned ? Stage.gold : Stage.line,
                        shadows: earned
                            ? [
                                Shadow(
                                  color: Stage.gold.withValues(alpha: 0.6),
                                  blurRadius: 24,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _ScoreTile extends StatelessWidget {
  const _ScoreTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color, width: 2),
        ),
        child: Column(
          children: [
            Text(value, style: Stage.display(24, color: Stage.deep(color))),
            const SizedBox(height: 2),
            Text(label.toUpperCase(), style: Stage.label(size: 9)),
          ],
        ),
      ),
    );
  }
}

class _UnlockBanner extends StatelessWidget {
  const _UnlockBanner({required this.lesson, required this.game});

  final Lesson lesson;
  final GameController game;

  @override
  Widget build(BuildContext context) {
    final accent = Stage.tierAccent(lesson.tierId);
    final tier = game.tierOf(lesson);
    final newAct = tier.lessons.first.id == lesson.id;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          const Text('🔓', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  newAct ? 'NEW ACT UNLOCKED · ${tier.difficulty}' : 'UNLOCKED',
                  style: Stage.label(color: Stage.deep(accent)),
                ),
                const SizedBox(height: 2),
                Text(lesson.title, style: Stage.display(20)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({
    required this.number,
    required this.question,
    required this.chosen,
  });

  final int number;
  final Question question;
  final int chosen;

  @override
  Widget build(BuildContext context) {
    final correct = chosen == question.correctIndex;
    final color = correct ? Stage.correct : Stage.wrong;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Stage.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Stage.line, width: 2),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: !correct,
          shape: const Border(),
          collapsedShape: const Border(),
          leading: CircleAvatar(
            radius: 15,
            backgroundColor: color,
            child: Icon(
              correct ? Icons.check_rounded : Icons.close_rounded,
              size: 18,
              color: Stage.onAccent,
            ),
          ),
          title: Text(
            '$number. ${question.prompt}',
            style: Stage.body(14.5, weight: FontWeight.w600),
          ),
          iconColor: Stage.textMuted,
          collapsedIconColor: Stage.textMuted,
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (question.code != null) ...[
              CodeBlock(
                code: question.code!,
                fontSize: 12,
                filledBlank: question.type == QuestionType.fillTheBlank
                    ? question.options[question.correctIndex]
                    : null,
                blankColor: Stage.correct,
              ),
              const SizedBox(height: 10),
            ],
            if (!correct)
              _AnswerLine(
                label: 'You said',
                text: question.options[chosen],
                color: Stage.wrong,
              ),
            _AnswerLine(
              label: 'Answer',
              text: question.options[question.correctIndex],
              color: Stage.correct,
            ),
            const SizedBox(height: 6),
            Text(
              question.explanation.replaceAll('`', ''),
              style: Stage.body(14, color: Stage.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerLine extends StatelessWidget {
  const _AnswerLine({
    required this.label,
    required this.text,
    required this.color,
  });

  final String label;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: Stage.body(13, color: Stage.textMuted),
            ),
            TextSpan(
              text: text,
              style: Stage.code(13, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.progress});

  final double progress;

  static const _colors = [
    Stage.gold,
    Stage.green,
    Stage.blue,
    Stage.pink,
    Stage.orange,
    Stage.violet,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (progress >= 1) return;
    final rnd = math.Random(42);
    final paint = Paint();
    for (var i = 0; i < 70; i++) {
      final x0 = rnd.nextDouble() * size.width;
      final speed = 0.6 + rnd.nextDouble() * 0.8;
      final drift = (rnd.nextDouble() - 0.5) * 120;
      final spin = rnd.nextDouble() * 8;
      final y = -20 + progress * speed * size.height * 1.1;
      final x = x0 + drift * progress;
      paint.color = _colors[i % _colors.length].withValues(
        alpha: (1 - progress).clamp(0.0, 1.0),
      );
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(spin * progress * math.pi);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-4, -2, 8, 4),
          const Radius.circular(1),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) =>
      old.progress != progress;
}
