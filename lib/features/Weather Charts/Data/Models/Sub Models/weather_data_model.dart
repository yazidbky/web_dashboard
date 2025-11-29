import 'package:web_dashboard/features/Weather Charts/Data/Models/Sub Models/weather_record_model.dart';
import 'package:web_dashboard/features/Weather Charts/Data/Models/Sub Models/weather_error_detail_model.dart';

class WeatherDataModel {
  final int totalDays;
  final int saved;
  final int errors;
  final List<WeatherRecordModel> records;
  final List<WeatherErrorDetailModel> errorDetails;

  WeatherDataModel({
    required this.totalDays,
    required this.saved,
    required this.errors,
    required this.records,
    required this.errorDetails,
  });

  factory WeatherDataModel.fromJson(Map<String, dynamic> json) {
    return WeatherDataModel(
      totalDays: json['totalDays'] ?? 0,
      saved: json['saved'] ?? 0,
      errors: json['errors'] ?? 0,
      records: (json['records'] as List<dynamic>?)
              ?.map((e) => WeatherRecordModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      errorDetails: (json['errorDetails'] as List<dynamic>?)
              ?.map((e) => WeatherErrorDetailModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'totalDays': totalDays,
        'saved': saved,
        'errors': errors,
        'records': records.map((e) => e.toJson()).toList(),
        'errorDetails': errorDetails.map((e) => e.toJson()).toList(),
      };
}

