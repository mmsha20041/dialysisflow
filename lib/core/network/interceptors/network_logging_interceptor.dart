import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NetworkLoggingInterceptor extends Interceptor {
  NetworkLoggingInterceptor({this.enabled = true});

  final bool enabled;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enabled) {
      debugPrint(
        '[HTTP] --> ${options.method} ${options.uri} '
        'query=${options.queryParameters} body=${options.data}',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (enabled) {
      debugPrint(
        '[HTTP] <-- ${response.statusCode} ${response.requestOptions.method} '
        '${response.requestOptions.uri} data=${response.data}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enabled) {
      debugPrint(
        '[HTTP] xx ${err.response?.statusCode} ${err.requestOptions.method} '
        '${err.requestOptions.uri} error=${err.message}',
      );
    }
    handler.next(err);
  }
}
