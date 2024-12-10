import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/scoreboard_controller.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/extensions/string_extensions.dart';
import 'package:tuple/tuple.dart';

import '../../../../helper_manager/network_manager/api_const.dart';
import '../../../../helper_manager/network_manager/remote_service.dart';
import '../../../../model/bottom_navigation_models/news_feed_models/loan_list_model.dart';
import '../../../../model/bottom_navigation_models/search_model/global_search_model.dart';
import '../../../../model/dropdown_models/loan_preferences_models.dart';
import '../../../../model/response_model/responese_datamodel.dart';
import '../../../../ui/style/showloader_component.dart';
import '../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../utils/validation/validation.dart';

class CreateScoreBoardController extends GetxController {
  ScrollController scrollController = ScrollController();
  var searchListController = <GlobalForumFeedArticle>[].obs;
  var forumFilter = 'FU'.obs;
  var pageLimitPagination = 6.obs;
  var pageToShow = 1.obs;
  var totalRecords = 0.obs;
  var isAllDataLoaded = false.obs;
  var searchText = ''.obs;
  var userType = ''.obs;
  var isFilterEnable = false.obs;

  // var searchFeedCategoryList = <GlobalSearchData>[].obs;
  // var feedCategoryList = <GlobalSearchData>[].obs;
  var selectedIndustryName = ''.obs;
  var selectedIndustryImage = ''.obs;
  Rxn selectedCategoryId = Rxn();
  var searchLoanList = <TagDetails>[].obs;

  var currentPageIndex = 0.obs;

  var loanList = <LoanData>[].obs;
  var loanTagDetails = <TagDetails>[].obs;

  var filterScoreBoardList = <FilterScoreBoard>[].obs;
  var sortingType = ''.obs;
  var scoreSortingData = ''.obs;

  var totalRecord = 0.obs;
  Rxn<GetAllIndustryListModel> getIndustryModel = Rxn();

  /// Loan Tag Details
  var strList = List.generate(2, (index) => '').obs;

  var getAllLoanList = <TagDetails>[].obs;
  var selectedPrefLoanChipList = <TagDetails>[].obs;
  var prefLoanList = <int>[].obs;

  /// Get Industry details
  var getAllIndustryList = <GetAllIndustryListModel>[].obs;
  var searchResIndustryList = <GetAllIndustryListModel>[].obs;
  var selectedResIndustryChipList = <GetAllIndustryListModel>[].obs;
  var resIndustryList = <int>[].obs;

  var isEnabled = false.obs;
  var isEnableButton = false.obs;
  var loanAmount = ''.obs;
  var loanIndustry = ''.obs;
  var loanIndustryId = 0.obs;
  var funderBrokerId = 0.obs;
  var isScoreboardListLoaded = false.obs;

  // var searchFeedCategoryList = <GlobalSearchData>[].obs;
  // var feedCategoryList = <GlobalSearchData>[].obs;
  var selectedFunderBrokerName = ''.obs;
  var selectedFunderBrokerImage = ''.obs;
  var isLoadMoreRunningForViewAll = false;
  var isCompanyLoan = false.obs;
  var isDataLoaded = false.obs;
  var isSearching = false.obs;


  ///Search Pagination
  searchPagination() {
    brokerFunderListApiCall();
  }

  ///pagination loader
  paginationLoadData() {
    if (searchListController.length.toString() == totalRecords.value.toString()) {
      return true;
    } else {
      return false;
    }
  }

  ///Search Api Call Function
  brokerFunderListApiCall() async {
    Map<String, dynamic> params = {};
    params['query'] = searchText.value;
    params['limit'] = defaultFetchLimit;
    params['start'] = searchListController.length;
    params['user_type'] = userSingleton.userType == 'FU' ? 'BROKER_AND_COMPANY' : 'FUNDER_AND_COMPANY';
    ResponseModel<GlobalSearch> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.loanSearch, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      totalRecords.value = responseModel.data?.totalRecord ?? 0;
      if (totalRecords.value != 0) {
        isDataLoaded.value = true;
      } else {
        isDataLoaded.value = false;
      }
      isSearching.value = false;

      if (searchListController.isEmpty) {
        searchListController.value = responseModel.data?.globalForumFeedArticle ?? [];
      } else {
        searchListController.addAll(responseModel.data?.globalForumFeedArticle ?? []);
      }

      isAllDataLoaded.value = (searchListController.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  onSearch(String search) {
    searchListController.value = searchListController
        .where(
          (e) => e.globalSearchData!.firstName!.toLowerCase().contains(
                search.toLowerCase(),
              ),
        )
        .toList();
    if (kDebugMode) {
      print(search);
    }
  }

  //////////////////////////////

  ///load searchable dropdown list
  loadDropdownTempListsForSearch() {
    searchLoanList.value = getAllLoanList;
    searchResIndustryList.value = getAllIndustryList;
  }

  ///check box select - unselect
  checkBoxPrefLoan(int index, bool value) {
    searchLoanList[index].isPrefIndustryChecked.value = value;
    if (searchLoanList[index].isPrefIndustryChecked.value == true) {
      selectedPrefLoanChipList.add(searchLoanList[index]);
      prefLoanList.add(searchLoanList[index].id ?? 0);
      Logger().i(prefLoanList);
      validateFilterButton();
      validateButton();
    } else {
      selectedPrefLoanChipList.remove(searchLoanList[index]);
      prefLoanList.remove(searchLoanList[index].id ?? 0);
      Logger().i('PrefLoanList ======> $prefLoanList');
      validateFilterButton();
      validateButton();
    }
  }

  ///on search for pref industries
  onPrefIndSearch(String search) {
    searchLoanList.value = getAllLoanList.where((e) => e.tagName!.toLowerCase().contains(search.toLowerCase())).toList();
    Logger().i(search);
  }

  ///on search for res industries
  onRestrictedIndSearch(String search) {
    searchResIndustryList.value = getAllIndustryList.where((e) => e.industryName!.toLowerCase().contains(search.toLowerCase())).toList();
    Logger().i(search);
  }

  ///check box select - unselect
  checkBoxResIndustry(int index, bool value) {
    searchResIndustryList[index].isResIndustryChecked.value = value;
    if (searchResIndustryList[index].isResIndustryChecked.value == true) {
      selectedResIndustryChipList.add(searchResIndustryList[index]);
      resIndustryList.add(searchResIndustryList[index].id ?? 0);
      Logger().i(resIndustryList);
      validateFilterButton();
    } else {
      selectedResIndustryChipList.remove(searchResIndustryList[index]);
      resIndustryList.remove(searchResIndustryList[index].id ?? 0);
      Logger().i(resIndustryList);
      validateFilterButton();
    }
  }

  /// Loan Tag Scoreboard list api
  loanTagList() async {
    Map<String, dynamic> params = {};

    ResponseModel<List<TagDetails>> response = await sharedServiceManager.createGetRequest(params: params, typeOfEndPoint: ApiType.scoreboardTagList);

    if (response.status == ApiConstant.statusCodeSuccess) {
      getAllLoanList.value = response.data ?? [];
      //searchLoanList.value = loanTagDetails.value;

      //loanTagDetails.addAll(response.data?.tagDetails ?? []);

      return true;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
      return false;
    }
  }

  /// Get Industry scoreboard list api
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

  /// Create Loan details Submit Button action
  submitLoanDetailsAPICall() async {
    Map<String, dynamic> params = {};
    params["loan_amount"] = loanAmount.value.replaceSpaceAndComma();
    params["loan_industries"] = loanIndustryId.value;
    isCompanyLoan.value ? params["company_for_loan"] = funderBrokerId.value : params["funder_or_broker_name"] = funderBrokerId.value;
    params["select_tag"] = prefLoanList;
    params['is_loan_for_a_company'] = isCompanyLoan.value ? 'True' : 'False';

    ResponseModel<ResponseModel> response = await sharedServiceManager.uploadRequest(params: params, ApiType.createLoan);

    ShowLoaderDialog.dismissLoaderDialog();

    if (response.status == ApiConstant.statusCodeSuccess || response.status == ApiConstant.statusCodeCreated) {
      Get.back(result: true);
      searchLoanList.clear();
      getAllLoanList.clear();
      selectedPrefLoanChipList.clear();
      prefLoanList.clear();
      return true;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
      return false;
    }
  }

  ///******* button enable disable validation *******
  validateButton() {
    if (loanAmount.value.isNotEmpty &&
        //(" ${loanIndustry.value}").isNotEmpty
        (getIndustryModel.value?.industryName ?? '').isNotEmpty
        //&& (" ${resIndustryList.length}").isNotEmpty
        &&
        selectedFunderBrokerName.value.isNotEmpty &&
        prefLoanList.isNotEmpty) {
      isEnableButton.value = true;
    } else {
      isEnableButton.value = false;
    }
  }

  ///aa levani
  Tuple2<bool, String> isValidLoanPref() {
    List<Tuple2<ValidationType, String>> arrList = [];
    //arrList.add(Tuple2(ValidationType.resIndustries, (prefLoanList).toString()));
    arrList.add(Tuple2(ValidationType.loanAmount, loanAmount.value));
    arrList.add(Tuple2(ValidationType.loanIndustry, (getIndustryModel.value?.industryName ?? '').toString()));
    arrList.add(Tuple2(ValidationType.funderBrokerName, selectedFunderBrokerName.value));
    arrList.add(Tuple2(ValidationType.addTagScoreBoard, (prefLoanList).toString()));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);
    return Tuple2(validationResult.item1, validationResult.item2);
  }

  ///*******Filter Screen Function
  validateFilterButton() {
    if (resIndustryList.isNotEmpty && prefLoanList.isNotEmpty) {
      isFilterEnable.value = true;
    } else {
      isFilterEnable.value = false;
    }
  }

  Tuple2<bool, String> isValidLoanFilter() {
    List<Tuple2<ValidationType, String>> arrList = [];
    arrList.add(Tuple2(ValidationType.addIndustries, (resIndustryList).toString()));
    arrList.add(Tuple2(ValidationType.addTagScoreBoard, (prefLoanList).toString()));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);
    return Tuple2(validationResult.item1, validationResult.item2);
  }

  /// Filter Screen Submit button action
  filterBySubmitButton({required int page}) async {
    Map<String, dynamic> params = {};
    params["industies"] = resIndustryList;
    params["tags"] = prefLoanList;
    params["user_type"] = forumFilter.value;
    params["page"] = page;
    params["limit"] = defaultFetchLimit;

    ResponseModel<LoanListModel> response = await sharedServiceManager.uploadRequest(params: params, ApiType.loanList);

    if (response.status == ApiConstant.statusCodeSuccess) {
      searchLoanList.clear();
      getAllLoanList.clear();
      selectedPrefLoanChipList.clear();
      prefLoanList.clear();
      if (loanList.isEmpty) {
        loanList.value = response.data?.loanData ?? [];
      } else {
        //loanList.addAll(response.data?.loanData ?? []);
      }
      return true;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
      return false;
    }
  }

  /// Fetch Loan list for Funder and Broker
  fetchLoanList({required int page, required String userType}) async {
    Map<String, dynamic> params = {};
    params["page"] = page;
    params["limit"] = defaultFetchLimit;
    params["user_type"] = userType;
    params["sort_by"] = sortingType.value;

    ResponseModel<LoanListModel> response = await sharedServiceManager.uploadRequest(ApiType.loanList, params: params);
    isScoreboardListLoaded.value = true;
    if (response.status == ApiConstant.statusCodeSuccess) {
      totalRecord.value = response.data?.totalRecord ?? 0;
      if (loanList.isEmpty) {
        loanList.value = response.data?.loanData ?? [];
      } else {
        loanList.addAll(response.data?.loanData ?? []);
      }
      return true;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
      return false;
    }
  }
}
