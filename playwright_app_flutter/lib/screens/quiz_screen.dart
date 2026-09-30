import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playwright_app_client/playwright_app_client.dart';

import '../game/game_controller.dart';
import '../theme.dart';
import '../widgets/code_block.dart';
import '../widgets/stage.dart';
import 'results_screen.dart';

/// Plays through a lesson's questions with instant feedback.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.lesson});

  /// A lesson including its questions.
  final Lesson lesson;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<Question> _questions = widget.lesson.questions!;

  /// For each question, the display order of the original option indices.
  late final List<List<int>> _order = [
    for (final q in _questions)
      q.type == QuestionType.trueFalse
          ? List.generate(q.options.length, (i) => i)
          : (List.generate(q.options.length, (i) => i)..shuffle(_random)),
  ];

  /// Chosen original option index per question.
  late final List<int?> _answers = List.filled(_questions.length, null);

  final _random = math.Random();
  int _index = 0;
  int _combo = 0;
  bool _hintVisible = false;
  bool _submitting = false;
  late String _cheer;

  Question get _question => _questions[_index];
  int? get _chosen => _answers[_index];
  bool get _revealed => _chosen != null;
  bool get _isCorrect => _chosen == _question.correctIndex;

  static const _cheers = [
    'Nailed it!',
    'Bravo!',
    'Encore!',
    'Spot on!',
    'Standing ovation!',
    'Flawless!',
  ];
  static const _consolations = [
    'Not quite',
    'Missed your cue',
    'Close, but no curtain call',
    'Plot twist',
  ];

  void _choose(int originalIndex) {
    if (_revealed) return;
    HapticFeedback.selectionClick();
    setState(() {
      _answers[_index] = originalIndex;
      if (_isCorrect) {
        _combo++;
        _cheer = _cheers[_random.nextInt(_cheers.length)];
      } else {
        _combo = 0;
        _cheer = _consolations[_random.nextInt(_consolations.length)];
      }
    });
  }

  Future<void> _next() async {
    if (!_revealed || _submitting) return;
    if (_index < _questions.length - 1) {
      setState(() {
        _index++;
        _hintVisible = false;
      });
      return;
    }
    setState(() => _submitting = true);
    final answers = _answers.cast<int>();
    try {
      final result = await GameScope.read(
        context,
      ).submit(widget.lesson.id, answers);
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => ResultsScreen(
            lesson: widget.lesson,
            result: result,
            answers: answers,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save your score. Check your connection.'),
        ),
      );
    }
  }

  Future<void> _confirmExit() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Stage.card,
        title: Text('Leave the stage?', style: Stage.display(24)),
        content: Text(
          'Your progress in this quiz will be lost.',
          style: Stage.body(15, color: Stage.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep playing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Stage.coral),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    if (leave == true && mounted) Navigator.of(context).pop();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      _next();
      return KeyEventResult.handled;
    }
    final digit = int.tryParse(event.character ?? '');
    final order = _order[_index];
    if (digit != null && digit >= 1 && digit <= order.length) {
      _choose(order[digit - 1]);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final accent = Stage.tierAccent(widget.lesson.tierId);
    final spotlight = !_revealed
        ? accent
        : _isCorrect
        ? Stage.correct
        : Stage.wrong;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit();
      },
      child: Focus(
        autofocus: true,
        onKeyEvent: _onKey,
        child: Scaffold(
          body: StageBackdrop(
            spotlight: spotlight,
            spotlightAlignment: const Alignment(0, -1.2),
            child: SafeArea(
              child: PhoneColumn(
                child: Column(
                  children: [
                    _Header(
                      total: _questions.length,
                      index: _index,
                      results: [
                        for (var i = 0; i < _questions.length; i++)
                          _answers[i] == null
                              ? null
                              : _answers[i] == _questions[i].correctIndex,
                      ],
                      combo: _combo,
                      accent: accent,
                      onClose: _confirmExit,
                    ),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween(
                              begin: const Offset(0.08, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
                        child: _QuestionView(
                          key: ValueKey(_index),
                          question: _question,
                          number: _index + 1,
                          total: _questions.length,
                          order: _order[_index],
                          chosen: _chosen,
                          accent: accent,
                          hintVisible: _hintVisible,
                          onShowHint: () => setState(() => _hintVisible = true),
                          onChoose: _choose,
                        ),
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      child: _revealed
                          ? _FeedbackPanel(
                              correct: _isCorrect,
                              title: _cheer,
                              explanation: _question.explanation,
                              correctAnswer:
                                  _question.options[_question.correctIndex],
                              isLast: _index == _questions.length - 1,
                              busy: _submitting,
                              onContinue: _next,
                            )
                          : const SizedBox(width: double.infinity),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.total,
    required this.index,
    required this.results,
    required this.combo,
    required this.accent,
    required this.onClose,
  });

  final int total;
  final int index;
  final List<bool?> results;
  final int combo;
  final Color accent;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 18, 6),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Leave quiz',
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Row(
              children: [
                for (var i = 0; i < total; i++)
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: switch (results[i]) {
                          true => Stage.correct,
                          false => Stage.wrong,
                          null =>
                            i == index
                                ? accent.withValues(alpha: 0.6)
                                : Stage.line,
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, a) =>
                ScaleTransition(scale: a, child: child),
            child: combo >= 2
                ? Text(
                    '🔥 ×$combo',
                    key: ValueKey(combo),
                    style: Stage.body(
                      15,
                      weight: FontWeight.w800,
                      color: Stage.coral,
                    ),
                  )
                : const SizedBox(key: ValueKey('none'), width: 42),
          ),
        ],
      ),
    );
  }
}

class _QuestionView extends StatelessWidget {
  const _QuestionView({
    super.key,
    required this.question,
    required this.number,
    required this.total,
    required this.order,
    required this.chosen,
    required this.accent,
    required this.hintVisible,
    required this.onShowHint,
    required this.onChoose,
  });

  final Question question;
  final int number;
  final int total;
  final List<int> order;
  final int? chosen;
  final Color accent;
  final bool hintVisible;
  final VoidCallback onShowHint;
  final ValueChanged<int> onChoose;

  bool get _revealed => chosen != null;

  @override
  Widget build(BuildContext context) {
    final typeLabel = switch (question.type) {
      QuestionType.multipleChoice => 'Pick one',
      QuestionType.trueFalse => 'True or false',
      QuestionType.fillTheBlank => 'Fill the blank',
    };
    final filled = !_revealed
        ? null
        : question.options[question.type == QuestionType.fillTheBlank
              ? chosen!
              : question.correctIndex];

    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 16),
      children: [
        Row(
          children: [
            Tag(typeLabel, color: accent),
            const Spacer(),
            Text('$number / $total', style: Stage.label()),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          question.prompt,
          style: Stage.display(
            question.prompt.length > 90 ? 22 : 26,
          ),
        ),
        if (question.code != null) ...[
          const SizedBox(height: 16),
          CodeBlock(
            code: question.code!,
            filledBlank: question.type == QuestionType.fillTheBlank
                ? filled
                : null,
            blankColor: !_revealed
                ? Stage.gold
                : chosen == question.correctIndex
                ? Stage.correct
                : Stage.wrong,
          ),
        ],
        const SizedBox(height: 20),
        if (question.type == QuestionType.trueFalse)
          Row(
            children: [
              for (final (i, original) in order.indexed) ...[
                if (i > 0) const SizedBox(width: 12),
                Expanded(
                  child: _OptionTile(
                    text: question.options[original],
                    badge: original == 0 ? '✓' : '✗',
                    state: _stateFor(original),
                    tall: true,
                    onTap: () => onChoose(original),
                  ),
                ),
              ],
            ],
          )
        else
          for (final (i, original) in order.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _OptionTile(
                text: question.options[original],
                badge: 'ABCD'[i],
                state: _stateFor(original),
                monospace:
                    question.type == QuestionType.fillTheBlank ||
                    _looksLikeCode(question.options[original]),
                onTap: () => onChoose(original),
              ),
            ),
        if (question.hint != null && !_revealed) ...[
          const SizedBox(height: 4),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: hintVisible
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Center(
              child: TextButton.icon(
                onPressed: onShowHint,
                icon: const Text('💡'),
                label: Text(
                  'Need a hint?',
                  style: Stage.body(14, color: Stage.goldText),
                ),
              ),
            ),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Stage.gold.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                '💡 ${question.hint}',
                style: Stage.body(14, color: Stage.goldText),
              ),
            ),
          ),
        ],
      ],
    );
  }

  _OptionState _stateFor(int original) {
    if (!_revealed) return _OptionState.idle;
    if (original == question.correctIndex) return _OptionState.correct;
    if (original == chosen) return _OptionState.wrong;
    return _OptionState.dimmed;
  }

  static final _codeish = RegExp(
    r"""^(npx |--|\.|'|"|\{|use:|await |page\.|[\w.]+\(|[a-z]+[A-Z]\w*\(?\)?$)""",
  );
  static bool _looksLikeCode(String s) => _codeish.hasMatch(s);
}

enum _OptionState { idle, correct, wrong, dimmed }

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.text,
    required this.badge,
    required this.state,
    required this.onTap,
    this.monospace = false,
    this.tall = false,
  });

  final String text;
  final String badge;
  final _OptionState state;
  final VoidCallback onTap;
  final bool monospace;
  final bool tall;

  @override
  Widget build(BuildContext context) {
    final (Color border, Color fill, Color fg) = switch (state) {
      _OptionState.idle => (Stage.line, Stage.card, Stage.text),
      _OptionState.correct => (
        Stage.correct,
        Stage.correct.withValues(alpha: 0.18),
        Stage.text,
      ),
      _OptionState.wrong => (
        Stage.wrong,
        Stage.wrong.withValues(alpha: 0.18),
        Stage.text,
      ),
      _OptionState.dimmed => (
        Stage.line.withValues(alpha: 0.5),
        Stage.card.withValues(alpha: 0.5),
        Stage.textMuted,
      ),
    };
    final badgeColor = switch (state) {
      _OptionState.correct => Stage.correct,
      _OptionState.wrong => Stage.wrong,
      _ => Stage.cardTint,
    };
    final textStyle = monospace
        ? Stage.code(14, color: fg)
        : Stage.body(16, color: fg, weight: FontWeight.w600);

    return Pressable(
      onTap: state == _OptionState.idle ? onTap : null,
      semanticLabel: text,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        constraints: BoxConstraints(minHeight: tall ? 92 : 60),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border, width: 2),
          boxShadow: state == _OptionState.idle
              ? [
                  BoxShadow(
                    color: Stage.line,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: tall
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(badge, style: Stage.display(28, color: fg)),
                  const SizedBox(height: 2),
                  Text(text, style: textStyle),
                ],
              )
            : Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: switch (state) {
                      _OptionState.correct => const Icon(
                        Icons.check_rounded,
                        size: 20,
                        color: Stage.onAccent,
                      ),
                      _OptionState.wrong => const Icon(
                        Icons.close_rounded,
                        size: 20,
                        color: Stage.onAccent,
                      ),
                      _ => Text(
                        badge,
                        style: Stage.body(
                          14,
                          weight: FontWeight.w800,
                          color: Stage.textMuted,
                        ),
                      ),
                    },
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: Text(text, style: textStyle)),
                ],
              ),
      ),
    );
  }
}

class _FeedbackPanel extends StatelessWidget {
  const _FeedbackPanel({
    required this.correct,
    required this.title,
    required this.explanation,
    required this.correctAnswer,
    required this.isLast,
    required this.busy,
    required this.onContinue,
  });

  final bool correct;
  final String title;
  final String explanation;
  final String correctAnswer;
  final bool isLast;
  final bool busy;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final color = correct ? Stage.correct : Stage.wrong;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: BoxDecoration(
        color: Color.lerp(Stage.card, color, 0.12),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: color.withValues(alpha: 0.6), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(correct ? '🎉' : '🎭', style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title, style: Stage.display(24, color: color)),
              ),
            ],
          ),
          if (!correct) ...[
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Answer: '),
                  TextSpan(
                    text: correctAnswer,
                    style: Stage.code(14, color: Stage.correct),
                  ),
                ],
              ),
              style: Stage.body(14, weight: FontWeight.w700),
            ),
          ],
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 140),
            child: SingleChildScrollView(
              child: _BacktickText(explanation),
            ),
          ),
          const SizedBox(height: 16),
          SpotlightButton(
            label: isLast ? 'See my score' : 'Continue',
            icon: Icons.arrow_forward_rounded,
            color: color,
            busy: busy,
            onTap: onContinue,
          ),
        ],
      ),
    );
  }
}

class _BacktickText extends StatelessWidget {
  const _BacktickText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final parts = text.split('`');
    return Text.rich(
      TextSpan(
        children: [
          for (var i = 0; i < parts.length; i++)
            TextSpan(
              text: parts[i],
              style: i.isOdd ? Stage.code(13.5, color: Stage.violet) : null,
            ),
        ],
      ),
      style: Stage.body(15, color: Stage.text),
    );
  }
}
