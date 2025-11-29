import 'package:web_dashboard/features/Farmers/Farmers%20Connect/Data/Models/connect_farmer_data_model.dart';
import 'package:equatable/equatable.dart';

abstract class ConnectFarmerState extends Equatable {
  const ConnectFarmerState();

  @override
  List<Object?> get props => [];
}

class ConnectFarmerInitial extends ConnectFarmerState {}

class ConnectFarmerLoading extends ConnectFarmerState {}

class ConnectFarmerSuccess extends ConnectFarmerState {
  final ConnectFarmerDataModel data;
  final String message;

  const ConnectFarmerSuccess({
    required this.data,
    required this.message,
  });

  @override
  List<Object?> get props => [data, message];
}

class ConnectFarmerFailure extends ConnectFarmerState {
  final String failureMessage;

  const ConnectFarmerFailure(this.failureMessage);

  @override
  List<Object?> get props => [failureMessage];
}

