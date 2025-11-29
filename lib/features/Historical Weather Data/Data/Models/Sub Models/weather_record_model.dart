class WeatherRecordModel {
  final String date;
  final String action;
  final int id;

  WeatherRecordModel({
    required this.date,
    required this.action,
    required this.id,
  });

  factory WeatherRecordModel.fromJson(Map<String, dynamic> json) {
    return WeatherRecordModel(
      date: json['date'] ?? '',
      action: json['action'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'action': action,
        'id': id,
      };
}

