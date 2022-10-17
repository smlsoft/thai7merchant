import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thai7merchant/repositories/user_repository.dart';
import 'package:thai7merchant/model/userlogin.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(LoginInitial()) {
    on<LoginOnLoad>(_onLoginLoad);
  }

  void _onLoginLoad(LoginOnLoad event, Emitter<LoginState> emit) async {
    emit(LoginInProgress());
    try {
      final _result =
          await _userRepository.authenUser(event.userName, event.passWord);

      if (_result.success) {
        final appConfig = GetStorage("AppConfig");
        UserLogin userLogin =
            UserLogin(userName: event.userName, token: _result.data["token"]);
        appConfig.write("token", _result.data["token"]);
        emit(LoginSuccess(userLogin: userLogin));
      } else {
        emit(LoginFailed(message: 'User Not Found'));
      }
    } on Exception catch (exception) {
      emit(LoginFailed(
          message: 'ติดต่อ Server ไม่ได้ : ' + exception.toString()));
    } catch (e) {
      emit(LoginFailed(message: 'ติดต่อ Server ไม่ได้ : ' + e.toString()));
    }
  }
}
