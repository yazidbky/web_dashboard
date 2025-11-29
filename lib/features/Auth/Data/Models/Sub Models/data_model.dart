import 'package:web_dashboard/features/Auth/Data/Models/Sub%20Models/farmer_model.dart';

class DataModel {
  EngineerData engineerData ;
  String token ; 
  
  DataModel({
    required this.engineerData,
    required this.token
  });

    factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
     engineerData: EngineerData.fromJson(json['engineerData'] ?? {}),
     token: json['token'] ?? ''
    );
  }

   Map<String, dynamic> toJson() => {
     'engineerData': engineerData, 'token': token
  };

}