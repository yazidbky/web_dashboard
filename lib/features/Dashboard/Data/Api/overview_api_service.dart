import 'package:web_dashboard/core/Database/api_consumer.dart';
import 'package:web_dashboard/core/constants/Endpoint.dart';
import 'package:web_dashboard/features/Dashboard/Data/Models/overview_response_model.dart';

class OverviewApiService {
  final ApiConsumer apiConsumer;

  OverviewApiService(this.apiConsumer);

  Future<OverviewResponseModel> getOverview() async {
    final response = await apiConsumer.get(Endpoints.overviewEndPoint);
    return OverviewResponseModel.fromJson(response);
  }
}

