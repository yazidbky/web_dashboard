import 'package:web_dashboard/features/My%20Farmers/Data/Models/Sub%20Models/farmer_data_model.dart';

class FarmersListDataModel {
  final List<FarmerDataModel> farmers;
  final int count;

  FarmersListDataModel({
    required this.farmers,
    required this.count,
  });

  factory FarmersListDataModel.fromJson(Map<String, dynamic> json) {
    return FarmersListDataModel(
      farmers: (json['farmers'] as List<dynamic>?)
              ?.map((e) => FarmerDataModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'farmers': farmers.map((e) => e.toJson()).toList(),
        'count': count,
      };
}

