import 'package:equatable/equatable.dart';
import 'package:web_dashboard/features/Historical%20Weather%20Data/Data/Models/Sub%20Models/weather_data_model.dart';
abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherSuccess extends WeatherState {
  final WeatherDataModel weatherData;
  final String message;

  const WeatherSuccess({
    required this.weatherData,
    required this.message,
  });

  @override
  List<Object?> get props => [weatherData, message];
}

class WeatherFailure extends WeatherState {
  final String failureMessage;

  const WeatherFailure(this.failureMessage);

  @override
  List<Object?> get props => [failureMessage];
}

