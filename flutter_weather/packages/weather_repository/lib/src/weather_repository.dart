import 'dart:async';
import 'package:meta_weather_api/meta_weather_api.dart' hide Weather;
import 'package:weather_repository/weather_repository.dart';

class WeatherFailure implements Exception {}

class WeatherRepository {
  WeatherRepository({MetaWeatherAPIClient? apiClient})
      : _metaWeatherAPIClient = apiClient ?? MetaWeatherAPIClient();

  final MetaWeatherAPIClient _metaWeatherAPIClient;

  Future<Weather> getWeather(String city) async {
    try {
      final location = await _metaWeatherAPIClient.locationSearch(city);
      final weather = await _metaWeatherAPIClient.getWeather(location.woeid);
      return Weather(
          location: location.title,
          temperature: weather.theTemp,
          condition: weather.weatherStateAbbr.toCondition);
    } catch (exception) {
      throw exception;
    }
  }
}

extension on WeatherState {
  WeatherCondition get toCondition {
    switch (this) {
      case WeatherState.clear:
        return WeatherCondition.clear;
      case WeatherState.snow:
      case WeatherState.sleet:
      case WeatherState.hail:
        return WeatherCondition.snowy;
      case WeatherState.thunderstorm:
      case WeatherState.heavyRain:
      case WeatherState.lightRain:
      case WeatherState.showers:
        return WeatherCondition.rainy;
      case WeatherState.heavyCloud:
      case WeatherState.lightCloud:
        return WeatherCondition.cloudy;
      default:
        return WeatherCondition.unknown;
    }
  }
}
