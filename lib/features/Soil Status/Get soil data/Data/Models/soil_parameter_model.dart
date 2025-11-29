class SoilParameterModel {
  final String name;
  final String value;
  final String icon;
  final String color;

  SoilParameterModel({
    required this.name,
    required this.value,
    required this.icon,
    required this.color,
  });

  factory SoilParameterModel.fromJson(Map<String, dynamic> json) {
    return SoilParameterModel(
      name: json['name']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'icon': icon,
      'color': color,
    };
  }
}

