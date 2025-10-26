import 'package:dio/dio.dart';
import 'package:task_tharad_tech/core/network/api_err.dart';

class ApiExceptions {
  static ApiError handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return ApiError(
          message: 'Request was cancelled. Please try again.',
        );

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiError(
          message: 'Connection to the server timed out. Please check your internet connection.',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final serverMessage = error.response?.data?['message'];

        switch (statusCode) {
          case 400:
            return ApiError(message: serverMessage ?? 'Bad request.');
          case 401:
            return ApiError(message: serverMessage ?? 'You must log in first.');
          case 403:
            return ApiError(message: serverMessage ?? 'Access forbidden.');
          case 404:
            return ApiError(message: serverMessage ?? 'Requested item not found.');
          case 500:
            return ApiError(message: 'Server error occurred. Please try later.');
          default:
            return ApiError(
              message: serverMessage ?? 'Unexpected error occurred. (Code: $statusCode)',
            );
        }

      case DioExceptionType.unknown:
        return ApiError(
          message: 'Connection failed. Make sure you are connected to the internet.',
        );

      default:
        return ApiError(
          message: 'An unknown error occurred. Please try again later.',
        );
    }
  }
}
