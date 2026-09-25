import 'package:flutter/foundation.dart';

import '../../../core/config/app_config.dart';
import '../../../domain/engine/game_session.dart';
import '../../../domain/engine/question_generator.dart';
import '../../../domain/entities/difficulty.dart';
import '../../../domain/entities/game_mode.dart';
import '../../../domain/entities/game_result.dart';
import '../../../domain/repositories/travel_repository.dart';
import '../../../services/ads/ads_service.dart';
import '../../../services/analytics/analytics_service.dart';
import '../../profile/state/progress_controller.dart';

enum GameStatus { loading, ready, error }

/// Flutter-side wrapper around the pure [GameSession]: loads data, talks to
/// services (ads, analytics) and notifies the UI.
class GameController extends ChangeNotifier {
  GameController({
    required this.mode,
    required Difficulty difficulty,
    required TravelRepository travelRepository,
    required ProgressController progress,
    required AdsService ads,
    required AnalyticsService analytics,
    required AppConfig config,
    DateTime Function()? clock,
  })  : difficulty = mode.usesFixedDifficulty ? Difficulty.medium : difficulty,
        _travel = travelRepository,
        _progress = progress,
        _ads = ads,
        _analytics = analytics,
        _config = config,
        _clock = clock ?? DateTime.now;

  final GameMode mode;
  final Difficulty difficulty;
  final TravelRepository _travel;
  final ProgressController _progress;
  final AdsService _ads;
  final AnalyticsService _analytics;
  final AppConfig _config;
  final DateTime Function() _clock;

  GameStatus _status = GameStatus.loading;
  GameSession? _session;
  GameSummary? _summary;
  bool _isFinishing = false;
  bool _disposed = false;

  GameStatus get status => _status;
  GameSession? get session => _session;
  bool get isFinishing => _isFinishing;

  Future<void> start() async {
    if (_status != GameStatus.loading) {
      _status = GameStatus.loading;
      _notify();
    }
    try {
      final countries = await _travel.getCountries();
      final cities = await _travel.getCities();
      final generator = mode == GameMode.daily
          ? QuestionGenerator.daily(
              countries: countries,
              cities: cities,
              date: _clock(),
            )
          : QuestionGenerator(
              countries: countries,
              cities: cities,
              recentlySeen: _progress.progress.recentQuestionIds,
            );
      _session = GameSession(
        mode: mode,
        difficulty: difficulty,
        generator: generator,
      );
      _status = GameStatus.ready;
      _analytics.logEvent('game_start', {
        'mode': mode.name,
        'difficulty': difficulty.name,
      });
    } catch (error, stack) {
      debugPrint('Failed to start game: $error\n$stack');
      _status = GameStatus.error;
    }
    _notify();
  }

  void answer(int index) {
    final s = _session;
    if (s == null || s.isAnswered) {
      return;
    }
    s.answer(index);
    _notify();
  }

  void revealClue() {
    final s = _session;
    if (s == null || !s.canRevealClue) {
      return;
    }
    s.revealClue();
    _notify();
  }

  /// Spends one hint from the player's balance. Returns false when the
  /// player has no hints left (UI then points to the shop / playing more).
  Future<bool> useHint() async {
    final s = _session;
    if (s == null || !s.canUseHint) {
      return false;
    }
    if (_progress.progress.hints <= 0) {
      return false;
    }
    s.useHint();
    _notify();
    await _progress.spendHint();
    return true;
  }

  void next() {
    final s = _session;
    if (s == null || !s.isAnswered || s.isOver) {
      return;
    }
    s.next();
    _notify();
  }

  /// Survival: offer a rewarded ad for one more life (once per game).
  bool get canOfferExtraLife {
    final s = _session;
    return s != null &&
        _config.adsEnabled &&
        _config.rewardedExtraLifeEnabled &&
        _ads.isSupported &&
        mode.hasLives &&
        s.lives <= 0 &&
        !s.extraLifeUsed;
  }

  Future<bool> watchAdForExtraLife() async {
    if (!canOfferExtraLife) {
      return false;
    }
    final rewarded = await _ads.showRewarded();
    if (rewarded) {
      _session?.addExtraLife();
      _analytics.logEvent('extra_life_rewarded', {'mode': mode.name});
      _notify();
    }
    return rewarded;
  }

  /// Saves progress and returns the summary for the results screen.
  Future<GameSummary> finish() async {
    final existing = _summary;
    if (existing != null) {
      return existing;
    }
    final s = _session;
    if (s == null) {
      throw StateError('The game has not started.');
    }
    _isFinishing = true;
    _notify();
    final summary = await _progress.recordGame(s.toOutcome());
    _summary = summary;
    _analytics.logEvent('game_complete', {
      'mode': mode.name,
      'difficulty': difficulty.name,
      'score': summary.score,
      'correct': summary.correct,
    });

    final every = _config.interstitialEveryNGames;
    final played = _progress.progress.gamesPlayed;
    if (_config.adsEnabled &&
        !_progress.progress.adsRemoved &&
        every > 0 &&
        played % every == 0) {
      await _ads.showInterstitial();
    }
    _isFinishing = false;
    _notify();
    return summary;
  }

  void _notify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
