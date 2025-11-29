class FarmerTableData {
  final String id;
  final String farmerName;
  final String cropType;
  final String lastActivity;

  FarmerTableData({
    required this.id,
    required this.farmerName,
    required this.cropType,
    required this.lastActivity,
  });

  factory FarmerTableData.fromJson(Map<String, dynamic> json) {
    return FarmerTableData(
      id: json['id'] ?? '',
      farmerName: json['farmerName'] ?? json['fullName'] ?? '',
      cropType: json['cropType'] ?? '',
      lastActivity: json['lastActivity'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerName': farmerName,
      'cropType': cropType,
      'lastActivity': lastActivity,
    };
  }
}

