import 'package:web_dashboard/core/Database/api_consumer.dart';
import 'package:web_dashboard/core/constants/Endpoint.dart';
import 'package:web_dashboard/features/Farmers/Farmers%20Connect/Data/Models/connect_farmer_request_model.dart';
import 'package:web_dashboard/features/Farmers/Farmers%20Connect/Data/Models/connect_farmer_response_model.dart';

class ConnectFarmerApiService {
  final ApiConsumer apiConsumer;

  ConnectFarmerApiService(this.apiConsumer);

  Future<ConnectFarmerResponseModel> connectFarmer(
      ConnectFarmerRequestModel request) async {
    final response = await apiConsumer.post(
      Endpoints.connectFarmerEndPoint,
      data: request.toJson(),
    );
    return ConnectFarmerResponseModel.fromJson(response);
  }
}

