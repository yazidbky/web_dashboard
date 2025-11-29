import 'package:web_dashboard/core/Database/api_consumer.dart';
import 'package:web_dashboard/core/constants/Endpoint.dart';
import 'package:web_dashboard/features/Historical%20Weather%20Data/Data/Models/weather_request_model.dart';
import 'package:web_dashboard/features/Historical%20Weather%20Data/Data/Models/weather_response_model.dart';

class WeatherApiService {
  final ApiConsumer apiConsumer;

  WeatherApiService(this.apiConsumer);

  Future<WeatherResponseModel> fetchAndSaveWeather(WeatherRequestModel request) async {
    print('📡 [WeatherApiService] Preparing to fetch weather data');
    print('📡 [WeatherApiService] Request data: ${request.toJson()}');
    print('📡 [WeatherApiService] Endpoint: ${Endpoints.weatherFetchAndSaveEndPoint}');
    
    try {
      final response = await apiConsumer.post(
        Endpoints.weatherFetchAndSaveEndPoint,
        data: request.toJson(),
      );
      print('📡 [WeatherApiService] Response received: $response');
      return WeatherResponseModel.fromJson(response);
    } catch (e) {
      print('❌ [WeatherApiService] Error in fetchAndSaveWeather: $e');
      rethrow;
    }
  }
}

