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
/// Language: every text in a question (subject, options, clues, fun fact)
/// uses [languageCode] ('en' or 'tr'), falling back to English when a
/// translation is missing. Which subjects are picked never depends on the
/// language, so the Daily Challenge is the same for every player.
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
    this.languageCode = 'en',
  })  : _countries = List.unmodifiable(countries),
        _cities = List.unmodifiable(cities),
        _random = random ?? Random(),
        _recent = recentlySeen.toSet(),
        _countryByCode = {for (final c in countries) c.code: c};

  /// Deterministic generator for the Daily Challenge: same date -> same
  /// questions for every player on every platform (and in every language).
  factory QuestionGenerator.daily({
    required List<Country> countries,
    required List<City> cities,
    required DateTime date,
    String languageCode = 'en',
  }) {
    return QuestionGenerator(
      countries: countries,
      cities: cities,
      random: SeededRandom(DayKey.seedOf(date)),
      languageCode: languageCode,
    );
  }

  /// Language of the generated texts: 'en' or 'tr'.
  final String languageCode;

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

  /// Progressive clues for a country, hardest first, in [languageCode].
  /// Any clue that would reveal the name (e.g. "Singapore dollar" /
  /// "Singapur doları") is masked: "••• dollar" / "••• doları".
  List<Clue> buildClues(Country country) {
    final lang = languageCode;
    final secrets = [country.nameIn(lang), ...country.aliasesIn(lang)];
    String hide(String value) => TextUtils.maskAll(value, secrets);
    bool safe(String value) => !secrets.any((s) => TextUtils.leaks(value, s));
    final languages = country.languagesIn(lang);
    final currency = country.currencyIn(lang);
    final landmarks = country.landmarksIn(lang);
    final safeLandmarks = landmarks.where(safe).toList();
    return [
      Clue(ClueType.continent, country.continent.name),
      if (country.population.isNotEmpty)
        Clue(ClueType.population, country.population),
      if (languages.isNotEmpty)
        Clue(ClueType.language, hide(languages.join(', '))),
      if (currency.isNotEmpty) Clue(ClueType.currency, hide(currency)),
      if (safeLandmarks.isNotEmpty)
        Clue(
          ClueType.landmark,
          safeLandmarks[_random.nextInt(safeLandmarks.length)],
        )
      else if (landmarks.isNotEmpty)
        Clue(ClueType.landmark, hide(landmarks.first)),
      Clue(ClueType.capital, hide(country.capitalIn(lang))),
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
      _name(country),
      _distractorCountries(country, d, sameContinentFirst: true).map(_name),
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
      funFact: country.funFactIn(languageCode),
      displayEmoji: '🧭',
    );
  }

  Question? _capitalOfCountry(Difficulty d) {
    const type = QuestionType.capitalOfCountry;
    final candidates = _countryPool(d).where(_capitalIsSafe).toList();
    final country = _pickFresh(candidates, (c) => questionId(type, c.code));
    if (country == null) {
      return null;
    }
    final built = _buildOptions(
      _capital(country),
      _distractorCountries(country, d, sameContinentFirst: d.preferSameContinent)
          .map(_capital),
      d.optionCount,
    );
    return Question(
      id: questionId(type, country.code),
      type: type,
      subject: _name(country),
      options: built.options,
      correctIndex: built.correctIndex,
      continent: country.continent,
      funFact: country.funFactIn(languageCode),
      displayEmoji: country.flag,
    );
  }

  Question? _countryOfCapital(Difficulty d) {
    const type = QuestionType.countryOfCapital;
    final candidates = _countryPool(d).where(_capitalIsSafe).toList();
    final country = _pickFresh(candidates, (c) => questionId(type, c.code));
    if (country == null) {
      return null;
    }
    final built = _buildOptions(
      _name(country),
      _distractorCountries(country, d, sameContinentFirst: d.preferSameContinent)
          .map(_name),
      d.optionCount,
    );
    return Question(
      id: questionId(type, country.code),
      type: type,
      subject: _capital(country),
      options: built.options,
      correctIndex: built.correctIndex,
      continent: country.continent,
      funFact: country.funFactIn(languageCode),
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
      _name(country),
      _distractorCountries(country, d, sameContinentFirst: d.preferSameContinent)
          .map(_name),
      d.optionCount,
    );
    return Question(
      id: questionId(type, country.code),
      type: type,
      subject: country.flag,
      options: built.options,
      correctIndex: built.correctIndex,
      continent: country.continent,
      funFact: country.funFactIn(languageCode),
      displayEmoji: country.flag,
    );
  }

  Question? _cityFromLandmark(Difficulty d) {
    const type = QuestionType.cityFromLandmark;
    // A usable landmark must exist in English (keeps the pool the same in
    // every language) and in the current language (the one shown).
    final candidates = _cityPool(d)
        .where((c) =>
            _safeLandmarks(c, 'en').isNotEmpty &&
            _safeLandmarks(c, languageCode).isNotEmpty)
        .toList();
    final city = _pickFresh(candidates, (c) => questionId(type, c.id));
    if (city == null) {
      return null;
    }
    final usable = _safeLandmarks(city, languageCode);
    final landmark = usable[_random.nextInt(usable.length)];
    final built = _buildOptions(
      _cityName(city),
      _distractorCities(city, d).map(_cityName),
      d.optionCount,
    );
    return Question(
      id: questionId(type, city.id),
      type: type,
      subject: landmark,
      options: built.options,
      correctIndex: built.correctIndex,
      continent: _countryByCode[city.countryCode]?.continent,
      funFact: city.funFactIn(languageCode),
      displayEmoji: '📍',
    );
  }

  Question? _countryOfCity(Difficulty d) {
    const type = QuestionType.countryOfCity;
    final candidates = _cityPool(d)
        .where((c) =>
            !TextUtils.related(c.name, c.countryName) &&
            !TextUtils.related(_cityName(c), _countryNameOfCity(c)))
        .toList();
    final city = _pickFresh(candidates, (c) => questionId(type, c.id));
    if (city == null) {
      return null;
    }
    final country = _countryByCode[city.countryCode];
    final distractors = country != null
        ? _distractorCountries(country, d,
                sameContinentFirst: d.preferSameContinent)
            .map(_name)
        : ([..._countries]..shuffle(_random))
            .where((c) => c.code != city.countryCode)
            .map(_name);
    final built =
        _buildOptions(_countryNameOfCity(city), distractors, d.optionCount);
    return Question(
      id: questionId(type, city.id),
      type: type,
      subject: _cityName(city),
      options: built.options,
      correctIndex: built.correctIndex,
      continent: country?.continent,
      funFact: city.funFactIn(languageCode),
      displayEmoji: '🏙️',
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _name(Country c) => c.nameIn(languageCode);

  String _capital(Country c) => c.capitalIn(languageCode);

  String _cityName(City c) => c.nameIn(languageCode);

  /// Country name of [city], taken from the country list when possible so it
  /// always matches the option texts.
  String _countryNameOfCity(City city) =>
      _countryByCode[city.countryCode]?.nameIn(languageCode) ??
      city.countryNameIn(languageCode);

  /// Capital questions skip countries whose capital gives the name away
  /// (e.g. Singapore, Kuwait City / Kuveyt) in English or in the current
  /// language, so the pool is the same in every language.
  bool _capitalIsSafe(Country c) =>
      c.capital.isNotEmpty &&
      !TextUtils.related(c.capital, c.name) &&
      !TextUtils.related(_capital(c), _name(c));

  /// Landmarks of [city] in [lang] that do not contain the city's name.
  List<String> _safeLandmarks(City city, String lang) {
    final name = city.nameIn(lang);
    return city
        .landmarksIn(lang)
        .where((l) => !TextUtils.leaks(l, name))
        .toList();
  }

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

  /// Turkish-aware, case-insensitive key used to keep options unique.
  static String _normalize(String value) => TextUtils.fold(value.trim());
}
