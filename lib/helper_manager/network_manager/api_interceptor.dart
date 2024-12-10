import 'dart:async';

import 'package:dio/dio.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';

class ApiInterceptors extends Interceptor {
  @override
  FutureOr<dynamic> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if ((userSingleton.token ?? '').isNotEmpty) {
      options.headers.addAll(
        {"Authorization": 'Token ${userSingleton.token}'},
      );
      handler.next(options);
      return options;
    } else {
      handler.next(options);
    }
  }

  @override
  FutureOr<dynamic> onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
    return response;
  }

  @override
  FutureOr<dynamic> onError(DioError err, ErrorInterceptorHandler handler) {
    handler.next(err);
    return err;
  }
}
