import 'package:dio/dio.dart';
import 'package:task_tharad_tech/core/network/api_constance.dart';

import '../utils/pref_helper.dart';

class DioClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstance.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  DioClient() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler)async {
          final token =await PrefHelper.getToken();

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }
Dio getDio() {
  return dio;
}
}
