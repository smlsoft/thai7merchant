part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginOnLoad extends LoginEvent {
  String userName;
  String passWord;
  LoginOnLoad({required this.userName, required this.passWord});

  @override
  List<Object> get props => [];
}
