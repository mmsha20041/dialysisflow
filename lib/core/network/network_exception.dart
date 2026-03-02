class NetworkException implements Exception {
  NetworkException({
    required this.message,
    this.statusCode,
    this.code,
    this.uri,
    this.cause,
  });

  final String message;
  final int? statusCode;
  final String? code;
  final Uri? uri;
  final Object? cause;

  @override
  String toString() =>
      'NetworkException(statusCode: $statusCode, code: $code, message: $message)';
}
