import 'package:flutter/material.dart';
import 'package:playwright_app_client/playwright_app_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../game/game_controller.dart';
import '../game/ranks.dart';
import '../theme.dart';
import '../widgets/quest_ui.dart';
import '../widgets/stage.dart';
import 'lesson_intro_screen.dart';

/// Mirrors `GameRules.xpPerCorrectAnswer` on the server.
const _xpPerCorrectAnswer = 10;

const _roman = ['I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII'];

/// The quest map: header, intro, one "Start here" card, the acts as a
/// readable list, and the rank card. Everything is derived from the
/// curriculum and the player's progress.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Finished or open acts the player expanded to see their lessons.
  final _expandedActs = <String>{};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GameScope.read(context).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = GameScope.of(context);
    return Scaffold(
      body: QuestBackground(
        child: SafeArea(
          bottom: false,
          child: switch ((game.isReady, game.error)) {
            (false, final Object error) => _ErrorView(
              error: error,
              onRetry: game.load,
            ),
            (false, _) => const Center(
              child: CircularProgressIndicator(color: QuestColors.green),
            ),
            _ => RefreshIndicator(
              color: QuestColors.green,
              onRefresh: game.load,
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 34),
                    children: _gap(22, [
                      _Header(game: game),
                      _Intro(game: game),
                      _StartHereCard(game: game),
                      _ActsSection(
                        game: game,
                        expanded: _expandedActs,
                        onToggle: (id) => setState(() {
                          if (!_expandedActs.remove(id)) _expandedActs.add(id);
                        }),
                      ),
                      _RankCard(game: game),
                    ]),
                  ),
                ),
              ),
            ),
          },
        ),
      ),
    );
  }
}

List<Widget> _gap(double gap, List<Widget> children) => [
  for (final (i, child) in children.indexed) ...[
    if (i > 0) SizedBox(height: gap),
    child,
  ],
];

/// Where a lesson stands for the player.
enum _LessonState { done, next, locked }

extension on GameController {
  /// The lesson the "Start here" card points at.
  Lesson get currentLesson => nextUp ?? allLessons.last;

  _LessonState stateOf(Lesson lesson) {
    if (lesson.id == currentLesson.id) return _LessonState.next;
    if (starsFor(lesson.id) > 0) return _LessonState.done;
    return _LessonState.locked;
  }

  int lessonNumber(Lesson lesson) => lesson.order + 1;

  bool isActDone(Tier tier) => tier.lessons.every((l) => starsFor(l.id) > 0);
}

String _actName(Tier tier) => 'Act ${_roman[tier.order]}';

/// The act name without the "Act I ·" prefix, e.g. "Rehearsal".
String _actTitle(Tier tier) => tier.title.split('·').last.trim();

// ---------------------------------------------------------------------------
// 1. Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.game});

  final GameController game;

  @override
  Widget build(BuildContext context) {
    final streak = game.stats?.currentStreak ?? 0;
    final initial = (game.email?.trim().isNotEmpty ?? false)
        ? game.email!.trim()[0].toUpperCase()
        : 'P';
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Row(
        children: [
          const QuestLogo(size: 36),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Playwright Quest',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: questBaloo(18),
            ),
          ),
          const SizedBox(width: 10),
          Tooltip(
            message: 'Do a lesson every day to grow your streak',
            child: Semantics(
              label:
                  '$streak day streak. Do a lesson every day to grow your '
                  'streak',
              excludeSemantics: true,
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: QuestColors.orangeDot,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$streak ${streak == 1 ? 'day' : 'days'}',
                      style: questNunito(
                        12.5,
                        weight: FontWeight.w700,
                        color: QuestColors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Semantics(
            button: true,
            label: 'Profile',
            excludeSemantics: true,
            child: Material(
              color: QuestColors.ink,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => _showProfile(context, game),
                child: SizedBox.square(
                  dimension: 44,
                  child: Center(
                    child: Text(
                      initial,
                      style: questBaloo(15, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. Intro
// ---------------------------------------------------------------------------

class _Intro extends StatelessWidget {
  const _Intro({required this.game});

  final GameController game;

  @override
  Widget build(BuildContext context) {
    final total = game.allLessons.length;
    final done = game.lessonsDone;
    final returning = game.pendingWelcome == WelcomeKind.returning;
    final title = returning
        ? 'Welcome back!'
        : 'Your path to writing real browser tests';
    final subtitle = done == 0
        ? '$total short lessons across ${game.tiers.length} acts, from zero '
              'to expert. Start with the first one.'
        : done == total
        ? "You've finished all $total lessons. Replay any of them to earn "
              'more stars.'
        : "You've finished $done of $total lessons. Pick up where you left "
              'off.';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: questBaloo(28, height: 1.05)),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: questNunito(14.5, color: QuestColors.muted, height: 1.45),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Start here (the only primary call to action)
// ---------------------------------------------------------------------------

class _StartHereCard extends StatelessWidget {
  const _StartHereCard({required this.game});

  final GameController game;

  @override
  Widget build(BuildContext context) {
    final lesson = game.currentLesson;
    final n = game.lessonNumber(lesson);
    final attempted = game.progressFor(lesson.id) != null;
    final passed = game.starsFor(lesson.id) > 0;
    final (eyebrow, action) = passed
        ? ('Play again', 'Replay lesson $n')
        : attempted
        ? ('Up next', 'Try lesson $n again')
        : game.lessonsDone == 0
        ? ('Start here', 'Start lesson $n')
        : ('Up next', 'Start lesson $n');
    final white = questNunito(12, weight: FontWeight.w700, color: Colors.white);

    Widget chip(String label) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: QuestColors.greenDeeper,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(label, style: white),
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: QuestColors.greenDark,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: QuestColors.greenDeeper, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _gap(14, [
          Row(
            children: [
              Expanded(
                child: Text(
                  eyebrow.toUpperCase(),
                  style: white.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Text('Lesson $n of ${game.allLessons.length}', style: white),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                lesson.title,
                style: questBaloo(26, color: Colors.white, height: 1.05),
              ),
              const SizedBox(height: 4),
              Text(
                lesson.summary,
                style: questNunito(14.5, color: Colors.white, height: 1.4),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              chip('${lesson.questionCount} questions'),
              chip('~3 min'),
              chip('+${lesson.questionCount * _xpPerCorrectAnswer} XP'),
            ],
          ),
          _WhiteButton(
            label: action,
            onPressed: () => openLesson(context, lesson),
          ),
        ]),
      ),
    );
  }
}

/// White pill with a deep green "lip" that presses down.
class _WhiteButton extends StatefulWidget {
  const _WhiteButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  State<_WhiteButton> createState() => _WhiteButtonState();
}

class _WhiteButtonState extends State<_WhiteButton> {
  bool _pressed = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.label,
      excludeSemantics: true,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        onShowFocusHighlight: (v) => setState(() => _focused = v),
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
            height: 52,
            transform: Matrix4.translationValues(0, _pressed ? 3 : 0, 0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(99),
              border: _focused
                  ? Border.all(color: QuestColors.ink, width: 2.5)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: QuestColors.greenDeeper,
                  offset: Offset(0, _pressed ? 1 : 4),
                ),
              ],
            ),
            child: Text(
              widget.label,
              style: questNunito(
                17,
                weight: FontWeight.w800,
                color: QuestColors.greenDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. The acts
// ---------------------------------------------------------------------------

class _ActsSection extends StatelessWidget {
  const _ActsSection({
    required this.game,
    required this.expanded,
    required this.onToggle,
  });

  final GameController game;
  final Set<String> expanded;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final current = game.tierOf(game.currentLesson);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _gap(10, [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  'The ${game.tiers.length} acts',
                  style: questBaloo(20),
                ),
              ),
            ),
            Text(
              '${game.lessonsDone} of ${game.allLessons.length} lessons done',
              style: questNunito(
                12.5,
                weight: FontWeight.w700,
                color: QuestColors.faint,
              ),
            ),
          ],
        ),
        for (final tier in game.tiers)
          if (tier.id == current.id || expanded.contains(tier.id))
            _ActCard(
              tier: tier,
              game: game,
              onCollapse: tier.id == current.id
                  ? null
                  : () => onToggle(tier.id),
            )
          else
            _ActRow(tier: tier, game: game, onExpand: () => onToggle(tier.id)),
      ]),
    );
  }
}

/// An act shown with all of its lessons.
class _ActCard extends StatelessWidget {
  const _ActCard({required this.tier, required this.game, this.onCollapse});

  final Tier tier;
  final GameController game;

  /// Null for the current act, which is always open.
  final VoidCallback? onCollapse;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                _actName(tier).toUpperCase(),
                style: questNunito(
                  11.5,
                  weight: FontWeight.w800,
                  color: QuestColors.greenDark,
                ).copyWith(letterSpacing: 1),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: QuestColors.paleGreen,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  tier.difficulty,
                  style: questNunito(
                    11.5,
                    weight: FontWeight.w800,
                    color: QuestColors.greenOnPale,
                  ),
                ),
              ),
              const Spacer(),
              if (onCollapse != null)
                IconButton(
                  tooltip: 'Hide lessons',
                  onPressed: onCollapse,
                  constraints: const BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                  ),
                  icon: const Icon(
                    Icons.expand_less_rounded,
                    color: QuestColors.muted,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(_actTitle(tier), style: questBaloo(21)),
          Text(
            tier.description,
            style: questNunito(13.5, color: QuestColors.muted, height: 1.4),
          ),
          const SizedBox(height: 12),
          for (final lesson in tier.lessons)
            _LessonRow(lesson: lesson, game: game),
        ],
      ),
    );
  }
}

class _LessonRow extends StatelessWidget {
  const _LessonRow({required this.lesson, required this.game});

  final Lesson lesson;
  final GameController game;

  @override
  Widget build(BuildContext context) {
    final n = game.lessonNumber(lesson);
    final state = game.stateOf(lesson);
    final stars = game.starsFor(lesson.id);

    final (Color tileBg, Widget tileChild) = switch (state) {
      _LessonState.next => (
        // Spec #1fae5b gives white text only 2.9:1; the dark green passes.
        QuestColors.greenDark,
        Text('$n', style: questBaloo(17, color: Colors.white)),
      ),
      _LessonState.done => (
        QuestColors.paleGreen,
        const Icon(Icons.check_rounded, color: QuestColors.greenOnPale),
      ),
      _LessonState.locked => (
        QuestColors.lavender,
        Text('$n', style: questBaloo(17, color: QuestColors.faint)),
      ),
    };
    final title = switch (state) {
      _LessonState.locked => questNunito(
        15,
        weight: FontWeight.w700,
        color: QuestColors.muted,
      ),
      _ => questNunito(15, weight: FontWeight.w800),
    };
    final (String status, TextStyle statusStyle) = switch (state) {
      _LessonState.next => (
        'Up next',
        questNunito(12, weight: FontWeight.w800, color: QuestColors.greenDark),
      ),
      _LessonState.done => (
        '$stars of 3 stars',
        questNunito(12, weight: FontWeight.w800, color: QuestColors.greenDark),
      ),
      _LessonState.locked => (
        'After lesson ${n - 1}',
        questNunito(12, weight: FontWeight.w600, color: QuestColors.faint),
      ),
    };

    final row = Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: QuestColors.divider)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tileBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: tileChild,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(lesson.title, style: title)),
          const SizedBox(width: 12),
          Text(status, style: statusStyle),
        ],
      ),
    );

    // Finished lessons can be replayed from the list. The next lesson is
    // started from the "Start here" card only, so it is not a second button.
    if (state != _LessonState.done) {
      return Semantics(
        label: '${lesson.title}, lesson $n. $status.',
        excludeSemantics: true,
        child: row,
      );
    }
    return Semantics(
      button: true,
      label: 'Replay lesson $n, ${lesson.title}. $status.',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => openLesson(context, lesson),
        child: row,
      ),
    );
  }
}

/// A collapsed act: locked, or finished and tappable to show its lessons.
class _ActRow extends StatelessWidget {
  const _ActRow({
    required this.tier,
    required this.game,
    required this.onExpand,
  });

  final Tier tier;
  final GameController game;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    final locked = !game.isUnlocked(tier.lessons.first.id);
    final count = tier.lessons.length;
    final lessons = '$count ${count == 1 ? 'lesson' : 'lessons'}';
    final previous = tier.order > 0 ? game.tiers[tier.order - 1] : null;
    final String subtitle;
    final String status;
    if (locked) {
      subtitle =
          '$lessons · unlocks after ${previous == null ? 'sign-in' : _actName(previous)}';
      status = 'Locked';
    } else if (game.isActDone(tier)) {
      final stars = tier.lessons.fold(0, (sum, l) => sum + game.starsFor(l.id));
      subtitle = '$lessons · $stars of ${count * 3} stars';
      status = 'Done';
    } else {
      final done = tier.lessons.where((l) => game.starsFor(l.id) > 0).length;
      subtitle = '$lessons · $done done';
      status = 'Open';
    }

    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_actName(tier)} · ${tier.difficulty}',
                  style: questNunito(15, weight: FontWeight.w800),
                ),
                Text(
                  subtitle,
                  style: questNunito(13, color: QuestColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            status,
            style: questNunito(
              12,
              weight: locked ? FontWeight.w600 : FontWeight.w800,
              color: locked ? QuestColors.faint : QuestColors.greenDark,
            ),
          ),
          if (!locked) ...[
            const SizedBox(width: 4),
            const Icon(Icons.expand_more_rounded, color: QuestColors.muted),
          ],
        ],
      ),
    );

    if (locked) {
      return Semantics(
        label: '${_actName(tier)}, ${tier.difficulty}. $subtitle. Locked.',
        excludeSemantics: true,
        child: content,
      );
    }
    return Semantics(
      button: true,
      label: '${_actName(tier)}, ${tier.difficulty}. $subtitle. Show lessons.',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onExpand,
        child: content,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. Rank
// ---------------------------------------------------------------------------

class _RankCard extends StatelessWidget {
  const _RankCard({required this.game});

  final GameController game;

  @override
  Widget build(BuildContext context) {
    final xp = game.stats?.xp ?? 0;
    final rank = Rank.of(xp);
    final next = Rank.nextAfter(xp);
    final muted = questNunito(13.5, color: QuestColors.muted, height: 1.45);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _gap(10, [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR RANK',
                      style: questNunito(
                        11.5,
                        weight: FontWeight.w800,
                        color: QuestColors.faint,
                      ).copyWith(letterSpacing: 1),
                    ),
                    Text(rank.title, style: questBaloo(21)),
                    Text(
                      rank.meaning,
                      style: questNunito(13, color: QuestColors.muted),
                    ),
                  ],
                ),
              ),
              Text(
                next == null ? '$xp XP' : '$xp / ${next.minXp} XP',
                style: questNunito(
                  15,
                  weight: FontWeight.w800,
                  color: QuestColors.orange,
                ),
              ),
            ],
          ),
          Semantics(
            label: next == null
                ? 'Top rank reached'
                : '$xp of ${next.minXp} XP towards ${next.title}',
            excludeSemantics: true,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: LinearProgressIndicator(
                value: next == null ? 1 : xp / next.minXp,
                minHeight: 8,
                color: QuestColors.green,
                backgroundColor: QuestColors.emptyTrack,
              ),
            ),
          ),
          Text.rich(
            next == null
                ? const TextSpan(
                    text:
                        "Every lesson earns XP and up to 3 stars. You've "
                        'reached the top rank.',
                  )
                : TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'Every lesson earns XP and up to 3 stars. Reach '
                            '${next.minXp} XP to be promoted to ',
                      ),
                      TextSpan(
                        text: next.title,
                        style: questNunito(
                          13.5,
                          weight: FontWeight.w800,
                          height: 1.45,
                        ),
                      ),
                      TextSpan(text: ' (${next.meaning.toLowerCase()}).'),
                    ],
                  ),
            style: muted,
          ),
        ]),
      ),
    );
  }
}

BoxDecoration _cardDecoration(double radius) => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(radius),
  boxShadow: [
    BoxShadow(
      color: QuestColors.ink.withValues(alpha: 0.07),
      blurRadius: 30,
      offset: const Offset(0, 10),
    ),
  ],
);

void openLesson(BuildContext context, Lesson lesson) {
  final game = GameScope.read(context);
  if (!game.isUnlocked(lesson.id)) {
    final previous = game.allLessons[lesson.order - 1];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Locked: earn at least 1 star in "${previous.title}" to unlock this scene.',
        ),
      ),
    );
    return;
  }
  // Starting a lesson means the player has moved past the welcome panel.
  game.dismissWelcome();
  Navigator.of(context).push(lessonRoute(lesson));
}

/// The animated route into a lesson's intro screen.
Route<void> lessonRoute(Lesson lesson) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 450),
    pageBuilder: (_, _, _) => LessonIntroScreen(lesson: lesson),
    transitionsBuilder: (_, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const QuestLogo(size: 64),
            const SizedBox(height: 12),
            Text('The show is delayed', style: Stage.display(26)),
            const SizedBox(height: 8),
            Text(
              'We could not reach the server. Check your connection and '
              'try again.',
              textAlign: TextAlign.center,
              style: Stage.body(14, color: Stage.textMuted),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: SpotlightButton(label: 'Retry', onTap: onRetry),
            ),
          ],
        ),
      ),
    );
  }
}

void _showProfile(BuildContext context, GameController game) {
  final stats = game.stats!;
  final rank = Rank.of(stats.xp);
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Stage.card,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              rank.title,
              style: Stage.display(28),
              textAlign: TextAlign.center,
            ),
            Text(
              rank.meaning,
              style: Stage.body(14, color: Stage.textMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _ProfileStat(label: 'XP', value: '${stats.xp}'),
                _ProfileStat(label: 'Stars', value: '${game.totalStars}'),
                _ProfileStat(
                  label: 'Streak',
                  value: '${stats.currentStreak}',
                ),
                _ProfileStat(
                  label: 'Best streak',
                  value: '${stats.longestStreak}',
                ),
              ],
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () async {
                Navigator.of(sheetContext).pop();
                game.reset();
                await client.auth.signOutDevice();
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Sign out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Stage.coral,
                side: const BorderSide(color: Stage.coral),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: Stage.display(24, color: Stage.goldText)),
          const SizedBox(height: 2),
          Text(
            label.toUpperCase(),
            style: Stage.label(size: 9),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
