import '../engine/level_system.dart';
import '../engine/rewards.dart';
import 'continent.dart';
import 'game_mode.dart';
import 'passport_stamp.dart';

/// Everything we remember about the player between sessions.
/// Stored locally by ProgressRepository (shared_preferences).
class PlayerProgress {
  const PlayerProgress({
    this.xp = 0,
    this.hints = RewardRules.startingHints,
    this.highScores = const {},
    this.bestStreak = 0,
    this.gamesPlayed = 0,
    this.totalCorrect = 0,
    this.totalAnswered = 0,
    this.continentCorrect = const {},
    this.lastDailyDateKey,
    this.dailyStreak = 0,
    this.recentQuestionIds = const [],
    this.adsRemoved = false,
  });

  final int xp;

  /// Consumable hint currency.
  final int hints;
  final Map<GameMode, int> highScores;
  final int bestStreak;
  final int gamesPlayed;
  final int totalCorrect;
  final int totalAnswered;

  /// Correct answers per continent (drives passport stamps).
  final Map<Continent, int> continentCorrect;

  /// "yyyy-mm-dd" of the last day the Daily Challenge was completed.
  final String? lastDailyDateKey;

  /// Consecutive days the Daily Challenge was completed.
  final int dailyStreak;

  /// Recently asked question ids (helps avoid repeats between games).
  final List<String> recentQuestionIds;

  /// Set when the "remove_ads" purchase is owned.
  final bool adsRemoved;

  int get level => LevelSystem.levelForXp(xp);

  TravelerRank get rank => TravelerRank.forLevel(level);

  double get levelProgress => LevelSystem.progressToNextLevel(xp);

  int get xpToNextLevel => LevelSystem.xpToNextLevel(xp);

  double get accuracy => totalAnswered == 0 ? 0 : totalCorrect / totalAnswered;

  int highScoreFor(GameMode mode) => highScores[mode] ?? 0;

  int correctIn(Continent continent) => continentCorrect[continent] ?? 0;

  StampTier stampFor(Continent continent) =>
      PassportStamps.tierFor(correctIn(continent));

  int get stampsCollected =>
      Continent.values.where((c) => stampFor(c) != StampTier.none).length;

  PlayerProgress copyWith({
    int? xp,
    int? hints,
    Map<GameMode, int>? highScores,
    int? bestStreak,
    int? gamesPlayed,
    int? totalCorrect,
    int? totalAnswered,
    Map<Continent, int>? continentCorrect,
    String? lastDailyDateKey,
    int? dailyStreak,
    List<String>? recentQuestionIds,
    bool? adsRemoved,
  }) {
    return PlayerProgress(
      xp: xp ?? this.xp,
      hints: hints ?? this.hints,
      highScores: highScores ?? this.highScores,
      bestStreak: bestStreak ?? this.bestStreak,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalAnswered: totalAnswered ?? this.totalAnswered,
      continentCorrect: continentCorrect ?? this.continentCorrect,
      lastDailyDateKey: lastDailyDateKey ?? this.lastDailyDateKey,
      dailyStreak: dailyStreak ?? this.dailyStreak,
      recentQuestionIds: recentQuestionIds ?? this.recentQuestionIds,
      adsRemoved: adsRemoved ?? this.adsRemoved,
    );
  }
}
