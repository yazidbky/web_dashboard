import 'package:web_dashboard/core/Database/api_consumer.dart';
import 'package:web_dashboard/core/constants/Endpoint.dart';
import 'package:web_dashboard/features/Soil%20Status/Get%20All%20Soil%20Sections/Data/Models/soil_sections_response_model.dart';

class SoilSectionsApiService {
  final ApiConsumer apiConsumer;

  SoilSectionsApiService(this.apiConsumer);

  Future<SoilSectionsResponseModel> getAllSoilSections(int farmerId, int landId) async {
    final response = await apiConsumer.get(
      Endpoints.getAllSoilSectionsEndPoint(farmerId, landId),
    );
    return SoilSectionsResponseModel.fromJson(response);
  }
}

