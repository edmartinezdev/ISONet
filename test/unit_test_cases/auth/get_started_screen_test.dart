import 'package:flutter_test/flutter_test.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';

import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';

import 'package:iso_net/utils/validation/validation.dart';

void main() {
  // Define your variables and test data here
  String firstName = 'Christopher';
  String lastName = 'Joseph';
  String emailText = 'christopher@yopmail.com';
  String phoneNo = '(123) 4567-789';
  String password = '123456';
  String confirmPassword = '123456';
  bool termsCondition = true;
  String userBroker = 'BR';
  String userFunder = 'FU';


  group('Form Validation Tests', () {
    test('First Name Valid Test', () {
      var result = Validation().validateFirstName(firstName);
      expect(result.item2, '');
    });

    test('Last Name Valid Test', () {
      var result = Validation().validateLastName(lastName);
      expect(result.item2, '');
    });

    test('Email Valid Test', () {
      var result = Validation().validateEmail(emailText);
      expect(result.item2, '');
    });

    test('PhoneNo Valid Test', () {
      var result = Validation().validatePhoneNumber(phoneNo);
      expect(result.item2, '');
    });

    test('Password Valid Test', () {
      var result = Validation().validatePassword(password);
      expect(result.item2, '');
    });

    test('Confirm Password Valid Test', () {
      var result = Validation().validateConfirmPassword(password, confirmPassword);
      expect(result.item2, '');
    });
  });

  group('Signup Stage 1 Api Call', () {
    test('User Already Register Test Case', () async {
      Map<String, dynamic> requestParams = {};
      requestParams['email'] = 'roy@yopmail.com';
      requestParams['password'] = '12345678';
      requestParams['first_name'] = 'Roy';
      requestParams['last_name'] = 'Lee';
      requestParams['user_type'] = 'FU';
      requestParams['phone_number'] = CommonUtils.convertToPhoneNumber(updatedStr: phoneNo);

      ResponseModel result = await sharedServiceManager.createTestPostRequest(
        typeOfEndPoint: ApiType.signUp,
        params: requestParams,
      );

      expect(result.status, 400);
      expect(result.message, 'A user is already registered with this e-mail address.');
      expect(result.data, null);
    });

    test('User Register Success Test Case', () async {
      Map<String, dynamic> requestParams = {};
      requestParams['email'] = emailText;
      requestParams['password'] = password;
      requestParams['first_name'] = firstName;
      requestParams['last_name'] = lastName;
      requestParams['user_type'] = userBroker;
      requestParams['phone_number'] = CommonUtils.convertToPhoneNumber(updatedStr: phoneNo);

      ResponseModel result = await sharedServiceManager.createTestPostRequest(
        typeOfEndPoint: ApiType.signUp,
        params: requestParams,
      );
      Map<String, dynamic> userStage1ApiResponse = {
        "id": result.data['id'],
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": CommonUtils.convertToPhoneNumber(updatedStr: phoneNo),
        "email": emailText,
        "city": null,
        "password": result.data['password'],
        "state": null,
        "dob": null,
        "position": null,
        "bio": null,
        "user_type": "FU",
        "is_owner": false,
        "profile_img": null,
        "background_img": null,
        "is_approved": "pending",
        "is_sup_admin": false,
        "is_blocked": false,
        "is_active": true,
        "is_deleted": false,
        "is_verified": false,
        "delete_by_user": false,
        "is_staff": false,
        "is_superuser": false,
        "last_login": null,
        "user_stage": 1,
        "is_public": true,
        "is_subscribed": false,
        "current_subscription_type": null,
        "subscription_start_date": null,
        "subscription_end_date": null,
        "is_canceled": false,
        "compress_profile_img_name": null,
        "compress_background_img_name": null,
        "created_at": result.data['created_at'],
        "updated_at": result.data['updated_at'],
        "socket_id": null,
        "company_id": null,
        "experience_id": null,
        "interest_in": [],
        "notification_types": [],
        "flagged_by_users": [],
        "blocked_users": [],
        "token": result.data['token'],
        "referral": result.data['referral'],
        "referral_by": null
      };
      Logger().i(result.message);

      expect(result.status, 200);

      expect(result.data, userStage1ApiResponse);
    });
  });
}
