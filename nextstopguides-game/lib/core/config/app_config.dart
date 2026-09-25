// Feature flags for the whole app.
//
// Every monetization feature is OFF by default. Flip a flag here (or pass it
// at build time with --dart-define) once the matching real service has been
// plugged in inside lib/core/di/service_locator.dart.
//
// Build-time example:
//   flutter run -d chrome --dart-define=ADS_ENABLED=true --dart-define=IAP_ENABLED=true

class AppConfig {
  const AppConfig({
    this.adsEnabled = false,
    this.purchasesEnabled = false,
    this.analyticsEnabled = false,
    this.rewardedExtraLifeEnabled = true,
    this.interstitialEveryNGames = 3,
    this.showShop = true,
  });

  /// The configuration used by the running app.
  static const AppConfig current = AppConfig(
    adsEnabled: bool.fromEnvironment('ADS_ENABLED', defaultValue: false),
    purchasesEnabled: bool.fromEnvironment('IAP_ENABLED', defaultValue: false),
    analyticsEnabled:
        bool.fromEnvironment('ANALYTICS_ENABLED', defaultValue: false),
  );

  /// Show banner / interstitial / rewarded ads (requires a real AdsService).
  final bool adsEnabled;

  /// Enable in-app purchases in the shop (requires a real PurchaseService).
  final bool purchasesEnabled;

  /// Send analytics events (requires a real AnalyticsService).
  final bool analyticsEnabled;

  /// In Survival mode, offer "watch an ad for an extra life" when lives run out.
  final bool rewardedExtraLifeEnabled;

  /// Show an interstitial ad after every N finished games (0 = never).
  final int interstitialEveryNGames;

  /// Show the Shop tab.
  final bool showShop;
}
