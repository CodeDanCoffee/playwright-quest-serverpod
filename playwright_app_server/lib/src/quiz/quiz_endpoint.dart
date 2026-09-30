import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'content/curriculum.dart';
import 'game_rules.dart';

/// The Playwright quiz game: curriculum, player progress and scoring.
class QuizEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Returns all tiers and their lessons, without the questions.
  Future<List<Tier>> getTiers(Session session) async {
    return [
      for (final tier in curriculum)
        tier.copyWith(
          lessons: [for (final l in tier.lessons) _withoutQuestions(l)],
        ),
    ];
  }

  /// Returns a lesson including its questions. The lesson must be unlocked.
  Future<Lesson> getLesson(Session session, String lessonId) async {
    final lesson = _findLesson(lessonId);
    await _ensureUnlocked(session, lessonId);
    return lesson;
  }

  /// Returns the signed-in player's stats and per-lesson progress.
  Future<PlayerProgress> getProgress(Session session) async {
    final userId = session.authenticated!.authUserId;
    final lessons = await _lessonProgress(session, userId);
    final stats = await _stats(session, userId);
    return PlayerProgress(
      stats: _withEffectiveStreak(stats),
      lessons: lessons,
      unlockedLessonIds: GameRules.unlockedLessonIds(_starsByLesson(lessons)),
    );
  }

  /// Grades a finished lesson. [answers] holds the chosen option index for
  /// each question, in question order.
  Future<LessonResult> submitLesson(
    Session session,
    String lessonId,
    List<int> answers,
  ) async {
    final userId = session.authenticated!.authUserId;
    final lesson = _findLesson(lessonId);
    final questions = lesson.questions!;
    if (answers.length != questions.length) {
      throw QuizException(
        message:
            'Expected ${questions.length} answers but got ${answers.length}.',
      );
    }

    return session.db.transaction((transaction) async {
      final allProgress = await _lessonProgress(
        session,
        userId,
        transaction: transaction,
      );
      final starsBefore = _starsByLesson(allProgress);
      if (!GameRules.unlockedLessonIds(starsBefore).contains(lessonId)) {
        throw QuizException(message: 'This lesson is still locked.');
      }

      var correct = 0;
      for (var i = 0; i < questions.length; i++) {
        if (answers[i] == questions[i].correctIndex) correct++;
      }
      final total = questions.length;
      final stars = GameRules.starsFor(correct, total);
      final now = DateTime.now().toUtc();

      final existing = allProgress
          .where((p) => p.lessonId == lessonId)
          .firstOrNull;
      final isNewBest = existing == null || correct > existing.bestCorrect;
      if (existing == null) {
        await LessonProgress.db.insertRow(
          session,
          LessonProgress(
            authUserId: userId,
            lessonId: lessonId,
            bestCorrect: correct,
            total: total,
            stars: stars,
            attempts: 1,
            lastPlayedAt: now,
          ),
          transaction: transaction,
        );
      } else {
        await LessonProgress.db.updateRow(
          session,
          existing.copyWith(
            bestCorrect: isNewBest ? correct : existing.bestCorrect,
            total: total,
            stars: isNewBest ? stars : existing.stars,
            attempts: existing.attempts + 1,
            lastPlayedAt: now,
          ),
          transaction: transaction,
        );
      }

      final xpEarned = GameRules.xpFor(
        correct: correct,
        stars: stars,
        previousStars: existing?.stars,
      );
      final stats = await _stats(session, userId, transaction: transaction);
      final streak = GameRules.nextStreak(
        currentStreak: stats.currentStreak,
        lastPlayedAt: stats.lastPlayedAt,
        now: now,
      );
      final updatedStats = stats.copyWith(
        xp: stats.xp + xpEarned,
        currentStreak: streak,
        longestStreak: streak > stats.longestStreak
            ? streak
            : stats.longestStreak,
        lastPlayedAt: now,
      );
      final savedStats = stats.id == null
          ? await PlayerStats.db.insertRow(
              session,
              updatedStats,
              transaction: transaction,
            )
          : await PlayerStats.db.updateRow(
              session,
              updatedStats,
              transaction: transaction,
            );

      final starsAfter = {
        ...starsBefore,
        lessonId: isNewBest ? stars : starsBefore[lessonId] ?? 0,
      };
      final unlockedBefore = GameRules.unlockedLessonIds(starsBefore).toSet();
      final newlyUnlocked = GameRules.unlockedLessonIds(
        starsAfter,
      ).where((id) => !unlockedBefore.contains(id)).firstOrNull;

      return LessonResult(
        lessonId: lessonId,
        correct: correct,
        total: total,
        stars: stars,
        xpEarned: xpEarned,
        isNewBest: isNewBest,
        unlockedLessonId: newlyUnlocked,
        stats: savedStats,
      );
    });
  }

  Lesson _findLesson(String lessonId) {
    final lesson = allLessons.where((l) => l.id == lessonId).firstOrNull;
    if (lesson == null) {
      throw QuizException(message: 'Unknown lesson "$lessonId".');
    }
    return lesson;
  }

  Future<void> _ensureUnlocked(Session session, String lessonId) async {
    final userId = session.authenticated!.authUserId;
    final progress = await _lessonProgress(session, userId);
    final unlocked = GameRules.unlockedLessonIds(_starsByLesson(progress));
    if (!unlocked.contains(lessonId)) {
      throw QuizException(message: 'This lesson is still locked.');
    }
  }

  Future<List<LessonProgress>> _lessonProgress(
    Session session,
    UuidValue userId, {
    Transaction? transaction,
  }) {
    return LessonProgress.db.find(
      session,
      where: (t) => t.authUserId.equals(userId),
      transaction: transaction,
    );
  }

  /// The stored stats, or fresh (unsaved) stats for a new player.
  Future<PlayerStats> _stats(
    Session session,
    UuidValue userId, {
    Transaction? transaction,
  }) async {
    return await PlayerStats.db.findFirstRow(
          session,
          where: (t) => t.authUserId.equals(userId),
          transaction: transaction,
        ) ??
        PlayerStats(authUserId: userId);
  }

  PlayerStats _withEffectiveStreak(PlayerStats stats) => stats.copyWith(
    currentStreak: GameRules.effectiveStreak(
      currentStreak: stats.currentStreak,
      lastPlayedAt: stats.lastPlayedAt,
      now: DateTime.now(),
    ),
  );

  Map<String, int> _starsByLesson(List<LessonProgress> progress) => {
    for (final p in progress) p.lessonId: p.stars,
  };

  Lesson _withoutQuestions(Lesson lesson) => lesson.copyWith(questions: null);
}
