import 'package:flutter/foundation.dart';

import '../../../core/utils/day_key.dart';
import '../../../domain/engine/progress_calculator.dart';
import '../../../domain/entities/game_result.dart';
import '../../../domain/entities/player_progress.dart';
import '../../../domain/repositories/progress_repository.dart';

/// Holds the player's progress (XP, hints, stamps, high scores) for the
/// whole app and saves every change.
class ProgressController extends ChangeNotifier {
  ProgressController(
    this._repository, {
    ProgressCalculator calculator = const ProgressCalculator(),
    DateTime Function()? clock,
  })  : _calculator = calculator,
        _clock = clock ?? DateTime.now;

  final ProgressRepository _repository;
  final ProgressCalculator _calculator;
  final DateTime Function() _clock;

  PlayerProgress _progress = const PlayerProgress();
  bool _isLoaded = false;

  PlayerProgress get progress => _progress;
  bool get isLoaded => _isLoaded;

  bool get isDailyDoneToday =>
      _progress.lastDailyDateKey == DayKey.of(_clock());

  Future<void> load() async {
    _progress = await _repository.load();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> _update(PlayerProgress next) async {
    _progress = next;
    notifyListeners();
    await _repository.save(next);
  }

  /// Uses one hint. Returns false when the player has none.
  Future<bool> spendHint() async {
    if (_progress.hints <= 0) {
      return false;
    }
    await _update(_progress.copyWith(hints: _progress.hints - 1));
    return true;
  }

  Future<void> addHints(int amount) async {
    if (amount <= 0) {
      return;
    }
    await _update(_progress.copyWith(hints: _progress.hints + amount));
  }

  Future<void> setAdsRemoved(bool removed) =>
      _update(_progress.copyWith(adsRemoved: removed));

  /// Applies a finished game and returns what the results screen shows.
  Future<GameSummary> recordGame(GameOutcome outcome) async {
    final update = _calculator.apply(_progress, outcome, _clock());
    await _update(update.progress);
    return update.summary;
  }

  Future<void> reset() async {
    await _repository.reset();
    _progress = const PlayerProgress();
    notifyListeners();
  }
}
