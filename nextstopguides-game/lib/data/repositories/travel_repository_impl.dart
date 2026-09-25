import '../../domain/entities/city.dart';
import '../../domain/entities/country.dart';
import '../../domain/repositories/travel_repository.dart';
import '../datasources/travel_data_source.dart';
import '../models/city_model.dart';
import '../models/country_model.dart';

/// Loads and caches the travel database from a [TravelDataSource].
class TravelRepositoryImpl implements TravelRepository {
  TravelRepositoryImpl(this._source);

  final TravelDataSource _source;
  List<Country>? _countries;
  List<City>? _cities;

  @override
  Future<List<Country>> getCountries() async {
    return _countries ??= List<Country>.unmodifiable(
      (await _source.loadCountries()).map(CountryModel.fromJson),
    );
  }

  @override
  Future<List<City>> getCities() async {
    return _cities ??= List<City>.unmodifiable(
      (await _source.loadCities()).map(CityModel.fromJson),
    );
  }
}
