class ForecastConditionModel {
  final String text;
  final String icon;

  ForecastConditionModel({
    required this.text,
    required this.icon,
  });

  factory ForecastConditionModel.fromJson(Map<String, dynamic> json) {
    return ForecastConditionModel(
      text: json['text'] ?? '',
      icon: json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'icon': icon,
      };
}

