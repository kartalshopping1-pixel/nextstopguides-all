import 'package:flutter_test/flutter_test.dart';
import 'package:nextstopguides_game/core/config/app_config.dart';
import 'package:nextstopguides_game/core/l10n/strings.dart';

void main() {
  const utm = {
    'utm_source': 'game',
    'utm_medium': 'promo',
    'utm_campaign': 'trivia',
  };

  test('guides link carries language and UTM parameters', () {
    for (final language in AppLanguage.values) {
      final uri = AppConfig.siteUri(SiteLink.guides, language.code);
      expect(uri.scheme, 'https');
      expect(uri.host, 'thenextstopguides.com');
      expect(uri.path, '/guides/');
      expect(uri.queryParameters, {'lang': language.code, ...utm});
    }
  });

  test('exact guides URL in Turkish', () {
    expect(
      AppConfig.siteUri(SiteLink.guides, 'tr').toString(),
      'https://thenextstopguides.com/guides/?lang=tr'
      '&utm_source=game&utm_medium=promo&utm_campaign=trivia',
    );
  });

  test('packing list link carries language and UTM parameters', () {
    final uri = AppConfig.siteUri(SiteLink.packingList, 'en');
    expect(uri.path, '/packing-list/');
    expect(uri.queryParameters, {'lang': 'en', ...utm});
  });

  test('site home link only carries the language', () {
    expect(
      AppConfig.siteUri(SiteLink.home, 'tr').toString(),
      'https://thenextstopguides.com/?lang=tr',
    );
  });

  test('promo is on by default', () {
    expect(const AppConfig().showGuidePromo, isTrue);
  });
}
