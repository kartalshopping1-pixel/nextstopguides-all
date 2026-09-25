import 'continent.dart';
import 'difficulty.dart';
import 'game_mode.dart';
import 'passport_stamp.dart';

/// Raw result of a finished game session (input for ProgressCalculator).
class GameOutcome {
  const GameOutcome({
    required this.mode,
    required this.difficulty,
    required this.score,
    required this.correct,
    required this.answered,
    required this.bestStreak,
    this.continentCorrect = const {},
    this.questionIds = const [],
    this.hintsUsed = 0,
  });

  final GameMode mode;
  final Difficulty difficulty;
  final int score;
  final int correct;
  final int answered;
  final int bestStreak;
  final Map<Continent, int> continentCorrect;
  final List<String> questionIds;
  final int hintsUsed;
}

/// What the results screen shows after progress was updated.
class GameSummary {
  const GameSummary({
    required this.mode,
    required this.difficulty,
    required this.score,
    required this.correct,
    required this.answered,
    required this.bestStreak,
    required this.xpGained,
    required this.previousLevel,
    required this.newLevel,
    required this.isNewHighScore,
    required this.hintsEarned,
    required this.stampsUnlocked,
    required this.isDailyPractice,
    required this.dailyStreak,
  });

  final GameMode mode;
  final Difficulty difficulty;
  final int score;
  final int correct;
  final int answered;
  final int bestStreak;
  final int xpGained;
  final int previousLevel;
  final int newLevel;
  final bool isNewHighScore;
  final int hintsEarned;
  final List<StampUnlock> stampsUnlocked;

  /// Daily Challenge replayed on the same day: no daily rewards.
  final bool isDailyPractice;
  final int dailyStreak;

  bool get leveledUp => newLevel > previousLevel;

  double get accuracy => answered == 0 ? 0 : correct / answered;
}
