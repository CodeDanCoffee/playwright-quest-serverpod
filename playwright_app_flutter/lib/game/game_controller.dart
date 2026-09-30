import 'package:flutter/widgets.dart';
import 'package:playwright_app_client/playwright_app_client.dart';

import '../client.dart';

/// Holds the curriculum and the player's progress, shared by all screens.
class GameController extends ChangeNotifier {
  List<Tier> tiers = [];
  PlayerProgress? progress;
  Object? error;
  bool loading = false;

  /// Which welcome screen to show once the map has loaded, set right after
  /// sign-in. Cleared when the player moves on.
  WelcomeKind? pendingWelcome;

  void dismissWelcome() {
    if (pendingWelcome == null) return;
    pendingWelcome = null;
    notifyListeners();
  }

  /// The signed-in player's email, for the profile button's initial.
  String? email;

  bool get isReady => tiers.isNotEmpty && progress != null;

  int get lessonsDone =>
      progress?.lessons.where((p) => p.stars > 0).length ?? 0;

  List<Lesson> get allLessons => [for (final t in tiers) ...t.lessons];

  PlayerStats? get stats => progress?.stats;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        if (tiers.isEmpty) client.quiz.getTiers(),
        client.quiz.getProgress(),
      ]);
      if (results.length == 2) tiers = results.first as List<Tier>;
      progress = results.last as PlayerProgress;
      email ??= await _loadEmail();
    } catch (e) {
      error = e;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<String?> _loadEmail() async {
    try {
      final profile = await client.modules.serverpod_auth_core.userProfileInfo
          .get();
      return profile.email;
    } catch (_) {
      return null; // The initial falls back to a generic letter.
    }
  }

  bool isUnlocked(String lessonId) =>
      progress?.unlockedLessonIds.contains(lessonId) ?? false;

  LessonProgress? progressFor(String lessonId) =>
      progress?.lessons.where((p) => p.lessonId == lessonId).firstOrNull;

  int starsFor(String lessonId) => progressFor(lessonId)?.stars ?? 0;

  int get totalStars =>
      progress?.lessons.fold<int>(0, (sum, p) => sum + p.stars) ?? 0;

  int get maxStars => allLessons.length * 3;

  /// The next lesson to play: first unlocked one without 3 stars.
  Lesson? get nextUp {
    for (final l in allLessons) {
      if (!isUnlocked(l.id)) return null;
      if (starsFor(l.id) < 1) return l;
    }
    return allLessons.where((l) => starsFor(l.id) < 3).firstOrNull;
  }

  int tierStars(Tier tier) =>
      tier.lessons.fold(0, (sum, l) => sum + starsFor(l.id));

  Tier tierOf(Lesson lesson) => tiers.firstWhere((t) => t.id == lesson.tierId);

  Future<LessonResult> submit(String lessonId, List<int> answers) async {
    final result = await client.quiz.submitLesson(lessonId, answers);
    await load();
    return result;
  }

  void reset() {
    tiers = [];
    progress = null;
    email = null;
    pendingWelcome = null;
    notifyListeners();
  }
}

/// The two variants of the screen shown right after signing in.
enum WelcomeKind { newUser, returning }

/// Makes the [GameController] available to the widget tree.
class GameScope extends InheritedNotifier<GameController> {
  const GameScope({
    super.key,
    required GameController controller,
    required super.child,
  }) : super(notifier: controller);

  static GameController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<GameScope>()!.notifier!;

  static GameController read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<GameScope>()!.notifier!;
}
