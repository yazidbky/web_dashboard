import 'package:web_dashboard/features/Auth/Data/Models/Sub%20Models/data_model.dart';

class LoginResponseModel {
    int statusCode;
    DataModel dataModel;
    String message;
    bool success;

  LoginResponseModel({
    required this.statusCode,
    required this.dataModel,
    required this.message,
    required this.success,
  });

   factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
     statusCode: json['statusCode'] ?? 0,
     dataModel: DataModel.fromJson(json['data'] ?? {}),
     message: json['message'] ?? '',
     success: json['success'] ?? false,
    );
  }

   Map<String, dynamic> toJson() => {
     'statusCode': statusCode, 'dataModel': dataModel,'message': message, 'success': success,
  };
  
}







