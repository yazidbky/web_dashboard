import 'package:web_dashboard/core/Database/api_consumer.dart';
import 'package:web_dashboard/core/constants/Endpoint.dart';
import 'package:web_dashboard/features/Graphs/Data/Models/grafana_graph_request_model.dart';
import 'package:web_dashboard/features/Graphs/Data/Models/grafana_graph_response_model.dart';

class GrafanaGraphApiService {
  final ApiConsumer apiConsumer;

  GrafanaGraphApiService(this.apiConsumer);

  Future<GrafanaGraphResponseModel> getGrafanaGraphUrl(
    GrafanaGraphRequestModel request,
  ) async {
    print('📡 [GrafanaGraphApiService] Requesting Grafana graph URL...');
    print('📋 [GrafanaGraphApiService] Request: ${request.toJson()}');
    
    final response = await apiConsumer.post(
      Endpoints.grafanaGraphUrlEndPoint,
      data: request.toJson(),
    );
    
    print('📡 [GrafanaGraphApiService] Response received');
    return GrafanaGraphResponseModel.fromJson(response);
  }
}

