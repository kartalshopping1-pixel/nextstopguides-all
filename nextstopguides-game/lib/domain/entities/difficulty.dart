enum Difficulty {
  easy(maxTier: 1, optionCount: 3, multiplier: 1.0),
  medium(maxTier: 2, optionCount: 4, multiplier: 1.5),
  hard(maxTier: 3, optionCount: 4, multiplier: 2.0);

  const Difficulty({
    required this.maxTier,
    required this.optionCount,
    required this.multiplier,
  });

  /// Countries/cities with a tier up to this value are used.
  final int maxTier;

  /// Number of answer options in multiple choice questions.
  final int optionCount;

  /// Score multiplier.
  final double multiplier;

  /// "Guess the Country" shows a few more options.
  int get clueOptionCount => optionCount + 2;

  /// On hard, wrong options come from the same continent (much trickier).
  bool get preferSameContinent => this == Difficulty.hard;
}
