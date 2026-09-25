import 'dart:math';

import '../entities/difficulty.dart';

/// All scoring rules in one place. Pure Dart and fully unit-tested
/// (see test/domain/scoring_test.dart).
class ScoreCalculator {
  const ScoreCalculator();

  static const int basePoints = 100;
  static const int maxStreakBonusSteps = 10;
  static const double streakBonusPerStep = 0.1; // +10% per streak step
  static const double hintPenaltyFactor = 0.5; // using a hint halves points

  /// Points for one answer.
  ///
  /// * Wrong answers give 0.
  /// * Clue questions: the fewer clues revealed, the more points
  ///   (1 clue = 100%, all clues = 1/totalClues).
  /// * Difficulty multiplies the result (easy 1x, medium 1.5x, hard 2x).
  /// * The current streak (before this answer) adds +10% per step, max +100%.
  /// * Using a hint halves the points.
  int pointsFor({
    required bool correct,
    required Difficulty difficulty,
    int streakBefore = 0,
    int cluesRevealed = 0,
    int totalClues = 0,
    bool usedHint = false,
  }) {
    if (!correct) {
      return 0;
    }
    var points = basePoints.toDouble();
    if (totalClues > 0) {
      final revealed = min(max(cluesRevealed, 1), totalClues);
      points *= (totalClues - revealed + 1) / totalClues;
    }
    points *= difficulty.multiplier;
    final streakSteps = min(max(streakBefore, 0), maxStreakBonusSteps);
    points *= 1 + streakSteps * streakBonusPerStep;
    if (usedHint) {
      points *= hintPenaltyFactor;
    }
    return max(1, points.round());
  }

  /// XP earned for a finished game.
  int xpForGame({
    required int score,
    required int correctAnswers,
    bool dailyBonus = false,
  }) {
    return score ~/ 10 + correctAnswers * 2 + (dailyBonus ? 25 : 0);
  }
}
