class CropDataModel {
  final String growingSeason;
  final double minTemperature;
  final double maxTemperature;
  final double minRainfall;
  final double maxRainfall;
  final String soilTypeRequirements;
  final double minPh;
  final double maxPh;
  final double idealPh;
  final String waterRequirement;
  final double dailySunlightHours;
  final double maturityDuration;
  final double expectedYieldPerHectare;

  CropDataModel({
    required this.growingSeason,
    required this.minTemperature,
    required this.maxTemperature,
    required this.minRainfall,
    required this.maxRainfall,
    required this.soilTypeRequirements,
    required this.minPh,
    required this.maxPh,
    required this.idealPh,
    required this.waterRequirement,
    required this.dailySunlightHours,
    required this.maturityDuration,
    required this.expectedYieldPerHectare,
  });

  factory CropDataModel.fromJson(Map<String, dynamic> json) {
    return CropDataModel(
      growingSeason: json['growingSeason'] ?? '',
      minTemperature: _parseDouble(json['minTemperature']),
      maxTemperature: _parseDouble(json['maxTemperature']),
      minRainfall: _parseDouble(json['minRainfall']),
      maxRainfall: _parseDouble(json['maxRainfall']),
      soilTypeRequirements: json['soilTypeRequirements'] ?? '',
      minPh: _parseDouble(json['minPh']),
      maxPh: _parseDouble(json['maxPh']),
      idealPh: _parseDouble(json['idealPh']),
      waterRequirement: json['waterRequirement'] ?? '',
      dailySunlightHours: _parseDouble(json['dailySunlightHours']),
      maturityDuration: _parseDouble(json['maturityDuration']),
      expectedYieldPerHectare: _parseDouble(json['expectedYieldPerHectare']),
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
        'growingSeason': growingSeason,
        'minTemperature': minTemperature,
        'maxTemperature': maxTemperature,
        'minRainfall': minRainfall,
        'maxRainfall': maxRainfall,
        'soilTypeRequirements': soilTypeRequirements,
        'minPh': minPh,
        'maxPh': maxPh,
        'idealPh': idealPh,
        'waterRequirement': waterRequirement,
        'dailySunlightHours': dailySunlightHours,
        'maturityDuration': maturityDuration,
        'expectedYieldPerHectare': expectedYieldPerHectare,
      };
}

