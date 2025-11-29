import 'package:web_dashboard/features/Graphs/Data/Models/grafana_graph_data_model.dart';
import 'package:equatable/equatable.dart';

abstract class GrafanaGraphState extends Equatable {
  const GrafanaGraphState();

  @override
  List<Object?> get props => [];
}

class GrafanaGraphInitial extends GrafanaGraphState {}

class GrafanaGraphLoading extends GrafanaGraphState {}

class GrafanaGraphSuccess extends GrafanaGraphState {
  final GrafanaGraphDataModel data;
  const GrafanaGraphSuccess(this.data);
  @override
  List<Object?> get props => [data];
}

class GrafanaGraphFailure extends GrafanaGraphState {
  final String failureMessage;
  const GrafanaGraphFailure(this.failureMessage);
  @override
  List<Object?> get props => [failureMessage];
}

