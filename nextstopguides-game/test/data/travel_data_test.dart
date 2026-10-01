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
import 'package:nextstopguides_game/domain/entities/question.dart';

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

  group('Turkish data', () {
    test('every country has complete Turkish fields', () {
      expect(countries.map((c) => c.nameTr).toSet().length, countries.length,
          reason: 'Turkish country names must be unique');
      for (final c in countries) {
        expect(c.nameTr.trim(), isNotEmpty, reason: c.name);
        expect(c.capitalTr.trim(), isNotEmpty, reason: c.name);
        expect(c.currencyTr.trim(), isNotEmpty, reason: c.name);
        expect(c.funFactTr.trim(), isNotEmpty, reason: c.name);
        expect(c.languagesTr.length, c.languages.length, reason: c.name);
        expect(c.landmarksTr.length, c.landmarks.length, reason: c.name);
        for (final value in [...c.languagesTr, ...c.landmarksTr]) {
          expect(value.trim(), isNotEmpty, reason: c.name);
        }
      }
    });

    test('every city has complete Turkish fields matching its country', () {
      final byCode = {for (final c in countries) c.code: c};
      for (final city in cities) {
        expect(city.nameTr.trim(), isNotEmpty, reason: city.name);
        expect(city.funFactTr.trim(), isNotEmpty, reason: city.name);
        expect(city.landmarksTr.length, city.landmarks.length, reason: city.name);
        expect(city.countryNameTr, byCode[city.countryCode]!.nameTr,
            reason: city.name);
        expect(
          city.landmarksTr.any((l) => !TextUtils.leaks(l, city.nameTr)),
          isTrue,
          reason: '${city.nameTr} needs a Turkish landmark without its name',
        );
      }
    });

    test('well-known Turkish exonyms are used', () {
      String name(String code) => countries.firstWhere((c) => c.code == code).nameTr;
      String capital(String code) =>
          countries.firstWhere((c) => c.code == code).capitalTr;
      expect([name('EG'), capital('EG')], ['Mısır', 'Kahire']);
      expect([name('DE'), capital('DE')], ['Almanya', 'Berlin']);
      expect([name('JP'), capital('JP')], ['Japonya', 'Tokyo']);
      expect(name('CI'), 'Fildişi Sahili');
      expect([name('NL'), capital('NL')], ['Hollanda', 'Amsterdam']);
      expect([name('NZ'), capital('NZ')], ['Yeni Zelanda', 'Wellington']);
      expect([name('KR'), capital('KR')], ['Güney Kore', 'Seul']);
      expect([name('AE'), capital('AE')], ['Birleşik Arap Emirlikleri', 'Abu Dabi']);
      expect([name('TR'), capital('TR')], ['Türkiye', 'Ankara']);
    });

    test('Turkish questions on the real data never show English-only names', () {
      final englishOnly = {
        for (final c in countries) c.name,
        for (final c in countries) c.capital,
        for (final c in cities) c.name,
      }.difference({
        for (final c in countries) c.nameTr,
        for (final c in countries) c.capitalTr,
        for (final c in cities) c.nameTr,
      });
      for (final mode in GameMode.values) {
        for (final difficulty in Difficulty.values) {
          final gen = QuestionGenerator(
            countries: countries,
            cities: cities,
            languageCode: 'tr',
          );
          for (final q in gen.generateSet(mode, difficulty, 25)) {
            for (final text in [q.subject, ...q.options]) {
              expect(englishOnly.contains(text), isFalse,
                  reason: '${q.id}: "$text"');
            }
            for (final clue in q.clues) {
              expect(englishOnly.contains(clue.value), isFalse,
                  reason: '${q.id}: clue "${clue.value}"');
            }
          }
        }
      }
    });

    test('Turkish clues on the real data never reveal the country', () {
      final gen = QuestionGenerator(
        countries: countries,
        cities: cities,
        languageCode: 'tr',
      );
      for (final c in countries) {
        for (final clue in gen.buildClues(c)) {
          if (clue.type == ClueType.flag) {
            continue;
          }
          expect(TextUtils.leaks(clue.value, c.nameTr), isFalse,
              reason: '${c.nameTr}: ${clue.type.name} = ${clue.value}');
          for (final alias in c.aliasesTr) {
            expect(TextUtils.leaks(clue.value, alias), isFalse,
                reason: '${c.nameTr}: ${clue.value}');
          }
        }
      }
      final currency = gen
          .buildClues(countries.firstWhere((c) => c.code == 'EG'))
          .firstWhere((c) => c.type == ClueType.currency);
      expect(currency.value, '${TextUtils.maskToken} lirası');
    });
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
