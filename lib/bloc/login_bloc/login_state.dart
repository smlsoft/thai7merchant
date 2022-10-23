part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginInProgress extends LoginState {}

class LoginSuccess extends LoginState {
  UserLogin userLogin;

  LoginSuccess({
    required this.userLogin,
  });

  @override
  List<Object> get props => [userLogin];
}

class LoginFailed extends LoginState {
  final String message;
  LoginFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
