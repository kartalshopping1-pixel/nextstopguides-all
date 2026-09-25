import 'continent.dart';

/// A country as used by the game. Immutable, pure Dart.
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

  @override
  bool operator ==(Object other) => other is Country && other.code == code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'Country($code, $name)';
}
