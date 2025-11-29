import 'package:web_dashboard/features/Farmers/Farmers%20Connect/Data/Models/connected_farmer_model.dart';
import 'package:web_dashboard/features/Farmers/Farmers%20Connect/Data/Models/connected_engineer_model.dart';

class ConnectFarmerDataModel {
  final int id;
  final int farmerId;
  final int engineerId;
  final ConnectedFarmerModel farmer;
  final ConnectedEngineerModel engineer;

  ConnectFarmerDataModel({
    required this.id,
    required this.farmerId,
    required this.engineerId,
    required this.farmer,
    required this.engineer,
  });

  factory ConnectFarmerDataModel.fromJson(Map<String, dynamic> json) {
    return ConnectFarmerDataModel(
      id: json['id'] ?? 0,
      farmerId: json['farmerId'] ?? 0,
      engineerId: json['engineerId'] ?? 0,
      farmer: ConnectedFarmerModel.fromJson(json['farmer'] ?? {}),
      engineer: ConnectedEngineerModel.fromJson(json['engineer'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'farmerId': farmerId,
        'engineerId': engineerId,
        'farmer': farmer.toJson(),
        'engineer': engineer.toJson(),
      };
}

