import 'package:web_dashboard/features/Weather/Get%20Weather%20a%20day/Data/Models/today_weather_data_model.dart';

class TodayWeatherResponseModel {
  final int statusCode;
  final TodayWeatherDataModel data;
  final String message;
  final bool success;

  TodayWeatherResponseModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory TodayWeatherResponseModel.fromJson(Map<String, dynamic> json) {
    return TodayWeatherResponseModel(
      statusCode: json['statusCode'] ?? 0,
      data: TodayWeatherDataModel.fromJson(json['data'] ?? {}),
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

