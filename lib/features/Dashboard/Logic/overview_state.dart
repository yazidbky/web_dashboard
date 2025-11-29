import 'package:web_dashboard/features/Dashboard/Data/Models/overview_data_model.dart';
import 'package:equatable/equatable.dart';
abstract class OverviewState extends Equatable {
  const OverviewState();

  @override
  List<Object?> get props => [];
}

class OverviewInitial extends OverviewState {}

class OverviewLoading extends OverviewState {}

class OverviewSuccess extends OverviewState {
  final OverviewDataModel data;
  final String message;

  const OverviewSuccess({
    required this.data,
    required this.message,
  });

  @override
  List<Object?> get props => [data, message];
}

class OverviewFailure extends OverviewState {
  final String failureMessage;

  const OverviewFailure(this.failureMessage);

  @override
  List<Object?> get props => [failureMessage];
}

