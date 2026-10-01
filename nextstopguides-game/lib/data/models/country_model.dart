import '../../domain/entities/continent.dart';
import '../../domain/entities/country.dart';
import 'json_helpers.dart';

/// JSON <-> Country mapping. Field names match assets/data/countries.json.
/// Turkish fields use a `Tr` suffix (`nameTr`, `capitalTr`, ...).
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
      nameTr: readString(json['nameTr']),
      capitalTr: readString(json['capitalTr']),
      currencyTr: readString(json['currencyTr']),
      languagesTr: readStringList(json['languagesTr']),
      landmarksTr: readStringList(json['landmarksTr']),
      funFactTr: readString(json['funFactTr']),
      aliases: readStringList(json['aliases']),
      aliasesTr: readStringList(json['aliasesTr']),
    );
  }

  static Map<String, dynamic> toJson(Country country) => {
        'code': country.code,
        'name': country.name,
        'nameTr': country.nameTr,
        'capital': country.capital,
        'capitalTr': country.capitalTr,
        'continent': country.continent.label,
        'flag': country.flag,
        'currency': country.currency,
        'currencyTr': country.currencyTr,
        'languages': country.languages,
        'languagesTr': country.languagesTr,
        'population': country.population,
        'landmarks': country.landmarks,
        'landmarksTr': country.landmarksTr,
        'funFact': country.funFact,
        'funFactTr': country.funFactTr,
        'aliases': country.aliases,
        'aliasesTr': country.aliasesTr,
        'tier': country.tier,
      };
}
