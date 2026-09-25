/// Helpers to turn calendar days into stable keys and seeds.
/// Pure Dart - used by the Daily Challenge and streak logic.
class DayKey {
  DayKey._();

  /// Returns a key such as "2026-09-25" (local calendar day).
  static String of(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Key of the day before [date].
  static String yesterdayOf(DateTime date) =>
      of(DateTime(date.year, date.month, date.day - 1));

  /// A numeric seed such as 20260925 for the Daily Challenge generator.
  static int seedOf(DateTime date) =>
      date.year * 10000 + date.month * 100 + date.day;
}
