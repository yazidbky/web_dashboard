import 'package:web_dashboard/features/Farmers/Get%20Farmer%20Lands/Data/Models/farmer_lands_data_model.dart';

class FarmerLandsResponseModel {
  final int statusCode;
  final FarmerLandsDataModel data;
  final String message;
  final bool success;

  FarmerLandsResponseModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory FarmerLandsResponseModel.fromJson(Map<String, dynamic> json) {
    return FarmerLandsResponseModel(
      statusCode: json['statusCode'] ?? 0,
      data: FarmerLandsDataModel.fromJson(json['data'] ?? {}),
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

