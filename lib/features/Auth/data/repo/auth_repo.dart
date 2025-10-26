import 'dart:io';
import 'package:dio/dio.dart';
import 'package:task_tharad_tech/core/error/exceptions.dart';
import 'package:task_tharad_tech/core/network/api_constance.dart';
import 'package:task_tharad_tech/core/network/api_service.dart';
import 'package:task_tharad_tech/core/utils/helpers/pref_helper.dart';
import 'package:task_tharad_tech/features/Auth/data/model/user_model.dart';
import '../../../../core/network/api_err.dart';

class AuthRepo {
  final ApiService apiService = ApiService();

  UserModel? currentUser;

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
        await saveUserData(user);
      }

      currentUser = user;
      return user;
    } on DioError catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    required File image,
  }) async {
    try {
      final formData = FormData.fromMap({
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });

      final response = await apiService.post(
        path: ApiConstance.registerPath,
        body: formData,
      );

      return response;
    } on DioError catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final fullUrl = '${ApiConstance.baseUrl}otp?email=$email&otp=$otp';

      final response = await apiService.getRequest(fullUrl);
      return response;
    } on DioError catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<UserModel?> getUserProfile() async {
    try {
      final response = await apiService.getRequest(
        ApiConstance.profileDetailsPath,
      );
      final fetchedUser = UserModel.fromJson(response['data']);

      currentUser = fetchedUser;
      await saveUserData(fetchedUser);
      return fetchedUser;
    } on DioError catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<void> saveUserData(UserModel user) async {
    await PrefHelper.saveUserData(
      username: user.username,
      email: user.email,
      imageUrl: user.image,
      token: user.token ?? (await PrefHelper.getToken() ?? ''),
    );
    currentUser = user;
  }

  Future<UserModel?> getSavedUser() async {
    final data = await PrefHelper.getUserData();
    if (data == null) return null;
    final localUser = UserModel.fromJson(data);
    currentUser = localUser;
    return localUser;
  }


  Future<void> logout() async {
    try {
      final response = await apiService.delete(
        '${ApiConstance.baseUrl}auth/logout',
        {},
      );

      print('--- Logout API Response ---');
      print(response);

      // Clear local saved data
      await PrefHelper.clearUserData();
      currentUser = null;
    } on DioError catch (e) {
      print('--- Logout Error ---');
      print(e.response?.data ?? e.message);
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

}
