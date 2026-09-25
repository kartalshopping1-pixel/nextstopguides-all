import 'continent.dart';

enum QuestionType {
  countryFromClues,
  capitalOfCountry,
  countryOfCapital,
  flagToCountry,
  cityFromLandmark,
  countryOfCity,
}

/// Clue kinds for "Guess the Country", ordered from hardest to easiest.
enum ClueType { continent, population, language, currency, landmark, capital, flag }

class Clue {
  const Clue(this.type, this.value);

  final ClueType type;

  /// For [ClueType.continent] this is a Continent enum name (localized by UI).
  final String value;
}

/// A single generated question. The UI builds the localized prompt from
/// [type] + [subject] (see AppStrings.prompt).
class Question {
  const Question({
    required this.id,
    required this.type,
    required this.subject,
    required this.options,
    required this.correctIndex,
    this.clues = const [],
    this.continent,
    this.funFact = '',
    this.displayEmoji,
  });

  /// Stable id such as "flagToCountry:TR" - used to avoid repeats.
  final String id;
  final QuestionType type;

  /// Text inserted into the prompt (country, capital, landmark, city...).
  final String subject;
  final List<String> options;
  final int correctIndex;

  /// Progressive clues (only for QuestionType.countryFromClues).
  final List<Clue> clues;

  /// Continent of the answer - used for passport stamps.
  final Continent? continent;

  /// Shown after answering.
  final String funFact;

  /// Big emoji shown above the prompt (e.g. the flag in the Flag Quiz).
  final String? displayEmoji;

  String get correctAnswer => options[correctIndex];

  bool isCorrect(int index) => index == correctIndex;

  bool get isClueBased => clues.isNotEmpty;
}
