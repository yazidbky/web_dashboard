import 'package:web_dashboard/features/Historical%20Weather%20Data/Data/Models/Sub%20Models/weather_data_model.dart';
class WeatherResponseModel {
  final int statusCode;
  final WeatherDataModel data;
  final String message;
  final bool success;

  WeatherResponseModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory WeatherResponseModel.fromJson(Map<String, dynamic> json) {
    return WeatherResponseModel(
      statusCode: json['statusCode'] ?? 0,
      data: WeatherDataModel.fromJson(json['data'] ?? {}),
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

