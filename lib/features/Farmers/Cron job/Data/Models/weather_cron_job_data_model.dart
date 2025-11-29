class WeatherCronJobDataModel {
  final String message;
  final String schedule;
  final int landsCount;

  WeatherCronJobDataModel({
    required this.message,
    required this.schedule,
    required this.landsCount,
  });

  factory WeatherCronJobDataModel.fromJson(Map<String, dynamic> json) {
    return WeatherCronJobDataModel(
      message: json['message'] ?? '',
      schedule: json['schedule'] ?? '',
      landsCount: json['landsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'schedule': schedule,
        'landsCount': landsCount,
      };
}

