import 'package:equatable/equatable.dart';

abstract class FarmerLandsState extends Equatable {
  const FarmerLandsState();

  @override
  List<Object?> get props => [];
}

class FarmerLandsInitial extends FarmerLandsState {}

class FarmerLandsLoading extends FarmerLandsState {}

class FarmerLandsSuccess extends FarmerLandsState {
  final List<int> landIds;
  final String message;

  const FarmerLandsSuccess({
    required this.landIds,
    required this.message,
  });

  @override
  List<Object?> get props => [landIds, message];
}

class FarmerLandsFailure extends FarmerLandsState {
  final String failureMessage;

  const FarmerLandsFailure(this.failureMessage);

  @override
  List<Object?> get props => [failureMessage];
}

