import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nextstopguides_game/core/config/app_config.dart';
import 'package:nextstopguides_game/core/constants/app_constants.dart';
import 'package:nextstopguides_game/core/theme/app_theme.dart';
import 'package:nextstopguides_game/data/repositories/settings_repository.dart';
import 'package:nextstopguides_game/domain/entities/difficulty.dart';
import 'package:nextstopguides_game/domain/entities/game_mode.dart';
import 'package:nextstopguides_game/domain/entities/game_result.dart';
import 'package:nextstopguides_game/features/game/presentation/game_screen.dart';
import 'package:nextstopguides_game/features/promo/presentation/guide_promo_card.dart';
import 'package:nextstopguides_game/features/results/presentation/results_screen.dart';
import 'package:nextstopguides_game/features/settings/presentation/settings_screen.dart';
import 'package:nextstopguides_game/features/settings/state/settings_controller.dart';
import 'package:nextstopguides_game/services/analytics/analytics_service.dart';
import 'package:nextstopguides_game/services/links/link_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeLinkService implements LinkService {
  FakeLinkService({this.result = true});

  final bool result;
  final List<Uri> opened = [];

  @override
  Future<bool> open(Uri uri) async {
    opened.add(uri);
    return result;
  }
}

Future<void> pumpWithProviders(
  WidgetTester tester, {
  required String language,
  required LinkService links,
  required Widget home,
  AppConfig config = const AppConfig(),
}) async {
  SharedPreferences.setMockInitialValues({AppConstants.languageKey: language});
  final prefs = await SharedPreferences.getInstance();
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        Provider<AppConfig>.value(value: config),
        Provider<AnalyticsService>.value(value: const NoopAnalyticsService()),
        Provider<LinkService>.value(value: links),
        ChangeNotifierProvider(
          create: (_) => SettingsController(SettingsRepository(prefs)),
        ),
      ],
      child: MaterialApp(theme: AppTheme.light(), home: home),
    ),
  );
}

Future<void> pumpCard(
  WidgetTester tester, {
  required String language,
  required LinkService links,
  bool showPackingList = false,
}) =>
    pumpWithProviders(
      tester,
      language: language,
      links: links,
      home: Scaffold(
        body: SingleChildScrollView(
          child: GuidePromoCard(showPackingList: showPackingList),
        ),
      ),
    );

const _summary = GameSummary(
  mode: GameMode.flagQuiz,
  difficulty: Difficulty.easy,
  score: 120,
  correct: 6,
  answered: 10,
  bestStreak: 3,
  xpGained: 40,
  previousLevel: 1,
  newLevel: 1,
  isNewHighScore: false,
  hintsEarned: 0,
  stampsUnlocked: [],
  isDailyPractice: false,
  dailyStreak: 0,
);

const _resultsArgs = ResultsArgs(
  summary: _summary,
  replay: GameArgs(mode: GameMode.flagQuiz, difficulty: Difficulty.easy),
);

void main() {
  testWidgets('English promo renders and opens the guides page',
      (tester) async {
    final links = FakeLinkService();
    await pumpCard(tester, language: 'en', links: links);

    expect(find.text('Plan a real trip'), findsOneWidget);
    expect(
      find.text(
          'Heading to Japan? Get our printable 5, 7 & 10-day itineraries'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('promo_packingList')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('promo_guides')));
    await tester.pump();

    expect(links.opened, [AppConfig.siteUri(SiteLink.guides, 'en')]);
    expect(links.opened.single.queryParameters['lang'], 'en');
    expect(links.opened.single.queryParameters['utm_source'], 'game');
  });

  testWidgets('Turkish promo with packing list uses ?lang=tr', (tester) async {
    final links = FakeLinkService();
    await pumpCard(tester, language: 'tr', links: links, showPackingList: true);

    expect(find.text('Gerçek bir gezi planla'), findsOneWidget);
    expect(find.text('Ücretsiz Japonya bavul listesi'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('promo_packingList')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('promo_guides')));
    await tester.pump();

    expect(links.opened, [
      AppConfig.siteUri(SiteLink.packingList, 'tr'),
      AppConfig.siteUri(SiteLink.guides, 'tr'),
    ]);
    expect(links.opened.first.path, '/packing-list/');
  });

  testWidgets('shows a snackbar when the link cannot be opened',
      (tester) async {
    final links = FakeLinkService(result: false);
    await pumpCard(tester, language: 'en', links: links);

    await tester.tap(find.byKey(const ValueKey('promo_guides')));
    await tester.pump();

    expect(links.opened, hasLength(1));
    expect(find.text("Couldn't open the link."), findsOneWidget);
  });

  testWidgets('Results screen shows the promo with the packing list link',
      (tester) async {
    final links = FakeLinkService();
    await pumpWithProviders(
      tester,
      language: 'en',
      links: links,
      home: const ResultsScreen(args: _resultsArgs),
    );

    final packing = find.byKey(const ValueKey('promo_packingList'));
    await tester.scrollUntilVisible(packing, 200,
        scrollable: find.byType(Scrollable).first);
    await tester.ensureVisible(packing);
    await tester.pumpAndSettle();
    expect(find.byType(GuidePromoCard), findsOneWidget);
    await tester.tap(packing);
    await tester.pump();

    expect(links.opened, [AppConfig.siteUri(SiteLink.packingList, 'en')]);
  });

  testWidgets('Results screen hides the promo when the flag is off',
      (tester) async {
    await pumpWithProviders(
      tester,
      language: 'en',
      links: FakeLinkService(),
      config: const AppConfig(showGuidePromo: false),
      home: const ResultsScreen(args: _resultsArgs),
    );
    expect(find.byType(GuidePromoCard), findsNothing);
  });

  testWidgets('Settings has a NextStopGuides row linking to the site',
      (tester) async {
    final links = FakeLinkService();
    await pumpWithProviders(
      tester,
      language: 'tr',
      links: links,
      home: const SettingsScreen(),
    );

    final row = find.byKey(const ValueKey('settings_site'));
    await tester.scrollUntilVisible(row, 200,
        scrollable: find.byType(Scrollable).first);
    await tester.ensureVisible(row);
    await tester.pumpAndSettle();
    await tester.tap(row);
    await tester.pump();

    expect(links.opened.single.toString(),
        'https://thenextstopguides.com/?lang=tr');
  });
}
