import 'package:dio/dio.dart';

import '../../print_log_format.dart';

class RequestInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    printRequestLog('REQUEST ${options.method} => PATH: ${options.path}', true);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode != 200) {
      printRequestLog(
          '✗✗✗✗✗✗✗✗✗✗ RESPONSE ${response.statusCode} ✗✗✗✗✗✗✗✗✗✗', false);
    } else {
      printRequestLog(
          '✓✓✓✓✓✓✓✓✓✓ RESPONSE ${response.statusCode} ✓✓✓✓✓✓✓✓✓✓', true);
    }
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    printRequestLog(
        '✗✗✗✗✗✗✗✗✗✗ ERROR ${err.response?.statusCode ?? "Unknown"} ✗✗✗✗✗✗✗✗✗✗',
        false);
    super.onError(err, handler);
  }
}
