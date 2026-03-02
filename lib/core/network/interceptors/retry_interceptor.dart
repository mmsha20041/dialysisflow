import 'dart:async';

import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required Dio dio,
    this.maxRetries = 2,
    this.baseDelay = const Duration(milliseconds: 300),
  }) : _dio = dio;

  final Dio _dio;
  final int maxRetries;
  final Duration baseDelay;

  static const Set<String> _idempotentMethods = {
    'GET',
    'HEAD',
    'OPTIONS',
    'PUT',
    'DELETE',
  };

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final method = options.method.toUpperCase();
    final currentRetries = (options.extra['retry_attempt'] as int?) ?? 0;

    if (!_shouldRetry(err, method, currentRetries)) {
      handler.next(err);
      return;
    }

    options.extra['retry_attempt'] = currentRetries + 1;
    final delay = Duration(
      milliseconds: baseDelay.inMilliseconds * (currentRetries + 1),
    );
    await Future<void>.delayed(delay);

    try {
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (error) {
      handler.next(error);
    }
  }

  bool _shouldRetry(DioException err, String method, int currentRetries) {
    if (currentRetries >= maxRetries) {
      return false;
    }

    final type = err.type;
    final isTransient = type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.receiveTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.connectionError;

    final isServerError = (err.response?.statusCode ?? 0) >= 500;

    return _idempotentMethods.contains(method) && (isTransient || isServerError);
  }
}
