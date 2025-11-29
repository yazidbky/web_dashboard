class SoilDataModel {
  final int id;
  final int farmerId;
  final int landId;
  final String section;
  final double soilMoisture;
  final double soilTemperature;
  final double ph;
  final double electricalConductivity;
  final double organicMatter;
  final double nitrite;
  final double soilHealthScore;
  final String overallStatus;
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final String soilType;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  SoilDataModel({
    required this.id,
    required this.farmerId,
    required this.landId,
    required this.section,
    required this.soilMoisture,
    required this.soilTemperature,
    required this.ph,
    required this.electricalConductivity,
    required this.organicMatter,
    required this.nitrite,
    required this.soilHealthScore,
    required this.overallStatus,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.soilType,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SoilDataModel.fromJson(Map<String, dynamic> json) {
    return SoilDataModel(
      id: json['id'] ?? 0,
      farmerId: json['farmerId'] ?? 0,
      landId: json['landId'] ?? 0,
      section: json['section'] ?? '',
      soilMoisture: (json['soilMoisture'] ?? 0).toDouble(),
      soilTemperature: (json['soilTemperature'] ?? 0).toDouble(),
      ph: (json['ph'] ?? 0).toDouble(),
      electricalConductivity: (json['electricalConductivity'] ?? 0).toDouble(),
      organicMatter: (json['organicMatter'] ?? 0).toDouble(),
      nitrite: (json['nitrite'] ?? 0).toDouble(),
      soilHealthScore: (json['soilHealthScore'] ?? 0).toDouble(),
      overallStatus: json['overallStatus'] ?? '',
      nitrogen: (json['nitrogen'] ?? 0).toDouble(),
      phosphorus: (json['phosphorus'] ?? 0).toDouble(),
      potassium: (json['potassium'] ?? 0).toDouble(),
      soilType: json['soilType'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'farmerId': farmerId,
      'landId': landId,
      'section': section,
      'soilMoisture': soilMoisture,
      'soilTemperature': soilTemperature,
      'ph': ph,
      'electricalConductivity': electricalConductivity,
      'organicMatter': organicMatter,
      'nitrite': nitrite,
      'soilHealthScore': soilHealthScore,
      'overallStatus': overallStatus,
      'nitrogen': nitrogen,
      'phosphorus': phosphorus,
      'potassium': potassium,
      'soilType': soilType,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

