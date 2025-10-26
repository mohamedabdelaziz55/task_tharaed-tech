import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/repo/auth_repo.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepo authRepo;

  RegisterCubit(this.authRepo) : super(RegisterInitial());

  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required File image,
  }) async {
    emit(RegisterLoading());
    try {
      final response = await authRepo.register(
        username: username,
        email: email,
        password: password,
        passwordConfirmation: confirmPassword,
        image: image,
      );

      if (response['status'] == 'success') {
        emit(RegisterSuccess(response));
      } else {
        emit(RegisterFailure(response['message'] ?? "Registration failed"));
      }
    } catch (e) {
      emit(RegisterFailure("Registration failed: $e"));
    }
  }
}
