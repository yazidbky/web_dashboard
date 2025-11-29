import 'package:web_dashboard/features/Farmers/Cron%20job/Data/Models/weather_cron_job_data_model.dart';

class WeatherCronJobResponseModel {
  final int statusCode;
  final WeatherCronJobDataModel data;
  final String message;
  final bool success;

  WeatherCronJobResponseModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory WeatherCronJobResponseModel.fromJson(Map<String, dynamic> json) {
    return WeatherCronJobResponseModel(
      statusCode: json['statusCode'] ?? 0,
      data: WeatherCronJobDataModel.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'data': data.toJson(),
        'message': message,
        'success': success,
      };
}

