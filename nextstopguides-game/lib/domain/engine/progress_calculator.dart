import 'dart:math';

import '../../core/constants/app_constants.dart';
import '../../core/utils/day_key.dart';
import '../entities/continent.dart';
import '../entities/game_mode.dart';
import '../entities/game_result.dart';
import '../entities/passport_stamp.dart';
import '../entities/player_progress.dart';
import 'level_system.dart';
import 'rewards.dart';
import 'scoring.dart';

class ProgressUpdate {
  const ProgressUpdate(this.progress, this.summary);

  final PlayerProgress progress;
  final GameSummary summary;
}

/// Applies a finished game to the player's progress: XP, levels, high scores,
/// streaks, passport stamps and hint rewards. Pure Dart and unit-tested.
class ProgressCalculator {
  const ProgressCalculator({this.scoring = const ScoreCalculator()});

  final ScoreCalculator scoring;

  ProgressUpdate apply(PlayerProgress before, GameOutcome outcome, DateTime now) {
    final todayKey = DayKey.of(now);
    final isDaily = outcome.mode == GameMode.daily;
    final firstDailyToday = isDaily && before.lastDailyDateKey != todayKey;
    final isDailyPractice = isDaily && !firstDailyToday;

    // XP & level.
    final xpGained = scoring.xpForGame(
      score: outcome.score,
      correctAnswers: outcome.correct,
      dailyBonus: firstDailyToday,
    );
    final newXp = before.xp + xpGained;
    final previousLevel = before.level;
    final newLevel = LevelSystem.levelForXp(newXp);

    // High score (a same-day Daily replay does not count).
    final highScores = Map<GameMode, int>.of(before.highScores);
    final isNewHighScore = !isDailyPractice &&
        outcome.score > 0 &&
        outcome.score > before.highScoreFor(outcome.mode);
    if (isNewHighScore) {
      highScores[outcome.mode] = outcome.score;
    }

    // Passport stamps.
    final continentCorrect = Map<Continent, int>.of(before.continentCorrect);
    final unlocked = <StampUnlock>[];
    for (final entry in outcome.continentCorrect.entries) {
      final oldCount = continentCorrect[entry.key] ?? 0;
      final newCount = oldCount + entry.value;
      continentCorrect[entry.key] = newCount;
      final oldTier = PassportStamps.tierFor(oldCount);
      final newTier = PassportStamps.tierFor(newCount);
      if (newTier.index > oldTier.index) {
        unlocked.add(StampUnlock(entry.key, newTier));
      }
    }

    // Hints.
    final hintsEarned = RewardRules.hintsEarned(
      levelsGained: newLevel - previousLevel,
      firstDailyToday: firstDailyToday,
      bestStreakInGame: outcome.bestStreak,
    );

    // Daily streak.
    var dailyStreak = before.dailyStreak;
    var lastDailyDateKey = before.lastDailyDateKey;
    if (firstDailyToday) {
      dailyStreak = before.lastDailyDateKey == DayKey.yesterdayOf(now)
          ? before.dailyStreak + 1
          : 1;
      lastDailyDateKey = todayKey;
    }

    // Recently asked questions (to avoid repeats in future games).
    final recent = [...before.recentQuestionIds, ...outcome.questionIds];
    final trimmedRecent = recent.length > AppConstants.maxRecentQuestionIds
        ? recent.sublist(recent.length - AppConstants.maxRecentQuestionIds)
        : recent;

    final after = before.copyWith(
      xp: newXp,
      hints: before.hints + hintsEarned,
      highScores: highScores,
      bestStreak: max(before.bestStreak, outcome.bestStreak),
      gamesPlayed: before.gamesPlayed + 1,
      totalCorrect: before.totalCorrect + outcome.correct,
      totalAnswered: before.totalAnswered + outcome.answered,
      continentCorrect: continentCorrect,
      lastDailyDateKey: lastDailyDateKey,
      dailyStreak: dailyStreak,
      recentQuestionIds: trimmedRecent,
    );

    final summary = GameSummary(
      mode: outcome.mode,
      difficulty: outcome.difficulty,
      score: outcome.score,
      correct: outcome.correct,
      answered: outcome.answered,
      bestStreak: outcome.bestStreak,
      xpGained: xpGained,
      previousLevel: previousLevel,
      newLevel: newLevel,
      isNewHighScore: isNewHighScore,
      hintsEarned: hintsEarned,
      stampsUnlocked: unlocked,
      isDailyPractice: isDailyPractice,
      dailyStreak: dailyStreak,
    );

    return ProgressUpdate(after, summary);
  }
}
