import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/constants/app_constants.dart';

/// Where raw travel data comes from.
///
/// Today: [AssetTravelDataSource] reads the JSON files bundled in
/// assets/data/. Later you can add e.g. a `RemoteTravelDataSource` that
/// downloads the same JSON from your NextStopGuides server (using the `http`
/// package) and pass it to TravelRepositoryImpl in service_locator.dart.
abstract class TravelDataSource {
  Future<List<Map<String, dynamic>>> loadCountries();

  Future<List<Map<String, dynamic>>> loadCities();
}

class AssetTravelDataSource implements TravelDataSource {
  AssetTravelDataSource({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  @override
  Future<List<Map<String, dynamic>>> loadCountries() =>
      _loadList(AppConstants.countriesAsset);

  @override
  Future<List<Map<String, dynamic>>> loadCities() =>
      _loadList(AppConstants.citiesAsset);

  Future<List<Map<String, dynamic>>> _loadList(String path) async {
    final raw = await _bundle.loadString(path);
    final decoded = jsonDecode(raw);
    if (decoded is! List) {
      throw FormatException('Expected a JSON array in $path');
    }
    return decoded.whereType<Map<String, dynamic>>().toList(growable: false);
  }
}
