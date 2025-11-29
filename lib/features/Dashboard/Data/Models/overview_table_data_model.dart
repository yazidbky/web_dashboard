class OverviewTableDataModel {
  final String farmerName;
  final String cropType;
  final String soilMoisture;
  final String location;
  final String weatherImpact;

  OverviewTableDataModel({
    required this.farmerName,
    required this.cropType,
    required this.soilMoisture,
    required this.location,
    required this.weatherImpact,
  });

  factory OverviewTableDataModel.fromJson(Map<String, dynamic> json) {
    return OverviewTableDataModel(
      farmerName: json['farmerName'] ?? '',
      cropType: json['cropType'] ?? '',
      soilMoisture: json['soilMoisture']?.toString() ?? '0',
      location: json['location'] ?? '',
      weatherImpact: json['weatherImpact'] ?? 'Medium',
    );
  }

  Map<String, dynamic> toJson() => {
        'farmerName': farmerName,
        'cropType': cropType,
        'soilMoisture': soilMoisture,
        'location': location,
        'weatherImpact': weatherImpact,
      };
}

