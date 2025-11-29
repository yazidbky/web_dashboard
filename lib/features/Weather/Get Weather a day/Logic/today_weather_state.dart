import 'package:equatable/equatable.dart';
import 'package:web_dashboard/features/Weather/Get%20Weather%20a%20day/Data/Models/today_weather_data_model.dart';

abstract class TodayWeatherState extends Equatable {
  const TodayWeatherState();

  @override
  List<Object?> get props => [];
}

class TodayWeatherInitial extends TodayWeatherState {}

class TodayWeatherLoading extends TodayWeatherState {}

class TodayWeatherSuccess extends TodayWeatherState {
  final TodayWeatherDataModel weatherData;
  final String message;

  const TodayWeatherSuccess({
    required this.weatherData,
    required this.message,
  });

  @override
  List<Object?> get props => [weatherData, message];
}

class TodayWeatherFailure extends TodayWeatherState {
  final String failureMessage;

  const TodayWeatherFailure(this.failureMessage);

  @override
  List<Object?> get props => [failureMessage];
}

