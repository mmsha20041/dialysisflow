import 'package:dio/dio.dart';

import 'interceptors/auth_token_interceptor.dart';
import 'interceptors/error_mapping_interceptor.dart';
import 'interceptors/network_logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'token_provider.dart';

class ApiClient {
  ApiClient({
    required String baseUrl,
    required TokenProvider tokenProvider,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 20),
    bool enableLogging = true,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      responseType: ResponseType.json,
      contentType: Headers.jsonContentType,
    );

    _dio.interceptors.addAll([
      AuthTokenInterceptor(tokenProvider),
      RetryInterceptor(dio: _dio),
      ErrorMappingInterceptor(),
      NetworkLoggingInterceptor(enabled: enableLogging),
    ]);
  }

  final Dio _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
