class FarmerLandsDataModel {
  final List<int> landIds;

  FarmerLandsDataModel({
    required this.landIds,
  });

  factory FarmerLandsDataModel.fromJson(Map<String, dynamic> json) {
    return FarmerLandsDataModel(
      landIds: (json['landIds'] as List<dynamic>?)
              ?.map((id) => id is int ? id : int.tryParse(id.toString()) ?? 0)
              .where((id) => id > 0)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'landIds': landIds,
      };
}

