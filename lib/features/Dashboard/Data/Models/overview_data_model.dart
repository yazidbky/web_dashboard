import 'package:web_dashboard/features/Dashboard/Data/Models/overview_stats_model.dart';
import 'package:web_dashboard/features/Dashboard/Data/Models/overview_table_data_model.dart';

class OverviewDataModel {
  final OverviewStatsModel stats;
  final List<OverviewTableDataModel> tableData;

  OverviewDataModel({
    required this.stats,
    required this.tableData,
  });

  factory OverviewDataModel.fromJson(Map<String, dynamic> json) {
    return OverviewDataModel(
      stats: OverviewStatsModel.fromJson(json['stats'] ?? {}),
      tableData: (json['tableData'] as List<dynamic>?)
              ?.map((item) => OverviewTableDataModel.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'stats': stats.toJson(),
        'tableData': tableData.map((item) => item.toJson()).toList(),
      };
}

