class SoilHealthScoreModel {
  final int score;
  final String percentage;
  final String overallStatus;

  SoilHealthScoreModel({
    required this.score,
    required this.percentage,
    required this.overallStatus,
  });

  factory SoilHealthScoreModel.fromJson(Map<String, dynamic> json) {
    return SoilHealthScoreModel(
      score: json['score'] is int 
          ? json['score'] 
          : (json['score'] is String ? int.tryParse(json['score']) ?? 0 : 0),
      percentage: json['percentage']?.toString() ?? '',
      overallStatus: json['overallStatus']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'percentage': percentage,
      'overallStatus': overallStatus,
    };
  }
}

