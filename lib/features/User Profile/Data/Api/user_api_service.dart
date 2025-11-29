import 'package:web_dashboard/core/Database/api_consumer.dart';
import 'package:web_dashboard/core/constants/Endpoint.dart';
import 'package:web_dashboard/features/User Profile/Data/Models/user_response_model.dart';

class EngineerApiService {
  final ApiConsumer apiConsumer;

  EngineerApiService(this.apiConsumer);

  Future<EngineerResponseModel> getUserProfile() async {
    final response = await apiConsumer.get(
      Endpoints.userProfileEndPoint,
    );
    return EngineerResponseModel.fromJson(response);
  }
}

