import 'package:web_dashboard/features/Weather/Get%20Weather%203%20Days/Data/Models/forecast_day_model.dart';

class WeatherForecastResponseModel {
  final int statusCode;
  final List<ForecastDayModel> data;
  final String message;
  final bool success;

  WeatherForecastResponseModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory WeatherForecastResponseModel.fromJson(Map<String, dynamic> json) {
    return WeatherForecastResponseModel(
      statusCode: json['statusCode'] ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => ForecastDayModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'data': data.map((e) => e.toJson()).toList(),
        'message': message,
        'success': success,
      };
}

