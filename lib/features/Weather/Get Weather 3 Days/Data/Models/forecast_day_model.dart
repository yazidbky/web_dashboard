import 'package:web_dashboard/features/Weather/Get%20Weather%203%20Days/Data/Models/forecast_condition_model.dart';

class ForecastDayModel {
  final String dayName;
  final ForecastConditionModel condition;
  final int tempMax;
  final int tempMin;
  final int aqi;

  ForecastDayModel({
    required this.dayName,
    required this.condition,
    required this.tempMax,
    required this.tempMin,
    required this.aqi,
  });

  factory ForecastDayModel.fromJson(Map<String, dynamic> json) {
    return ForecastDayModel(
      dayName: json['dayName'] ?? '',
      condition: ForecastConditionModel.fromJson(json['condition'] ?? {}),
      tempMax: json['tempMax'] ?? 0,
      tempMin: json['tempMin'] ?? 0,
      aqi: json['aqi'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'dayName': dayName,
        'condition': condition.toJson(),
        'tempMax': tempMax,
        'tempMin': tempMin,
        'aqi': aqi,
      };
}

