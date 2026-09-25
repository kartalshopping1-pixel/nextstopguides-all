import 'dart:math';

/// XP -> level curve.
///
/// Cumulative XP needed: level 2 = 100, level 3 = 300, level 4 = 600,
/// level 5 = 1000 ... (each level needs 100 XP more than the previous one).
class LevelSystem {
  LevelSystem._();

  static const int maxLevel = 999;

  static int xpRequiredForLevel(int level) =>
      level <= 1 ? 0 : 50 * (level - 1) * level;

  static int levelForXp(int xp) {
    var level = 1;
    while (level < maxLevel && xp >= xpRequiredForLevel(level + 1)) {
      level++;
    }
    return level;
  }

  /// Progress (0..1) from the current level towards the next one.
  static double progressToNextLevel(int xp) {
    final level = levelForXp(xp);
    final start = xpRequiredForLevel(level);
    final end = xpRequiredForLevel(level + 1);
    if (end <= start) {
      return 1;
    }
    final value = (xp - start) / (end - start);
    if (value < 0) {
      return 0;
    }
    if (value > 1) {
      return 1;
    }
    return value;
  }

  static int xpToNextLevel(int xp) =>
      max(0, xpRequiredForLevel(levelForXp(xp) + 1) - xp);
}

/// Traveler rank titles shown on the profile.
enum TravelerRank {
  tourist(1),
  backpacker(5),
  explorer(10),
  globetrotter(20),
  ambassador(35);

  const TravelerRank(this.minLevel);

  final int minLevel;

  static TravelerRank forLevel(int level) {
    var rank = TravelerRank.tourist;
    for (final candidate in TravelerRank.values) {
      if (level >= candidate.minLevel) {
        rank = candidate;
      }
    }
    return rank;
  }
}
