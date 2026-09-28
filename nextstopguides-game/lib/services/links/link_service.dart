/// Opens external web links (the NextStopGuides website).
///
/// Kept behind an interface so widget tests can inject a fake and nothing
/// actually launches a browser. On the web the link opens in a new tab, on
/// mobile/desktop in the external browser. These are plain web links (no
/// payments), which is fine for the App Store / Play Store.
library;

import 'package:url_launcher/url_launcher.dart';

abstract class LinkService {
  /// Opens [uri]. Returns false if it could not be opened.
  Future<bool> open(Uri uri);
}

/// Default implementation backed by `url_launcher`.
class UrlLauncherLinkService implements LinkService {
  const UrlLauncherLinkService();

  @override
  Future<bool> open(Uri uri) async {
    try {
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
    } on Exception {
      return false;
    }
  }
}
