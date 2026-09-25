/// Analytics abstraction.
///
/// To add Firebase Analytics later: `flutterfire configure`,
/// `flutter pub add firebase_core firebase_analytics`, create a
/// FirebaseAnalyticsService that implements this interface
/// (FirebaseAnalytics.instance.logEvent(name: name, parameters: params)) and
/// return it from lib/core/di/service_locator.dart when
/// AppConfig.analyticsEnabled is true.
library;

abstract class AnalyticsService {
  Future<void> logEvent(String name, [Map<String, Object> params = const {}]);

  Future<void> logScreen(String screenName);
}

/// Default implementation: records nothing.
class NoopAnalyticsService implements AnalyticsService {
  const NoopAnalyticsService();

  @override
  Future<void> logEvent(String name, [Map<String, Object> params = const {}]) async {}

  @override
  Future<void> logScreen(String screenName) async {}
}
