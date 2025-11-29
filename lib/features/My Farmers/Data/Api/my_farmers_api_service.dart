import 'package:web_dashboard/core/Database/api_consumer.dart';
import 'package:web_dashboard/core/constants/Endpoint.dart';
import 'package:web_dashboard/features/My%20Farmers/Data/Models/my_farmers_response_model.dart';

class MyFarmersApiService {
  final ApiConsumer apiConsumer;

  MyFarmersApiService(this.apiConsumer);

  Future<MyFarmersResponseModel> getMyFarmers() async {
    final response = await apiConsumer.get(
      Endpoints.myFarmersEndPoint,
    );
    return MyFarmersResponseModel.fromJson(response);
  }
}

