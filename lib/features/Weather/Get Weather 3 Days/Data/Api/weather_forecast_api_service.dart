import 'package:web_dashboard/core/Database/api_consumer.dart';
import 'package:web_dashboard/core/constants/Endpoint.dart';
import 'package:web_dashboard/features/Weather/Get%20Weather%203%20Days/Data/Models/weather_forecast_response_model.dart';

class WeatherForecastApiService {
  final ApiConsumer apiConsumer;

  WeatherForecastApiService(this.apiConsumer);

  Future<WeatherForecastResponseModel> getWeatherForecast(int landId) async {
    final response = await apiConsumer.get(
      Endpoints.getWeatherForecastEndPoint(landId),
    );
    return WeatherForecastResponseModel.fromJson(response);
  }
}

