import 'continent.dart';

/// A country as used by the game. Immutable, pure Dart.
///
/// Text fields exist in English (`name`, `capital`, ...) and optionally in
/// Turkish (`nameTr`, `capitalTr`, ...). Use the `...In(languageCode)` getters
/// to read the right one; they fall back to English when a translation is
/// missing.
class Country {
  const Country({
    required this.code,
    required this.name,
    required this.capital,
    required this.continent,
    required this.flag,
    required this.currency,
    required this.languages,
    required this.population,
    required this.landmarks,
    required this.funFact,
    this.tier = 2,
    this.nameTr = '',
    this.capitalTr = '',
    this.currencyTr = '',
    this.languagesTr = const [],
    this.landmarksTr = const [],
    this.funFactTr = '',
    this.aliases = const [],
    this.aliasesTr = const [],
  });

  /// ISO 3166-1 alpha-2 code, e.g. "TR".
  final String code;
  final String name;
  final String capital;
  final Continent continent;

  /// Flag emoji, e.g. "🇹🇷".
  final String flag;
  final String currency;
  final List<String> languages;

  /// Population bracket: `<1M`, `1M-10M`, `10M-50M`, `50M-100M` or `100M+`.
  final String population;
  final List<String> landmarks;
  final String funFact;

  /// How well known the country is: 1 = very famous, 2 = known, 3 = expert.
  /// Difficulty levels use this to pick the question pool.
  final int tier;

  // Turkish texts (empty = not translated, English is used instead).
  final String nameTr;
  final String capitalTr;
  final String currencyTr;
  final List<String> languagesTr;
  final List<String> landmarksTr;
  final String funFactTr;

  /// Short forms that would give the answer away in a clue, e.g. "UAE"
  /// in "UAE dirham". They are masked like the name.
  final List<String> aliases;
  final List<String> aliasesTr;

  bool _tr(String languageCode) => languageCode == 'tr';

  String nameIn(String languageCode) =>
      _tr(languageCode) && nameTr.isNotEmpty ? nameTr : name;

  String capitalIn(String languageCode) =>
      _tr(languageCode) && capitalTr.isNotEmpty ? capitalTr : capital;

  String currencyIn(String languageCode) =>
      _tr(languageCode) && currencyTr.isNotEmpty ? currencyTr : currency;

  List<String> languagesIn(String languageCode) =>
      _tr(languageCode) && languagesTr.isNotEmpty ? languagesTr : languages;

  List<String> landmarksIn(String languageCode) =>
      _tr(languageCode) && landmarksTr.isNotEmpty ? landmarksTr : landmarks;

  String funFactIn(String languageCode) =>
      _tr(languageCode) && funFactTr.isNotEmpty ? funFactTr : funFact;

  List<String> aliasesIn(String languageCode) =>
      _tr(languageCode) ? aliasesTr : aliases;

  @override
  bool operator ==(Object other) => other is Country && other.code == code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'Country($code, $name)';
}
