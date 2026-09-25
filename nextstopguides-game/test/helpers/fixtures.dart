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
  );
}

final List<Country> testCountries = [
  country('TR', 'Türkiye', 'Ankara', Continent.europe, currency: 'Turkish lira'),
  country('FR', 'France', 'Paris', Continent.europe, landmarks: const ['Eiffel Tower']),
  country('DE', 'Germany', 'Berlin', Continent.europe),
  country('IT', 'Italy', 'Rome', Continent.europe),
  country('ES', 'Spain', 'Madrid', Continent.europe, tier: 2),
  country('JP', 'Japan', 'Tokyo', Continent.asia),
  country('CN', 'China', 'Beijing', Continent.asia, landmarks: const ['Great Wall of China', 'Forbidden City']),
  country('SG', 'Singapore', 'Singapore', Continent.asia, tier: 2, currency: 'Singapore dollar'),
  country('EG', 'Egypt', 'Cairo', Continent.africa),
  country('KE', 'Kenya', 'Nairobi', Continent.africa, tier: 2),
  country('US', 'United States', 'Washington, D.C.', Continent.northAmerica),
  country('MX', 'Mexico', 'Mexico City', Continent.northAmerica),
  country('BR', 'Brazil', 'Brasília', Continent.southAmerica),
  country('AU', 'Australia', 'Canberra', Continent.oceania),
  country('BO', 'Bolivia', 'Sucre', Continent.southAmerica, tier: 3),
];

City city(
  String name,
  String countryCode,
  String countryName,
  List<String> landmarks, {
  int tier = 1,
}) {
  return City(
    id: '${countryCode.toLowerCase()}-${name.toLowerCase().replaceAll(' ', '-')}',
    name: name,
    countryCode: countryCode,
    countryName: countryName,
    landmarks: landmarks,
    funFact: 'Fun fact about $name.',
    tier: tier,
  );
}

final List<City> testCities = [
  city('Paris', 'FR', 'France', ['Eiffel Tower', 'Louvre Museum']),
  city('Rome', 'IT', 'Italy', ['Colosseum', 'Trevi Fountain']),
  city('Istanbul', 'TR', 'Türkiye', ['Hagia Sophia', 'Grand Bazaar']),
  city('Tokyo', 'JP', 'Japan', ['Shibuya Crossing', 'Tokyo Skytree']),
  city('Sydney', 'AU', 'Australia', ['Sydney Opera House', 'Harbour Bridge']),
  city('Cairo', 'EG', 'Egypt', ['Egyptian Museum']),
  city('Berlin', 'DE', 'Germany', ['Brandenburg Gate']),
  city('Mexico City', 'MX', 'Mexico', ['Zócalo']),
  city('Singapore', 'SG', 'Singapore', ['Merlion'], tier: 2),
  city('Only Leaky', 'US', 'United States', ['Only Leaky Tower'], tier: 1),
];
