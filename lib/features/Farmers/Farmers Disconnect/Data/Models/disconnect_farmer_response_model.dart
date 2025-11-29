import 'package:web_dashboard/features/Farmers/Farmers%20Disconnect/Data/Models/disconnect_farmer_data_model.dart';

class DisconnectFarmerResponseModel {
  final int statusCode;
  final DisconnectFarmerDataModel data;
  final String message;
  final bool success;

  DisconnectFarmerResponseModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory DisconnectFarmerResponseModel.fromJson(Map<String, dynamic> json) {
    return DisconnectFarmerResponseModel(
      statusCode: json['statusCode'] ?? 0,
      data: DisconnectFarmerDataModel.fromJson(json['data'] ?? {}),
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

