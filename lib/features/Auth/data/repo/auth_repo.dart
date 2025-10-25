import 'dart:io';
import 'package:dio/dio.dart';
import 'package:task_tharad_tech/core/error/exceptions.dart';
import 'package:task_tharad_tech/core/network/api_constance.dart';
import 'package:task_tharad_tech/core/network/api_err.dart';
import 'package:task_tharad_tech/core/network/api_service.dart';
import 'package:task_tharad_tech/core/utils/helpers/pref_helper.dart';
import 'package:task_tharad_tech/features/Auth/data/model/user_model.dart';

class AuthRepo {
  final ApiService apiService = ApiService();

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiService.post(
        path: ApiConstance.loginPath,
        body: {'email': email, 'password': password},
      );

      final user = UserModel.fromJson(response);

      if (user.token != null && user.token!.isNotEmpty) {
        await PrefHelper.saveUserToken(user.token!);
      }

      return user;
    } on DioError catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    required File image,
  }) async {
    try {
      final response = await apiService.post(
        path: ApiConstance.registerPath,
        body: {
          'username': username,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'image': await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
        },
      );

      final user = UserModel.fromJson(response);

      if (user.token != null && user.token!.isNotEmpty) {
        await PrefHelper.saveUserToken(user.token!);
      }

      return user;
    } on DioError catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
}
