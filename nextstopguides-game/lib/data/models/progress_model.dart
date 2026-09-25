import '../../domain/engine/rewards.dart';
import '../../domain/entities/continent.dart';
import '../../domain/entities/game_mode.dart';
import '../../domain/entities/player_progress.dart';
import 'json_helpers.dart';

/// JSON <-> PlayerProgress mapping used for local storage.
class ProgressModel {
  ProgressModel._();

  static Map<String, dynamic> toJson(PlayerProgress p) => {
        'xp': p.xp,
        'hints': p.hints,
        'highScores': writeEnumIntMap(p.highScores),
        'bestStreak': p.bestStreak,
        'gamesPlayed': p.gamesPlayed,
        'totalCorrect': p.totalCorrect,
        'totalAnswered': p.totalAnswered,
        'continentCorrect': writeEnumIntMap(p.continentCorrect),
        'lastDailyDateKey': p.lastDailyDateKey,
        'dailyStreak': p.dailyStreak,
        'recentQuestionIds': p.recentQuestionIds,
        'adsRemoved': p.adsRemoved,
      };

  static PlayerProgress fromJson(Map<String, dynamic> json) {
    final lastDaily = json['lastDailyDateKey'];
    return PlayerProgress(
      xp: readInt(json['xp']),
      hints: readInt(json['hints'], RewardRules.startingHints),
      highScores: readEnumIntMap(json['highScores'], GameMode.values),
      bestStreak: readInt(json['bestStreak']),
      gamesPlayed: readInt(json['gamesPlayed']),
      totalCorrect: readInt(json['totalCorrect']),
      totalAnswered: readInt(json['totalAnswered']),
      continentCorrect:
          readEnumIntMap(json['continentCorrect'], Continent.values),
      lastDailyDateKey: lastDaily is String ? lastDaily : null,
      dailyStreak: readInt(json['dailyStreak']),
      recentQuestionIds: readStringList(json['recentQuestionIds']),
      adsRemoved: json['adsRemoved'] == true,
    );
  }
}
