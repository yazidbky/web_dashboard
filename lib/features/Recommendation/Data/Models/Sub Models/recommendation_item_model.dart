import 'package:web_dashboard/features/Recommendation/Data/Models/Sub%20Models/crop_data_model.dart';

class RecommendationItemModel {
  final int rank;
  final int cropRecId;
  final String cropName;
  final double similarityScore;
  final double similarityPercentage;
  final CropDataModel cropData;

  RecommendationItemModel({
    required this.rank,
    required this.cropRecId,
    required this.cropName,
    required this.similarityScore,
    required this.similarityPercentage,
    required this.cropData,
  });

  factory RecommendationItemModel.fromJson(Map<String, dynamic> json) {
    return RecommendationItemModel(
      rank: json['rank'] ?? 0,
      cropRecId: json['cropRecId'] ?? 0,
      cropName: json['cropName'] ?? '',
      similarityScore: _parseDouble(json['similarityScore']),
      similarityPercentage: _parseDouble(json['similarityPercentage']),
      cropData: CropDataModel.fromJson(json['cropData'] ?? {}),
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() => {
        'rank': rank,
        'cropRecId': cropRecId,
        'cropName': cropName,
        'similarityScore': similarityScore,
        'similarityPercentage': similarityPercentage,
        'cropData': cropData.toJson(),
      };
}

