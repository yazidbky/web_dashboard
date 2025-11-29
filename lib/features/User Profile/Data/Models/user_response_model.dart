import 'package:web_dashboard/features/Auth/Data/Models/Sub%20Models/farmer_model.dart';

class EngineerResponseModel {
  int statusCode;
  EngineerData data;
  String message;
  bool success;

  EngineerResponseModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory EngineerResponseModel.fromJson(Map<String, dynamic> json) {
    return EngineerResponseModel(
      statusCode: json['statusCode'] ?? 0,
      data: EngineerData.fromJson(json['data'] ?? {}),
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

