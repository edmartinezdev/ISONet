import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/company_profile_model.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/string_extensions.dart';
import 'package:tuple/tuple.dart';

import '../../../../helper_manager/network_manager/api_const.dart';
import '../../../../helper_manager/network_manager/remote_service.dart';
import '../../../../model/dropdown_models/loan_preferences_models.dart';
import '../../../../model/response_model/responese_datamodel.dart';
import '../../../../ui/style/showloader_component.dart';
import '../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../utils/validation/validation.dart';

class CompanyFilterController extends GetxController {
  var loanAmount = ''.obs;
  var monthlyRevenue = ''.obs;
  Rxn<MinimumMonthRevenueListModel> minMonthRevModel = Rxn();
  Rxn<MinimumTimeListModel> minTimeRevModel = Rxn();
  Rxn<CreditRequirementModel> creditRequirementModel = Rxn();
  Rxn<MinimumNSFListModel> minimumNSFListModel = Rxn();
  Rxn<GetAllIndustryListModel> getAllIndustryListModel = Rxn();
  Rxn<GetStatesListModel> getStatesListModel = Rxn();
  Rxn<MaxFundingAmountListModel> maxFundingAmountListModel = Rxn();
  Rxn<MaxTermLengthListModel> maxTermLengthListModel = Rxn();
  Rxn<StartingBuyRatesListModel> startingBuyRatesListModel = Rxn();
  Rxn<MaxUpSellPointsListModel> maxUpSellPointsListModel = Rxn();
  var selectedStateChipList = <GetStatesListModel>[].obs;
  var selectedResIndustryChipList = <GetAllIndustryListModel>[].obs;
  var selectedPrefIndustryChipList = <GetAllIndustryListModel>[].obs;
  var getAllIndustryList = <GetAllIndustryListModel>[].obs;
  var searchResIndustryList = <GetAllIndustryListModel>[].obs;
  var searchPrefIndustryList = <GetAllIndustryListModel>[].obs;
  var creditRequirementList = <CreditRequirementModel>[].obs;
  var monthlyRevenueList = <MinimumMonthRevenueListModel>[].obs;
  var minTimeList = <MinimumTimeListModel>[].obs;
  var nsfList = <MinimumNSFListModel>[].obs;
  var getAllStates = <GetStatesListModel>[].obs;
  var searchGetAllStates = <GetStatesListModel>[].obs;
  var resStateList = <int>[].obs;
  var resIndustryList = <int>[].obs;
  var prefIndustryList = <int>[].obs;
  var maxFundAmountList = <MaxFundingAmountListModel>[].obs;
  var maxTermLengthList = <MaxTermLengthListModel>[].obs;
  var buyingRateList = <StartingBuyRatesListModel>[].obs;
  var maxUpSellList = <MaxUpSellPointsListModel>[].obs;
  TextEditingController creditTextController = TextEditingController();
  TextEditingController nsfTextController = TextEditingController();
  TextEditingController buyRateTextController = TextEditingController();
  TextEditingController maxUpSellTextController = TextEditingController();
  TextEditingController fundAmountController = TextEditingController();
  TextEditingController monthlyRevenueController = TextEditingController();
  var strList = List.generate(11, (index) => '').obs;

  var isEnabled = false.obs;
  var isLoanEdit = false.obs;

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

  Future fetchCreditRequirementList() async {
    ResponseModel<List<CreditRequirementModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.creditRequirementList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      creditRequirementList.value = responseModel.data ?? [];
    } else {
      strList.insert(0, responseModel.message);
    }
  }

  Future fetchMinimumTimeList() async {
    ResponseModel<List<MinimumTimeListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.timeInBusinessList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      minTimeList.value = responseModel.data ?? [];
    } else {
      strList.insert(1, responseModel.message);
    }
  }

  Future fetchMonthlyRevenueList() async {
    ResponseModel<List<MinimumMonthRevenueListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.monthlyRevenueList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      monthlyRevenueList.value = responseModel.data ?? [];
    } else {
      strList.insert(2, responseModel.message);
    }
  }

  Future fetchIndustryList() async {
    ResponseModel<List<GetAllIndustryListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.industriesList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      getAllIndustryList.value = responseModel.data ?? [];
    } else {
      strList.insert(3, responseModel.message);
    }
  }

  Future fetchMinimumNSFList() async {
    ResponseModel<List<MinimumNSFListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.nsfList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      nsfList.value = responseModel.data ?? [];
    } else {
      strList.insert(4, responseModel.message);
    }
  }

  Future fetchStatesList() async {
    ResponseModel<List<GetStatesListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.stateList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      getAllStates.value = responseModel.data ?? [];
    } else {
      strList.insert(5, responseModel.message);
    }
  }

  Future fetchMaxFundingList() async {
    ResponseModel<List<MaxFundingAmountListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.maxFundList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      maxFundAmountList.value = responseModel.data ?? [];
    } else {
      strList.insert(7, responseModel.message);
    }
  }

  Future fetchMaxTermList() async {
    ResponseModel<List<MaxTermLengthListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.maxTermLengthList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      maxTermLengthList.value = responseModel.data ?? [];
    } else {
      strList.insert(8, responseModel.message);
    }
  }

  Future fetchStartingBuyRatesList() async {
    ResponseModel<List<StartingBuyRatesListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.startBuyRatesList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      buyingRateList.value = responseModel.data ?? [];
    } else {
      strList.insert(9, responseModel.message);
    }
  }

  Future fetchMaxUpsellList() async {
    ResponseModel<List<MaxUpSellPointsListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.maxUpsellPointsList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      maxUpSellList.value = responseModel.data ?? [];
    } else {
      strList.insert(10, responseModel.message);
    }
  }

  updateCompanyLOANApiCall({required onErr, onSuccess}) async {
    Map<String, dynamic> requestParams = {
      //'credit_score': creditRequirementModel.value?.id ?? 0,
      'credit_score': int.parse(creditTextController.text),
      'min_monthly_rev': monthlyRevenueController.text.replaceSpaceAndComma(),
      'min_time_business': minTimeRevModel.value?.id ?? 0,
      'restr_industies': resIndustryList,
      //'nsf': minimumNSFListModel.value?.id ?? 0,
      'nsf': int.parse(nsfTextController.text),
      'restr_state': resStateList,
      'pref_industries': prefIndustryList,
      'max_fund_amount': fundAmountController.text.replaceSpaceAndComma(),
      'max_term_length': maxTermLengthListModel.value?.id ?? 0,
      // 'buying_rates': startingBuyRatesListModel.value?.id ?? 0,
      'buying_rates': buyRateTextController.text.contains('.') ? double.parse(buyRateTextController.text).toStringAsFixed(2) : double.parse('${buyRateTextController.text}.00').toStringAsFixed(2),
      //'max_upsell_points': maxUpSellPointsListModel.value?.id ?? 0
      'max_upsell_points': int.parse(maxUpSellTextController.text)
    };
    ResponseModel<CompanyProfileModel> responseModel = await sharedServiceManager.uploadRequest(
      ApiType.updateCompanyLoanData,
      params: requestParams,
    );
    ShowLoaderDialog.dismissLoaderDialog();
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      onSuccess(responseModel.message);
      isLoanEdit.value = false;
      return true;
    } else {
      onErr(responseModel.message);
      return false;
    }
  }

  ///******* Loan preferences Form validation *******
  Tuple2<bool, String> isValidLoanPref() {
    List<Tuple2<ValidationType, String>> arrList = [];
    //arrList.add(Tuple2(ValidationType.creditRequirement, creditRequirementModel.value?.reqScore ?? ''));
    arrList.add(Tuple2(ValidationType.creditRequirementManual, creditTextController.text));
    arrList.add(Tuple2(ValidationType.minMonthlyRev, monthlyRevenueController.text));
    arrList.add(Tuple2(ValidationType.minTimeInBus, (minTimeRevModel.value?.bussinessTime ?? "").toString()));

    arrList.add(Tuple2(ValidationType.resIndustries, (resIndustryList).toString()));
    //arrList.add(Tuple2(ValidationType.maxNsf, (minimumNSFListModel.value?.nsfCount ?? '').toString()));
    arrList.add(Tuple2(ValidationType.maxNsfManual, nsfTextController.text));
    arrList.add(Tuple2(ValidationType.resState, (resStateList).toString()));
    arrList.add(Tuple2(ValidationType.prefIndustries, (prefIndustryList).toString()));
    arrList.add(Tuple2(ValidationType.maxFund, fundAmountController.text));
    arrList.add(Tuple2(ValidationType.maxTerms, (maxTermLengthListModel.value?.maxTerm ?? '').toString()));
    //arrList.add(Tuple2(ValidationType.startBuyRates, startingBuyRatesListModel.value?.maxBuyRates ?? ''));
    arrList.add(Tuple2(ValidationType.startBuyRateManual, buyRateTextController.text));
    //arrList.add(Tuple2(ValidationType.maxUpSells, maxUpSellPointsListModel.value?.sellPoints ?? ''));
    arrList.add(Tuple2(ValidationType.maxUpSellsManual, maxUpSellTextController.text));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);

    return Tuple2(validationResult.item1, validationResult.item2);
  }

  ///******* button enable disable validation *******
  validateButton() {
    if (/*(creditRequirementModel.value?.reqScore ?? '').isNotEmpty &&*/
        (creditTextController.text.isNotEmpty && (int.parse(creditTextController.text) >= 500 && int.parse(creditTextController.text) <= 1000)) &&
            (" ${minTimeRevModel.value?.bussinessTime ?? 0.0}").isNotEmpty &&
            (monthlyRevenueController.text).isNotEmpty &&
            monthlyRevenueController.text != '\$ 0.00' &&
            resIndustryList.isNotEmpty &&
            //(" ${minimumNSFListModel.value?.nsfCount ?? 0}").isNotEmpty &&
            (nsfTextController.text).isNotEmpty &&
            resStateList.isNotEmpty &&
            prefIndustryList.isNotEmpty &&
            prefIndustryList.where((p0) => resIndustryList.contains(p0)).isEmpty &&
            (fundAmountController.text).isNotEmpty &&
            fundAmountController.text != '\$ 0.00' &&
            ('${maxTermLengthListModel.value?.maxTerm ?? 0}').isNotEmpty &&
            //(startingBuyRatesListModel.value?.maxBuyRates ?? '').isNotEmpty &&
            (buyRateTextController.text).isNotEmpty &&
            //(maxUpSellPointsListModel.value?.sellPoints ?? '').isNotEmpty) {
            (maxUpSellTextController.text).isNotEmpty) {
      isEnabled.value = true;
    } else {
      isEnabled.value = false;
    }


  }

  ///GetAll Dropdown Data
  getModelDropDownData(CompanyProfileModel companyProfileData) {
    ///CreditRequirement
    for (int i = 0; i < creditRequirementList.length; i++) {
      if (creditRequirementList[i].id == companyProfileData.creditScore) {
        creditRequirementModel.value = creditRequirementList[i];
      }
    }

    ///MINIMUM TIME IN Business
    for (int i = 0; i < minTimeList.length; i++) {
      if (minTimeList[i].id == companyProfileData.minTimeBusiness) {
        minTimeRevModel.value = minTimeList[i];
      }
    }

    /* ///Minimum Month Revenue
    for (int i = 0; i < monthlyRevenueList.length; i++) {
      if (monthlyRevenueList[i].id == companyProfileData.minMonthlyRev) {
        minMonthRevModel.value = monthlyRevenueList[i];
      }
    }*/

    ///Selected Restricted Industry
    for (int i = 0; i < searchResIndustryList.length; i++) {
      if (companyProfileData.restrIndusties != null) {
        if (companyProfileData.restrIndusties!.contains(searchResIndustryList[i].id ?? 0)) {
          selectedResIndustryChipList.add(searchResIndustryList[i]);
          resIndustryList.add(searchResIndustryList[i].id ?? 0);
          searchResIndustryList[i].isResIndustryChecked.value = true;
        }
      }
    }

    ///Maximum Nsf
    for (int i = 0; i < nsfList.length; i++) {
      if (nsfList[i].id == companyProfileData.nsfId) {
        minimumNSFListModel.value = nsfList[i];
      }
    }

    ///Selected Restricted States
    for (int i = 0; i < searchGetAllStates.length; i++) {
      if (companyProfileData.restrState != null) {
        if (companyProfileData.restrState!.contains(searchGetAllStates[i].id ?? 0)) {
          selectedStateChipList.add(searchGetAllStates[i]);
          resStateList.add(searchGetAllStates[i].id ?? 0);
          searchGetAllStates[i].isStateChecked.value = true;
        }
      }
    }

    ///Selected Preferred Industry
    for (int i = 0; i < searchPrefIndustryList.length; i++) {
      if (companyProfileData.prefIndustries != null) {
        if (companyProfileData.prefIndustries!.contains(searchPrefIndustryList[i].id ?? 0)) {
          selectedPrefIndustryChipList.add(searchPrefIndustryList[i]);
          prefIndustryList.add(searchPrefIndustryList[i].id ?? 0);
          searchPrefIndustryList[i].isPrefIndustryChecked.value = true;
        }
      }
    }

    /*///Maximum Funding Amounts
    for (int i = 0; i < maxFundAmountList.length; i++) {
      if (maxFundAmountList[i].id == companyProfileData.maxFundAmount) {
        maxFundingAmountListModel.value = maxFundAmountList[i];
      }
      // loanAmount.value = companyProfileData.maxFundAmount ?? ''.replaceAll(RegExp('[^0-9]'), "");
    }*/

    ///Maximum Term Length
    for (int i = 0; i < maxTermLengthList.length; i++) {
      if (maxTermLengthList[i].id == companyProfileData.maxTermLength) {
        maxTermLengthListModel.value = maxTermLengthList[i];
      }
    }

    ///starting Buy Rates
    for (int i = 0; i < buyingRateList.length; i++) {
      if (buyingRateList[i].id == companyProfileData.buyingRates) {
        startingBuyRatesListModel.value = buyingRateList[i];
      }
    }

    ///Max Upsell Points
    for (int i = 0; i < maxUpSellList.length; i++) {
      if (maxUpSellList[i].id == companyProfileData.maxUpsellPoints) {
        maxUpSellPointsListModel.value = maxUpSellList[i];
      }
    }
    ShowLoaderDialog.dismissLoaderDialog();
  }
}
