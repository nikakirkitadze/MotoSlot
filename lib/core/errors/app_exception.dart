class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}

class NetworkException extends AppException {
  final int? statusCode;

  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
    this.statusCode,
  });
}

class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class BookingException extends AppException {
  const BookingException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class PaymentException extends AppException {
  const PaymentException({
    required super.message,
    super.code,
    super.originalError,
  });
}

class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.originalError,
  });
}
