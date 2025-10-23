
import '../network/error_message_model.dart';

class ServerException implements Exception {
  final ErrorMessageModel message;

 const ServerException({required this.message});

  @override
  String toString() => 'ServerException: $message';
}