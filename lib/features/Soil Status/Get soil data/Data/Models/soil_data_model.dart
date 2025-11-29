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
    // Helper function to safely convert to double
    double _toDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      return 0.0;
    }

    return SoilDataModel(
      id: json['id'] is int ? json['id'] : (json['id'] is String ? int.tryParse(json['id']) ?? 0 : 0),
      farmerId: json['farmerId'] is int ? json['farmerId'] : (json['farmerId'] is String ? int.tryParse(json['farmerId']) ?? 0 : 0),
      landId: json['landId'] is int ? json['landId'] : (json['landId'] is String ? int.tryParse(json['landId']) ?? 0 : 0),
      section: json['section']?.toString() ?? '',
      soilMoisture: _toDouble(json['soilMoisture']),
      soilTemperature: _toDouble(json['soilTemperature']),
      ph: _toDouble(json['ph']),
      electricalConductivity: _toDouble(json['electricalConductivity']),
      organicMatter: _toDouble(json['organicMatter']),
      nitrite: _toDouble(json['nitrite']),
      soilHealthScore: _toDouble(json['soilHealthScore']),
      overallStatus: json['overallStatus']?.toString() ?? '',
      nitrogen: _toDouble(json['nitrogen']),
      phosphorus: _toDouble(json['phosphorus']),
      potassium: _toDouble(json['potassium']),
      soilType: json['soilType']?.toString() ?? '',
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
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

