import '../../domain/entities/continent.dart';
import '../../domain/entities/country.dart';
import 'json_helpers.dart';

/// JSON <-> Country mapping. Field names match assets/data/countries.json.
class CountryModel {
  CountryModel._();

  static Country fromJson(Map<String, dynamic> json) {
    return Country(
      code: readString(json['code']).toUpperCase(),
      name: readString(json['name']),
      capital: readString(json['capital']),
      continent: Continent.fromLabel(readString(json['continent'])),
      flag: readString(json['flag']),
      currency: readString(json['currency']),
      languages: readStringList(json['languages']),
      population: readString(json['population']),
      landmarks: readStringList(json['landmarks']),
      funFact: readString(json['funFact']),
      tier: readInt(json['tier'], 2),
    );
  }

  static Map<String, dynamic> toJson(Country country) => {
        'code': country.code,
        'name': country.name,
        'capital': country.capital,
        'continent': country.continent.label,
        'flag': country.flag,
        'currency': country.currency,
        'languages': country.languages,
        'population': country.population,
        'landmarks': country.landmarks,
        'funFact': country.funFact,
        'tier': country.tier,
      };
}
