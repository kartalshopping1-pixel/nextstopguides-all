/// A city with famous landmarks. Immutable, pure Dart.
///
/// Like [Country], texts exist in English and optionally Turkish; the
/// `...In(languageCode)` getters fall back to English.
class City {
  const City({
    required this.id,
    required this.name,
    required this.countryCode,
    required this.countryName,
    required this.landmarks,
    required this.funFact,
    this.tier = 2,
    this.nameTr = '',
    this.countryNameTr = '',
    this.landmarksTr = const [],
    this.funFactTr = '',
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

  // Turkish texts (empty = not translated).
  final String nameTr;
  final String countryNameTr;
  final List<String> landmarksTr;
  final String funFactTr;

  bool _tr(String languageCode) => languageCode == 'tr';

  String nameIn(String languageCode) =>
      _tr(languageCode) && nameTr.isNotEmpty ? nameTr : name;

  String countryNameIn(String languageCode) =>
      _tr(languageCode) && countryNameTr.isNotEmpty ? countryNameTr : countryName;

  List<String> landmarksIn(String languageCode) =>
      _tr(languageCode) && landmarksTr.isNotEmpty ? landmarksTr : landmarks;

  String funFactIn(String languageCode) =>
      _tr(languageCode) && funFactTr.isNotEmpty ? funFactTr : funFact;

  @override
  bool operator ==(Object other) => other is City && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'City($id)';
}
