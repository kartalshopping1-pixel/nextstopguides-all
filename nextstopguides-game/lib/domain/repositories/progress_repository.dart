import '../entities/player_progress.dart';

/// Persists player progress. The default implementation stores it locally
/// with shared_preferences; a cloud-save implementation could replace it.
abstract class ProgressRepository {
  Future<PlayerProgress> load();

  Future<void> save(PlayerProgress progress);

  Future<void> reset();
}
