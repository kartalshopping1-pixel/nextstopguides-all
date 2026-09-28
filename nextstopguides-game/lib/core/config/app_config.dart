// Feature flags for the whole app.
//
// Every monetization feature is OFF by default. Flip a flag here (or pass it
// at build time with --dart-define) once the matching real service has been
// plugged in inside lib/core/di/service_locator.dart.
//
// Build-time example:
//   flutter run -d chrome --dart-define=ADS_ENABLED=true --dart-define=IAP_ENABLED=true
//
// All links to the NextStopGuides website also live here (see [SiteLink]).

/// Pages on the NextStopGuides website that the game links to.
enum SiteLink {
  /// Site home page (Settings > NextStopGuides).
  home('/', tracked: false),

  /// Printable itineraries (promo card on Home / Results).
  guides('/guides/'),

  /// Free Japan packing list (secondary link on Results).
  packingList('/packing-list/');

  const SiteLink(this.path, {this.tracked = true});

  final String path;

  /// Whether the UTM campaign parameters are appended.
  final bool tracked;
}

class AppConfig {
  const AppConfig({
    this.adsEnabled = false,
    this.purchasesEnabled = false,
    this.analyticsEnabled = false,
    this.rewardedExtraLifeEnabled = true,
    this.interstitialEveryNGames = 3,
    this.showShop = true,
    this.showGuidePromo = true,
  });

  /// Base URL of the NextStopGuides website (no trailing slash).
  static const String siteBaseUrl = 'https://thenextstopguides.com';

  /// UTM parameters added to tracked [SiteLink]s.
  static const Map<String, String> promoUtm = {
    'utm_source': 'game',
    'utm_medium': 'promo',
    'utm_campaign': 'trivia',
  };

  /// Full URL of a website page in the player's language
  /// (e.g. https://thenextstopguides.com/guides/?lang=tr&utm_source=game...).
  static Uri siteUri(SiteLink link, String languageCode) {
    final base = Uri.parse(siteBaseUrl);
    return base.replace(
      path: link.path,
      queryParameters: {
        'lang': languageCode,
        if (link.tracked) ...promoUtm,
      },
    );
  }

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

  /// Show the "Plan a real trip" promo card (Home + Results) linking to the
  /// NextStopGuides travel guides. Plain web links only - no payments in-app.
  final bool showGuidePromo;
}
