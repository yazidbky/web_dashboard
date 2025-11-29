import 'package:web_dashboard/features/Farmers/Farmers%20Connect/Data/Models/connect_farmer_data_model.dart';

class ValidationError {
  final String field;
  final String message;

  ValidationError({
    required this.field,
    required this.message,
  });

  factory ValidationError.fromJson(Map<String, dynamic> json) {
    return ValidationError(
      field: json['field'] ?? '',
      message: json['message'] ?? '',
    );
  }
}

class ConnectFarmerResponseModel {
  final int statusCode;
  final ConnectFarmerDataModel? data;
  final String message;
  final bool success;
  final List<ValidationError>? errors;

  ConnectFarmerResponseModel({
    required this.statusCode,
    this.data,
    required this.message,
    required this.success,
    this.errors,
  });

  factory ConnectFarmerResponseModel.fromJson(Map<String, dynamic> json) {
    List<ValidationError>? errors;
    if (json['errors'] != null) {
      errors = (json['errors'] as List<dynamic>)
          .map((e) => ValidationError.fromJson(e))
          .toList();
    }

    return ConnectFarmerResponseModel(
      statusCode: json['statusCode'] ?? 0,
      data: json['data'] != null
          ? ConnectFarmerDataModel.fromJson(json['data'])
          : null,
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      errors: errors,
    );
  }

  /// Get formatted error message from validation errors
  String get formattedErrorMessage {
    if (errors != null && errors!.isNotEmpty) {
      return errors!.map((e) => '${e.field}: ${e.message}').join('\n');
    }
    return message;
  }
}

