import 'package:web_dashboard/features/Dashboard/Data/Models/overview_data_model.dart';

class OverviewResponseModel {
  final int statusCode;
  final OverviewDataModel data;
  final String message;
  final bool success;

  OverviewResponseModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory OverviewResponseModel.fromJson(Map<String, dynamic> json) {
    return OverviewResponseModel(
      statusCode: json['statusCode'] ?? 0,
      data: OverviewDataModel.fromJson(json['data'] ?? {}),
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

