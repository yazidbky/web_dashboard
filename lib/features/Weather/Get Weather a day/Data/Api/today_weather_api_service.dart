import 'package:web_dashboard/core/Database/api_consumer.dart';
import 'package:web_dashboard/core/constants/Endpoint.dart';
import 'package:web_dashboard/features/Weather/Get%20Weather%20a%20day/Data/Models/today_weather_response_model.dart';

class TodayWeatherApiService {
  final ApiConsumer apiConsumer;

  TodayWeatherApiService(this.apiConsumer);

  Future<TodayWeatherResponseModel> getTodayWeather(int landId) async {
    final response = await apiConsumer.get(
      Endpoints.getTodayWeatherEndPoint(landId),
    );
    return TodayWeatherResponseModel.fromJson(response);
  }
}

