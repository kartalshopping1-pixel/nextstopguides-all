import 'continent.dart';

/// Passport stamp level earned per continent.
enum StampTier { none, bronze, silver, gold }

/// A stamp that was upgraded during a game (shown on the results screen).
class StampUnlock {
  const StampUnlock(this.continent, this.tier);

  final Continent continent;
  final StampTier tier;

  @override
  bool operator ==(Object other) =>
      other is StampUnlock && other.continent == continent && other.tier == tier;

  @override
  int get hashCode => Object.hash(continent, tier);
}
