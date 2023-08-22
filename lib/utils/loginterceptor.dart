import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class LoggingInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint(
        "--> ${options.method != null ? options.method.toUpperCase() : 'METHOD'} ${"${options.baseUrl}${options.path}"}");
    debugPrint("Headers:");
    options.headers.forEach(
          (k, v) => debugPrint('$k: $v'),
    );
    if (options.queryParameters != null) {
      debugPrint("queryParameters:");
      options.queryParameters.forEach(
            (k, v) => debugPrint('$k: $v'),
      );
    }
    if (options.data != null) {
      debugPrint("Body: ${options.data.toString()}");
    }
    debugPrint(
        "--> END ${options.method != null ? options.method.toUpperCase() : 'METHOD'}");

    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        "<-- ${response.statusCode} ${response.requestOptions != null ? (response.requestOptions.baseUrl + response.requestOptions.path) : 'URL'}");
    debugPrint("Headers:");
    response.headers.forEach(
          (k, v) => debugPrint('$k: $v'),
    );
    debugPrint("Response: ${response.data}");
    debugPrint("<-- END HTTP");
    return super.onResponse(response, handler) as Future;
  }

  @override
  Future onError(DioError dioError, ErrorInterceptorHandler handler) {
    // debugPrint(
    //     "<-- ${dioError.message} ${dioError.response?.requestOptions != null ? (dioError.response?.requestOptions.baseUrl +dioError.response?.requestOptions.path) : 'URL'}");
    debugPrint(
        "${dioError.response != null ? dioError.response?.data : 'Unknown Error'}");
    debugPrint("<-- End error");
    return super.onError(dioError, handler) as Future;
  }
}