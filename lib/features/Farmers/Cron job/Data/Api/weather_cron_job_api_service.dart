import 'package:web_dashboard/core/Database/api_consumer.dart';
import 'package:web_dashboard/core/constants/Endpoint.dart';
import 'package:web_dashboard/features/Farmers/Cron%20job/Data/Models/weather_cron_job_response_model.dart';

class WeatherCronJobApiService {
  final ApiConsumer apiConsumer;

  WeatherCronJobApiService(this.apiConsumer);

  Future<WeatherCronJobResponseModel> startWeatherCronJob() async {
    final response = await apiConsumer.post(
      Endpoints.startWeatherCronJobEndPoint,
      data: null, // No data to send for this endpoint
    );
    return WeatherCronJobResponseModel.fromJson(response);
  }
}

