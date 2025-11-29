import 'package:web_dashboard/features/Recommendation/Data/Models/Sub%20Models/recommendation_data_model.dart';
class RecommendationResponseModel {
  final int statusCode;
  final RecommendationDataModel data;
  final String message;
  final bool success;

  RecommendationResponseModel({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.success,
  });

  factory RecommendationResponseModel.fromJson(Map<String, dynamic> json) {
    return RecommendationResponseModel(
      statusCode: json['statusCode'] ?? 0,
      data: RecommendationDataModel.fromJson(json['data'] ?? {}),
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

