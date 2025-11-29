class WeatherErrorDetailModel {
  final String date;
  final String error;

  WeatherErrorDetailModel({
    required this.date,
    required this.error,
  });

  factory WeatherErrorDetailModel.fromJson(Map<String, dynamic> json) {
    return WeatherErrorDetailModel(
      date: json['date'] ?? '',
      error: json['error'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'error': error,
      };
}

