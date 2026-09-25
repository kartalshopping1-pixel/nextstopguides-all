// Widget smoke tests. (This file also prevents `flutter create .` from
// generating the default counter-app test, which would not compile here.)

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nextstopguides_game/core/theme/app_theme.dart';
import 'package:nextstopguides_game/features/game/presentation/widgets/answer_option_tile.dart';

void main() {
  testWidgets('AnswerOptionTile shows its label and reacts to taps', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: AnswerOptionTile(
            label: 'Ankara',
            index: 0,
            state: AnswerOptionState.idle,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Ankara'), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    await tester.tap(find.text('Ankara'));
    expect(tapped, isTrue);
  });

  testWidgets('correct state shows a check icon', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: const Scaffold(
          body: AnswerOptionTile(
            label: 'Paris',
            index: 1,
            state: AnswerOptionState.correct,
          ),
        ),
      ),
    );
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}
