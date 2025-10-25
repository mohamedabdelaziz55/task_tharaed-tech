import 'package:dio/dio.dart';
import 'package:task_tharad_tech/core/error/exceptions.dart';
import 'package:task_tharad_tech/core/network/dio_client.dart';

class ApiService {
  final DioClient dioClient = DioClient();

  Future<dynamic> getRequest(String path) async {
    try {
      final response = await dioClient.dio.get(path);
      return response.data;
    } on DioError catch (e) {
      return ApiExceptions.handleError(e);
    }
  }

  Future<dynamic> post({
    required String path,
    required dynamic body,
  }) async {
    try {
      final response = await dioClient.dio.post(
        path,
        data: body,
        options: Options(
          contentType: body is FormData ? 'multipart/form-data' : 'application/json',
        ),
      );
      return response.data;
    } on DioError catch (e) {
      return ApiExceptions.handleError(e);
    }
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    try {
      final response = await dioClient.dio.put(path, data: body);
      return response.data;
    } on DioError catch (e) {
      return ApiExceptions.handleError(e);
    }
  }

  Future<dynamic> delete(String path, Map<String, dynamic> body) async {
    try {
      final response = await dioClient.dio.delete(path, data: body);
      return response.data;
    } on DioError catch (e) {
      return ApiExceptions.handleError(e);
    }
  }
}
