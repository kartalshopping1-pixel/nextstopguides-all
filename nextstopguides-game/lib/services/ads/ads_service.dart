import 'package:flutter/widgets.dart';

/// Advertising abstraction. The game only talks to this interface, so real
/// ads can be added later without touching game code.
///
/// HOW TO PLUG IN GOOGLE ADMOB (google_mobile_ads) - Android & iOS only,
/// AdMob does not support Flutter web:
///
/// 1. `flutter pub add google_mobile_ads`
/// 2. Android: add your AdMob App ID to android/app/src/main/AndroidManifest.xml
///    inside the application tag:
///      meta-data android:name="com.google.android.gms.ads.APPLICATION_ID"
///                 android:value="ca-app-pub-XXXXXXXX~YYYYYYYY"
///    iOS: add GADApplicationIdentifier (same App ID) to ios/Runner/Info.plist.
/// 3. Create lib/services/ads/admob_ads_service.dart:
///
///    class AdMobAdsService implements AdsService {
///      initialize() -> await MobileAds.instance.initialize();
///                      then preload an InterstitialAd and a RewardedAd.
///      buildBanner() -> return an AdWidget(ad: BannerAd(adUnitId: ...,
///                      size: AdSize.banner, request: const AdRequest(),
///                      listener: BannerAdListener())..load())
///                      wrapped in a SizedBox of the banner size.
///      showInterstitial() -> show the preloaded InterstitialAd, then load
///                      the next one.
///      showRewarded() -> show the RewardedAd and complete with true inside
///                      onUserEarnedReward. This powers
///                      "watch an ad for an extra life" in Survival mode.
///    }
///
///    Use Google's TEST ad unit ids while developing, e.g. banner
///    ca-app-pub-3940256099942544/6300978111 (Android). Never click your own
///    live ads.
/// 4. In lib/core/di/service_locator.dart return AdMobAdsService() when
///    config.adsEnabled is true (and not on web: check kIsWeb).
/// 5. Enable the flag in lib/core/config/app_config.dart or build with
///    --dart-define=ADS_ENABLED=true
/// 6. Add a privacy policy & consent (UMP / GDPR) before publishing.
abstract class AdsService {
  Future<void> initialize();

  /// True when this implementation can actually show ads.
  bool get isSupported;

  /// A banner widget to place at the bottom of the screen, or null.
  Widget? buildBanner();

  /// Full screen ad between games.
  Future<void> showInterstitial();

  /// Rewarded ad. Completes with true when the user earned the reward.
  Future<bool> showRewarded();

  void dispose();
}

/// Default implementation: does nothing, shows nothing.
class NoopAdsService implements AdsService {
  const NoopAdsService();

  @override
  Future<void> initialize() async {}

  @override
  bool get isSupported => false;

  @override
  Widget? buildBanner() => null;

  @override
  Future<void> showInterstitial() async {}

  @override
  Future<bool> showRewarded() async => false;

  @override
  void dispose() {}
}
