import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_constance.dart';
import '../../../../core/network/api_err.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/helpers/pref_helper.dart';
import '../../../Auth/data/model/user_model.dart';

class ProfileRepo {
  final ApiService apiService = ApiService();

  Future<UserModel> updateProfile({
    required String username,
    required String email,
    String? oldPassword,
    String? newPassword,
    String? confirmPassword,
    File? image,
  }) async {
    try {
      final token = await PrefHelper.getToken();

      final formData = FormData.fromMap({
        'username': username,
        'email': email,
        if (oldPassword != null && oldPassword.isNotEmpty) 'password': oldPassword,
        if (newPassword != null && newPassword.isNotEmpty) 'new_password': newPassword,
        if (confirmPassword != null && confirmPassword.isNotEmpty) 'new_password_confirmation': confirmPassword,
        if (image != null)
          'image': await MultipartFile.fromFile(image.path, filename: image.path.split('/').last),
        '_method': 'PUT',
      });

      final response = await apiService.post(
        path: ApiConstance.updateProfilePath,
        body: formData,
      );

      final updatedUser = UserModel.fromJson(response['data'] ?? response);

      await PrefHelper.saveUserData(
        username: updatedUser.username,
        email: updatedUser.email,
        imageUrl: updatedUser.image,
        token: token ?? '',
      );

      return updatedUser;
    } on DioError catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }
}