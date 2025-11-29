import 'package:equatable/equatable.dart';
import 'package:web_dashboard/features/Farmers/Cron%20job/Data/Models/weather_cron_job_data_model.dart';

abstract class WeatherCronJobState extends Equatable {
  const WeatherCronJobState();

  @override
  List<Object?> get props => [];
}

class WeatherCronJobInitial extends WeatherCronJobState {}

class WeatherCronJobLoading extends WeatherCronJobState {}

class WeatherCronJobSuccess extends WeatherCronJobState {
  final WeatherCronJobDataModel data;
  final String message;

  const WeatherCronJobSuccess({
    required this.data,
    required this.message,
  });

  @override
  List<Object?> get props => [data, message];
}

class WeatherCronJobFailure extends WeatherCronJobState {
  final String failureMessage;

  const WeatherCronJobFailure(this.failureMessage);

  @override
  List<Object?> get props => [failureMessage];
}

