import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:integration_test/integration_test.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/validation/validation.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  String emailText = 'roy@yopmail';
  var emailTest = Validation().validateEmailTest(emailText);
  String password = '12345678';
  var passwordTest = Validation().validatePasswordTest(password);

  group("emailField", () {
    if (emailTest.item3 == '') {
      test("email empty", () {
        //Logger().i('email empty ${emailTest.item3}');
        expect(emailTest.item2, AppStrings.blankEmail);
      });
    } else if (emailTest.item1 == false) {
      test("email not valid", () {
        //Logger().i('email not valid ${emailTest.item3}');
        expect(emailTest.item2, AppStrings.validateEmail);
      });
      //expect(emailTest.item2, AppStrings.validateEmail);
    } else {
      test("email valid", () {
        //Logger().i('email valid ${emailTest.item3}');
        expect(emailTest.item1, true);
      });
    }
  });
  group("passwordField", () {
    if (passwordTest.item3 == '') {
      test("password empty", () {
        //Logger().i('password empty ${passwordTest.item3}');
        expect(passwordTest.item2, AppStrings.blankPassword);
      });
    } else if (passwordTest.item1 == false) {
      test("password not valid", () {
        //Logger().i('email not valid ${passwordTest.item3}');
        expect(passwordTest.item2, AppStrings.validatePassword);
      });
    } else {
      test("password valid", () {
        //Logger().i('password valid ${passwordTest.item3}');
        expect(passwordTest.item1, true);
      });
    }
  });
  if (passwordTest.item1 && emailTest.item1) {
    test(
      'given UserRepository class when getUser function is called and status code is 200 then a usermodel should be returned',
      () async {
        Logger().i('Api Call');
        Map<String, dynamic> requestParams = {};
        requestParams['email'] = emailTest.item3;
        requestParams['password'] = passwordTest.item3;
        requestParams['device_id'] = 'test';
        requestParams['device_type'] = 'android';
        requestParams['device_token'] = 'testtoken';
        // Arrange
        ResponseModel<UserModel> loginApiResponse = await sharedServiceManager.createPostRequest(
          typeOfEndPoint: ApiType.login,
          params: requestParams,
        );

        loginApiResponse.status;
        Logger().i(loginApiResponse.data);
      },
    );
  }
}
