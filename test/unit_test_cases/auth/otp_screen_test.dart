import 'package:flutter_test/flutter_test.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/utils/validation/validation.dart';

main() {
  String otpNumber = '925356';
  String token = 'a8d4489991f38369b943f7e9a9805f617012b4b0';
  test('Otp Valid Test Case', () {
    var result = Validation().validateOtp(otpNumber);
    expect(result.item2, '');
  });

  test('Sign up stage 2 otp success test case', () async {
    Map<String, dynamic> requestParams = {};
    requestParams['email'] = 'vinses@yopmail.com';
    requestParams['otp'] = '784172';
    ResponseModel resendOtp = await sharedServiceManager.createTestPostRequest(
      typeOfEndPoint: ApiType.otp,
      params: requestParams,
    );
    expect(resendOtp.status, 200);
  });

  test('Sign up stage 2 otp invalid test case', () async {
    Map<String, dynamic> requestParams = {};
    requestParams['email'] = 'vinses@yopmail.com';
    requestParams['otp'] = '467627';
    ResponseModel resendOtp = await sharedServiceManager.createTestPostRequest(
      typeOfEndPoint: ApiType.otp,
      params: requestParams
    );
    expect(resendOtp.status, 400);

  });

  test('resend otp test case', () async {
    ResponseModel resendOtp = await sharedServiceManager.createTestPostRequest(
      typeOfEndPoint: ApiType.resendOtp,
    );
    expect(resendOtp.status, 200);
  });
}
