import 'package:equatable/equatable.dart';

abstract class DisconnectFarmerState extends Equatable {
  const DisconnectFarmerState();

  @override
  List<Object?> get props => [];
}

class DisconnectFarmerInitial extends DisconnectFarmerState {}

class DisconnectFarmerLoading extends DisconnectFarmerState {}

class DisconnectFarmerSuccess extends DisconnectFarmerState {
  final String message;

  const DisconnectFarmerSuccess({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

class DisconnectFarmerFailure extends DisconnectFarmerState {
  final String failureMessage;

  const DisconnectFarmerFailure(this.failureMessage);

  @override
  List<Object?> get props => [failureMessage];
}

