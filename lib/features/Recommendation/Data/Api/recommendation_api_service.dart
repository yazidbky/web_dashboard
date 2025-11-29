import 'package:web_dashboard/core/Database/api_consumer.dart';
import 'package:web_dashboard/core/constants/Endpoint.dart';
import 'package:web_dashboard/features/Recommendation/Data/Models/recommendation_response_model.dart';

class RecommendationApiService {
  final ApiConsumer apiConsumer;

  RecommendationApiService(this.apiConsumer);

  Future<RecommendationResponseModel> getCropRecommendations({
    required int farmerId,
    required int landId,
  }) async {
    final response = await apiConsumer.get(
      Endpoints.recommendationsEndPoint(farmerId, landId),
    );
    return RecommendationResponseModel.fromJson(response);
  }
}

