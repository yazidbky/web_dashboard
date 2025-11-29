import 'package:web_dashboard/features/My%20Farmers/Data/Models/Sub%20Models/farmers_list_data_model.dart';

class MyFarmersResponseModel {
  final int statusCode;
  final FarmersListDataModel data;
  final String message;
  final bool success;

  MyFarmersResponseModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory MyFarmersResponseModel.fromJson(Map<String, dynamic> json) {
    return MyFarmersResponseModel(
      statusCode: json['statusCode'] ?? 0,
      data: FarmersListDataModel.fromJson(json['data'] ?? {}),
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

