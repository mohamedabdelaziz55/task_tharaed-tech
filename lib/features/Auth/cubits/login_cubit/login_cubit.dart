import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅

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
        // تخزين حالة تسجيل الدخول
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userToken', user.token!); // لو عايز تخزن التوكن
        emit(LoginSuccess(user));
      } else {
        emit(LoginFailure("Invalid credentials"));
      }
    } catch (e) {
      emit(LoginFailure("Login failed: $e"));
    }
  }

  // دالة لتسجيل الخروج
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userToken');
    emit(LoginInitial());
  }

  // دالة للتحقق من حالة تسجيل الدخول عند بدء التطبيق
  static Future<bool> checkLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
