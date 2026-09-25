/// A city with famous landmarks. Immutable, pure Dart.
class City {
  const City({
    required this.id,
    required this.name,
    required this.countryCode,
    required this.countryName,
    required this.landmarks,
    required this.funFact,
    this.tier = 2,
  });

  final String id;
  final String name;

  /// ISO code of the country the city belongs to (links to Country.code).
  final String countryCode;
  final String countryName;
  final List<String> landmarks;
  final String funFact;

  /// 1 = very famous, 2 = known, 3 = expert.
  final int tier;

  @override
  bool operator ==(Object other) => other is City && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'City($id)';
}
