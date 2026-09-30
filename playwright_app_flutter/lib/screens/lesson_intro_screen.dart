import 'package:flutter/material.dart';
import 'package:playwright_app_client/playwright_app_client.dart';

import '../client.dart';
import '../game/game_controller.dart';
import '../theme.dart';
import '../widgets/code_block.dart';
import '../widgets/stage.dart';
import 'quiz_screen.dart';

/// A short concept card ("the script") shown before the quiz.
class LessonIntroScreen extends StatefulWidget {
  const LessonIntroScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  State<LessonIntroScreen> createState() => _LessonIntroScreenState();
}

class _LessonIntroScreenState extends State<LessonIntroScreen> {
  late Future<Lesson> _full = client.quiz.getLesson(widget.lesson.id);

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final accent = Stage.tierAccent(lesson.tierId);
    final game = GameScope.of(context);
    final tier = game.tierOf(lesson);
    final best = game.progressFor(lesson.id);

    return Scaffold(
      body: StageBackdrop(
        spotlight: accent,
        spotlightAlignment: const Alignment(0.8, -1.1),
        child: SafeArea(
          child: PhoneColumn(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: 'Back to map',
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      const Spacer(),
                      if (best != null) ...[
                        Text('BEST ', style: Stage.label()),
                        StarRow(stars: best.stars),
                      ],
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
                    children: [
                      Row(
                        children: [
                          Tag(tier.difficulty, color: accent),
                          const SizedBox(width: 8),
                          Text(
                            'SCENE ${lesson.order + 1}',
                            style: Stage.label(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(lesson.title, style: Stage.display(38)),
                      const SizedBox(height: 6),
                      Text(
                        lesson.summary,
                        style: Stage.body(15, color: Stage.textMuted),
                      ),
                      const SizedBox(height: 26),
                      _ScriptCard(lesson: lesson, accent: accent),
                      if (lesson.proTip != null) ...[
                        const SizedBox(height: 16),
                        _ProTip(text: lesson.proTip!),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
                  child: FutureBuilder<Lesson>(
                    future: _full,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return SpotlightButton(
                          label: 'Could not load. Tap to retry',
                          color: Stage.coral,
                          onTap: () => setState(() {
                            _full = client.quiz.getLesson(lesson.id);
                          }),
                        );
                      }
                      final full = snapshot.data;
                      return SpotlightButton(
                        label: best == null
                            ? 'Start quiz · ${lesson.questionCount} questions'
                            : 'Play again · ${lesson.questionCount} questions',
                        icon: Icons.arrow_forward_rounded,
                        color: accent,
                        busy: full == null,
                        onTap: full == null
                            ? null
                            : () => Navigator.of(context).pushReplacement(
                                MaterialPageRoute<void>(
                                  builder: (_) => QuizScreen(lesson: full),
                                ),
                              ),
                      );
                    },
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

class _ScriptCard extends StatelessWidget {
  const _ScriptCard({required this.lesson, required this.accent});

  final Lesson lesson;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Stage.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.35), width: 2),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📜  THE SCRIPT', style: Stage.label(color: Stage.deep(accent))),
          const SizedBox(height: 8),
          Text(lesson.conceptTitle, style: Stage.display(24)),
          const SizedBox(height: 12),
          for (final paragraph in lesson.conceptBody.split('\n\n')) ...[
            _RichParagraph(paragraph),
            const SizedBox(height: 12),
          ],
          if (lesson.conceptCode != null) ...[
            const SizedBox(height: 4),
            CodeBlock(code: lesson.conceptCode!, fontSize: 12),
          ],
        ],
      ),
    );
  }
}

/// A paragraph where `backticked` words render as inline code.
class _RichParagraph extends StatelessWidget {
  const _RichParagraph(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final parts = text.split('`');
    return Text.rich(
      TextSpan(
        children: [
          for (var i = 0; i < parts.length; i++)
            i.isOdd
                ? TextSpan(
                    text: parts[i],
                    style: Stage.code(
                      14,
                      color: Stage.violet,
                    ).copyWith(backgroundColor: Stage.cardTint),
                  )
                : TextSpan(text: parts[i]),
        ],
      ),
      style: Stage.body(15.5, color: Stage.text),
    );
  }
}

class _ProTip extends StatelessWidget {
  const _ProTip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.012,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Stage.gold.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Stage.gold, width: 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('💡', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PRO TIP FOR REAL PROJECTS',
                    style: Stage.label(color: Stage.goldText),
                  ),
                  const SizedBox(height: 4),
                  _RichParagraph(text),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
