class WeatherUnitModel {
  final double value;
  final String unit;

  WeatherUnitModel({
    required this.value,
    required this.unit,
  });

  factory WeatherUnitModel.fromJson(Map<String, dynamic> json) {
    return WeatherUnitModel(
      value: (json['value'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'value': value,
        'unit': unit,
      };
}

