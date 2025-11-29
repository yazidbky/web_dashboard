import 'package:web_dashboard/features/Weather/Get%20Weather%20a%20day/Data/Models/today_weather_unit_model.dart';

class TodayWeatherDataModel {
  final WeatherUnitModel rain;
  final WeatherUnitModel temperature;
  final WeatherUnitModel wind;
  final WeatherUnitModel humidity;

  TodayWeatherDataModel({
    required this.rain,
    required this.temperature,
    required this.wind,
    required this.humidity,
  });

  factory TodayWeatherDataModel.fromJson(Map<String, dynamic> json) {
    return TodayWeatherDataModel(
      rain: WeatherUnitModel.fromJson(json['rain'] ?? {}),
      temperature: WeatherUnitModel.fromJson(json['temperature'] ?? {}),
      wind: WeatherUnitModel.fromJson(json['wind'] ?? {}),
      humidity: WeatherUnitModel.fromJson(json['humidity'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'rain': rain.toJson(),
        'temperature': temperature.toJson(),
        'wind': wind.toJson(),
        'humidity': humidity.toJson(),
      };
}

