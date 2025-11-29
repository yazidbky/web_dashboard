import 'package:web_dashboard/core/Database/api_consumer.dart';
import 'package:web_dashboard/core/constants/Endpoint.dart';
import 'package:web_dashboard/features/Soil%20Status/Get%20soil%20data/Data/Models/soil_data_response_model.dart';

class SoilDataApiService {
  final ApiConsumer apiConsumer;

  SoilDataApiService(this.apiConsumer);

  /// Fetches soil data for a specific farmer, land, and section
  /// 
  /// [farmerId] - The ID of the farmer
  /// [landId] - The ID of the land
  /// [section] - The section identifier
  Future<SoilDataResponseModel> getSoilData({
    required int farmerId,
    required int landId,
    required String section,
  }) async {
    final response = await apiConsumer.get(
      Endpoints.getSoilDataEndPoint(farmerId, landId, section),
    );
    return SoilDataResponseModel.fromJson(response);
  }
}

