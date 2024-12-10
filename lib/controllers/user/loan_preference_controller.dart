import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iso_net/model/bottom_navigation_models/search_model/findfunder_model.dart';
import 'package:iso_net/model/dropdown_models/loan_preferences_models.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/extensions/string_extensions.dart';
import 'package:iso_net/utils/validation/validation.dart';
import 'package:tuple/tuple.dart';

import '../../helper_manager/network_manager/api_const.dart';
import '../../helper_manager/network_manager/remote_service.dart';
import '../../model/response_model/responese_datamodel.dart';
import '../../singelton_class/auth_singelton.dart';

class LoanPreferenceController extends GetxController {
  ///********* variables declaration ********///

  Rxn<MinimumMonthRevenueListModel> minMonthRevModel = Rxn();
  var monthlyRevenueList = <MinimumMonthRevenueListModel>[].obs;

  Rxn<MinimumTimeListModel> minTimeRevModel = Rxn();
  var minTimeList = <MinimumTimeListModel>[].obs;

  Rxn<CreditRequirementModel> creditRequirementModel = Rxn();
  var creditRequirementList = <CreditRequirementModel>[].obs;

  Rxn<MinimumNSFListModel> minimumNSFListModel = Rxn();
  var nsfList = <MinimumNSFListModel>[].obs;

  ///**************** Industry *****************************///
  Rxn<GetAllIndustryListModel> getAllIndustryListModel = Rxn();

  ///******Main list of get all industry ******///
  var getAllIndustryList = <GetAllIndustryListModel>[].obs;

  ///*****user selected list of Restricted & prefer industry*****//
  var selectedResIndustryChipList = <GetAllIndustryListModel>[].obs;
  var selectedPrefIndustryChipList = <GetAllIndustryListModel>[].obs;

  ///*****search list of Restricted & prefer industry*****//
  var searchResIndustryList = <GetAllIndustryListModel>[].obs;
  var searchPrefIndustryList = <GetAllIndustryListModel>[].obs;

  ///*****user selected id list of Restricted & prefer industry*****//
  var resIndustryList = <int>[].obs;
  var prefIndustryList = <int>[].obs;

  ///**********************************************************///

  ///**************** State *****************************///
  Rxn<GetStatesListModel> getStatesListModel = Rxn();

  ///******Main list of get all state ******///
  var getAllStates = <GetStatesListModel>[].obs;

  ///*****user selected list of Restricted  state*****//
  var selectedStateChipList = <GetStatesListModel>[].obs;

  ///*****search list of Restricted state*****//
  var searchGetAllStates = <GetStatesListModel>[].obs;

  ///*****user selected id list of Restricted  state*****//
  var resStateList = <int>[].obs;

  ///**********************************************************///

  Rxn<MaxFundingAmountListModel> maxFundingAmountListModel = Rxn();
  var maxFundAmountList = <MaxFundingAmountListModel>[].obs;

  Rxn<MaxTermLengthListModel> maxTermLengthListModel = Rxn();
  var maxTermLengthList = <MaxTermLengthListModel>[].obs;

  Rxn<StartingBuyRatesListModel> startingBuyRatesListModel = Rxn();
  var buyingRateList = <StartingBuyRatesListModel>[].obs;

  Rxn<MaxUpSellPointsListModel> maxUpSellPointsListModel = Rxn();
  var maxUpSellList = <MaxUpSellPointsListModel>[].obs;

  var loanAmount = ''.obs;
  var monthlyRevenue = ''.obs;
  var strList = List.generate(9, (index) => '').obs;
  var isButtonEnable = false.obs;

  TextEditingController creditTextController = TextEditingController();
  TextEditingController nsfTextController = TextEditingController();
  TextEditingController buyRateTextController = TextEditingController();
  TextEditingController maxUpSellTextController = TextEditingController();

  ///*******************************************

  ///load searchable dropdown list
  loadDropdownTempListsForSearch() {
    searchResIndustryList.value = getAllIndustryList;
    searchPrefIndustryList.value = getAllIndustryList;
    searchGetAllStates.value = getAllStates;
  }

  ///on search for res industries
  onRestrictedIndSearch(String search) {
    searchResIndustryList.value = getAllIndustryList.where((e) => e.industryName!.toLowerCase().contains(search.toLowerCase())).toList();
    Logger().i(search);
  }

  ///on search for pref industries
  onPrefIndSearch(String search) {
    searchPrefIndustryList.value = getAllIndustryList.where((e) => e.industryName!.toLowerCase().contains(search.toLowerCase())).toList();
    Logger().i(search);
  }

  ///on search for res states
  onResStatesSearch(String search) {
    searchGetAllStates.value = getAllStates.where((e) => e.stateName!.toLowerCase().contains(search.toLowerCase())).toList();
    Logger().i(search);
  }

  ///check box select - unselect
  checkBoxTap(int index, bool value) {
    searchGetAllStates[index].isStateChecked.value = value;
    if (searchGetAllStates[index].isStateChecked.value == true) {
      selectedStateChipList.add(searchGetAllStates[index]);
      resStateList.add(searchGetAllStates[index].id ?? 0);
      validateButton();
      Logger().i(resStateList);
    } else {
      selectedStateChipList.remove(searchGetAllStates[index]);
      resStateList.remove(searchGetAllStates[index].id ?? 0);
      validateButton();
      Logger().i(resStateList);
    }
  }

  ///check box select - unselect
  checkBoxResIndustry(int index, bool value) {
    searchResIndustryList[index].isResIndustryChecked.value = value;
    if (searchResIndustryList[index].isResIndustryChecked.value == true) {
      selectedResIndustryChipList.add(searchResIndustryList[index]);
      resIndustryList.add(searchResIndustryList[index].id ?? 0);
      validateButton();
      Logger().i(resIndustryList);
    } else {
      selectedResIndustryChipList.remove(searchResIndustryList[index]);
      resIndustryList.remove(searchResIndustryList[index].id ?? 0);
      validateButton();
      Logger().i(resIndustryList);
    }
  }

  ///check box select - unselect
  checkBoxPrefIndustry(int index, bool value) {
    searchPrefIndustryList[index].isPrefIndustryChecked.value = value;
    if (searchPrefIndustryList[index].isPrefIndustryChecked.value == true) {
      selectedPrefIndustryChipList.add(searchPrefIndustryList[index]);
      prefIndustryList.add(searchPrefIndustryList[index].id ?? 0);
      validateButton();
      Logger().i(prefIndustryList);
    } else {
      selectedPrefIndustryChipList.remove(searchPrefIndustryList[index]);
      prefIndustryList.remove(searchPrefIndustryList[index].id ?? 0);
      validateButton();
      Logger().i(prefIndustryList);
    }
  }

  ///*****Fetch CreditRequirementList api function *****///
  Future apiCallFetchCreditRequirementList() async {
    ResponseModel<List<CreditRequirementModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.creditRequirementList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      creditRequirementList.value = responseModel.data ?? [];
    } else {
      strList.insert(0, responseModel.message);
    }
  }

  ///*****Fetch MinimumTimeList api function *****///
  Future apiCallFetchMinimumTimeList() async {
    ResponseModel<List<MinimumTimeListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.timeInBusinessList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      minTimeList.value = responseModel.data ?? [];
    } else {
      strList.insert(1, responseModel.message);
    }
  }

  ///*****Fetch MonthlyRevenueList api function *****///
  /*Future apiCallFetchMonthlyRevenueList() async {
    ResponseModel<List<MinimumMonthRevenueListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.monthlyRevenueList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      monthlyRevenueList.value = responseModel.data ?? [];
    } else {
      strList.insert(2, responseModel.message);
    }
  }*/

  ///*****Fetch IndustryList api function *****///
  Future apiCallFetchIndustryList() async {
    ResponseModel<List<GetAllIndustryListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.industriesList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      getAllIndustryList.value = responseModel.data ?? [];
    } else {
      strList.insert(2, responseModel.message);
      strList.insert(5, responseModel.message);
    }
  }

  ///*****Fetch MinimumNSFList api function *****///
  Future apiCallFetchMinimumNSFList() async {
    ResponseModel<List<MinimumNSFListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.nsfList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      nsfList.value = responseModel.data ?? [];
    } else {
      strList.insert(3, responseModel.message);
    }
  }

  ///*****Fetch StatesList api function *****///
  Future apiCallFetchStatesList() async {
    ResponseModel<List<GetStatesListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.stateList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      getAllStates.value = responseModel.data ?? [];
    } else {
      strList.insert(4, responseModel.message);
    }
  }

  ///*****Fetch MaxFundingList api function *****///
  /* Future apiCallFetchMaxFundingList() async {
    ResponseModel<List<MaxFundingAmountListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.maxFundList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      maxFundAmountList.value = responseModel.data ?? [];
    } else {
      strList.insert(5, responseModel.message);
    }
  }*/

  ///*****Fetch MaxTermList api function *****///
  Future apiCallFetchMaxTermList() async {
    ResponseModel<List<MaxTermLengthListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.maxTermLengthList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      maxTermLengthList.value = responseModel.data ?? [];
    } else {
      strList.insert(6, responseModel.message);
    }
  }

  ///*****Fetch Starting Buy Rates List api function *****///
  Future apiCallFetchStartingBuyRatesList() async {
    ResponseModel<List<StartingBuyRatesListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.startBuyRatesList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      buyingRateList.value = responseModel.data ?? [];
    } else {
      strList.insert(7, responseModel.message);
    }
  }

  ///*****Fetch MaxUpsellList api function *****///
  Future apiCallFetchMaxUpsellList() async {
    ResponseModel<List<MaxUpSellPointsListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.maxUpsellPointsList,
    );
    ShowLoaderDialog.dismissLoaderDialog();
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      maxUpSellList.value = responseModel.data ?? [];
    } else {
      strList.insert(8, responseModel.message);
    }
  }

  ///***** create funder company api function *****///
  apiCallCreateCompanyFunder(
      {required String companyName,
      required String address,
      required String city,
      required String state,
      required String zipcode,
      required String phoneNumber,
      required String website,
      required String description,
      required List<File> file,
      required String latitude,
      required String longitude,
      required onErr}) async {
    if (file.isEmpty) {
      ShowLoaderDialog.showLoaderDialog(Get.context!);
    } else {
      ShowLoaderDialog.showLinearProgressIndicatorForFileUpload(context: Get.context!);
    }

    Map<String, dynamic> requestParams = {
      'company_name': companyName,
      'address': address,
      'city': city,
      'state': state,
      'zipcode': zipcode,
      'phone_number': phoneNumber,
      'website': website,
      if (description.isNotEmpty || description != '') 'description': description,
      'latitude': latitude,
      'longitude': longitude,
      //'credit_score': creditRequirementModel.value?.id ?? 0,
      'credit_score': int.parse(creditTextController.text),
      'min_monthly_rev': monthlyRevenue.value.replaceSpaceAndComma(),
      /*minMonthRevModel.value?.id ?? '',*/
      'min_time_business': minTimeRevModel.value?.id ?? 0,
      'restr_industies': resIndustryList,
      //'nsf': minimumNSFListModel.value?.id ?? 0,
      'nsf': int.parse(nsfTextController.text),
      'restr_state': resStateList,
      'pref_industries': prefIndustryList,
      'max_fund_amount': loanAmount.value.replaceSpaceAndComma(),
      'max_term_length': maxTermLengthListModel.value?.id ?? 0,
      //'buying_rates': startingBuyRatesListModel.value?.id ?? 0,
      'buying_rates': buyRateTextController.text.contains('.') ? double.parse(buyRateTextController.text).toStringAsFixed(2) : double.parse('${buyRateTextController.text}.00').toStringAsFixed(2),
      //'max_upsell_points': maxUpSellPointsListModel.value?.id ?? 0
      'max_upsell_points': int.parse(maxUpSellTextController.text)
    };
    ResponseModel<UserModel> responseModel = await sharedServiceManager.uploadRequest(
      ApiType.createCompany,
      params: requestParams,
      arrFile: file.isEmpty
          ? []
          : [
              AppMultiPartFile(localFiles: file, key: 'company_image'),
            ],
    );

    ShowLoaderDialog.dismissLoaderDialog();
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      ///***** Api Success *****//
      await userSingleton.updateValue(
        responseModel.data?.toJson() ?? <String, dynamic>{},
      );
      return true;
    } else {
      ///***** Api Error *****///
      onErr(responseModel.message);
      return false;
    }
  }

  ///******* Loan preferences Form validation *******
  Tuple2<bool, String> isValidLoanPref() {
    List<Tuple2<ValidationType, String>> arrList = [];
    //arrList.add(Tuple2(ValidationType.creditRequirement, creditRequirementModel.value?.reqScore ?? ''));
    arrList.add(Tuple2(ValidationType.creditRequirementManual, creditTextController.text));
    arrList.add(Tuple2(ValidationType.minTimeInBus, (minTimeRevModel.value?.bussinessTime ?? "").toString()));
    //arrList.add(Tuple2(ValidationType.minMonthlyRev, minMonthRevModel.value?.revenue ?? ''));
    arrList.add(Tuple2(ValidationType.minMonthlyRev, monthlyRevenue.value));
    arrList.add(Tuple2(ValidationType.resIndustries, (resIndustryList).toString()));
    //arrList.add(Tuple2(ValidationType.maxNsf, (minimumNSFListModel.value?.nsfCount ?? '').toString()));
    arrList.add(Tuple2(ValidationType.maxNsfManual, nsfTextController.text));
    arrList.add(Tuple2(ValidationType.resState, (resStateList).toString()));
    arrList.add(Tuple2(ValidationType.prefIndustries, (prefIndustryList).toString()));
    arrList.add(Tuple2(ValidationType.maxFund, loanAmount.value));
    arrList.add(Tuple2(ValidationType.maxTerms, (maxTermLengthListModel.value?.maxTerm ?? '').toString()));
    //arrList.add(Tuple2(ValidationType.startBuyRates, startingBuyRatesListModel.value?.maxBuyRates ?? ''));
    arrList.add(Tuple2(ValidationType.startBuyRateManual, buyRateTextController.text));
    // arrList.add(Tuple2(ValidationType.maxUpSells, maxUpSellPointsListModel.value?.sellPoints ?? ''));
    arrList.add(Tuple2(ValidationType.maxUpSellsManual, maxUpSellTextController.text));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);

    return Tuple2(validationResult.item1, validationResult.item2);
  }

  ///******* button enable disable validation *******
  validateButton() {
    if ( //(creditRequirementModel.value?.reqScore ?? '').isNotEmpty &&
        (creditTextController.text.isNotEmpty && (int.parse(creditTextController.text) >= 500 && int.parse(creditTextController.text) <= 1000)) &&
            (monthlyRevenue.value).isNotEmpty &&
            (" ${minTimeRevModel.value?.bussinessTime ?? 0.0}").isNotEmpty &&
            resIndustryList.isNotEmpty &&
            // (" ${minimumNSFListModel.value?.nsfCount ?? 0}").isNotEmpty &&
            (nsfTextController.text).isNotEmpty &&
            resStateList.isNotEmpty &&
            prefIndustryList.isNotEmpty &&
            prefIndustryList.where((p0) => resIndustryList.contains(p0)).isEmpty &&
            (loanAmount.value).isNotEmpty &&
            ('${maxTermLengthListModel.value?.maxTerm ?? 0}').isNotEmpty &&
            //(startingBuyRatesListModel.value?.maxBuyRates ?? '').isNotEmpty &&
            (buyRateTextController.text).isNotEmpty &&
            // (maxUpSellPointsListModel.value?.sellPoints ?? '').isNotEmpty)
            (maxUpSellTextController.text).isNotEmpty) {
      isButtonEnable.value = true;
    } else {
      isButtonEnable.value = false;
    }
  }

  ///******************************* Find a Funder Form ***********************************///

  ///********* variables declaration ********///
  var funderCompanyList = <CompanyList>[].obs;
  var pageToShow = 1.obs;
  var pageLimitPagination = 6.obs;
  var totalRecords = 0.obs;
  var isAllDataLoaded = false.obs;
  ScrollController scrollController = ScrollController();
  var isLoadMoreRunningForViewAll = false;

  ///*******************************************///

  ///******* Find Funder Form validation *******
  Tuple2<bool, String> isValidFindFunderForm() {
    List<Tuple2<ValidationType, String>> arrList = [];
    arrList.add(Tuple2(ValidationType.creditRequirement, creditRequirementModel.value?.reqScore ?? ''));
    arrList.add(Tuple2(ValidationType.minTimeInBus, (minTimeRevModel.value?.bussinessTime ?? "").toString()));
    /*arrList.add(Tuple2(ValidationType.minMonthlyRev, minMonthRevModel.value?.revenue ?? ''));*/
    arrList.add(Tuple2(ValidationType.minMonthlyRev, monthlyRevenue.value));
    arrList.add(Tuple2(ValidationType.findFunderIndustry, (resIndustryList).toString()));
    arrList.add(Tuple2(ValidationType.findFunderState, (resStateList).toString()));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);

    return Tuple2(validationResult.item1, validationResult.item2);
  }

  ///******* button enable disable validation *******

  validateFindFunderButton() {
    if ((creditRequirementModel.value?.reqScore ?? '').isNotEmpty &&
        (" ${minTimeRevModel.value?.bussinessTime ?? 0.0}").isNotEmpty &&
        //(minMonthRevModel.value?.revenue ?? '').isNotEmpty &&
        (monthlyRevenue.value).isNotEmpty &&
        resIndustryList.isNotEmpty &&
        resStateList.isNotEmpty) {
      isButtonEnable.value = true;
    } else {
      isButtonEnable.value = false;
    }
  }

  ///******Find Funder Pagination

  funderPagination() {

    Logger().i(pageToShow.value);
    apiCallFindFunder(onErr: (msg) {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
    });
  }

  ///Find Funder Api Call Function
  apiCallFindFunder({required onErr}) async {
    Map<String, dynamic> params = {};
    params['credit_score'] = (creditRequirementModel.value?.reqScore ?? '').replaceSpaceAndPlus();
    params['min_monthly_rev'] = monthlyRevenue.value.replaceSpaceAndComma();
    params['min_time_business'] = minTimeRevModel.value?.id ?? 0;
    params['industries'] = resIndustryList;
    params['state'] = resStateList;
    params['start'] = funderCompanyList.length;
    params['limit'] = pageLimitPagination.value;

    ResponseModel<FindFunderModel> responseModel = await sharedServiceManager.uploadRequest(ApiType.findFunder, params: params);
    ShowLoaderDialog.dismissLoaderDialog();

    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      ///***** Api Success *****//
      totalRecords.value = responseModel.data?.totalRecord ?? 0;
      if (funderCompanyList.isEmpty) {
        funderCompanyList.value = responseModel.data?.companyList ?? [];
      } else {
        funderCompanyList.addAll(responseModel.data?.companyList ?? []);
      }
      isAllDataLoaded.value = (funderCompanyList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
      return true;
    } else {
      ///***** Api Error *****///
      onErr(responseModel.message);
      return false;
    }
  }
}
