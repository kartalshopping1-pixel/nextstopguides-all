/// Small text helpers used by the question generator. Pure Dart.
class TextUtils {
  TextUtils._();

  /// Replaces a hidden answer inside a clue, e.g. "Singapore dollar" -> "••• dollar".
  static const String maskToken = '•••';

  /// True when [text] contains [secret] (case-insensitive).
  static bool leaks(String text, String secret) {
    final s = secret.trim().toLowerCase();
    if (s.isEmpty) {
      return false;
    }
    return text.toLowerCase().contains(s);
  }

  /// True when either string contains the other (e.g. "Tunis" / "Tunisia").
  static bool related(String a, String b) => leaks(a, b) || leaks(b, a);

  /// Hides every occurrence of [secret] inside [text].
  static String mask(String text, String secret) {
    final s = secret.trim();
    if (s.isEmpty) {
      return text;
    }
    return text.replaceAll(
      RegExp(RegExp.escape(s), caseSensitive: false),
      maskToken,
    );
  }

  /// Creates a url/id friendly slug: "São Paulo" -> "s-o-paulo".
  static String slug(String value) => value
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
}
