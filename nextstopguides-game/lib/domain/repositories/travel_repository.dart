import '../entities/city.dart';
import '../entities/country.dart';

/// Source of the travel database. Today it reads bundled JSON assets
/// (TravelRepositoryImpl + AssetTravelDataSource); later it can be backed by
/// a remote API without touching the game code.
abstract class TravelRepository {
  Future<List<Country>> getCountries();

  Future<List<City>> getCities();
}
