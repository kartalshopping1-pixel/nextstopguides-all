// App-wide constants. Pure Dart (no Flutter imports) so the domain layer
// can use them too.

class AppConstants {
  AppConstants._();

  static const String brandName = 'NextStopGuides';
  static const String appName = 'NextStop Trivia';
  static const String appVersion = '1.0.0';

  // Data assets (see assets/data/). Loaded by AssetTravelDataSource.
  static const String countriesAsset = 'assets/data/countries.json';
  static const String citiesAsset = 'assets/data/cities.json';

  // Game rules.
  static const int questionsPerRound = 10;
  static const int survivalLives = 3;

  /// How many recently asked question ids are remembered between games so
  /// that questions rarely repeat.
  static const int maxRecentQuestionIds = 300;

  // Layout.
  static const double maxContentWidth = 760;
  static const double wideLayoutBreakpoint = 840;

  // Local storage keys (shared_preferences).
  static const String progressStorageKey = 'player_progress_v1';
  static const String languageKey = 'settings_language';
  static const String difficultyKey = 'settings_default_difficulty';
  static const String themeModeKey = 'settings_theme_mode';
}
