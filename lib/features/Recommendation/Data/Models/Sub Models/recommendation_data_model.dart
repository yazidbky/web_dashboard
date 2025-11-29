import 'package:web_dashboard/features/Recommendation/Data/Models/Sub%20Models/land_profile_model.dart';
import 'package:web_dashboard/features/Recommendation/Data/Models/Sub%20Models/recommendation_item_model.dart';

class RecommendationDataModel {
  final LandProfileModel landProfile;
  final List<RecommendationItemModel> recommendations;

  RecommendationDataModel({
    required this.landProfile,
    required this.recommendations,
  });

  factory RecommendationDataModel.fromJson(Map<String, dynamic> json) {
    return RecommendationDataModel(
      landProfile: LandProfileModel.fromJson(json['landProfile'] ?? {}),
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => RecommendationItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'landProfile': landProfile.toJson(),
        'recommendations': recommendations.map((e) => e.toJson()).toList(),
      };
}

