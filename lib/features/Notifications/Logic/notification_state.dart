import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class TokenRegistrationSuccess extends NotificationState {
  final String message;

  const TokenRegistrationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class TokenRegistrationFailure extends NotificationState {
  final String errorMessage;

  const TokenRegistrationFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class NotificationSentSuccess extends NotificationState {
  final String message;

  const NotificationSentSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationSentFailure extends NotificationState {
  final String errorMessage;

  const NotificationSentFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

