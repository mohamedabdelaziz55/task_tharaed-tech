class ApiError {
  final String? message;
  final int? statusCode;

  ApiError({this.message, this.statusCode});

  @override
  String toString() {
    return 'ApiError: message=${message ?? "Unknown error"}';
  }
}
