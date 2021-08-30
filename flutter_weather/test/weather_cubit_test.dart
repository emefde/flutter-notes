import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/theme/cubit/theme_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_weather/weather/weather.dart';
import 'package:weather_repository/weather_repository.dart'
    as weather_repository;

import 'helpers/hydrated_bloc.dart';

const weatherLocation = 'London';
const weatherCondition = weather_repository.WeatherCondition.clear;
const weatherTemperature = 23.0;

class MockWeatherRepository extends Mock
    implements weather_repository.WeatherRepository {}

class MockWeather extends Mock implements weather_repository.Weather {}

void main() {
  group('WeatherRepository', () {
    late weather_repository.Weather weather;
    late weather_repository.WeatherRepository repository;
    late WeatherCubit weatherCubit;

    setUpAll(initHydratedBloc);

    setUp(() {
      weather = MockWeather();
      repository = MockWeatherRepository();
      when(() => weather.location).thenReturn(weatherLocation);
      when(() => weather.condition).thenReturn(weatherCondition);
      when(() => weather.temperature).thenReturn(weatherTemperature);
      when(() => repository.getWeather(weatherLocation))
          .thenAnswer((_) async => weather);
      weatherCubit = WeatherCubit(repository);
    });

    tearDown(() {
      weatherCubit.close();
    });

    test('initial state is correct', () {
      expect(weatherCubit.state, WeatherState());
    });

    group('toJson/fromJson', () {
      test('works properly', () {
        expect(weatherCubit.fromJson(weatherCubit.toJson(weatherCubit.state)),
            WeatherState());
      });
    });

    group('fetchWeather', () {
      blocTest<WeatherCubit, WeatherState>(
        'emits nothing when city is null',
        build: () => WeatherCubit(repository),
        act: (cubit) => cubit.fetchWeather(null),
        expect: () => const <WeatherState>[],
      );

      blocTest<WeatherCubit, WeatherState>(
        'emits nothing when city is empty',
        build: () => WeatherCubit(repository),
        act: (cubit) => cubit.fetchWeather(''),
        expect: () => const <WeatherState>[],
      );

      blocTest<WeatherCubit, WeatherState>('calls getWeather with correct city',
          build: () => WeatherCubit(repository),
          act: (cubit) => cubit.fetchWeather(weatherLocation),
          verify: (_) {
            verify(() => repository.getWeather(weatherLocation)).called(1);
          });

      blocTest<WeatherCubit, WeatherState>(
          'emits [loading, failure] when getWeather throws',
          build: () {
            when(() => repository.getWeather(any()))
                .thenThrow(Exception('whoops'));
            return weatherCubit;
          },
          act: (cubit) => cubit.fetchWeather(weatherLocation),
          expect: () => <WeatherState>[
                WeatherState(status: WeatherStatus.loading),
                WeatherState(status: WeatherStatus.failure)
              ]);

      blocTest<WeatherCubit, WeatherState>(
          'emits [loading, success] when getWeather returns celcius',
          build: () => weatherCubit,
          act: (cubit) => cubit.fetchWeather(weatherLocation),
          expect: () => <dynamic>[
                WeatherState(status: WeatherStatus.loading),
                isA<WeatherState>()
                    .having((w) => w.status, 'status', WeatherStatus.success)
                    .having(
                        (w) => w.weather,
                        'weather',
                        isA<Weather>()
                            .having((w) => w.condition, 'condition',
                                weather_repository.WeatherCondition.clear)
                            .having((w) => w.temperature, 'temp',
                                Temperature(value: weatherTemperature))
                            .having((w) => w.location, 'location', 'London'))
              ]);

      blocTest<WeatherCubit, WeatherState>(
          'emits [loading, success] when getWeather returns fahrenheit',
          build: () => weatherCubit,
          seed: () =>
              WeatherState(temperatureUnits: TemperatureUnits.fahrenheit),
          act: (cubit) => cubit.fetchWeather(weatherLocation),
          expect: () => <dynamic>[
                WeatherState(
                    status: WeatherStatus.loading,
                    temperatureUnits: TemperatureUnits.fahrenheit),
                isA<WeatherState>()
                    .having((w) => w.status, 'status', WeatherStatus.success)
                    .having(
                        (w) => w.weather,
                        'weather',
                        isA<Weather>()
                            .having((w) => w.condition, 'condition',
                                weather_repository.WeatherCondition.clear)
                            .having(
                                (w) => w.temperature,
                                'temp',
                                Temperature(
                                    value: weatherTemperature.toFahrenheit()))
                            .having((w) => w.location, 'location', 'London'))
              ]);
    });
  });
}

extension on double {
  double toFahrenheit() => ((this * 9 / 5) + 32);
  double toCelsius() => ((this - 32) * 5 / 9);
}