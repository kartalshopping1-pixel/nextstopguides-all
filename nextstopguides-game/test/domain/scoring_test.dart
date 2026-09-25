import 'package:flutter_test/flutter_test.dart';
import 'package:nextstopguides_game/domain/engine/level_system.dart';
import 'package:nextstopguides_game/domain/engine/rewards.dart';
import 'package:nextstopguides_game/domain/engine/scoring.dart';
import 'package:nextstopguides_game/domain/entities/difficulty.dart';
import 'package:nextstopguides_game/domain/entities/passport_stamp.dart';

void main() {
  const scoring = ScoreCalculator();

  group('ScoreCalculator.pointsFor', () {
    test('wrong answers score zero', () {
      expect(
        scoring.pointsFor(correct: false, difficulty: Difficulty.hard, streakBefore: 9),
        0,
      );
    });

    test('base points are multiplied by difficulty', () {
      expect(scoring.pointsFor(correct: true, difficulty: Difficulty.easy), 100);
      expect(scoring.pointsFor(correct: true, difficulty: Difficulty.medium), 150);
      expect(scoring.pointsFor(correct: true, difficulty: Difficulty.hard), 200);
    });

    test('streak adds 10% per step and is capped at +100%', () {
      expect(
        scoring.pointsFor(correct: true, difficulty: Difficulty.easy, streakBefore: 3),
        130,
      );
      expect(
        scoring.pointsFor(correct: true, difficulty: Difficulty.easy, streakBefore: 10),
        200,
      );
      expect(
        scoring.pointsFor(correct: true, difficulty: Difficulty.easy, streakBefore: 50),
        200,
      );
    });

    test('fewer clues give more points', () {
      int points(int revealed) => scoring.pointsFor(
            correct: true,
            difficulty: Difficulty.easy,
            cluesRevealed: revealed,
            totalClues: 7,
          );
      expect(points(1), 100);
      expect(points(2), 86); // 100 * 6/7
      expect(points(7), 14); // 100 * 1/7
      for (var i = 1; i < 7; i++) {
        expect(points(i), greaterThan(points(i + 1)));
      }
    });

    test('clues revealed are clamped to a valid range', () {
      final zero = scoring.pointsFor(
        correct: true,
        difficulty: Difficulty.easy,
        cluesRevealed: 0,
        totalClues: 5,
      );
      final tooMany = scoring.pointsFor(
        correct: true,
        difficulty: Difficulty.easy,
        cluesRevealed: 99,
        totalClues: 5,
      );
      expect(zero, 100);
      expect(tooMany, 20);
    });

    test('using a hint halves the points', () {
      expect(
        scoring.pointsFor(correct: true, difficulty: Difficulty.medium, usedHint: true),
        75,
      );
    });

    test('a correct answer always scores at least 1 point', () {
      expect(
        scoring.pointsFor(
          correct: true,
          difficulty: Difficulty.easy,
          cluesRevealed: 1000,
          totalClues: 1000,
          usedHint: true,
        ),
        1,
      );
    });
  });

  group('XP and levels', () {
    test('xp for a game', () {
      expect(scoring.xpForGame(score: 1000, correctAnswers: 8), 116);
      expect(scoring.xpForGame(score: 0, correctAnswers: 0, dailyBonus: true), 25);
    });

    test('level thresholds', () {
      expect(LevelSystem.xpRequiredForLevel(1), 0);
      expect(LevelSystem.xpRequiredForLevel(2), 100);
      expect(LevelSystem.xpRequiredForLevel(3), 300);
      expect(LevelSystem.xpRequiredForLevel(4), 600);
      expect(LevelSystem.levelForXp(0), 1);
      expect(LevelSystem.levelForXp(99), 1);
      expect(LevelSystem.levelForXp(100), 2);
      expect(LevelSystem.levelForXp(299), 2);
      expect(LevelSystem.levelForXp(300), 3);
    });

    test('progress to next level', () {
      expect(LevelSystem.progressToNextLevel(0), 0);
      expect(LevelSystem.progressToNextLevel(200), closeTo(0.5, 0.0001));
      expect(LevelSystem.xpToNextLevel(250), 50);
    });

    test('ranks', () {
      expect(TravelerRank.forLevel(1), TravelerRank.tourist);
      expect(TravelerRank.forLevel(5), TravelerRank.backpacker);
      expect(TravelerRank.forLevel(19), TravelerRank.explorer);
      expect(TravelerRank.forLevel(100), TravelerRank.ambassador);
    });
  });

  group('Rewards', () {
    test('hints earned', () {
      expect(
        RewardRules.hintsEarned(levelsGained: 0, firstDailyToday: false, bestStreakInGame: 9),
        0,
      );
      expect(
        RewardRules.hintsEarned(levelsGained: 1, firstDailyToday: true, bestStreakInGame: 10),
        4,
      );
    });

    test('passport stamp tiers', () {
      expect(PassportStamps.tierFor(0), StampTier.none);
      expect(PassportStamps.tierFor(10), StampTier.bronze);
      expect(PassportStamps.tierFor(50), StampTier.silver);
      expect(PassportStamps.tierFor(150), StampTier.gold);
      expect(PassportStamps.nextThreshold(12), 50);
      expect(PassportStamps.nextThreshold(200), isNull);
    });
  });
}
