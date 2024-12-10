import 'package:dio/dio.dart';

import 'api_const.dart';
import 'api_interceptor.dart';

Dio initDio() {
  Dio dio = Dio(BaseOptions(
    //baseUrl: ApiConstant.basDomainLocal,
    baseUrl: ApiConstant.baseDomain,
    connectTimeout: ApiConstant.timeoutDurationMultipartAPIs,
    receiveTimeout: ApiConstant.timeoutDurationMultipartAPIs,
  ));
  dio.interceptors.add(ApiInterceptors());
  return dio;
}
