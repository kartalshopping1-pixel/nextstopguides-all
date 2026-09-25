enum Continent {
  africa('Africa', '🌍'),
  asia('Asia', '🌏'),
  europe('Europe', '🏰'),
  northAmerica('North America', '🗽'),
  southAmerica('South America', '🦙'),
  oceania('Oceania', '🏝️');

  const Continent(this.label, this.emoji);

  /// English label as used in the JSON data files.
  final String label;
  final String emoji;

  /// Parses "North America", "northAmerica" or "north america".
  static Continent fromLabel(String value) {
    final normalized = value.trim().toLowerCase();
    for (final continent in Continent.values) {
      if (continent.label.toLowerCase() == normalized ||
          continent.name.toLowerCase() == normalized) {
        return continent;
      }
    }
    throw FormatException('Unknown continent: $value');
  }
}
