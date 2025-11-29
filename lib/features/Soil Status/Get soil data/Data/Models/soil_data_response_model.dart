import 'package:web_dashboard/features/Soil%20Status/Get%20soil%20data/Data/Models/soil_data_wrapper_model.dart';

class SoilDataResponseModel {
  final int statusCode;
  final SoilDataWrapperModel? data;
  final String message;
  final bool success;

  SoilDataResponseModel({
    required this.statusCode,
    this.data,
    required this.message,
    required this.success,
  });

  factory SoilDataResponseModel.fromJson(Map<String, dynamic> json) {
    SoilDataWrapperModel? wrapperData;
    if (json['data'] != null) {
      final dataMap = json['data'] as Map<String, dynamic>;
      wrapperData = SoilDataWrapperModel.fromJson(dataMap);
    }
    
    return SoilDataResponseModel(
      statusCode: json['statusCode'] ?? 0,
      data: wrapperData,
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

