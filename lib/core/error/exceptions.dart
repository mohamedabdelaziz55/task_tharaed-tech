import 'package:dio/dio.dart';
import 'package:task_tharad_tech/core/network/api_err.dart';

class ApiExceptions {
  static ApiError handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return ApiError(
          message: 'Request to API server was cancelled: ${error.message}',
        );
      case DioExceptionType.connectionTimeout:
        return ApiError(
          message: 'Connection timeout with API server: ${error.message}',
        );
      case DioExceptionType.sendTimeout:
        return ApiError(
          message:
              'Send timeout in connection with API server: ${error.message}',
        );
      case DioExceptionType.receiveTimeout:
        return ApiError(
          message:
              'Receive timeout in connection with API server: ${error.message}',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 400:
            return ApiError(message: 'Bad request');
          case 401:
            return ApiError(message: 'Unauthorized');
          case 403:
            return ApiError(message: 'Forbidden');
          case 404:
            return ApiError(message: 'Not found');
          case 500:
            return ApiError(message: 'Internal server error');
          default:
            return ApiError(
              message: 'Received invalid status code: $statusCode',
            );
        }
      case DioExceptionType.unknown:
        return ApiError(
          message:
              'Connection failed due to internet connection: ${error.message}',
        );
      default:
        return ApiError(message: 'Unexpected error occurred: ${error.message}');
    }
  }
}
