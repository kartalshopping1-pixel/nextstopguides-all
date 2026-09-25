import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/progress_local_data_source.dart';
import '../../data/datasources/travel_data_source.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/travel_repository_impl.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/repositories/travel_repository.dart';
import '../../services/ads/ads_service.dart';
import '../../services/analytics/analytics_service.dart';
import '../../services/purchase/purchase_service.dart';
import '../config/app_config.dart';

/// Simple dependency injection: builds every service once at startup.
/// The objects are then handed to the widget tree with `provider`
/// (see lib/app.dart).
///
/// THIS IS THE PLACE TO SWAP IMPLEMENTATIONS, e.g.:
///   ads: config.adsEnabled && !kIsWeb ? AdMobAdsService() : const NoopAdsService()
///   purchases: config.purchasesEnabled && !kIsWeb ? StorePurchaseService() : const NoopPurchaseService()
///   travel data: TravelRepositoryImpl(RemoteTravelDataSource(...))
class AppDependencies {
  AppDependencies({
    required this.config,
    required this.ads,
    required this.purchases,
    required this.analytics,
    required this.travelRepository,
    required this.progressRepository,
    required this.settingsRepository,
  });

  final AppConfig config;
  final AdsService ads;
  final PurchaseService purchases;
  final AnalyticsService analytics;
  final TravelRepository travelRepository;
  final ProgressRepository progressRepository;
  final SettingsRepository settingsRepository;

  static Future<AppDependencies> create({
    AppConfig config = AppConfig.current,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // TODO(monetization): replace the Noop services with real ones when the
    // matching flag in AppConfig is enabled (see README.md).
    const AdsService ads = NoopAdsService();
    const PurchaseService purchases = NoopPurchaseService();
    const AnalyticsService analytics = NoopAnalyticsService();

    await ads.initialize();
    await purchases.initialize();

    return AppDependencies(
      config: config,
      ads: ads,
      purchases: purchases,
      analytics: analytics,
      travelRepository: TravelRepositoryImpl(AssetTravelDataSource()),
      progressRepository: ProgressRepositoryImpl(ProgressLocalDataSource(prefs)),
      settingsRepository: SettingsRepository(prefs),
    );
  }
}
