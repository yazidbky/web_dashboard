import 'package:web_dashboard/core/Database/api_consumer.dart';
import 'package:web_dashboard/core/constants/Endpoint.dart';
import 'package:web_dashboard/features/Farmers/Farmers%20Disconnect/Data/Models/disconnect_farmer_response_model.dart';

class DisconnectFarmerApiService {
  final ApiConsumer apiConsumer;

  DisconnectFarmerApiService(this.apiConsumer);

  Future<DisconnectFarmerResponseModel> disconnectFarmer(int farmerId) async {
    final response = await apiConsumer.delete(
      Endpoints.disconnectFarmerEndPoint(farmerId),
    );
    return DisconnectFarmerResponseModel.fromJson(response);
  }
}

