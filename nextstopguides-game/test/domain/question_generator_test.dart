import 'package:flutter_test/flutter_test.dart';
import 'package:nextstopguides_game/core/utils/seeded_random.dart';
import 'package:nextstopguides_game/core/utils/text_utils.dart';
import 'package:nextstopguides_game/domain/engine/question_generator.dart';
import 'package:nextstopguides_game/domain/entities/continent.dart';
import 'package:nextstopguides_game/domain/entities/difficulty.dart';
import 'package:nextstopguides_game/domain/entities/game_mode.dart';
import 'package:nextstopguides_game/domain/entities/question.dart';

import '../helpers/fixtures.dart';

QuestionGenerator generator({int seed = 42, Iterable<String> recent = const []}) {
  return QuestionGenerator(
    countries: testCountries,
    cities: testCities,
    random: SeededRandom(seed),
    recentlySeen: recent,
  );
}

void expectValid(Question q) {
  expect(q.options, isNotEmpty);
  expect(q.correctIndex, inInclusiveRange(0, q.options.length - 1));
  final normalized = q.options.map((o) => o.toLowerCase()).toSet();
  expect(normalized.length, q.options.length, reason: 'options must be unique: ${q.options}');
}

void main() {
  group('QuestionGenerator', () {
    test('every mode and difficulty produces valid questions', () {
      for (final mode in GameMode.values) {
        for (final difficulty in Difficulty.values) {
          final gen = generator(seed: mode.index * 10 + difficulty.index + 1);
          for (var i = 0; i < 20; i++) {
            final q = gen.next(mode, difficulty);
            expectValid(q);
            expect(
              QuestionGenerator.typesFor(mode, difficulty),
              contains(q.type),
            );
          }
        }
      }
    });

    test('capital questions have the real capital as correct answer', () {
      final gen = generator();
      for (var i = 0; i < 30; i++) {
        final q = gen.generate(QuestionType.capitalOfCountry, Difficulty.hard)!;
        final country = testCountries.firstWhere((c) => c.name == q.subject);
        expect(q.correctAnswer, country.capital);
        expect(q.options.length, Difficulty.hard.optionCount);
      }
    });

    test('capital questions skip countries whose capital reveals the name', () {
      final gen = generator();
      for (var i = 0; i < 50; i++) {
        final q = gen.generate(QuestionType.capitalOfCountry, Difficulty.hard)!;
        expect(q.subject, isNot(anyOf('Singapore', 'Mexico')));
      }
    });

    test('flag questions show the flag and answer with the country name', () {
      final gen = generator();
      final q = gen.generate(QuestionType.flagToCountry, Difficulty.medium)!;
      final country = testCountries.firstWhere((c) => c.name == q.correctAnswer);
      expect(q.displayEmoji, country.flag);
      expect(q.continent, country.continent);
    });

    test('easy difficulty only uses tier 1 subjects', () {
      final gen = generator();
      for (var i = 0; i < 40; i++) {
        final q = gen.next(GameMode.flagQuiz, Difficulty.easy);
        final country = testCountries.firstWhere((c) => c.name == q.correctAnswer);
        expect(country.tier, 1);
        expect(q.options.length, Difficulty.easy.optionCount);
      }
    });

    test('hard distractors prefer the same continent', () {
      final gen = generator(seed: 7);
      for (var i = 0; i < 20; i++) {
        final q = gen.generate(QuestionType.flagToCountry, Difficulty.hard)!;
        final answer = testCountries.firstWhere((c) => c.name == q.correctAnswer);
        final sameContinent =
            testCountries.where((c) => c.continent == answer.continent).length - 1;
        final wrongOptions = q.options.where((o) => o != q.correctAnswer).map(
              (o) => testCountries.firstWhere((c) => c.name == o),
            );
        final sameCount =
            wrongOptions.where((c) => c.continent == answer.continent).length;
        final expected = sameContinent < wrongOptions.length
            ? sameContinent
            : wrongOptions.length;
        expect(sameCount, expected);
      }
    });

    test('questions do not repeat within a game while fresh ones exist', () {
      final gen = generator();
      final ids = <String>{};
      // 14 fixture countries have tier <= 2, so 14 flag questions are unique.
      for (var i = 0; i < 14; i++) {
        final q = gen.next(GameMode.flagQuiz, Difficulty.medium);
        expect(ids.add(q.id), isTrue, reason: 'repeated ${q.id}');
      }
    });

    test('recently seen questions are avoided', () {
      final recent = testCountries
          .where((c) => c.tier == 1 && c.code != 'JP')
          .map((c) => QuestionGenerator.questionId(QuestionType.flagToCountry, c.code));
      final gen = generator(recent: recent);
      final q = gen.next(GameMode.flagQuiz, Difficulty.easy);
      expect(q.id, QuestionGenerator.questionId(QuestionType.flagToCountry, 'JP'));
    });

    test('falls back to repeats instead of failing when the pool is exhausted', () {
      final gen = generator();
      final questions = gen.generateSet(GameMode.flagQuiz, Difficulty.easy, 50);
      expect(questions.length, 50);
    });

    test('daily generator is deterministic per date', () {
      final date = DateTime(2026, 9, 25);
      List<String> ids(DateTime d) {
        final gen = QuestionGenerator.daily(
          countries: testCountries,
          cities: testCities,
          date: d,
        );
        return gen
            .generateSet(GameMode.daily, Difficulty.medium, 10)
            .map((q) => '${q.id}|${q.options.join(',')}')
            .toList();
      }

      expect(ids(date), ids(DateTime(2026, 9, 25, 23, 59)));
      expect(ids(date), isNot(ids(DateTime(2026, 9, 26))));
    });

    test('clue questions reveal the continent first and the flag last', () {
      final gen = generator();
      final q = gen.generate(QuestionType.countryFromClues, Difficulty.medium)!;
      expect(q.clues.first.type, ClueType.continent);
      expect(q.clues.last.type, ClueType.flag);
      expect(q.options.length, Difficulty.medium.clueOptionCount);
      expect(q.isClueBased, isTrue);
    });

    test('clues never leak the country name', () {
      final gen = generator();
      for (final c in testCountries) {
        final clues = gen.buildClues(c);
        for (final clue in clues.where((cl) => cl.type != ClueType.flag)) {
          expect(
            TextUtils.leaks(clue.value, c.name),
            isFalse,
            reason: '${c.name}: ${clue.type.name} = ${clue.value}',
          );
        }
      }
      final singapore = testCountries.firstWhere((c) => c.code == 'SG');
      final currency =
          gen.buildClues(singapore).firstWhere((c) => c.type == ClueType.currency);
      expect(currency.value, '${TextUtils.maskToken} dollar');
      final china = testCountries.firstWhere((c) => c.code == 'CN');
      final landmark =
          gen.buildClues(china).firstWhere((c) => c.type == ClueType.landmark);
      expect(landmark.value, 'Forbidden City');
    });

    test('landmark questions never contain the city name', () {
      final gen = generator();
      for (var i = 0; i < 40; i++) {
        final q = gen.generate(QuestionType.cityFromLandmark, Difficulty.hard)!;
        expect(TextUtils.leaks(q.subject, q.correctAnswer), isFalse);
        expect(q.correctAnswer, isNot('Only Leaky'));
      }
    });

    test('country-of-city questions skip cities named after their country', () {
      final gen = generator();
      for (var i = 0; i < 40; i++) {
        final q = gen.generate(QuestionType.countryOfCity, Difficulty.hard)!;
        expect(q.subject, isNot(anyOf('Singapore', 'Mexico City')));
        final city = testCities.firstWhere((c) => c.name == q.subject);
        expect(q.correctAnswer, city.countryName);
      }
    });

    test('questions carry the continent for passport stamps', () {
      final gen = generator();
      final q = gen.generate(QuestionType.cityFromLandmark, Difficulty.easy)!;
      expect(q.continent, isA<Continent>());
    });
  });

  group('SeededRandom', () {
    test('same seed gives the same sequence', () {
      final a = SeededRandom(123);
      final b = SeededRandom(123);
      for (var i = 0; i < 100; i++) {
        expect(a.nextInt(1000), b.nextInt(1000));
      }
    });

    test('values stay in range', () {
      final r = SeededRandom(0);
      for (var i = 0; i < 1000; i++) {
        expect(r.nextInt(7), inInclusiveRange(0, 6));
        final d = r.nextDouble();
        expect(d >= 0 && d < 1, isTrue);
      }
    });
  });
}
