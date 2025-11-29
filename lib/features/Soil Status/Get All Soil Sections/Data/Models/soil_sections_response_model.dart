import 'package:web_dashboard/features/Soil%20Status/Get%20All%20Soil%20Sections/Data/Models/soil_sections_data_model.dart';

class SoilSectionsResponseModel {
  final int statusCode;
  final SoilSectionsDataModel data;
  final String message;
  final bool success;

  SoilSectionsResponseModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory SoilSectionsResponseModel.fromJson(Map<String, dynamic> json) {
    return SoilSectionsResponseModel(
      statusCode: json['statusCode'] ?? 0,
      data: SoilSectionsDataModel.fromJson(json['data'] ?? {}),
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

