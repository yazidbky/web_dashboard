class GrafanaGraphRequestModel {
  final int farmerId;
  final int landId;
  final String column;
  final String plotType;
  final String tables;
  final String? sectionId;

  GrafanaGraphRequestModel({
    required this.farmerId,
    required this.landId,
    required this.column,
    required this.plotType,
    required this.tables,
    this.sectionId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'farmerId': farmerId,
      'landId': landId,
      'column': column,
      'plotType': plotType,
      'tables': tables,
    };
    
    if (sectionId != null && sectionId!.isNotEmpty) {
      json['sectionId'] = sectionId;
    }
    
    return json;
  }
}

