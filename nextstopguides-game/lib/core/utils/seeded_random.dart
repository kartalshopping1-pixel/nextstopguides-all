import 'dart:math';

/// A tiny deterministic pseudo random number generator (Park-Miller / Lehmer).
///
/// Unlike the default [Random], its output is guaranteed to be identical on
/// every platform (Android, iOS, web). The Daily Challenge relies on this so
/// that every player gets exactly the same questions on the same day.
/// All intermediate values stay below 2^53, so it is also exact on the web.
class SeededRandom implements Random {
  SeededRandom(int seed) : _state = _normalize(seed);

  static const int _modulus = 2147483647; // 2^31 - 1 (a prime)
  static const int _multiplier = 48271;

  int _state;

  static int _normalize(int seed) {
    final s = seed.abs() % _modulus;
    return s == 0 ? 1 : s;
  }

  int _nextRaw() {
    _state = (_state * _multiplier) % _modulus;
    return _state;
  }

  @override
  int nextInt(int max) {
    if (max <= 0 || max > _modulus) {
      throw RangeError.range(max, 1, _modulus, 'max');
    }
    return _nextRaw() % max;
  }

  @override
  double nextDouble() => (_nextRaw() - 1) / (_modulus - 1);

  @override
  bool nextBool() => _nextRaw().isEven;
}
