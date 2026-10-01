import 'package:nextstopguides_game/domain/entities/city.dart';
import 'package:nextstopguides_game/domain/entities/continent.dart';
import 'package:nextstopguides_game/domain/entities/country.dart';

Country country(
  String code,
  String name,
  String capital,
  Continent continent, {
  int tier = 1,
  String currency = 'Coin',
  List<String> landmarks = const ['Old Tower'],
  String nameTr = '',
  String capitalTr = '',
  String currencyTr = 'Jeton',
  List<String> languagesTr = const ['Dil'],
  List<String> landmarksTr = const ['Eski Kule'],
  List<String> aliasesTr = const [],
}) {
  return Country(
    code: code,
    name: name,
    capital: capital,
    continent: continent,
    flag: '🏳️$code',
    currency: currency,
    languages: const ['Language'],
    population: '1M-10M',
    landmarks: landmarks,
    funFact: 'Fun fact about $name.',
    tier: tier,
    nameTr: nameTr,
    capitalTr: capitalTr,
    currencyTr: currencyTr,
    languagesTr: languagesTr,
    landmarksTr: landmarksTr,
    funFactTr: nameTr.isEmpty ? '' : '$nameTr hakkında ilginç bilgi.',
    aliasesTr: aliasesTr,
  );
}

final List<Country> testCountries = [
  country('TR', 'Türkiye', 'Ankara', Continent.europe,
      currency: 'Turkish lira',
      nameTr: 'Türkiye', capitalTr: 'Ankara', currencyTr: 'Türk lirası',
      languagesTr: const ['Türkçe']),
  country('FR', 'France', 'Paris', Continent.europe,
      landmarks: const ['Eiffel Tower'],
      nameTr: 'Fransa', capitalTr: 'Paris', landmarksTr: const ['Eyfel Kulesi']),
  country('DE', 'Germany', 'Berlin', Continent.europe,
      nameTr: 'Almanya', capitalTr: 'Berlin'),
  // Upper-case dotted İ checks the Turkish-aware masking.
  country('IT', 'Italy', 'Rome', Continent.europe,
      nameTr: 'İtalya', capitalTr: 'Roma', languagesTr: const ['İtalyanca'],
      landmarksTr: const ['İTALYA Kulesi', 'Kolezyum']),
  country('ES', 'Spain', 'Madrid', Continent.europe, tier: 2,
      nameTr: 'İspanya', capitalTr: 'Madrid'),
  country('JP', 'Japan', 'Tokyo', Continent.asia,
      nameTr: 'Japonya', capitalTr: 'Tokyo'),
  country('CN', 'China', 'Beijing', Continent.asia,
      landmarks: const ['Great Wall of China', 'Forbidden City'],
      nameTr: 'Çin', capitalTr: 'Pekin',
      landmarksTr: const ['Çin Seddi', 'Yasak Şehir']),
  country('SG', 'Singapore', 'Singapore', Continent.asia, tier: 2,
      currency: 'Singapore dollar',
      nameTr: 'Singapur', capitalTr: 'Singapur', currencyTr: 'Singapur doları'),
  // Dotless ı / upper-case I: "MISIR" must still be masked as "Mısır".
  country('EG', 'Egypt', 'Cairo', Continent.africa,
      nameTr: 'Mısır', capitalTr: 'Kahire', currencyTr: 'MISIR lirası'),
  country('KE', 'Kenya', 'Nairobi', Continent.africa, tier: 2,
      nameTr: 'Kenya', capitalTr: 'Nairobi'),
  country('US', 'United States', 'Washington, D.C.', Continent.northAmerica,
      nameTr: 'Amerika Birleşik Devletleri', capitalTr: 'Washington, D.C.',
      currencyTr: 'ABD doları', aliasesTr: const ['ABD']),
  country('MX', 'Mexico', 'Mexico City', Continent.northAmerica,
      nameTr: 'Meksika', capitalTr: 'Meksiko'),
  country('BR', 'Brazil', 'Brasília', Continent.southAmerica,
      nameTr: 'Brezilya', capitalTr: 'Brasília'),
  country('AU', 'Australia', 'Canberra', Continent.oceania,
      nameTr: 'Avustralya', capitalTr: 'Kanberra'),
  country('BO', 'Bolivia', 'Sucre', Continent.southAmerica, tier: 3,
      nameTr: 'Bolivya', capitalTr: 'Sucre'),
];

City city(
  String name,
  String countryCode,
  String countryName,
  List<String> landmarks, {
  int tier = 1,
  String nameTr = '',
  List<String> landmarksTr = const [],
}) {
  return City(
    id: '${countryCode.toLowerCase()}-${name.toLowerCase().replaceAll(' ', '-')}',
    name: name,
    countryCode: countryCode,
    countryName: countryName,
    landmarks: landmarks,
    funFact: 'Fun fact about $name.',
    tier: tier,
    nameTr: nameTr,
    landmarksTr: landmarksTr,
    funFactTr: nameTr.isEmpty ? '' : '$nameTr hakkında ilginç bilgi.',
  );
}

final List<City> testCities = [
  city('Paris', 'FR', 'France', ['Eiffel Tower', 'Louvre Museum'],
      nameTr: 'Paris', landmarksTr: ['Eyfel Kulesi', 'Louvre Müzesi']),
  city('Rome', 'IT', 'Italy', ['Colosseum', 'Trevi Fountain'],
      nameTr: 'Roma', landmarksTr: ['Kolezyum', 'Roma Forumu']),
  city('Istanbul', 'TR', 'Türkiye', ['Hagia Sophia', 'Grand Bazaar'],
      nameTr: 'İstanbul', landmarksTr: ['Ayasofya', 'Kapalıçarşı']),
  city('Tokyo', 'JP', 'Japan', ['Shibuya Crossing', 'Tokyo Skytree'],
      nameTr: 'Tokyo', landmarksTr: ['Shibuya Kavşağı']),
  city('Sydney', 'AU', 'Australia', ['Sydney Opera House', 'Harbour Bridge'],
      nameTr: 'Sidney', landmarksTr: ['Opera Binası', 'Liman Köprüsü']),
  city('Cairo', 'EG', 'Egypt', ['Egyptian Museum'],
      nameTr: 'Kahire', landmarksTr: ['Mısır Müzesi']),
  city('Berlin', 'DE', 'Germany', ['Brandenburg Gate'],
      nameTr: 'Berlin', landmarksTr: ['Brandenburg Kapısı']),
  city('Mexico City', 'MX', 'Mexico', ['Zócalo'],
      nameTr: 'Meksiko', landmarksTr: ['Zócalo']),
  city('Singapore', 'SG', 'Singapore', ['Merlion'], tier: 2,
      nameTr: 'Singapur', landmarksTr: ['Merlion']),
  // No Turkish fields on purpose: exercises the English fallback.
  city('Only Leaky', 'US', 'United States', ['Only Leaky Tower'], tier: 1),
];
