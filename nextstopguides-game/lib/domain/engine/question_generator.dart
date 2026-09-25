import 'dart:math';

import '../../core/utils/day_key.dart';
import '../../core/utils/seeded_random.dart';
import '../../core/utils/text_utils.dart';
import '../entities/city.dart';
import '../entities/continent.dart';
import '../entities/country.dart';
import '../entities/difficulty.dart';
import '../entities/game_mode.dart';
import '../entities/question.dart';

/// Builds random questions from the travel database.
///
/// Pure Dart: no Flutter imports, so it is easy to unit test
/// (see test/domain/question_generator_test.dart).
///
/// Repeat avoidance works on two levels:
/// 1. inside one game a question id is never used twice while fresh ones exist;
/// 2. ids passed in `recentlySeen` (remembered from earlier games) are skipped
///    while there are other candidates left.
class QuestionGenerator {
  QuestionGenerator({
    required List<Country> countries,
    required List<City> cities,
    Random? random,
    Iterable<String> recentlySeen = const [],
  })  : _countries = List.unmodifiable(countries),
        _cities = List.unmodifiable(cities),
        _random = random ?? Random(),
        _recent = recentlySeen.toSet(),
        _countryByCode = {for (final c in countries) c.code: c};

  /// Deterministic generator for the Daily Challenge: same date -> same
  /// questions for every player on every platform.
  factory QuestionGenerator.daily({
    required List<Country> countries,
    required List<City> cities,
    required DateTime date,
  }) {
    return QuestionGenerator(
      countries: countries,
      cities: cities,
      random: SeededRandom(DayKey.seedOf(date)),
    );
  }

  final List<Country> _countries;
  final List<City> _cities;
  final Random _random;
  final Set<String> _recent;
  final Map<String, Country> _countryByCode;
  final Set<String> _sessionSeen = <String>{};

  Set<String> get sessionSeenIds => Set.unmodifiable(_sessionSeen);

  static String questionId(QuestionType type, String subjectId) =>
      '${type.name}:$subjectId';

  /// Which question types a mode uses. Duplicates act as weights.
  static List<QuestionType> typesFor(GameMode mode, Difficulty difficulty) {
    return switch (mode) {
      GameMode.guessCountry => const [QuestionType.countryFromClues],
      GameMode.capitalQuiz => difficulty == Difficulty.easy
          ? const [QuestionType.capitalOfCountry]
          : const [
              QuestionType.capitalOfCountry,
              QuestionType.capitalOfCountry,
              QuestionType.countryOfCapital,
            ],
      GameMode.flagQuiz => const [QuestionType.flagToCountry],
      GameMode.landmarkCity => const [
          QuestionType.cityFromLandmark,
          QuestionType.cityFromLandmark,
          QuestionType.countryOfCity,
        ],
      GameMode.survival => const [
          QuestionType.capitalOfCountry,
          QuestionType.countryOfCapital,
          QuestionType.flagToCountry,
          QuestionType.flagToCountry,
          QuestionType.cityFromLandmark,
          QuestionType.countryOfCity,
        ],
      GameMode.daily => const [
          QuestionType.countryFromClues,
          QuestionType.capitalOfCountry,
          QuestionType.flagToCountry,
          QuestionType.cityFromLandmark,
          QuestionType.countryOfCity,
          QuestionType.countryOfCapital,
        ],
    };
  }

  /// Next question for [mode]. Throws [StateError] if the data set is empty.
  Question next(GameMode mode, Difficulty difficulty) {
    final types = [...typesFor(mode, difficulty)]..shuffle(_random);
    for (final type in types) {
      final question = generate(type, difficulty);
      if (question != null) {
        _sessionSeen.add(question.id);
        return question;
      }
    }
    throw StateError(
      'Not enough travel data to build a question for ${mode.name}.',
    );
  }

  /// Builds [count] questions in a row.
  List<Question> generateSet(GameMode mode, Difficulty difficulty, int count) =>
      [for (var i = 0; i < count; i++) next(mode, difficulty)];

  /// Builds one question of [type], or null if no suitable data exists.
  Question? generate(QuestionType type, Difficulty difficulty) {
    return switch (type) {
      QuestionType.countryFromClues => _countryFromClues(difficulty),
      QuestionType.capitalOfCountry => _capitalOfCountry(difficulty),
      QuestionType.countryOfCapital => _countryOfCapital(difficulty),
      QuestionType.flagToCountry => _flagToCountry(difficulty),
      QuestionType.cityFromLandmark => _cityFromLandmark(difficulty),
      QuestionType.countryOfCity => _countryOfCity(difficulty),
    };
  }

  /// Progressive clues for a country, hardest first. Any clue that would
  /// reveal the name (e.g. "Singapore dollar") is masked.
  List<Clue> buildClues(Country country) {
    String hide(String value) => TextUtils.mask(value, country.name);
    final safeLandmarks =
        country.landmarks.where((l) => !TextUtils.leaks(l, country.name)).toList();
    return [
      Clue(ClueType.continent, country.continent.name),
      if (country.population.isNotEmpty)
        Clue(ClueType.population, country.population),
      if (country.languages.isNotEmpty)
        Clue(ClueType.language, hide(country.languages.join(', '))),
      if (country.currency.isNotEmpty)
        Clue(ClueType.currency, hide(country.currency)),
      if (safeLandmarks.isNotEmpty)
        Clue(
          ClueType.landmark,
          safeLandmarks[_random.nextInt(safeLandmarks.length)],
        )
      else if (country.landmarks.isNotEmpty)
        Clue(ClueType.landmark, hide(country.landmarks.first)),
      Clue(ClueType.capital, hide(country.capital)),
      Clue(ClueType.flag, country.flag),
    ];
  }

  // ---------------------------------------------------------------------------
  // Question builders
  // ---------------------------------------------------------------------------

  Question? _countryFromClues(Difficulty d) {
    const type = QuestionType.countryFromClues;
    final country =
        _pickFresh(_countryPool(d), (c) => questionId(type, c.code));
    if (country == null) {
      return null;
    }
    final built = _buildOptions(
      country.name,
      _distractorCountries(country, d, sameContinentFirst: true)
          .map((c) => c.name),
      d.clueOptionCount,
    );
    return Question(
      id: questionId(type, country.code),
      type: type,
      subject: '',
      options: built.options,
      correctIndex: built.correctIndex,
      clues: buildClues(country),
      continent: country.continent,
      funFact: country.funFact,
      displayEmoji: '🧭',
    );
  }

  Question? _capitalOfCountry(Difficulty d) {
    const type = QuestionType.capitalOfCountry;
    final candidates = _countryPool(d)
        .where((c) => c.capital.isNotEmpty && !TextUtils.related(c.capital, c.name))
        .toList();
    final country = _pickFresh(candidates, (c) => questionId(type, c.code));
    if (country == null) {
      return null;
    }
    final built = _buildOptions(
      country.capital,
      _distractorCountries(country, d, sameContinentFirst: d.preferSameContinent)
          .map((c) => c.capital),
      d.optionCount,
    );
    return Question(
      id: questionId(type, country.code),
      type: type,
      subject: country.name,
      options: built.options,
      correctIndex: built.correctIndex,
      continent: country.continent,
      funFact: country.funFact,
      displayEmoji: country.flag,
    );
  }

  Question? _countryOfCapital(Difficulty d) {
    const type = QuestionType.countryOfCapital;
    final candidates = _countryPool(d)
        .where((c) => c.capital.isNotEmpty && !TextUtils.related(c.capital, c.name))
        .toList();
    final country = _pickFresh(candidates, (c) => questionId(type, c.code));
    if (country == null) {
      return null;
    }
    final built = _buildOptions(
      country.name,
      _distractorCountries(country, d, sameContinentFirst: d.preferSameContinent)
          .map((c) => c.name),
      d.optionCount,
    );
    return Question(
      id: questionId(type, country.code),
      type: type,
      subject: country.capital,
      options: built.options,
      correctIndex: built.correctIndex,
      continent: country.continent,
      funFact: country.funFact,
      displayEmoji: '🏛️',
    );
  }

  Question? _flagToCountry(Difficulty d) {
    const type = QuestionType.flagToCountry;
    final candidates =
        _countryPool(d).where((c) => c.flag.isNotEmpty).toList();
    final country = _pickFresh(candidates, (c) => questionId(type, c.code));
    if (country == null) {
      return null;
    }
    final built = _buildOptions(
      country.name,
      _distractorCountries(country, d, sameContinentFirst: d.preferSameContinent)
          .map((c) => c.name),
      d.optionCount,
    );
    return Question(
      id: questionId(type, country.code),
      type: type,
      subject: country.flag,
      options: built.options,
      correctIndex: built.correctIndex,
      continent: country.continent,
      funFact: country.funFact,
      displayEmoji: country.flag,
    );
  }

  Question? _cityFromLandmark(Difficulty d) {
    const type = QuestionType.cityFromLandmark;
    final candidates = _cityPool(d)
        .where((c) => c.landmarks.any((l) => !TextUtils.leaks(l, c.name)))
        .toList();
    final city = _pickFresh(candidates, (c) => questionId(type, c.id));
    if (city == null) {
      return null;
    }
    final usable =
        city.landmarks.where((l) => !TextUtils.leaks(l, city.name)).toList();
    final landmark = usable[_random.nextInt(usable.length)];
    final built = _buildOptions(
      city.name,
      _distractorCities(city, d).map((c) => c.name),
      d.optionCount,
    );
    return Question(
      id: questionId(type, city.id),
      type: type,
      subject: landmark,
      options: built.options,
      correctIndex: built.correctIndex,
      continent: _countryByCode[city.countryCode]?.continent,
      funFact: city.funFact,
      displayEmoji: '📍',
    );
  }

  Question? _countryOfCity(Difficulty d) {
    const type = QuestionType.countryOfCity;
    final candidates = _cityPool(d)
        .where((c) => !TextUtils.related(c.name, c.countryName))
        .toList();
    final city = _pickFresh(candidates, (c) => questionId(type, c.id));
    if (city == null) {
      return null;
    }
    final country = _countryByCode[city.countryCode];
    final distractors = country != null
        ? _distractorCountries(country, d,
                sameContinentFirst: d.preferSameContinent)
            .map((c) => c.name)
        : ([..._countries]..shuffle(_random))
            .where((c) => c.code != city.countryCode)
            .map((c) => c.name);
    final built = _buildOptions(city.countryName, distractors, d.optionCount);
    return Question(
      id: questionId(type, city.id),
      type: type,
      subject: city.name,
      options: built.options,
      correctIndex: built.correctIndex,
      continent: country?.continent,
      funFact: city.funFact,
      displayEmoji: '🏙️',
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  List<Country> _countryPool(Difficulty d) =>
      _countries.where((c) => c.tier <= d.maxTier).toList();

  List<City> _cityPool(Difficulty d) =>
      _cities.where((c) => c.tier <= d.maxTier).toList();

  Continent? _continentOfCity(City city) =>
      _countryByCode[city.countryCode]?.continent;

  /// Picks a random candidate, preferring ones not seen in this game and not
  /// seen recently.
  T? _pickFresh<T>(List<T> candidates, String Function(T item) idOf) {
    if (candidates.isEmpty) {
      return null;
    }
    bool unseenThisGame(T item) => !_sessionSeen.contains(idOf(item));

    final fresh = candidates
        .where((item) => unseenThisGame(item) && !_recent.contains(idOf(item)))
        .toList();
    if (fresh.isNotEmpty) {
      return fresh[_random.nextInt(fresh.length)];
    }
    final notThisGame = candidates.where(unseenThisGame).toList();
    if (notThisGame.isNotEmpty) {
      return notThisGame[_random.nextInt(notThisGame.length)];
    }
    return candidates[_random.nextInt(candidates.length)];
  }

  /// Wrong-answer countries in the order they should be used.
  List<Country> _distractorCountries(
    Country answer,
    Difficulty d, {
    required bool sameContinentFirst,
  }) {
    final pool = _countries
        .where((c) => c.code != answer.code && c.tier <= d.maxTier)
        .toList()
      ..shuffle(_random);
    if (!sameContinentFirst) {
      return pool;
    }
    return [
      ...pool.where((c) => c.continent == answer.continent),
      ...pool.where((c) => c.continent != answer.continent),
    ];
  }

  List<City> _distractorCities(City answer, Difficulty d) {
    final pool = _cities
        .where((c) => c.id != answer.id && c.tier <= d.maxTier)
        .toList()
      ..shuffle(_random);
    if (!d.preferSameContinent) {
      return pool;
    }
    final continent = _continentOfCity(answer);
    return [
      ...pool.where((c) => _continentOfCity(c) == continent),
      ...pool.where((c) => _continentOfCity(c) != continent),
    ];
  }

  /// Combines the correct answer with unique distractors and shuffles them.
  ({List<String> options, int correctIndex}) _buildOptions(
    String correct,
    Iterable<String> distractors,
    int count,
  ) {
    final seen = <String>{_normalize(correct)};
    final wrong = <String>[];
    for (final candidate in distractors) {
      if (wrong.length >= count - 1) {
        break;
      }
      if (candidate.trim().isEmpty) {
        continue;
      }
      if (seen.add(_normalize(candidate))) {
        wrong.add(candidate);
      }
    }
    final options = [correct, ...wrong]..shuffle(_random);
    return (
      options: List<String>.unmodifiable(options),
      correctIndex: options.indexOf(correct),
    );
  }

  static String _normalize(String value) => value.trim().toLowerCase();
}
