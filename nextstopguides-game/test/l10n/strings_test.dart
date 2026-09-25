import 'package:flutter_test/flutter_test.dart';
import 'package:nextstopguides_game/core/l10n/strings.dart';
import 'package:nextstopguides_game/domain/engine/level_system.dart';
import 'package:nextstopguides_game/domain/entities/continent.dart';
import 'package:nextstopguides_game/domain/entities/difficulty.dart';
import 'package:nextstopguides_game/domain/entities/game_mode.dart';
import 'package:nextstopguides_game/domain/entities/passport_stamp.dart';
import 'package:nextstopguides_game/domain/entities/question.dart';
import 'package:nextstopguides_game/services/purchase/purchase_service.dart';

void main() {
  test('every language has exactly the same keys as English', () {
    final english = AppStrings.tableFor(AppLanguage.en).keys.toSet();
    for (final language in AppLanguage.values) {
      final keys = AppStrings.tableFor(language).keys.toSet();
      expect(english.difference(keys), isEmpty, reason: 'missing in ${language.code}');
      expect(keys.difference(english), isEmpty, reason: 'extra in ${language.code}');
    }
  });

  test('all enum-based keys exist', () {
    final table = AppStrings.tableFor(AppLanguage.en);
    final required = <String>[
      for (final m in GameMode.values) ...['mode_${m.name}_title', 'mode_${m.name}_desc'],
      for (final d in Difficulty.values) 'difficulty_${d.name}',
      for (final c in Continent.values) 'continent_${c.name}',
      for (final t in QuestionType.values) 'q_${t.name}',
      for (final c in ClueType.values) 'clue_${c.name}',
      for (final s in StampTier.values) 'stamp_${s.name}',
      for (final r in TravelerRank.values) 'rank_${r.name}',
      for (final id in ProductIds.all) ...['product_${id}_title', 'product_${id}_desc'],
    ];
    for (final key in required) {
      expect(table.containsKey(key), isTrue, reason: 'missing key $key');
    }
  });

  test('placeholders are replaced', () {
    const s = AppStrings(AppLanguage.en);
    expect(s.t('level', {'level': 7}), 'Level 7');
    const tr = AppStrings(AppLanguage.tr);
    expect(tr.t('game_question', {'current': 3, 'total': 10}), 'Soru 3/10');
  });

  test('unknown language codes fall back to English', () {
    expect(AppLanguage.fromCode('xx'), AppLanguage.en);
    expect(AppLanguage.fromCode('tr'), AppLanguage.tr);
  });
}
