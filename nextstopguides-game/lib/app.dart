import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/config/app_config.dart';
import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'domain/repositories/progress_repository.dart';
import 'domain/repositories/travel_repository.dart';
import 'features/profile/state/progress_controller.dart';
import 'features/settings/state/settings_controller.dart';
import 'services/ads/ads_service.dart';
import 'services/analytics/analytics_service.dart';
import 'services/purchase/purchase_service.dart';

/// Root widget: exposes all services/controllers with `provider` and builds
/// the MaterialApp.
class NextStopApp extends StatelessWidget {
  const NextStopApp({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    final deps = dependencies;
    return MultiProvider(
      providers: [
        Provider<AppConfig>.value(value: deps.config),
        Provider<AdsService>.value(value: deps.ads),
        Provider<PurchaseService>.value(value: deps.purchases),
        Provider<AnalyticsService>.value(value: deps.analytics),
        Provider<TravelRepository>.value(value: deps.travelRepository),
        Provider<ProgressRepository>.value(value: deps.progressRepository),
        ChangeNotifierProvider<SettingsController>(
          create: (context) => SettingsController(deps.settingsRepository),
        ),
        ChangeNotifierProvider<ProgressController>(
          create: (context) => ProgressController(deps.progressRepository)..load(),
        ),
      ],
      child: Consumer<SettingsController>(
        builder: (context, settings, child) => MaterialApp(
          title: settings.strings.appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: settings.themeMode,
          initialRoute: AppRoutes.home,
          onGenerateRoute: AppRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
