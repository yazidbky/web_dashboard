import 'package:equatable/equatable.dart';
import 'package:web_dashboard/features/Auth/Data/Models/Sub%20Models/farmer_model.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {
  final EngineerData userData;
  final String message;

  const UserSuccess({
    required this.userData,
    required this.message,
  });

  @override
  List<Object?> get props => [userData, message];
}

class UserFailure extends UserState {
  final String failureMessage;

  const UserFailure(this.failureMessage);

  @override
  List<Object?> get props => [failureMessage];
}

