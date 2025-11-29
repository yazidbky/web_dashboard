class GrafanaGraphDataModel {
  final String url;
  final String iframeUrl;
  final int farmerId;
  final int landId;
  final String column;
  final String plotType;
  final String panelId;
  final String tables;
  final String? sectionId;
  final int from;
  final int to;

  GrafanaGraphDataModel({
    required this.url,
    required this.iframeUrl,
    required this.farmerId,
    required this.landId,
    required this.column,
    required this.plotType,
    required this.panelId,
    required this.tables,
    this.sectionId,
    required this.from,
    required this.to,
  });

  factory GrafanaGraphDataModel.fromJson(Map<String, dynamic> json) {
    // Parse from and to - they can be either int (timestamp) or String (ISO date)
    int parseTimestamp(dynamic value) {
      if (value is int) {
        return value;
      } else if (value is String) {
        try {
          final date = DateTime.parse(value);
          return date.millisecondsSinceEpoch;
        } catch (e) {
          print('⚠️ [GrafanaGraphDataModel] Failed to parse date: $value');
          return 0;
        }
      }
      return 0;
    }

    return GrafanaGraphDataModel(
      url: json['url'] ?? '',
      iframeUrl: json['iframeUrl'] ?? '',
      farmerId: json['farmerId'] ?? 0,
      landId: json['landId'] ?? 0,
      column: json['column'] ?? '',
      plotType: json['plotType'] ?? '',
      panelId: json['panelId'] ?? '',
      tables: json['tables'] ?? json['table'] ?? '', // Support both 'tables' (preferred) and 'table' (fallback)
      sectionId: json['sectionId'],
      from: parseTimestamp(json['from']),
      to: parseTimestamp(json['to']),
    );
  }
}

