// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/utils/extensions/string_extensions.dart';
import 'package:path/path.dart';

import '../../model/response_model/responese_datamodel.dart';
import '../../utils/app_common_stuffs/app_logger.dart';
import '../../utils/app_common_stuffs/strings_constants.dart';
import '../../utils/network_util.dart';
import 'api_const.dart';
import 'init_dio.dart';

var sharedServiceManager = RemoteServices.singleton;

class RemoteServices {
   var dio = initDio();

  RemoteServices._internal();

  static final RemoteServices singleton = RemoteServices._internal();

  factory RemoteServices() {
    return singleton;
  }



  /// GET requests
  Future<ResponseModel<T>> createGetRequest<T>({required ApiType typeOfEndPoint, Map<String, dynamic>? params, String? urlParam}) async {
    if (await NetworkUtil.isNetworkConnected()) {
      final requestFinal = ApiConstant.requestParamsForSync(typeOfEndPoint, params: params, urlParams: urlParam);

      try {
        Response response = await dio.get(
          requestFinal.item1,
          options: Options(headers: requestFinal.item2),
        );
        Logger().v('Api Response : - ${response.data.toString()}');
        return ResponseModel<T>.fromJson(response.data, response.statusCode!);
      } on DioError catch (e) {
        if (e.response!.statusCode! == 400 || e.response!.statusCode! == 401 || e.response!.statusCode! == 403 || e.response!.statusCode! == 406) {
          return createErrorResponse(status: e.response!.statusCode!, message: e.response!.data['message']);
        } else if (e.type == DioErrorType.connectTimeout) {
          return createErrorResponse(status: ApiConstant.timeoutDurationNormalAPIs, message: 'Connection time out');
        } else {
          return createErrorResponse(status: ApiConstant.statusCodeBadGateway, message: e.message);
        }
      }
    } else {
      return createErrorResponse(status: ApiConstant.statusCodeServiceNotAvailable, message: AppStrings.noInternetMsg);
    }
  }

   Future<ResponseModel<T>> createTestGetRequest<T>({required ApiType typeOfEndPoint, Map<String, dynamic>? params, String? urlParam}) async {

       final requestFinal = ApiConstant.requestParamsForSync(typeOfEndPoint, params: params, urlParams: urlParam);

       try {
         Response response = await dio.get(
           requestFinal.item1,
           options: Options(headers: requestFinal.item2),
         );
         Logger().v('Api Response : - ${response.data.toString()}');
         return ResponseModel<T>.fromJson(response.data, response.statusCode!);
       } on DioError catch (e) {
         if (e.response!.statusCode! == 400 || e.response!.statusCode! == 401 || e.response!.statusCode! == 403 || e.response!.statusCode! == 406) {
           return createErrorResponse(status: e.response!.statusCode!, message: e.response!.data['message']);
         } else if (e.type == DioErrorType.connectTimeout) {
           return createErrorResponse(status: ApiConstant.timeoutDurationNormalAPIs, message: 'Connection time out');
         } else {
           return createErrorResponse(status: ApiConstant.statusCodeBadGateway, message: e.message);
         }
       }

   }

  /// POST requests
  Future<ResponseModel<T>> createPostRequest<T>({required ApiType typeOfEndPoint, Map<String, dynamic>? params, String? urlParam}) async {
    if (await NetworkUtil.isNetworkConnected()) {
      final requestFinal = ApiConstant.requestParamsForSync(typeOfEndPoint, params: params, urlParams: urlParam);
      try {
        Response response = await dio.post(requestFinal.item1, data: requestFinal.item3, options: Options(headers: requestFinal.item2));
        Logger().v('Api Response : - ${response.data.toString()}');

        return ResponseModel<T>.fromJson(response.data, response.statusCode);
      } on DioError catch (e) {
        if (e.response!.statusCode! == 400 || e.response!.statusCode! == 401 || e.response!.statusCode! == 403 || e.response!.statusCode! == 406) {
          Logger().v('Api Response : - ${e.response!.data['message']}');
          return createErrorResponse(status: e.response!.statusCode!, message: e.response!.data['message']);
        } else if (e.type == DioErrorType.connectTimeout) {
          return createErrorResponse(status: ApiConstant.timeoutDurationNormalAPIs, message: 'Connection time out');
        } else {
          return createErrorResponse(status: ApiConstant.statusCodeBadGateway, message: e.message);
        }
      }

      //}
    } else {
      return createErrorResponse(status: ApiConstant.statusCodeServiceNotAvailable, message: AppStrings.noInternetMsg);
    }
  }

   Future<ResponseModel<T>> createTestPostRequest<T>({required ApiType typeOfEndPoint, Map<String, dynamic>? params, String? urlParam}) async {

       final requestFinal = ApiConstant.requestParamsForSync(typeOfEndPoint, params: params, urlParams: urlParam);
       try {
         Response response = await dio.post(requestFinal.item1, data: requestFinal.item3, options: Options(headers: requestFinal.item2));
         Logger().v('Api Response : - ${response.data.toString()}');

         return ResponseModel<T>.fromJson(response.data, response.statusCode);
       } on DioError catch (e) {
         if (e.response!.statusCode! == 400 || e.response!.statusCode! == 401 || e.response!.statusCode! == 403 || e.response!.statusCode! == 406) {
           return createErrorResponse(status: e.response!.statusCode!, message: e.response!.data['message']);
         } else if (e.type == DioErrorType.connectTimeout) {
           return createErrorResponse(status: ApiConstant.timeoutDurationNormalAPIs, message: 'Connection time out');
         } else {
           return createErrorResponse(status: ApiConstant.statusCodeBadGateway, message: e.message);
         }
       }

       //}

   }



  /// PUT requests
  Future<ResponseModel<T>> createPutRequest<T>({required ApiType typeOfEndPoint, Map<String, dynamic>? params, String? urlParam}) async {
    if (await NetworkUtil.isNetworkConnected()) {
      final requestFinal = ApiConstant.requestParamsForSync(typeOfEndPoint, params: params, urlParams: urlParam);
      try {
        Response response = await dio.put(requestFinal.item1, data: requestFinal.item3, options: Options(headers: requestFinal.item2));
        Logger().v('Api Response : - ${response.data.toString()}');

        return ResponseModel<T>.fromJson(json.decode(response.data.toString()), response.statusCode);
      } on DioError catch (e) {
        return createErrorResponse(status: e.response!.statusCode!, message: e.message);
      }
    } else {
      return createErrorResponse(status: ApiConstant.statusCodeServiceNotAvailable, message: AppStrings.noInternetMsg);
    }
  }

  /// DELETE requests
  Future<ResponseModel<T>> createDeleteRequest<T>({required ApiType typeOfEndPoint, Map<String, dynamic>? params, String? urlParam}) async {
    if (await NetworkUtil.isNetworkConnected()) {
      final requestFinal = ApiConstant.requestParamsForSync(typeOfEndPoint, params: params, urlParams: urlParam);
      try {
        Response response = await dio.delete(requestFinal.item1, data: requestFinal.item3, options: Options(headers: requestFinal.item2));
        Logger().v('Api Response : - ${response.data.toString()}');
        return ResponseModel<T>.fromJson(response.data, response.statusCode!);
      } on DioError catch (e) {
        if (e.response!.statusCode! == 400 || e.response!.statusCode! == 401 || e.response!.statusCode! == 403 || e.response!.statusCode! == 406) {
          return createErrorResponse(status: e.response!.statusCode!, message: e.response!.data['message']);
        } else if (e.type == DioErrorType.connectTimeout) {
          return createErrorResponse(status: ApiConstant.timeoutDurationNormalAPIs, message: 'Connection time out');
        } else {
          return createErrorResponse(status: ApiConstant.statusCodeBadGateway, message: e.message);
        }
      }
    } else {
      return createErrorResponse(status: ApiConstant.statusCodeServiceNotAvailable, message: AppStrings.noInternetMsg);
    }
  }

  ResponseModel<T> createErrorResponse<T>({required int status, required String message}) {
    if (status == 401) {
      return userSingleton.user401LogOut();
    } else if (status == 403) {
      return userSingleton.userSubscriptionCancel();
    } else if (status == 406) {
      return userSingleton.userBlock406(message: message);
    } else {
      return ResponseModel(status: status, message: message, data: null);
    }
  }

  Future<ResponseModel<T>> uploadRequest<T>(
    ApiType apiType, {
    Map<String, dynamic>? params,
    List<AppMultiPartFile>? arrFile,
    String? urlParam,
    Function(double percentage)? onFileUpload,
  }) async {
    if (await NetworkUtil.isNetworkConnected()) {
      final requestFinal = ApiConstant.requestParamsForSync(apiType, params: params, arrFile: arrFile ?? []);

      Map<String, dynamic> other = <String, dynamic>{};
      other.addAll(requestFinal.item3);

      /* Adding File Content */
      for (AppMultiPartFile partFile in requestFinal.item4) {
        List<MultipartFile> uploadFiles = [];
        for (File file in partFile.localFiles ?? []) {
          String filename = basename(file.path);

          /// PDF Media
          if (filename.toLowerCase().contains(".pdf")) {
            MultipartFile mFile = await MultipartFile.fromFile(file.path, filename: filename);
            uploadFiles.add(mFile);
          }

          /// Video Media
          /*else if (filename.toLowerCase().contains(".mp4") || filename.toLowerCase().contains(".mov") || filename.toLowerCase().contains(".mkv")) {*/
          else if (filename.toLowerCase().videoFormat()) {
            MultipartFile mFile = await MultipartFile.fromFile(file.path, filename: filename, contentType: MediaType('video', filename.split(".").last));
            uploadFiles.add(mFile);
          }

          /// Image Media
          else {
            MultipartFile mFile = await MultipartFile.fromFile(file.path, filename: filename, contentType: MediaType('image', filename.split(".").last));
            uploadFiles.add(mFile);
          }
        }
        if (uploadFiles.isNotEmpty) {
          other[partFile.key ?? ""] = (uploadFiles.length == 1) ? uploadFiles.first : uploadFiles;
        }
      }

      FormData formData = FormData.fromMap(other);
      final option = Options(headers: requestFinal.item2);

      try {
        final response = await dio.post(
          requestFinal.item1,
          data: formData,
          options: option,
          onSendProgress: (sent, total) {
            var progress = sent / total;
            Logger().v("uploadFile $progress");
            if (onFileUpload != null) {
              onFileUpload(progress);
            }
          },
        );
        Logger().v('Api Response : - ${response.data.toString()}');
        return ResponseModel<T>.fromJson(response.data, response.statusCode!);
      } on DioError catch (e) {
        if (e.response!.statusCode! == 400 || e.response!.statusCode! == 401 || e.response!.statusCode! == 403 || e.response!.statusCode! == 406) {
          return createErrorResponse(status: e.response!.statusCode!, message: e.response!.data['message']);
        } else if (e.type == DioErrorType.connectTimeout) {
          return createErrorResponse(status: ApiConstant.timeoutDurationNormalAPIs, message: 'Connection time out');
        } else {
          return createErrorResponse(status: ApiConstant.statusCodeBadGateway, message: e.message);
        }
      }
    } else {
      return createErrorResponse(status: ApiConstant.statusCodeServiceNotAvailable, message: AppStrings.noInternetMsg);
    }
  }
}
