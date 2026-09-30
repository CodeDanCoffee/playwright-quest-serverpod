import 'package:playwright_app_server/src/quiz/content/curriculum.dart';
import 'package:playwright_app_server/src/quiz/game_rules.dart';
import 'package:test/test.dart';

void main() {
  group('Given the curriculum', () {
    test('then every question has a valid answer and unique id', () {
      final ids = <String>{};
      for (final lesson in allLessons) {
        expect(lesson.questions, isNotEmpty, reason: lesson.id);
        expect(lesson.questionCount, lesson.questions!.length);
        for (final q in lesson.questions!) {
          expect(ids.add(q.id), isTrue, reason: 'duplicate ${q.id}');
          expect(q.correctIndex, inInclusiveRange(0, q.options.length - 1));
          expect(
            q.options.toSet(),
            hasLength(q.options.length),
            reason: 'duplicate options in ${q.id}',
          );
        }
      }
    });

    test('then lessons are ordered and belong to a tier', () {
      for (var i = 0; i < allLessons.length; i++) {
        expect(allLessons[i].order, i);
        expect(allLessons[i].tierId, isNotEmpty);
      }
    });
  });

  group('Given starsFor', () {
    test('when scoring then thresholds are 60/80/100%', () {
      expect(GameRules.starsFor(5, 10), 0);
      expect(GameRules.starsFor(6, 10), 1);
      expect(GameRules.starsFor(8, 10), 2);
      expect(GameRules.starsFor(10, 10), 3);
    });
  });

  group('Given unlockedLessonIds', () {
    test('when nothing is played then only the first lesson is open', () {
      expect(GameRules.unlockedLessonIds({}), [allLessons.first.id]);
    });

    test('when the first lesson is passed then the second opens', () {
      expect(GameRules.unlockedLessonIds({allLessons[0].id: 1}), [
        allLessons[0].id,
        allLessons[1].id,
      ]);
    });

    test(
      'when the first lesson has zero stars then the second stays locked',
      () {
        expect(GameRules.unlockedLessonIds({allLessons[0].id: 0}), [
          allLessons[0].id,
        ]);
      },
    );
  });

  group('Given xpFor', () {
    test(
      'when passing perfectly for the first time then both bonuses apply',
      () {
        expect(
          GameRules.xpFor(correct: 7, stars: 3, previousStars: null),
          70 + GameRules.firstPassBonusXp + GameRules.firstPerfectBonusXp,
        );
      },
    );

    test('when replaying a passed lesson then only answer xp is given', () {
      expect(GameRules.xpFor(correct: 5, stars: 2, previousStars: 2), 50);
    });
  });

  group('Given streaks', () {
    final day1 = DateTime.utc(2026, 1, 1, 22);
    test('when playing the next day then the streak grows', () {
      expect(
        GameRules.nextStreak(
          currentStreak: 3,
          lastPlayedAt: day1,
          now: DateTime.utc(2026, 1, 2, 1),
        ),
        4,
      );
    });

    test('when playing again the same day then the streak is unchanged', () {
      expect(
        GameRules.nextStreak(currentStreak: 3, lastPlayedAt: day1, now: day1),
        3,
      );
    });

    test('when a day was skipped then the streak restarts', () {
      expect(
        GameRules.nextStreak(
          currentStreak: 3,
          lastPlayedAt: day1,
          now: DateTime.utc(2026, 1, 3, 9),
        ),
        1,
      );
      expect(
        GameRules.effectiveStreak(
          currentStreak: 3,
          lastPlayedAt: day1,
          now: DateTime.utc(2026, 1, 3, 9),
        ),
        0,
      );
    });
  });
}
