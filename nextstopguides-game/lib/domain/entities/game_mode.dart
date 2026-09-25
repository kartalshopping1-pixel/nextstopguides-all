import '../../core/constants/app_constants.dart';

enum GameMode {
  guessCountry('🧭'),
  capitalQuiz('🏛️'),
  flagQuiz('🚩'),
  landmarkCity('🗼'),
  survival('❤️'),
  daily('📅');

  const GameMode(this.emoji);

  final String emoji;

  /// Number of questions in a round, or null for endless (Survival).
  int? get questionCount =>
      this == GameMode.survival ? null : AppConstants.questionsPerRound;

  bool get hasLives => this == GameMode.survival;

  int get startingLives => hasLives ? AppConstants.survivalLives : 0;

  /// The Daily Challenge is always played on medium so scores are comparable.
  bool get usesFixedDifficulty => this == GameMode.daily;
}
