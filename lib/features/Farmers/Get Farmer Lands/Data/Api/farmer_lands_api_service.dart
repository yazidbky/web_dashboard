import 'package:web_dashboard/core/Database/api_consumer.dart';
import 'package:web_dashboard/core/constants/Endpoint.dart';
import 'package:web_dashboard/features/Farmers/Get%20Farmer%20Lands/Data/Models/farmer_lands_response_model.dart';

class FarmerLandsApiService {
  final ApiConsumer apiConsumer;

  FarmerLandsApiService(this.apiConsumer);

  Future<FarmerLandsResponseModel> getFarmerLands(int farmerId) async {
    final response = await apiConsumer.get(
      Endpoints.getFarmerLandsEndPoint(farmerId),
    );
    return FarmerLandsResponseModel.fromJson(response);
  }
}

