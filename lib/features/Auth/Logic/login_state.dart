import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable  {
  const LoginState();
   @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String successMessage ;
    const LoginSuccess(this.successMessage);

    @override
    List<Object?> get props => [successMessage];
}

class LoginFailure extends LoginState {
  final String failureMessage;
  const LoginFailure(this.failureMessage);
  
  @override
  List<Object?> get props => [failureMessage];
}

