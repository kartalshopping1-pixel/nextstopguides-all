import 'dart:math';

import '../entities/continent.dart';
import '../entities/difficulty.dart';
import '../entities/game_mode.dart';
import '../entities/game_result.dart';
import '../entities/question.dart';
import 'question_generator.dart';
import 'scoring.dart';

class AnswerResult {
  const AnswerResult({
    required this.selectedIndex,
    required this.correctIndex,
    required this.isCorrect,
    required this.points,
  });

  final int selectedIndex;
  final int correctIndex;
  final bool isCorrect;
  final int points;
}

/// The state machine of one game (round). Pure Dart - the Flutter
/// GameController only wraps it and notifies the UI.
class GameSession {
  GameSession({
    required this.mode,
    required this.difficulty,
    required QuestionGenerator generator,
    ScoreCalculator scoring = const ScoreCalculator(),
    Random? random,
  })  : _generator = generator,
        _scoring = scoring,
        _random = random ?? Random(),
        _lives = mode.startingLives {
    _current = _generator.next(mode, difficulty);
    _questionIds.add(_current.id);
  }

  final GameMode mode;
  final Difficulty difficulty;
  final QuestionGenerator _generator;
  final ScoreCalculator _scoring;

  /// Only used for hint elimination, never for question generation, so the
  /// Daily Challenge questions stay identical whether hints are used or not.
  final Random _random;

  late Question _current;
  int _lives;
  int _score = 0;
  int _streak = 0;
  int _bestStreak = 0;
  int _correct = 0;
  int _answered = 0;
  int _hintsUsed = 0;
  int _cluesRevealed = 1;
  bool _hintUsedOnCurrent = false;
  bool _extraLifeUsed = false;
  final Set<int> _eliminated = <int>{};
  final Map<Continent, int> _continentCorrect = <Continent, int>{};
  final List<String> _questionIds = <String>[];
  AnswerResult? _lastResult;

  Question get current => _current;
  int get lives => _lives;
  int get score => _score;
  int get streak => _streak;
  int get bestStreak => _bestStreak;
  int get correctCount => _correct;
  int get answeredCount => _answered;
  int get hintsUsed => _hintsUsed;
  int get cluesRevealed => _cluesRevealed;
  bool get extraLifeUsed => _extraLifeUsed;
  Set<int> get eliminated => Set.unmodifiable(_eliminated);
  AnswerResult? get lastResult => _lastResult;

  int? get totalQuestions => mode.questionCount;

  /// 1-based number of the question currently shown.
  int get questionNumber => _answered + (isAnswered ? 0 : 1);

  bool get isAnswered => _lastResult != null;

  bool get isOver {
    if (mode.hasLives && _lives <= 0) {
      return true;
    }
    final total = totalQuestions;
    return total != null && _answered >= total;
  }

  bool get canRevealClue =>
      !isAnswered && _current.isClueBased && _cluesRevealed < _current.clues.length;

  /// A hint removes some wrong options; at least one wrong option must remain.
  bool get canUseHint =>
      !isAnswered && !_hintUsedOnCurrent && _remainingWrongOptions().length >= 2;

  void revealClue() {
    if (canRevealClue) {
      _cluesRevealed++;
    }
  }

  /// Removes about half of the remaining wrong options. Returns the removed
  /// option indexes.
  List<int> useHint() {
    if (!canUseHint) {
      throw StateError('A hint cannot be used right now.');
    }
    final wrong = _remainingWrongOptions()..shuffle(_random);
    final removeCount = max(1, wrong.length ~/ 2);
    final removed = wrong.take(removeCount).toList();
    _eliminated.addAll(removed);
    _hintUsedOnCurrent = true;
    _hintsUsed++;
    return removed;
  }

  AnswerResult answer(int index) {
    if (isAnswered) {
      throw StateError('This question was already answered.');
    }
    if (index < 0 || index >= _current.options.length) {
      throw RangeError.index(index, _current.options, 'index');
    }
    final correct = _current.isCorrect(index);
    final points = _scoring.pointsFor(
      correct: correct,
      difficulty: difficulty,
      streakBefore: _streak,
      cluesRevealed: _current.isClueBased ? _cluesRevealed : 0,
      totalClues: _current.clues.length,
      usedHint: _hintUsedOnCurrent,
    );
    _answered++;
    if (correct) {
      _correct++;
      _streak++;
      _bestStreak = max(_bestStreak, _streak);
      _score += points;
      final continent = _current.continent;
      if (continent != null) {
        _continentCorrect[continent] = (_continentCorrect[continent] ?? 0) + 1;
      }
    } else {
      _streak = 0;
      if (mode.hasLives) {
        _lives = max(0, _lives - 1);
      }
    }
    final result = AnswerResult(
      selectedIndex: index,
      correctIndex: _current.correctIndex,
      isCorrect: correct,
      points: points,
    );
    _lastResult = result;
    return result;
  }

  /// Moves to the next question.
  void next() {
    if (!isAnswered) {
      throw StateError('Answer the current question first.');
    }
    if (isOver) {
      throw StateError('The game is over.');
    }
    _current = _generator.next(mode, difficulty);
    _questionIds.add(_current.id);
    _cluesRevealed = 1;
    _hintUsedOnCurrent = false;
    _eliminated.clear();
    _lastResult = null;
  }

  /// Survival only: continue with one more life (e.g. after a rewarded ad).
  void addExtraLife() {
    if (!mode.hasLives) {
      return;
    }
    _lives++;
    _extraLifeUsed = true;
  }

  GameOutcome toOutcome() => GameOutcome(
        mode: mode,
        difficulty: difficulty,
        score: _score,
        correct: _correct,
        answered: _answered,
        bestStreak: _bestStreak,
        continentCorrect: Map.unmodifiable(_continentCorrect),
        questionIds: List.unmodifiable(_questionIds),
        hintsUsed: _hintsUsed,
      );

  List<int> _remainingWrongOptions() => [
        for (var i = 0; i < _current.options.length; i++)
          if (i != _current.correctIndex && !_eliminated.contains(i)) i,
      ];
}
