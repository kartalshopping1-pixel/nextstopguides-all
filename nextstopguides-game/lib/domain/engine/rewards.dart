import '../entities/passport_stamp.dart';

/// Rules for the consumable "hint" currency.
///
/// Hints are earned by playing and can later also be sold through in-app
/// purchases (see lib/services/purchase/purchase_service.dart).
class RewardRules {
  RewardRules._();

  static const int startingHints = 3;
  static const int hintsPerLevelUp = 2;
  static const int hintsForFirstDailyOfTheDay = 1;

  /// Every N correct answers in a row inside one game gives +1 hint.
  static const int streakLengthForHint = 10;

  static int hintsEarned({
    required int levelsGained,
    required bool firstDailyToday,
    required int bestStreakInGame,
  }) {
    final levels = levelsGained < 0 ? 0 : levelsGained;
    return levels * hintsPerLevelUp +
        (firstDailyToday ? hintsForFirstDailyOfTheDay : 0) +
        bestStreakInGame ~/ streakLengthForHint;
  }
}

/// Passport stamps: correct answers per continent unlock bronze, silver and
/// gold stamps. This gives long-term goals and replay value.
class PassportStamps {
  PassportStamps._();

  static const int bronzeAt = 10;
  static const int silverAt = 50;
  static const int goldAt = 150;

  static StampTier tierFor(int correctAnswers) {
    if (correctAnswers >= goldAt) {
      return StampTier.gold;
    }
    if (correctAnswers >= silverAt) {
      return StampTier.silver;
    }
    if (correctAnswers >= bronzeAt) {
      return StampTier.bronze;
    }
    return StampTier.none;
  }

  /// The next threshold to reach, or null when gold is already earned.
  static int? nextThreshold(int correctAnswers) {
    if (correctAnswers < bronzeAt) {
      return bronzeAt;
    }
    if (correctAnswers < silverAt) {
      return silverAt;
    }
    if (correctAnswers < goldAt) {
      return goldAt;
    }
    return null;
  }
}
