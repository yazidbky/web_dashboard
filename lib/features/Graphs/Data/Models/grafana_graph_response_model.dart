import 'package:web_dashboard/features/Graphs/Data/Models/grafana_graph_data_model.dart';

class GrafanaGraphResponseModel {
  final int statusCode;
  final GrafanaGraphDataModel? data;
  final String message;
  final bool success;

  GrafanaGraphResponseModel({
    required this.statusCode,
    this.data,
    required this.message,
    required this.success,
  });

  factory GrafanaGraphResponseModel.fromJson(Map<String, dynamic> json) {
    return GrafanaGraphResponseModel(
      statusCode: json['statusCode'] ?? 0,
      data: json['data'] != null
          ? GrafanaGraphDataModel.fromJson(json['data'])
          : null,
      message: json['message'] ?? '',
      success: json['success'] ?? false,
    );
  }
}

