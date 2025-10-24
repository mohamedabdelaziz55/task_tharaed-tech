import 'package:dio/dio.dart';
import 'package:task_tharad_tech/core/error/exceptions.dart';
import 'package:task_tharad_tech/core/network/api_constance.dart';
import 'package:task_tharad_tech/core/network/api_err.dart';
import 'package:task_tharad_tech/core/network/api_service.dart';
import 'package:task_tharad_tech/core/utils/helpers/pref_helper.dart';
import 'package:task_tharad_tech/features/Auth/data/model/user_model.dart';

class AuthRepo {
  ApiService apiService = ApiService();

  Future<UserModel> login({required String email,required String password}) async {
    try {
      final response = await apiService.post(
        body: {'email': email, 'password': password},
        path: ApiConstance.loginPath,
      );

      final user = UserModel.fromJson(response['data']);
      if (user.token == null) {
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
