import '../../core/utils/text_utils.dart';
import '../../domain/entities/city.dart';
import 'json_helpers.dart';

/// JSON <-> City mapping. Field names match assets/data/cities.json.
/// Turkish fields: `cityTr`, `countryTr`, `landmarksTr`, `funFactTr`.
class CityModel {
  CityModel._();

  static City fromJson(Map<String, dynamic> json) {
    final name = readString(json['city']);
    final countryCode = readString(json['countryCode']).toUpperCase();
    final id = readString(json['id']);
    return City(
      id: id.isNotEmpty ? id : '${countryCode.toLowerCase()}-${TextUtils.slug(name)}',
      name: name,
      countryCode: countryCode,
      countryName: readString(json['country']),
      landmarks: readStringList(json['landmarks']),
      funFact: readString(json['funFact']),
      tier: readInt(json['tier'], 2),
      nameTr: readString(json['cityTr']),
      countryNameTr: readString(json['countryTr']),
      landmarksTr: readStringList(json['landmarksTr']),
      funFactTr: readString(json['funFactTr']),
    );
  }

  static Map<String, dynamic> toJson(City city) => {
        'id': city.id,
        'city': city.name,
        'cityTr': city.nameTr,
        'countryCode': city.countryCode,
        'country': city.countryName,
        'countryTr': city.countryNameTr,
        'landmarks': city.landmarks,
        'landmarksTr': city.landmarksTr,
        'funFact': city.funFact,
        'funFactTr': city.funFactTr,
        'tier': city.tier,
      };
}
