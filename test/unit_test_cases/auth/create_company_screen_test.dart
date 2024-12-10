import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/dropdown_models/loan_preferences_models.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/string_extensions.dart';
import 'package:iso_net/utils/validation/validation.dart';

main() {
  String companyName = 'Funding pvt Ltd';
  String address = '12B, Street of alabama road';
  String city = 'Alabama';
  String state = 'Alabama';
  String phoneNo = '(123) 456-7890';
  String zipcode = '35004';
  String companyImage =
      'https://images.unsplash.com/photo-1557804506-669a67965ba0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8Y29tcGFueSUyMGltYWdlfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=60';
  String userType = 'FU';
  String website = '';
  String description = '';
  bool isSkip = false;
  String creditScore = '600';
  String minTimeBusiness =  '1 Year';
  List<int> resIndustryList = [1,2,3];
  List<int> prefIndustryList = [5,6];
  List<int> resStateList = [1,2,3];
  String monthlyRevenue = '2000.00';
  String maxFund = '200.00';
  String maxTerm = '2 Years';
  int maxTermId = 2;
  String buyRates = '4.00';
  int maxUpsellPoint = 2;

  String nsfText = '2';



  //String userType = 'FU';

  group('Create company form test case', () {
    test('Company name valid test', () {
      final result = Validation().validateCompany(companyName);
      expect(result.item2, '');
    });
    test('Address valid test', () {
      final result = Validation().validateAddress(address);
      expect(result.item2, '');
    });

    test('City valid test', () {
      final result = Validation().validateCity(city);
      expect(result.item2, '');
    });
    test('State valid test', () {
      final result = Validation().validateState(state);
      expect(result.item2, '');
    });
    test('PhoneNo valid test', () {
      final result = Validation().validatePhoneNumber(phoneNo);
      expect(result.item2, '');
    });
    test('ZipCode valid test', () {
      final result = Validation().validateZipCode(zipcode);
      expect(result.item2, '');
    });
    test('Company image test', () {
      if (companyImage.isEmpty) {
        expect(AppStrings.validateCompanyImage, AppStrings.validateCompanyImage);
      }
    });
  });
  // if (userType == AppStrings.br) {
  //   return group('Create company broker api call', () {
  //     test('Create company success api test', () async {
  //       Map<String, dynamic> requestParams = {
  //         'company_name': companyName,
  //         'address': address,
  //         'city': city,
  //         'state': state,
  //         'zipcode': zipcode,
  //         'phone_number': phoneNo,
  //         'website': website,
  //         if (description.isNotEmpty || description != '') 'description': description,
  //         'latitude': ApiConstant.staticLatitude,
  //         'longitude': ApiConstant.staticLongitude,
  //       };
  //       ResponseModel<UserModel> responseModel = await sharedServiceManager.uploadRequest(
  //         ApiType.createCompanyBroker,
  //         params: requestParams,
  //         arrFile: isSkip == true
  //             ? []
  //             : [
  //                 AppMultiPartFile(localFiles: [File(companyImage)], key: 'company_image'),
  //               ],
  //       );
  //       expect(responseModel.status, 200);
  //     });
  //     test('Create company failure api test', () async {
  //       Map<String, dynamic> requestParams = {
  //         'company_name': '',
  //         'address': '',
  //         'city': city,
  //         'state': state,
  //         'zipcode': zipcode,
  //         'phone_number': phoneNo,
  //         'website': website,
  //         if (description.isNotEmpty || description != '') 'description': description,
  //         'latitude': ApiConstant.staticLatitude,
  //         'longitude': ApiConstant.staticLongitude,
  //       };
  //       ResponseModel<UserModel> responseModel = await sharedServiceManager.uploadRequest(
  //         ApiType.createCompanyBroker,
  //         params: requestParams,
  //         arrFile: isSkip == true
  //             ? []
  //             : [
  //                 AppMultiPartFile(localFiles: [File(companyImage)], key: 'company_image'),
  //               ],
  //       );
  //       expect(responseModel.status, 400);
  //     });
  //   });
  // }
  group('Loan Preference screen api call test', () {
    test('Credit score api test', () async {
      ResponseModel<List<CreditRequirementModel>> responseModel = await sharedServiceManager.createTestGetRequest(
        typeOfEndPoint: ApiType.creditRequirementList,
      );
      expect(responseModel.status, 200);
    });
    test('Minimum time in business api test', () async {
      ResponseModel<List<MinimumTimeListModel>> responseModel = await sharedServiceManager.createTestGetRequest(
        typeOfEndPoint: ApiType.timeInBusinessList,
      );
      expect(responseModel.status, 200);
    });
    test('Industry list api test', () async {
      ResponseModel<List<GetAllIndustryListModel>> responseModel = await sharedServiceManager.createTestGetRequest(
        typeOfEndPoint: ApiType.industriesList,
      );
      expect(responseModel.status, 200);
    });
    test('MinimumNSF list api test', () async {
      ResponseModel<List<MinimumNSFListModel>> responseModel = await sharedServiceManager.createTestGetRequest(
        typeOfEndPoint: ApiType.nsfList,
      );
      expect(responseModel.status, 200);
    });
    test('State list api test', () async {
      ResponseModel<List<GetStatesListModel>> responseModel = await sharedServiceManager.createTestGetRequest(
        typeOfEndPoint: ApiType.stateList,
      );
      expect(responseModel.status, 200);
    });
    test('MaxTerm api test', () async {
      ResponseModel<List<MaxTermLengthListModel>> responseModel = await sharedServiceManager.createTestGetRequest(
        typeOfEndPoint: ApiType.maxTermLengthList,
      );
      expect(responseModel.status, 200);
    });
    test('MaxUpsell api test', () async {
      ResponseModel<List<MaxUpSellPointsListModel>> responseModel = await sharedServiceManager.createTestGetRequest(
        typeOfEndPoint: ApiType.maxUpsellPointsList,
      );
      expect(responseModel.status, 200);
    });
    test('Buy Rates api test', () async {
      ResponseModel<List<StartingBuyRatesListModel>> responseModel = await sharedServiceManager.createTestGetRequest(
        typeOfEndPoint: ApiType.startBuyRatesList,
      );
      expect(responseModel.status, 200);
    });
  });
  group('Loan preference form valid test', () {
        test('Credit Score valid', () {
          final result = Validation().validateCreditReqManual(creditScore);
          expect(result.item2, '');
        });
        test('Minimum time in business  valid', () {
          final result = Validation().validateMinimumTimeInBusiness(minTimeBusiness);
          expect(result.item2, '');
        });
        test('Minimum monthly revenue valid', () {
          final result = Validation().validateMinimumMonthlyRevenue(monthlyRevenue);
          expect(result.item2, '');
        });
        test('Restricted Industry valid', () {
          final result = Validation().validateRestrictedIndustries(resIndustryList.toString());
          expect(result.item2, '');
        });
        test('Maximum Nsf valid', () {
          final result = Validation().validateMaximumOfNSFPerMonthManual(nsfText);
          expect(result.item2, '');
        });
        test('Restricted state valid', () {
          final result = Validation().validateRestrictedStates(resStateList.toString());
          expect(result.item2, '');
        });
        test('Preferred Industry valid', () {
          final result = Validation().validateSelectPreferredIndustries(prefIndustryList.toString());
          expect(result.item2, '');
        });
        test('MaxFund valid', () {
          final result = Validation().validateMaximumFundingAmounts(maxFund);
          expect(result.item2, '');
        });
        test('MaxTerms valid', () {
          final result = Validation().validateMaximumTermLength(maxTerm);
          expect(result.item2, '');
        });
        test('Starting buyRates valid', () {
          final result = Validation().validateStartingBuyRatesManual(buyRates);
          expect(result.item2, '');
        });

        test('maxUpsells valid', () {
          final result = Validation().validateMaxUpsellPointsManual(maxUpsellPoint.toString());
          expect(result.item2, '');
        });

      });

  test('Funder create company api success', ()async{
    Map<String, dynamic> requestParams = {
      'company_name': companyName,
      'address': address,
      'city': city,
      'state': state,
      'zipcode': zipcode,
      'phone_number': phoneNo,
      'website': website,
      if (description.isNotEmpty || description != '') 'description': description,
      'latitude': ApiConstant.staticLatitude,
      'longitude': ApiConstant.staticLongitude,
      //'credit_score': creditRequirementModel.value?.id ?? 0,
      'credit_score': int.parse(creditScore),
      'min_monthly_rev': monthlyRevenue.replaceSpaceAndComma(),
      /*minMonthRevModel.value?.id ?? '',*/
      'min_time_business': minTimeRevModel.value?.id ?? 0,
      'restr_industies': resIndustryList,
      //'nsf': minimumNSFListModel.value?.id ?? 0,
      'nsf': int.parse(nsfText),
      'restr_state': resStateList,
      'pref_industries': prefIndustryList,
      'max_fund_amount': maxFund.replaceSpaceAndComma(),
      'max_term_length': maxTermId,
      //'buying_rates': startingBuyRatesListModel.value?.id ?? 0,
      'buying_rates': buyRates.contains('.') ? double.parse(buyRates).toStringAsFixed(2) : double.parse('$buyRates.00').toStringAsFixed(2),
      //'max_upsell_points': maxUpSellPointsListModel.value?.id ?? 0
      'max_upsell_points': maxUpsellPoint
    };
    ResponseModel<UserModel> responseModel = await sharedServiceManager.uploadRequest(
      ApiType.createCompany,
      params: requestParams,
      arrFile:
           [
        AppMultiPartFile(localFiles: [File(companyImage)], key: 'company_image'),
      ],
    );

  });
}
