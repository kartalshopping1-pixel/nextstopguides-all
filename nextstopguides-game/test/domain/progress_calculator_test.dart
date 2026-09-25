import 'package:flutter_test/flutter_test.dart';
import 'package:nextstopguides_game/domain/engine/progress_calculator.dart';
import 'package:nextstopguides_game/domain/engine/rewards.dart';
import 'package:nextstopguides_game/domain/entities/continent.dart';
import 'package:nextstopguides_game/domain/entities/difficulty.dart';
import 'package:nextstopguides_game/domain/entities/game_mode.dart';
import 'package:nextstopguides_game/domain/entities/game_result.dart';
import 'package:nextstopguides_game/domain/entities/passport_stamp.dart';
import 'package:nextstopguides_game/domain/entities/player_progress.dart';

void main() {
  const calculator = ProgressCalculator();
  final today = DateTime(2026, 9, 25, 14);

  GameOutcome outcome({
    GameMode mode = GameMode.flagQuiz,
    int score = 500,
    int correct = 5,
    int bestStreak = 3,
    Map<Continent, int> continents = const {},
  }) {
    return GameOutcome(
      mode: mode,
      difficulty: Difficulty.medium,
      score: score,
      correct: correct,
      answered: 10,
      bestStreak: bestStreak,
      continentCorrect: continents,
      questionIds: const ['a', 'b'],
    );
  }

  test('first game updates stats, xp and high score', () {
    final update = calculator.apply(const PlayerProgress(), outcome(), today);
    final p = update.progress;
    expect(p.gamesPlayed, 1);
    expect(p.totalCorrect, 5);
    expect(p.totalAnswered, 10);
    expect(p.xp, 60); // 500/10 + 5*2
    expect(p.highScoreFor(GameMode.flagQuiz), 500);
    expect(update.summary.isNewHighScore, isTrue);
    expect(p.recentQuestionIds, ['a', 'b']);
  });

  test('a lower score is not a new high score', () {
    final before = const PlayerProgress(highScores: {GameMode.flagQuiz: 900});
    final update = calculator.apply(before, outcome(score: 500), today);
    expect(update.summary.isNewHighScore, isFalse);
    expect(update.progress.highScoreFor(GameMode.flagQuiz), 900);
  });

  test('leveling up awards hints', () {
    final before = const PlayerProgress(xp: 90, hints: 0);
    final update = calculator.apply(before, outcome(), today);
    expect(update.summary.previousLevel, 1);
    expect(update.summary.newLevel, 2);
    expect(update.summary.leveledUp, isTrue);
    expect(update.progress.hints, RewardRules.hintsPerLevelUp);
  });

  test('daily challenge: first play gives bonus and streak, replay is practice', () {
    final yesterday = const PlayerProgress(
      lastDailyDateKey: '2026-09-24',
      dailyStreak: 4,
      hints: 0,
    );
    final first = calculator.apply(yesterday, outcome(mode: GameMode.daily), today);
    expect(first.progress.dailyStreak, 5);
    expect(first.progress.lastDailyDateKey, '2026-09-25');
    expect(first.summary.isDailyPractice, isFalse);
    expect(first.summary.hintsEarned, greaterThanOrEqualTo(1));
    expect(first.summary.xpGained, 60 + 25);

    final replay = calculator.apply(
      first.progress,
      outcome(mode: GameMode.daily, score: 5000),
      today,
    );
    expect(replay.summary.isDailyPractice, isTrue);
    expect(replay.summary.isNewHighScore, isFalse);
    expect(replay.progress.dailyStreak, 5);
  });

  test('missing a day resets the daily streak', () {
    final before = const PlayerProgress(lastDailyDateKey: '2026-09-20', dailyStreak: 9);
    final update = calculator.apply(before, outcome(mode: GameMode.daily), today);
    expect(update.progress.dailyStreak, 1);
  });

  test('passport stamps unlock when crossing thresholds', () {
    final before = const PlayerProgress(continentCorrect: {Continent.europe: 8});
    final update = calculator.apply(
      before,
      outcome(continents: {Continent.europe: 3, Continent.asia: 2}),
      today,
    );
    expect(update.progress.correctIn(Continent.europe), 11);
    expect(update.progress.stampFor(Continent.europe), StampTier.bronze);
    expect(update.summary.stampsUnlocked, [
      const StampUnlock(Continent.europe, StampTier.bronze),
    ]);
  });

  test('a 10+ streak earns a hint', () {
    final update = calculator.apply(
      const PlayerProgress(hints: 0),
      outcome(bestStreak: 10, score: 0, correct: 0),
      today,
    );
    expect(update.summary.hintsEarned, 1);
    expect(update.progress.bestStreak, 10);
  });
}
