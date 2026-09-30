import 'content/curriculum.dart';

/// Pure game rules: scoring, unlocking and streaks. Kept free of database
/// access so they are easy to reason about and test.
abstract final class GameRules {
  static const xpPerCorrectAnswer = 10;
  static const firstPassBonusXp = 50;
  static const firstPerfectBonusXp = 25;

  /// Stars for [correct] out of [total]: 60% = 1, 80% = 2, 100% = 3.
  static int starsFor(int correct, int total) {
    if (total == 0) return 0;
    final ratio = correct / total;
    if (ratio >= 1) return 3;
    if (ratio >= 0.8) return 2;
    if (ratio >= 0.6) return 1;
    return 0;
  }

  /// A lesson is passed with at least one star.
  static bool isPassed(int stars) => stars >= 1;

  /// The first lesson is always open; each next one opens when the previous
  /// one is passed.
  static List<String> unlockedLessonIds(Map<String, int> starsByLesson) {
    final unlocked = <String>[];
    for (final lesson in allLessons) {
      unlocked.add(lesson.id);
      if (!isPassed(starsByLesson[lesson.id] ?? 0)) break;
    }
    return unlocked;
  }

  /// XP for an attempt, given the previous best stars (null if never played).
  static int xpFor({
    required int correct,
    required int stars,
    required int? previousStars,
  }) {
    var xp = correct * xpPerCorrectAnswer;
    final before = previousStars ?? 0;
    if (isPassed(stars) && !isPassed(before)) xp += firstPassBonusXp;
    if (stars == 3 && before < 3) xp += firstPerfectBonusXp;
    return xp;
  }

  /// The streak after playing at [now], given the last play time.
  static int nextStreak({
    required int currentStreak,
    required DateTime? lastPlayedAt,
    required DateTime now,
  }) {
    if (lastPlayedAt == null) return 1;
    final gap = _dayNumber(now) - _dayNumber(lastPlayedAt);
    if (gap <= 0) return currentStreak == 0 ? 1 : currentStreak;
    if (gap == 1) return currentStreak + 1;
    return 1;
  }

  /// The streak to display: it lapses if the player skipped a whole day.
  static int effectiveStreak({
    required int currentStreak,
    required DateTime? lastPlayedAt,
    required DateTime now,
  }) {
    if (lastPlayedAt == null) return 0;
    final gap = _dayNumber(now) - _dayNumber(lastPlayedAt);
    return gap <= 1 ? currentStreak : 0;
  }

  static int _dayNumber(DateTime t) {
    final utc = t.toUtc();
    return DateTime.utc(utc.year, utc.month, utc.day).millisecondsSinceEpoch ~/
        Duration.millisecondsPerDay;
  }
}
