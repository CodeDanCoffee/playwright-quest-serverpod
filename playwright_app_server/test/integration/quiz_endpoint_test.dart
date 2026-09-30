import 'package:playwright_app_server/src/generated/protocol.dart';
import 'package:playwright_app_server/src/quiz/content/curriculum.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Quiz endpoint', (sessionBuilder, endpoints) {
    late TestSessionBuilder player;

    setUp(() async {
      final user = await AuthUser.db.insertRow(
        sessionBuilder.build(),
        AuthUser(scopeNames: {}),
      );
      player = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          user.id!.uuid,
          {},
        ),
      );
    });

    List<int> perfectAnswers(String lessonId) => [
      for (final q in allLessons.firstWhere((l) => l.id == lessonId).questions!)
        q.correctIndex,
    ];

    test('when unauthenticated then getTiers throws', () async {
      await expectLater(
        endpoints.quiz.getTiers(
          sessionBuilder.copyWith(
            authentication: AuthenticationOverride.unauthenticated(),
          ),
        ),
        throwsA(isA<ServerpodUnauthenticatedException>()),
      );
    });

    test('when getting tiers then lessons come without questions', () async {
      final tiers = await endpoints.quiz.getTiers(player);
      expect(tiers, hasLength(4));
      expect(tiers.first.lessons.first.questions, isNull);
      expect(tiers.first.lessons.first.questionCount, greaterThan(0));
    });

    test(
      'when a new player gets progress then only lesson one is open',
      () async {
        final progress = await endpoints.quiz.getProgress(player);
        expect(progress.stats.xp, 0);
        expect(progress.unlockedLessonIds, ['b1']);
      },
    );

    test('when getting a locked lesson then it throws', () async {
      await expectLater(
        endpoints.quiz.getLesson(player, 'b2'),
        throwsA(isA<QuizException>()),
      );
    });

    test(
      'when submitting a perfect lesson then stars, xp and unlock follow',
      () async {
        final result = await endpoints.quiz.submitLesson(
          player,
          'b1',
          perfectAnswers('b1'),
        );
        expect(result.stars, 3);
        expect(result.isNewBest, isTrue);
        expect(result.unlockedLessonId, 'b2');
        expect(result.stats.xp, result.xpEarned);
        expect(result.stats.currentStreak, 1);

        final progress = await endpoints.quiz.getProgress(player);
        expect(progress.unlockedLessonIds, ['b1', 'b2']);
        expect(progress.lessons.single.stars, 3);

        final lesson = await endpoints.quiz.getLesson(player, 'b2');
        expect(lesson.questions, isNotEmpty);
      },
    );

    test('when replaying worse then the best score is kept', () async {
      await endpoints.quiz.submitLesson(player, 'b1', perfectAnswers('b1'));
      final wrong = perfectAnswers('b1').map((a) => a == 0 ? 1 : 0).toList();
      final result = await endpoints.quiz.submitLesson(player, 'b1', wrong);
      expect(result.stars, 0);
      expect(result.isNewBest, isFalse);
      expect(result.xpEarned, 0);

      final progress = await endpoints.quiz.getProgress(player);
      expect(progress.lessons.single.stars, 3);
      expect(progress.lessons.single.attempts, 2);
    });

    test(
      'when submitting the wrong number of answers then it throws',
      () async {
        await expectLater(
          endpoints.quiz.submitLesson(player, 'b1', [0]),
          throwsA(isA<QuizException>()),
        );
      },
    );

    test('when submitting a locked lesson then it throws', () async {
      await expectLater(
        endpoints.quiz.submitLesson(player, 'b2', perfectAnswers('b2')),
        throwsA(isA<QuizException>()),
      );
    });
  });
}
