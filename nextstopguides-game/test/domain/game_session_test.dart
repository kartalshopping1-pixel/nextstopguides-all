import 'package:flutter_test/flutter_test.dart';
import 'package:nextstopguides_game/core/utils/seeded_random.dart';
import 'package:nextstopguides_game/domain/engine/game_session.dart';
import 'package:nextstopguides_game/domain/engine/question_generator.dart';
import 'package:nextstopguides_game/domain/entities/difficulty.dart';
import 'package:nextstopguides_game/domain/entities/game_mode.dart';

import '../helpers/fixtures.dart';

GameSession newSession(GameMode mode, {Difficulty difficulty = Difficulty.medium}) {
  return GameSession(
    mode: mode,
    difficulty: difficulty,
    generator: QuestionGenerator(
      countries: testCountries,
      cities: testCities,
      random: SeededRandom(99),
    ),
    random: SeededRandom(5),
  );
}

int wrongIndex(GameSession s) => s.current.correctIndex == 0 ? 1 : 0;

void main() {
  test('a classic round ends after 10 questions', () {
    final s = newSession(GameMode.capitalQuiz);
    var answered = 0;
    while (true) {
      s.answer(s.current.correctIndex);
      answered++;
      if (s.isOver) {
        break;
      }
      s.next();
    }
    expect(answered, 10);
    expect(s.correctCount, 10);
    expect(s.bestStreak, 10);
    expect(s.score, greaterThan(0));
    expect(() => s.next(), throwsStateError);
  });

  test('survival ends after three wrong answers', () {
    final s = newSession(GameMode.survival);
    expect(s.lives, 3);
    s.answer(wrongIndex(s));
    expect(s.lives, 2);
    expect(s.streak, 0);
    s.next();
    s.answer(s.current.correctIndex);
    expect(s.lives, 2);
    s.next();
    s.answer(wrongIndex(s));
    s.next();
    s.answer(wrongIndex(s));
    expect(s.lives, 0);
    expect(s.isOver, isTrue);
  });

  test('an extra life lets survival continue once', () {
    final s = newSession(GameMode.survival);
    for (var i = 0; i < 3; i++) {
      s.answer(wrongIndex(s));
      if (!s.isOver) {
        s.next();
      }
    }
    expect(s.isOver, isTrue);
    s.addExtraLife();
    expect(s.extraLifeUsed, isTrue);
    expect(s.isOver, isFalse);
    s.next();
    expect(s.isAnswered, isFalse);
  });

  test('answering twice is not allowed', () {
    final s = newSession(GameMode.flagQuiz);
    s.answer(0);
    expect(() => s.answer(0), throwsStateError);
  });

  test('hints remove wrong options but never the correct one', () {
    final s = newSession(GameMode.guessCountry, difficulty: Difficulty.hard);
    final optionCount = s.current.options.length;
    expect(s.canUseHint, isTrue);
    final removed = s.useHint();
    expect(removed, isNotEmpty);
    expect(removed, isNot(contains(s.current.correctIndex)));
    expect(optionCount - 1 - removed.length, greaterThanOrEqualTo(1));
    expect(s.canUseHint, isFalse);
    expect(s.hintsUsed, 1);
  });

  test('revealing clues lowers the points', () {
    final a = newSession(GameMode.guessCountry);
    final b = newSession(GameMode.guessCountry);
    b.revealClue();
    b.revealClue();
    expect(b.cluesRevealed, 3);
    final pa = a.answer(a.current.correctIndex).points;
    final pb = b.answer(b.current.correctIndex).points;
    expect(pa, greaterThan(pb));
  });

  test('outcome contains continents and question ids', () {
    final s = newSession(GameMode.flagQuiz);
    s.answer(s.current.correctIndex);
    final outcome = s.toOutcome();
    expect(outcome.correct, 1);
    expect(outcome.answered, 1);
    expect(outcome.questionIds, hasLength(1));
    expect(outcome.continentCorrect.values.fold<int>(0, (a, b) => a + b), 1);
  });
}
