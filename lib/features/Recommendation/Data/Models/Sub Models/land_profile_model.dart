class LandProfileModel {
  final double minTemperature;
  final double maxTemperature;
  final double minRainfall;
  final double maxRainfall;
  final double minPh;
  final double maxPh;
  final double idealPh;
  final double nitrogenNeeds;
  final double phosphorusNeeds;
  final double potassiumNeeds;
  final double dailySunlightHours;
  final String soilTypeRequirements;
  final String waterRequirement;
  final String growingSeason;

  LandProfileModel({
    required this.minTemperature,
    required this.maxTemperature,
    required this.minRainfall,
    required this.maxRainfall,
    required this.minPh,
    required this.maxPh,
    required this.idealPh,
    required this.nitrogenNeeds,
    required this.phosphorusNeeds,
    required this.potassiumNeeds,
    required this.dailySunlightHours,
    required this.soilTypeRequirements,
    required this.waterRequirement,
    required this.growingSeason,
  });

  factory LandProfileModel.fromJson(Map<String, dynamic> json) {
    return LandProfileModel(
      minTemperature: _parseDouble(json['minTemperature']),
      maxTemperature: _parseDouble(json['maxTemperature']),
      minRainfall: _parseDouble(json['minRainfall']),
      maxRainfall: _parseDouble(json['maxRainfall']),
      minPh: _parseDouble(json['minPh']),
      maxPh: _parseDouble(json['maxPh']),
      idealPh: _parseDouble(json['idealPh']),
      nitrogenNeeds: _parseDouble(json['nitrogenNeeds']),
      phosphorusNeeds: _parseDouble(json['phosphorusNeeds']),
      potassiumNeeds: _parseDouble(json['potassiumNeeds']),
      dailySunlightHours: _parseDouble(json['dailySunlightHours']),
      soilTypeRequirements: json['soilTypeRequirements'] ?? '',
      waterRequirement: json['waterRequirement'] ?? '',
      growingSeason: json['growingSeason'] ?? '',
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() => {
        'minTemperature': minTemperature,
        'maxTemperature': maxTemperature,
        'minRainfall': minRainfall,
        'maxRainfall': maxRainfall,
        'minPh': minPh,
        'maxPh': maxPh,
        'idealPh': idealPh,
        'nitrogenNeeds': nitrogenNeeds,
        'phosphorusNeeds': phosphorusNeeds,
        'potassiumNeeds': potassiumNeeds,
        'dailySunlightHours': dailySunlightHours,
        'soilTypeRequirements': soilTypeRequirements,
        'waterRequirement': waterRequirement,
        'growingSeason': growingSeason,
      };
}

