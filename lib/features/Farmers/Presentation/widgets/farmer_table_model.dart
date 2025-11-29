import 'package:web_dashboard/features/My%20Farmers/Data/Models/Sub%20Models/farmer_data_model.dart';

/// Model for displaying farmer data in the table
class FarmerTableData {
  final String id;
  final String farmerName;
  final String cropType;
  final String lastActivity;
  final String? email;
  final String? phoneNumber;

  FarmerTableData({
    required this.id,
    required this.farmerName,
    required this.cropType,
    required this.lastActivity,
    this.email,
    this.phoneNumber,
  });

  /// Creates a FarmerTableData from FarmerDataModel (API response)
  factory FarmerTableData.fromFarmerDataModel(FarmerDataModel model, {String? cropType}) {
    // Parse the createdAt date for display
    String lastActivity = 'N/A';
    if (model.updatedAt.isNotEmpty) {
      try {
        final date = DateTime.parse(model.updatedAt);
        lastActivity = '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
      } catch (_) {
        lastActivity = model.updatedAt;
      }
    }

    return FarmerTableData(
      id: model.id.toString(),
      farmerName: model.fullName,
      cropType: cropType ?? 'Not specified',
      lastActivity: lastActivity,
      email: model.email,
      phoneNumber: model.phoneNumber,
    );
  }
}

