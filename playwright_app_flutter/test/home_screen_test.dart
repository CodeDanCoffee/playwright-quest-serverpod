import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playwright_app_client/playwright_app_client.dart';
import 'package:playwright_app_flutter/game/game_controller.dart';
import 'package:playwright_app_flutter/screens/home_screen.dart';

final _user = UuidValue.fromString('01a0f0d9-a86d-7775-8fa1-3187c2a50975');

var _order = 0;
Lesson _lesson(String id, String tierId, String title) => Lesson(
  id: id,
  tierId: tierId,
  order: _order++,
  title: title,
  summary: '$title summary.',
  conceptTitle: 'Concept',
  conceptBody: 'Body',
  questionCount: 7,
);

List<Tier> _tiers() {
  _order = 0;
  Tier tier(String id, int order, String difficulty, String name, String p) =>
      Tier(
        id: id,
        order: order,
        difficulty: difficulty,
        title: 'Act · $name',
        description: '$name description.',
        lessons: [
          for (var i = 1; i <= 3; i++) _lesson('$p$i', id, '$name lesson $i'),
        ],
      );
  return [
    tier('beginner', 0, 'Beginner', 'Rehearsal', 'b'),
    tier('intermediate', 1, 'Intermediate', 'Opening Night', 'i'),
    tier('advanced', 2, 'Advanced', 'On Tour', 'a'),
    tier('expert', 3, 'Expert', 'Standing Ovation', 'e'),
  ];
}

LessonProgress _passed(String id, int stars) => LessonProgress(
  authUserId: _user,
  lessonId: id,
  bestCorrect: 7,
  total: 7,
  stars: stars,
  attempts: 1,
  lastPlayedAt: DateTime.utc(2026, 9, 30),
);

GameController _game({
  List<LessonProgress> lessons = const [],
  List<String> unlocked = const ['b1'],
  int xp = 0,
  int streak = 0,
}) => GameController()
  ..tiers = _tiers()
  ..email = 'ada@example.com'
  ..progress = PlayerProgress(
    stats: PlayerStats(authUserId: _user, xp: xp, currentStreak: streak),
    lessons: lessons,
    unlockedLessonIds: unlocked,
  );

Future<void> _pump(WidgetTester tester, GameController game) async {
  tester.view.physicalSize = const Size(390, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    GameScope(
      controller: game,
      child: const MaterialApp(home: HomeScreen()),
    ),
  );
  await tester.pump();
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('Given a first-time player, then the map matches the spec', (
    tester,
  ) async {
    await _pump(tester, _game());

    // Header
    expect(find.text('0 days'), findsOneWidget);
    expect(find.text('A'), findsOneWidget); // profile initial
    // Intro
    expect(find.text('Your path to writing real browser tests'), findsOne);
    expect(
      find.text(
        '12 short lessons across 4 acts, from zero to expert. Start with the '
        'first one.',
      ),
      findsOneWidget,
    );
    // Start here card
    expect(find.text('START HERE'), findsOneWidget);
    expect(find.text('Lesson 1 of 12'), findsOneWidget);
    expect(find.text('7 questions'), findsOneWidget);
    expect(find.text('+70 XP'), findsOneWidget);
    expect(find.text('Start lesson 1'), findsOneWidget);
    // Acts
    expect(find.text('The 4 acts'), findsOneWidget);
    expect(find.text('0 of 12 lessons done'), findsOneWidget);
    expect(find.text('Up next'), findsOneWidget);
    expect(find.text('After lesson 1'), findsOneWidget);
    expect(find.text('After lesson 2'), findsOneWidget);
    expect(find.text('Act II · Intermediate'), findsOneWidget);
    expect(find.text('3 lessons · unlocks after Act I'), findsOneWidget);
    expect(find.text('3 lessons · unlocks after Act III'), findsOneWidget);
    expect(find.text('Locked'), findsNWidgets(3));
    // Rank
    expect(find.text('Stagehand'), findsOneWidget);
    expect(find.text('Just getting started'), findsOneWidget);
    expect(find.text('0 / 150 XP'), findsOneWidget);
    expect(
      find.textContaining(
        'promoted to Understudy (learning the basics).',
        findRichText: true,
      ),
      findsOneWidget,
    );
  });

  testWidgets(
    'Given a player who finished Act I, then Act II is current and Act I '
    'collapses to a done row that can be expanded',
    (tester) async {
      await _pump(
        tester,
        _game(
          lessons: [_passed('b1', 3), _passed('b2', 2), _passed('b3', 1)],
          unlocked: const ['b1', 'b2', 'b3', 'i1'],
          xp: 290,
          streak: 1,
        ),
      );

      expect(find.text('1 day'), findsOneWidget);
      expect(
        find.text(
          "You've finished 3 of 12 lessons. Pick up where you left off.",
        ),
        findsOneWidget,
      );
      expect(find.text('UP NEXT'), findsOneWidget);
      expect(find.text('Lesson 4 of 12'), findsOneWidget);
      expect(find.text('Start lesson 4'), findsOneWidget);
      expect(find.text('3 of 12 lessons done'), findsOneWidget);
      expect(find.text('3 lessons · 6 of 9 stars'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
      expect(find.text('After lesson 4'), findsOneWidget);
      expect(find.text('Understudy'), findsOneWidget);
      expect(find.text('290 / 400 XP'), findsOneWidget);

      await tester.tap(find.text('Act I · Beginner'));
      await tester.pump();

      expect(find.text('3 of 3 stars'), findsOneWidget);
      expect(find.text('2 of 3 stars'), findsOneWidget);
      expect(find.byTooltip('Hide lessons'), findsOneWidget);
    },
  );

  testWidgets('Given a returning player just signed in, then it welcomes '
      'them back', (tester) async {
    await _pump(
      tester,
      _game(lessons: [_passed('b1', 2)], unlocked: const ['b1', 'b2'])
        ..pendingWelcome = WelcomeKind.returning,
    );

    expect(find.text('Welcome back!'), findsOneWidget);
    expect(find.text('Your path to writing real browser tests'), findsNothing);
  });
}
