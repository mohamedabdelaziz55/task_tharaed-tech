import 'package:dio/dio.dart';
import 'package:task_tharad_tech/core/error/exceptions.dart';
import 'package:task_tharad_tech/core/network/dio_client.dart';

class ApiService {
  final DioClient dioClient = DioClient();

  Future<dynamic> getRequest(String path) async {
    try {
      final response = await dioClient.dio.get(path);
      _logRequest('GET', path, null, response);
      return response.data;
    } on DioError catch (e) {
      _logError('GET', path, e);
      throw ApiExceptions.handleError(e);
    }
  }
  Future<dynamic> post({
    required String path,
    required dynamic body,
  }) async {
    try {
      final options = Options(
        headers: {'Accept': 'application/json'},
        contentType: body is FormData ? null : 'application/json',
      );

      final response = await dioClient.dio.post(
        path,
        data: body,
        options: options,
      );

      _logRequest('POST', path, body, response);
      return response.data;
    } on DioError catch (e) {
      _logError('POST', path, e);
      throw ApiExceptions.handleError(e);
    }
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    try {
      final response = await dioClient.dio.put(path, data: body);
      _logRequest('PUT', path, body, response);
      return response.data;
    } on DioError catch (e) {
      _logError('PUT', path, e);
      throw ApiExceptions.handleError(e);
    }
  }

  Future<dynamic> delete(String path, Map<String, dynamic> body) async {
    try {
      final response = await dioClient.dio.delete(path, data: body);
      _logRequest('DELETE', path, body, response);
      return response.data;
    } on DioError catch (e) {
      _logError('DELETE', path, e);
      throw ApiExceptions.handleError(e);
    }
  }

  void _logRequest(String method, String path, dynamic body, Response response) {
    print('''
--- API $method Request ---
URL: $path
Body Type: ${body.runtimeType}
Status Code: ${response.statusCode}
Response: ${response.data}
---------------------------
''');
  }

  void _logError(String method, String path, DioError e) {
    print('''
--- API $method Error ---
URL: $path
Status: ${e.response?.statusCode}
Error: ${e.response?.data ?? e.message}
--------------------------
''');
  }
}
