# Architecture – NextStop Trivia

The app follows a light **clean architecture**: game rules are pure Dart and
independent from Flutter, data access sits behind repositories, and every
monetization feature is hidden behind a service interface with a "no-op"
default. This keeps the game easy to test and easy to extend (ads, purchases,
remote data, cloud save) without rewriting screens.

```
UI (features/*/presentation)  ──>  State (features/*/state, ChangeNotifier)
                                         │
                                         ▼
                    Domain (domain/engine + entities)  ← pure Dart, unit-tested
                                         │
                                         ▼
          Repositories (domain/repositories = interfaces, data/repositories = impl)
                                         │
                                         ▼
              Data sources (JSON assets, shared_preferences, later: API)

Services (ads, purchases, analytics) are injected at startup (core/di).
```

## Folder structure

```
nextstopguides-game/
├── assets/data/
│   ├── countries.json          136 countries (capital, flag, currency, languages, landmarks, fun fact, tier)
│   └── cities.json             113 cities (landmarks, fun fact, tier)
├── lib/
│   ├── main.dart               Entry point: builds dependencies, runs the app
│   ├── app.dart                MultiProvider + MaterialApp (theme, routes, language)
│   ├── core/
│   │   ├── config/app_config.dart      Feature flags: ads / IAP / analytics (also via --dart-define)
│   │   ├── constants/app_constants.dart Rules (questions per round, lives), asset paths, storage keys
│   │   ├── di/service_locator.dart     Creates services & repositories once (swap implementations here)
│   │   ├── l10n/strings.dart           All UI strings, English + Turkish, AppLanguage enum
│   │   ├── router/app_router.dart      Named routes: /, /game, /results
│   │   ├── theme/app_theme.dart        Brand colors + Material 3 light/dark themes
│   │   ├── utils/                      SeededRandom (daily), DayKey (dates), TextUtils (masking)
│   │   └── widgets/responsive_center.dart  Max-width wrapper for phone/tablet/desktop
│   ├── data/
│   │   ├── datasources/        AssetTravelDataSource (JSON), ProgressLocalDataSource (shared_preferences)
│   │   ├── models/             JSON <-> entity mappers (Country, City, PlayerProgress)
│   │   └── repositories/       TravelRepositoryImpl, ProgressRepositoryImpl, SettingsRepository
│   ├── domain/                 PURE DART – no Flutter imports
│   │   ├── entities/           Country, City, Question, GameMode, Difficulty, PlayerProgress, GameSummary…
│   │   ├── engine/
│   │   │   ├── question_generator.dart  Random/daily question building, repeat avoidance, clue masking
│   │   │   ├── game_session.dart        One round: answers, lives, streaks, hints, clues
│   │   │   ├── scoring.dart             Points and XP formulas
│   │   │   ├── level_system.dart        XP -> level curve, traveler ranks
│   │   │   ├── rewards.dart             Hint rewards, passport stamp thresholds
│   │   │   └── progress_calculator.dart Applies a finished game to saved progress
│   │   └── repositories/       Abstract TravelRepository, ProgressRepository
│   ├── features/
│   │   ├── home/               HomeShell (tabs + banner slot), HomeScreen, ModeCard
│   │   ├── game/               GameScreen + widgets, GameController (wraps GameSession)
│   │   ├── results/            ResultsScreen (score, XP, level up, stamps, hints)
│   │   ├── profile/            "My Passport" screen, ProgressController (global progress state)
│   │   ├── shop/               ShopScreen, ShopController (products, deliver purchases)
│   │   └── settings/           SettingsScreen, SettingsController (+ context.strings extension)
│   └── services/
│       ├── ads/ads_service.dart               AdsService + NoopAdsService (AdMob guide in comments)
│       ├── purchase/purchase_service.dart     PurchaseService + NoopPurchaseService, ProductIds
│       └── analytics/analytics_service.dart   AnalyticsService + NoopAnalyticsService
├── test/
│   ├── domain/                 question generator, game session, scoring/levels/rewards, progress
│   ├── data/                   validates the real JSON assets, progress JSON round trip
│   ├── l10n/                   EN/TR key parity, placeholders
│   └── widget_test.dart        widget smoke test
└── web/                        index.html (splash), manifest.json (PWA)
```

## Key flows

**Starting a game** – `HomeScreen` pushes `/game` with `GameArgs(mode, difficulty)`.
`GameScreen` creates a `GameController`, which loads countries/cities from the
`TravelRepository`, builds a `QuestionGenerator` (seeded by date for the Daily
Challenge, otherwise random + "recently seen" ids from progress) and a
`GameSession`.

**Answering** – the UI calls `GameController.answer(i)`; the pure
`GameSession` computes points with `ScoreCalculator`, updates streak/lives and
continent counters. Hints spend one unit from `ProgressController` and remove
about half of the wrong options.

**Finishing** – `GameController.finish()` turns the session into a
`GameOutcome`; `ProgressController.recordGame()` runs `ProgressCalculator`
(XP, level, high score, stamps, hint rewards, daily streak, recent ids), saves
through `ProgressRepository`, optionally shows an interstitial, and the
`ResultsScreen` shows the `GameSummary`.

## State management & DI

- `provider` only. `AppDependencies.create()` builds everything once;
  `app.dart` exposes services with `Provider.value` and the two global
  controllers (`SettingsController`, `ProgressController`) with
  `ChangeNotifierProvider`. Screen-level controllers (`GameController`,
  `ShopController`) are created by their screens.
- Strings: `context.strings` (listens to language changes) → `AppStrings.t(key, args)`.

## Monetization hooks

| Hook | Where | Default |
|---|---|---|
| Feature flags | `core/config/app_config.dart` | all off |
| Banner slot | `features/home/presentation/home_shell.dart` | `NoopAdsService.buildBanner()` returns null |
| Interstitial every N games | `GameController.finish()` | no-op |
| Rewarded "extra life" | `GameController.watchAdForExtraLife()` (Survival) | hidden unless ads enabled & supported |
| Products & purchases | `services/purchase/purchase_service.dart`, `features/shop/` | "coming soon" |
| Purchase delivery | `ShopController.deliver()` | hints / remove ads implemented |
| Analytics events | `game_start`, `game_complete`, `purchase`, `extra_life_rewarded` | no-op |

To go live, implement the interface (e.g. `AdMobAdsService`,
`StorePurchaseService`), return it from `core/di/service_locator.dart`
when the flag is on, and flip the flag.

## Extending

- **More data:** edit the JSON files (see README §12); `test/data/travel_data_test.dart` validates them.
- **Remote data:** add a `RemoteTravelDataSource implements TravelDataSource` and pass it
  to `TravelRepositoryImpl` in `service_locator.dart`.
- **Cloud save:** implement `ProgressRepository` with your backend.
- **New question type:** add a value to `QuestionType`, a builder in
  `QuestionGenerator.generate()`, a prompt key `q_<type>` in `strings.dart`
  (both languages) and add it to `QuestionGenerator.typesFor()` for the modes that should use it.
- **New game mode:** add to `GameMode`, map it in `typesFor()`, add
  `mode_<name>_title/_desc` strings. It appears on the home screen automatically.
- **New language:** see the header of `lib/core/l10n/strings.dart`.
