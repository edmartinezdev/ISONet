import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/dropdown_models/get_companies_list_model.dart';
import 'package:iso_net/model/dropdown_models/userdetail_dropdown_model.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/validation/validation.dart';

main() {
  String city = 'Alabama';
  String state = 'Alabama';
  String dob = '1999-10-17';
  String companyName = 'Excents Pvt Ltd';
  String position = 'CEO';
  String bio = 'Testing Bio';

  group('DetailInfo screen api call', () {
    test('Experience list api call', () async {
      ///Need to check token if token is invalid test case will be failed.
      ResponseModel<List<ExperienceDropDownModel>> responseModel = await sharedServiceManager.createTestGetRequest(
        typeOfEndPoint: ApiType.getExperienceList,
      );
      expect(responseModel.status, 200);
      Logger().i(responseModel.message);
    });
    test('Company list api call', () async {
      ResponseModel<List<GetCompaniesListModel>> companiesList = await sharedServiceManager.createTestGetRequest(
        typeOfEndPoint: ApiType.getCompaniesList,
      );
      expect(companiesList.status, 200);
    });
  });

  group('Detail info screen form validation test case', () {
    test('City valid test', () {
      var result = Validation().validateCity(city);
      expect(result.item2, '');
    });
    test('State valid test', () {
      var result = Validation().validateState(state);
      expect(result.item2, '');
    });
    test('Birthdate valid test', () {
      var result = Validation().validateBirthDate(dob);
      expect(result.item2, '');
    });

    test('CompanyName valid test', () {
      var result = Validation().validateCompanyDropDown(companyName);
      expect(result.item2, '');
    });

    test('Position valid test', () {
      var result = Validation().validatePosition(position);
      expect(result.item2, '');
    });

    test('Bio valid test', () {
      var result = Validation().validatePosition(bio);
      expect(result.item2, '');
    });
  });

  group('Signup Stage 3 Api test', () {
    test('Sign up stage 3 api success', () async {
      Map<String, dynamic> requestParams = {};
      requestParams['city'] = city;
      requestParams['state'] = state;
      requestParams['dob'] = dob;
      requestParams['company_id'] = 66;
      requestParams['position'] = position;
      requestParams['experience_id'] = 5;
      requestParams['bio'] = bio;
      requestParams['is_public'] = true;

      ResponseModel<UserModel> signUpResponse = await sharedServiceManager.createTestPostRequest(
        typeOfEndPoint: ApiType.signUpStage3,
        params: requestParams,
      );
      expect(signUpResponse.status, 200);
    });
    test('Sign up stage 3 api failure test', () async {
      Map<String, dynamic> requestParams = {};
      requestParams['city'] = city;
      requestParams['state'] = state;
      requestParams['dob'] = dob;
      requestParams['company_id'] = 0;
      requestParams['position'] = position;
      requestParams['experience_id'] = 5;
      requestParams['bio'] = bio;
      requestParams['is_public'] = true;

      ResponseModel<UserModel> signUpResponse = await sharedServiceManager.createTestPostRequest(
        typeOfEndPoint: ApiType.signUpStage3,
        params: requestParams,
      );
      expect(signUpResponse.status, 400);
      Logger().e(signUpResponse.message);
    });
  });
}
