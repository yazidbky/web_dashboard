class OverviewStatsModel {
  final int totalFarmers;
  final int farmersNeedingAttention;
  final double averageSoilMoisture;

  OverviewStatsModel({
    required this.totalFarmers,
    required this.farmersNeedingAttention,
    required this.averageSoilMoisture,
  });

  factory OverviewStatsModel.fromJson(Map<String, dynamic> json) {
    return OverviewStatsModel(
      totalFarmers: json['totalFarmers'] ?? 0,
      farmersNeedingAttention: json['farmersNeedingAttention'] ?? 0,
      averageSoilMoisture: (json['averageSoilMoisture'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'totalFarmers': totalFarmers,
        'farmersNeedingAttention': farmersNeedingAttention,
        'averageSoilMoisture': averageSoilMoisture,
      };
}

