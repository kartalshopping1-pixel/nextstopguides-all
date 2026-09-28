import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/config/app_config.dart';
import '../../../services/analytics/analytics_service.dart';
import '../../../services/links/link_service.dart';
import '../../settings/state/settings_controller.dart';

/// Opens a NextStopGuides page in the current game language, logs a
/// `site_link_open` analytics event and shows a snackbar if it fails.
Future<void> openSiteLink(BuildContext context, SiteLink link) async {
  final settings = context.read<SettingsController>();
  final links = context.read<LinkService>();
  final analytics = context.read<AnalyticsService>();
  final messenger = ScaffoldMessenger.maybeOf(context);
  final failedText = settings.strings.t('link_openFailed');

  final uri = AppConfig.siteUri(link, settings.language.code);
  await analytics.logEvent('site_link_open', {'link': link.name});
  final opened = await links.open(uri);
  if (!opened) {
    messenger?.showSnackBar(SnackBar(content: Text(failedText)));
  }
}
