import 'package:dio/dio.dart';

import '../network_exception.dart';

class ErrorMappingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    final statusCode = response?.statusCode;
    final data = response?.data;

    final message = _extractMessage(data) ?? _defaultMessage(err, statusCode);

    final mapped = NetworkException(
      message: message,
      statusCode: statusCode,
      code: data is Map<String, dynamic> ? data['code']?.toString() : null,
      uri: err.requestOptions.uri,
      cause: err,
    );

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: mapped,
        message: mapped.message,
      ),
    );
  }

  String? _extractMessage(Object? data) {
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ?? data['error']?.toString();
    }
    return null;
  }

  String _defaultMessage(DioException err, int? statusCode) {
    if (statusCode == 401) {
      return 'Session expired. Please login again.';
    }
    if (statusCode == 403) {
      return 'You are not authorized to access this resource.';
    }
    if (statusCode == 404) {
      return 'Requested resource not found.';
    }
    if ((statusCode ?? 0) >= 500) {
      return 'Server error occurred. Please try again later.';
    }

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return 'Network timeout. Check your internet connection.';
      default:
        return 'Unexpected network error occurred.';
    }
  }
}
