import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/model/user_model.dart';
import '../../data/repo/auth_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo authRepo;

  LoginCubit(this.authRepo) : super(LoginInitial());

  Future<void> loginUser(String email, String password) async {
    emit(LoginLoading());
    try {
      final user = await authRepo.login(email: email, password: password);
      if (user.token != null && user.token!.isNotEmpty) {
        emit(LoginSuccess(user));
      } else {
        emit(LoginFailure("Invalid credentials"));
      }
    } catch (e) {
      emit(LoginFailure("Login failed: $e"));
    }
  }
}
