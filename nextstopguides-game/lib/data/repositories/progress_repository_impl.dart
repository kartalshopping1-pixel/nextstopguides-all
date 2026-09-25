import '../../domain/entities/player_progress.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_local_data_source.dart';
import '../models/progress_model.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  ProgressRepositoryImpl(this._local);

  final ProgressLocalDataSource _local;

  @override
  Future<PlayerProgress> load() async {
    final json = _local.read();
    if (json == null) {
      return const PlayerProgress();
    }
    return ProgressModel.fromJson(json);
  }

  @override
  Future<void> save(PlayerProgress progress) =>
      _local.write(ProgressModel.toJson(progress));

  @override
  Future<void> reset() => _local.clear();
}
