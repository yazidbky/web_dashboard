class SoilSectionsDataModel {
  final List<String> sections;
  final int count;

  SoilSectionsDataModel({
    required this.sections,
    required this.count,
  });

  factory SoilSectionsDataModel.fromJson(Map<String, dynamic> json) {
    return SoilSectionsDataModel(
      sections: (json['sections'] as List<dynamic>?)
              ?.map((section) => section.toString())
              .toList() ??
          [],
      count: json['count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'sections': sections,
        'count': count,
      };
}

