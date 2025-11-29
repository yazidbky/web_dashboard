import 'package:web_dashboard/features/Soil%20Status/Get%20soil%20data/Data/Models/soil_data_model.dart';
import 'package:web_dashboard/features/Soil%20Status/Get%20soil%20data/Data/Models/soil_parameter_model.dart';
import 'package:web_dashboard/features/Soil%20Status/Get%20soil%20data/Data/Models/soil_health_score_model.dart';

class SoilDataWrapperModel {
  final List<SoilParameterModel> parameters;
  final SoilHealthScoreModel soilHealthScore;
  final SoilDataModel rawData;

  SoilDataWrapperModel({
    required this.parameters,
    required this.soilHealthScore,
    required this.rawData,
  });

  factory SoilDataWrapperModel.fromJson(Map<String, dynamic> json) {
    // Parse parameters array
    List<SoilParameterModel> parameters = [];
    if (json['parameters'] != null && json['parameters'] is List) {
      parameters = (json['parameters'] as List)
          .map((item) => SoilParameterModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    // Parse soilHealthScore
    SoilHealthScoreModel soilHealthScore = SoilHealthScoreModel(
      score: 0,
      percentage: '0%',
      overallStatus: '',
    );
    if (json['soilHealthScore'] != null) {
      soilHealthScore = SoilHealthScoreModel.fromJson(
        json['soilHealthScore'] as Map<String, dynamic>,
      );
    }

    // Parse rawData
    SoilDataModel rawData = SoilDataModel(
      id: 0,
      farmerId: 0,
      landId: 0,
      section: '',
      soilMoisture: 0,
      soilTemperature: 0,
      ph: 0,
      electricalConductivity: 0,
      organicMatter: 0,
      nitrite: 0,
      soilHealthScore: 0,
      overallStatus: '',
      nitrogen: 0,
      phosphorus: 0,
      potassium: 0,
      soilType: '',
      latitude: 0,
      longitude: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    if (json['rawData'] != null) {
      rawData = SoilDataModel.fromJson(
        json['rawData'] as Map<String, dynamic>,
      );
    }

    return SoilDataWrapperModel(
      parameters: parameters,
      soilHealthScore: soilHealthScore,
      rawData: rawData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parameters': parameters.map((p) => p.toJson()).toList(),
      'soilHealthScore': soilHealthScore.toJson(),
      'rawData': rawData.toJson(),
    };
  }
}

