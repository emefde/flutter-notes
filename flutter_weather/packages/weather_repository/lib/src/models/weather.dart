import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'weather.g.dart';

enum WeatherCondition {
  clear,
  rainy,
  cloudy,
  snowy,
  unknown,
}

@JsonSerializable()
class Weather extends Equatable {
  const Weather(
      {required this.location,
      required this.temperature,
      required this.condition});

  final String location;
  final double temperature;
  final WeatherCondition condition;

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);

  @override
  List<Object> get props => [location, temperature, condition];
}