/// Theatre-themed player ranks, earned with XP.
class Rank {
  const Rank(this.title, this.minXp, this.meaning);

  final String title;
  final int minXp;

  /// Plain-language partner for the theatre term, shown next to it.
  final String meaning;

  static const all = [
    Rank('Stagehand', 0, 'Just getting started'),
    Rank('Understudy', 150, 'Learning the basics'),
    Rank('Supporting Actor', 400, 'Writing your own tests'),
    Rank('Lead Actor', 800, 'Confident with Playwright'),
    Rank('Director', 1300, 'Running whole test suites'),
    Rank('Playwright', 2000, 'Top rank: a Playwright expert'),
  ];

  static Rank of(int xp) => all.lastWhere((r) => xp >= r.minXp);

  static Rank? nextAfter(int xp) => all.where((r) => r.minXp > xp).firstOrNull;

  /// Progress 0..1 towards the next rank.
  static double progressToNext(int xp) {
    final current = of(xp);
    final next = nextAfter(xp);
    if (next == null) return 1;
    return (xp - current.minXp) / (next.minXp - current.minXp);
  }
}
