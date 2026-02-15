class AppException implements Exception {
  AppException(this.message, [this.statusCode]);

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException([super.message = 'Network error']);
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String message = 'Unauthorized']) : super(message, 401);
}

class ServerException extends AppException {
  ServerException([super.message = 'Server error', super.statusCode]);
}

class ValidationException extends AppException {
  ValidationException([super.message = 'Validation failed']);
}
