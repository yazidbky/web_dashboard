import 'package:equatable/equatable.dart';
import 'package:web_dashboard/features/Weather/Get%20Weather%203%20Days/Data/Models/forecast_day_model.dart';

abstract class WeatherForecastState extends Equatable {
  const WeatherForecastState();

  @override
  List<Object?> get props => [];
}

class WeatherForecastInitial extends WeatherForecastState {}

class WeatherForecastLoading extends WeatherForecastState {}

class WeatherForecastSuccess extends WeatherForecastState {
  final List<ForecastDayModel> forecastData;
  final String message;

  const WeatherForecastSuccess({
    required this.forecastData,
    required this.message,
  });

  @override
  List<Object?> get props => [forecastData, message];
}

class WeatherForecastFailure extends WeatherForecastState {
  final String failureMessage;

  const WeatherForecastFailure(this.failureMessage);

  @override
  List<Object?> get props => [failureMessage];
}

