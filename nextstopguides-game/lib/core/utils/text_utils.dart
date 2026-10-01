/// Small text helpers used by the question generator. Pure Dart.
class TextUtils {
  TextUtils._();

  /// Replaces a hidden answer inside a clue, e.g. "Singapore dollar" -> "••• dollar".
  static const String maskToken = '•••';

  /// Case-folds [value] for comparisons in both English and Turkish.
  ///
  /// Dart's `toLowerCase` is locale-independent: it turns "I" into "i" (wrong
  /// for Turkish, where it is "ı") and "İ" into "i̇" (two code units). To keep
  /// matching simple and length-preserving, all four of I, İ, ı and i fold to
  /// "i", so "IRAK", "Irak" and "ırak" all match, as do "İtalya" and "italya".
  /// The result always has the same length as [value], so indexes found in
  /// the folded text can be used on the original.
  static String fold(String value) {
    final buffer = StringBuffer();
    for (final unit in value.codeUnits) {
      switch (unit) {
        case 0x49: // I
        case 0x130: // İ
        case 0x131: // ı
          buffer.writeCharCode(0x69); // i
        default:
          final char = String.fromCharCode(unit);
          final lower = char.toLowerCase();
          buffer.write(lower.length == 1 ? lower : char);
      }
    }
    return buffer.toString();
  }

  /// True when [text] contains [secret] (case-insensitive, Turkish-aware).
  static bool leaks(String text, String secret) {
    final s = fold(secret.trim());
    if (s.isEmpty) {
      return false;
    }
    return fold(text).contains(s);
  }

  /// True when either string contains the other (e.g. "Tunis" / "Tunisia").
  static bool related(String a, String b) => leaks(a, b) || leaks(b, a);

  /// Hides every occurrence of [secret] inside [text] (case-insensitive,
  /// Turkish-aware), e.g. mask("Mısır lirası", "MISIR") -> "••• lirası".
  static String mask(String text, String secret) {
    final s = fold(secret.trim());
    if (s.isEmpty) {
      return text;
    }
    final folded = fold(text);
    final buffer = StringBuffer();
    var start = 0;
    while (true) {
      final index = folded.indexOf(s, start);
      if (index < 0) {
        break;
      }
      buffer
        ..write(text.substring(start, index))
        ..write(maskToken);
      start = index + s.length;
    }
    buffer.write(text.substring(start));
    return buffer.toString();
  }

  /// Hides every one of [secrets] inside [text] (longest first).
  static String maskAll(String text, Iterable<String> secrets) {
    final sorted = secrets.toList()
      ..sort((a, b) => b.length.compareTo(a.length));
    var result = text;
    for (final secret in sorted) {
      result = mask(result, secret);
    }
    return result;
  }

  /// Creates a url/id friendly slug: "São Paulo" -> "s-o-paulo".
  static String slug(String value) => value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
}
