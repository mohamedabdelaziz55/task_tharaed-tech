import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/user_model.dart';
import '../../data/repo/auth_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo authRepo;

  LoginCubit(this.authRepo) : super(LoginInitial());

  Future<void> loginUser(String email, String password, {bool rememberMe = false}) async {
    emit(LoginLoading());
    try {
      final user = await authRepo.login(email: email, password: password);
      if (user.token != null && user.token!.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userToken', user.token!);

        // ✅ حفظ بيانات التذكر
        if (rememberMe) {
          await prefs.setBool('rememberMe', true);
          await prefs.setString('savedEmail', email);
          await prefs.setString('savedPassword', password);
        } else {
          await prefs.setBool('rememberMe', false);
          await prefs.remove('savedEmail');
          await prefs.remove('savedPassword');
        }

        emit(LoginSuccess(user));
      } else {
        emit(LoginFailure("Invalid credentials"));
      }
    } catch (e) {
      emit(LoginFailure("Login failed: $e"));
    }
  }
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userToken');
    emit(LoginInitial());
  }
  static Future<bool> checkLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
  Future<Map<String, dynamic>> loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRemember = prefs.getBool('rememberMe') ?? false;
    final savedEmail = prefs.getString('savedEmail') ?? '';
    final savedPassword = prefs.getString('savedPassword') ?? '';
    return {
      'rememberMe': savedRemember,
      'email': savedEmail,
      'password': savedPassword,
    };
  }
}
