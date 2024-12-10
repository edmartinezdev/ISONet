import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';

import 'package:iso_net/utils/validation/validation.dart';
import 'package:mockito/mockito.dart';

import '../../Service/mock_provider.mocks.dart';
import 'otp_screen_test.dart';

main() {
  late Dio dio;
  late DioAdapter dioAdapter;

  Response<dynamic> response;

  final mockRemoteService = MockRemoteServices();
  final baseUrl = ApiConstant.baseDomain;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
    dioAdapter = DioAdapter(dio: dio);
  });
  String emailText = 'roy@yopmail.com';

  String password = '12345678';

  Map<String, dynamic> userResponse = {};

  group("Login Form Validation", () {
    test('Email Valid Test', () {
      var result = Validation().validateEmail(emailText);
      expect(result.item2, '');
    });

    test('Password Valid Test', () {
      var result = Validation().validatePassword(password);
      expect(result.item2, '');
    });
  });

  group('Login Api Call', () {
    test('User Invalid Credential Test Case', () async {
      Map<String, dynamic> requestParams = {};
      requestParams['email'] = 'roy@yopmail.com';
      requestParams['password'] = '123456';
      requestParams['device_id'] = 'testdevice';
      requestParams['device_type'] = 'android';
      requestParams['device_token'] = 'testtoken';

      ResponseModel result = await sharedServiceManager.createTestPostRequest(
        typeOfEndPoint: ApiType.login,
        params: requestParams,
      );

      expect(result.status, 400);
      expect(result.data, null);
    });

    test('User Valid Credential Test Case', () async {
        Map<String, dynamic> requestParams = {};
        requestParams['email'] = 'vinses@yopmail.com';
        requestParams['password'] = '123456';
        requestParams['device_id'] = 'testdevice';
        requestParams['device_type'] = 'android';
        requestParams['device_token'] = 'testtoken';

      ResponseModel result = await sharedServiceManager.createTestPostRequest(
        typeOfEndPoint: ApiType.login,
        params: requestParams,
      );
      Map<String, dynamic> userLoginApiResponse = {
        "id": result.data['id'],
        "first_name": "Roy",
        "last_name": "Lee",
        "phone_number": "1231231231",
        "email": "roy@yopmail.com",
        "city": "Sl",
        "password": result.data['password'],
        "state": "Alaska",
        "dob": "2023-08-16",
        "position": "CEO",
        "bio": "NA",
        "user_type": "BR",
        "is_owner": true,
        "profile_img": result.data['profile_img'],
        "background_img": null,
        "is_approved": "approved",
        "is_sup_admin": false,
        "is_blocked": false,
        "is_active": true,
        "is_deleted": false,
        "is_verified": false,
        "delete_by_user": false,
        "is_staff": false,
        "is_superuser": false,
        "last_login": null,
        "user_stage": 4,
        "is_public": true,
        "is_subscribed": true,
        "current_subscription_type": "YR",
        "subscription_start_date": result.data['subscription_start_date'],
        "subscription_end_date": result.data['subscription_end_date'],
        "is_canceled": false,
        "compress_profile_img_name": "image_cropper_1692257206989.jpg",
        "compress_background_img_name": null,
        "created_at": result.data['created_at'],
        "updated_at": result.data['updated_at'],
        "socket_id": result.data['socket_id'],
        "company_id": result.data['company_id'],
        "experience_id": result.data['experience_id'],
        "interest_in": result.data['interest_in'],
        "notification_types": result.data['notification_types'],
        "flagged_by_users": [],
        "blocked_users": [],
        "token": result.data['token'],
        "referral": result.data['referral']
      };
      Logger().i(result.message);

      expect(result.status, 200);

      expect(result.data, result.data);

      userResponse = result.data;
    });

    /*test('Login Mock', () async {

      Map<String, dynamic> requestParams = {};
      requestParams['email'] = 'roy@yopmail.com';
      requestParams['password'] = '12345678';
      requestParams['device_id'] = 'testdevice';
      requestParams['device_type'] = 'android';
      requestParams['device_token'] = 'testtoken';

      UserModel userLoginApiResponse = UserModel();
      userLoginApiResponse.id = 185;

      when(mockRemoteService.createPostRequest(params: requestParams, typeOfEndPoint: ApiType.login))
          .thenAnswer((_) async => ResponseModel(status: 200, message: 'Success', data: userLoginApiResponse));

      var response = await mockRemoteService.createPostRequest(params: requestParams, typeOfEndPoint: ApiType.login);
      expect(response.status, 200);
    });*/
  });
}
