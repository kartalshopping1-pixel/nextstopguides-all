// Small tolerant JSON readers shared by the models.

List<String> readStringList(Object? value) {
  if (value is List) {
    return List<String>.unmodifiable(value.map((e) => e.toString()));
  }
  if (value is String && value.isNotEmpty) {
    return List<String>.unmodifiable([value]);
  }
  return const [];
}

int readInt(Object? value, [int fallback = 0]) {
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value) ?? fallback;
  }
  return fallback;
}

String readString(Object? value, [String fallback = '']) =>
    value is String ? value : fallback;

/// Converts {"europe": 12} into {Continent.europe: 12} for any enum.
Map<T, int> readEnumIntMap<T extends Enum>(Object? raw, List<T> values) {
  final result = <T, int>{};
  if (raw is Map) {
    for (final entry in raw.entries) {
      for (final value in values) {
        if (value.name == entry.key) {
          result[value] = readInt(entry.value);
        }
      }
    }
  }
  return result;
}

Map<String, int> writeEnumIntMap<T extends Enum>(Map<T, int> map) => {
      for (final entry in map.entries) entry.key.name: entry.value,
    };
