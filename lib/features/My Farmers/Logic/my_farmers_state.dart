import 'package:equatable/equatable.dart';
import 'package:web_dashboard/features/My%20Farmers/Data/Models/Sub%20Models/farmer_data_model.dart';

abstract class MyFarmersState extends Equatable {
  const MyFarmersState();

  @override
  List<Object?> get props => [];
}

class MyFarmersInitial extends MyFarmersState {}

class MyFarmersLoading extends MyFarmersState {}

class MyFarmersSuccess extends MyFarmersState {
  final List<FarmerDataModel> farmers;
  final int count;
  final String message;

  const MyFarmersSuccess({
    required this.farmers,
    required this.count,
    required this.message,
  });

  @override
  List<Object?> get props => [farmers, count, message];
}

class MyFarmersFailure extends MyFarmersState {
  final String failureMessage;

  const MyFarmersFailure(this.failureMessage);

  @override
  List<Object?> get props => [failureMessage];
}

