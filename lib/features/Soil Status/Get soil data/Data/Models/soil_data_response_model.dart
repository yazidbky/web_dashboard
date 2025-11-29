import 'package:web_dashboard/features/Soil%20Status/Get%20soil%20data/Data/Models/soil_data_model.dart';

class SoilDataResponseModel {
  final int statusCode;
  final SoilDataModel? data;
  final String message;
  final bool success;

  SoilDataResponseModel({
    required this.statusCode,
    this.data,
    required this.message,
    required this.success,
  });

  factory SoilDataResponseModel.fromJson(Map<String, dynamic> json) {
    return SoilDataResponseModel(
      statusCode: json['statusCode'] ?? 0,
      data: json['data'] != null ? SoilDataModel.fromJson(json['data']) : null,
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data?.toJson(),
      'message': message,
      'success': success,
    };
  }
}

