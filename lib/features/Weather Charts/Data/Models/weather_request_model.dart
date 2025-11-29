class WeatherRequestModel {
  final int landId;

  WeatherRequestModel({
    required this.landId,
  });

  Map<String, dynamic> toJson() => {
        'landId': landId,
      };
}

