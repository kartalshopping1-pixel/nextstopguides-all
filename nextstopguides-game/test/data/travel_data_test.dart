import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:nextstopguides_game/core/utils/text_utils.dart';
import 'package:nextstopguides_game/data/models/city_model.dart';
import 'package:nextstopguides_game/data/models/country_model.dart';
import 'package:nextstopguides_game/data/models/progress_model.dart';
import 'package:nextstopguides_game/domain/engine/question_generator.dart';
import 'package:nextstopguides_game/domain/entities/city.dart';
import 'package:nextstopguides_game/domain/entities/continent.dart';
import 'package:nextstopguides_game/domain/entities/country.dart';
import 'package:nextstopguides_game/domain/entities/difficulty.dart';
import 'package:nextstopguides_game/domain/entities/game_mode.dart';
import 'package:nextstopguides_game/domain/entities/player_progress.dart';

/// Validates the real JSON assets (run from the project root: flutter test).
void main() {
  late List<Country> countries;
  late List<City> cities;

  setUpAll(() {
    final countriesJson =
        jsonDecode(File('assets/data/countries.json').readAsStringSync()) as List;
    final citiesJson =
        jsonDecode(File('assets/data/cities.json').readAsStringSync()) as List;
    countries = countriesJson
        .cast<Map<String, dynamic>>()
        .map(CountryModel.fromJson)
        .toList();
    cities = citiesJson.cast<Map<String, dynamic>>().map(CityModel.fromJson).toList();
  });

  test('data set is large enough', () {
    expect(countries.length, greaterThanOrEqualTo(120));
    expect(cities.length, greaterThanOrEqualTo(100));
  });

  test('countries have unique codes and names and complete fields', () {
    expect(countries.map((c) => c.code).toSet().length, countries.length);
    expect(countries.map((c) => c.name).toSet().length, countries.length);
    for (final c in countries) {
      expect(c.name, isNotEmpty);
      expect(c.capital, isNotEmpty, reason: c.name);
      expect(c.flag, isNotEmpty, reason: c.name);
      expect(c.currency, isNotEmpty, reason: c.name);
      expect(c.languages, isNotEmpty, reason: c.name);
      expect(c.landmarks, isNotEmpty, reason: c.name);
      expect(c.funFact, isNotEmpty, reason: c.name);
      expect(c.tier, inInclusiveRange(1, 3), reason: c.name);
      expect(
        ['<1M', '1M-10M', '10M-50M', '50M-100M', '100M+'],
        contains(c.population),
        reason: c.name,
      );
    }
  });

  test('every continent is represented', () {
    for (final continent in Continent.values) {
      expect(countries.where((c) => c.continent == continent), isNotEmpty);
    }
  });

  test('every city points to a known country with a matching name', () {
    final byCode = {for (final c in countries) c.code: c};
    expect(cities.map((c) => c.id).toSet().length, cities.length);
    for (final city in cities) {
      final country = byCode[city.countryCode];
      expect(country, isNotNull, reason: city.name);
      expect(country!.name, city.countryName, reason: city.name);
      expect(city.landmarks, isNotEmpty, reason: city.name);
      expect(
        city.landmarks.any((l) => !TextUtils.leaks(l, city.name)),
        isTrue,
        reason: '${city.name} needs a landmark that does not contain its name',
      );
    }
  });

  test('the real data set can generate every mode on every difficulty', () {
    for (final mode in GameMode.values) {
      for (final difficulty in Difficulty.values) {
        final gen = QuestionGenerator(countries: countries, cities: cities);
        final ids = gen
            .generateSet(mode, difficulty, 10)
            .map((q) => q.id)
            .toList();
        expect(ids.toSet().length, 10, reason: '${mode.name}/${difficulty.name}');
      }
    }
  });

  test('progress survives a JSON round trip', () {
    const progress = PlayerProgress(
      xp: 420,
      hints: 7,
      highScores: {GameMode.survival: 1234},
      continentCorrect: {Continent.oceania: 12},
      lastDailyDateKey: '2026-09-25',
      dailyStreak: 3,
      recentQuestionIds: ['flagToCountry:TR'],
      adsRemoved: true,
    );
    final restored = ProgressModel.fromJson(
      jsonDecode(jsonEncode(ProgressModel.toJson(progress))) as Map<String, dynamic>,
    );
    expect(restored.xp, 420);
    expect(restored.hints, 7);
    expect(restored.highScoreFor(GameMode.survival), 1234);
    expect(restored.correctIn(Continent.oceania), 12);
    expect(restored.lastDailyDateKey, '2026-09-25');
    expect(restored.dailyStreak, 3);
    expect(restored.recentQuestionIds, ['flagToCountry:TR']);
    expect(restored.adsRemoved, isTrue);
  });
}
