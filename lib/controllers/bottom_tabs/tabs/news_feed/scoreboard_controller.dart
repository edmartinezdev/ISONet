import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:tuple/tuple.dart';

import '../../../../helper_manager/network_manager/api_const.dart';
import '../../../../helper_manager/network_manager/remote_service.dart';
import '../../../../model/bottom_navigation_models/news_feed_models/loan_list_model.dart';
import '../../../../model/bottom_navigation_models/search_model/global_search_model.dart';
import '../../../../model/dropdown_models/loan_preferences_models.dart';
import '../../../../model/response_model/responese_datamodel.dart';
import '../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../utils/validation/validation.dart';

class ScoreBoardController extends GetxController {
  ScrollController scrollController = ScrollController();
  var currentPageIndex = 0.obs;
  var forumFilter = 'FU'.obs;
  RxList<TabFilterList> tabFilterList = <TabFilterList>[
    TabFilterList(
      tabName: 'Funders',
      apiFilterName: 'FU',
    ),
    TabFilterList(tabName: 'Brokers', apiFilterName: 'BR'),
  ].obs;
  var loanList = <LoanData>[].obs;
  var loanTagDetails = <TagDetails>[].obs;
  var pageLimitPagination = 5.obs;
  var pageToShow = 1.obs;
  var isAllDataLoaded = false.obs;
  var filterScoreBoardList = <FilterScoreBoard>[].obs;
  var sortingType = ''.obs;
  var scoreSortingData = ''.obs;
  var isFilterEnable = false.obs;
  var totalRecord = 0.obs;
  Rxn<GetAllIndustryListModel> getIndustryModel = Rxn();

  /// Loan Tag Details
  var strList = List.generate(2, (index) => '').obs;
  var searchLoanList = <TagDetails>[].obs;
  var getAllLoanList = <TagDetails>[].obs;
  var selectedPrefLoanChipList = <TagDetails>[].obs;
  var prefLoanList = <int>[].obs;

  /// Get Industry details
  var getAllIndustryList = <GetAllIndustryListModel>[].obs;
  var searchResIndustryList = <GetAllIndustryListModel>[].obs;
  var selectedResIndustryChipList = <GetAllIndustryListModel>[].obs;
  var resIndustryList = <int>[].obs;

  var isEnabled = false.obs;
  var loanAmount = ''.obs;
  var loanIndustry = ''.obs;
  var loanIndustryId = 0.obs;
  var funderBrokerId = 0.obs;
  var isScoreboardListLoaded = false.obs;

  var totalRecords = 0.obs;
  var searchText = ''.obs;
  var userType = ''.obs;

  // var searchFeedCategoryList = <GlobalSearchData>[].obs;
  // var feedCategoryList = <GlobalSearchData>[].obs;
  var selectedFunderBrokerName = ''.obs;
  var selectedFunderBrokerImage = ''.obs;
  Rxn selectedCategoryId = Rxn();
  var searchListController = <GlobalSearchData>[].obs;
  var isLoadMoreRunningForViewAll = false;


  @override
  void onInit() {
    filterScoreBoardList.value = [
      FilterScoreBoard(scoreboardSortingData: 'Daily', apiScoreBoardParam: 'daily'),
      FilterScoreBoard(scoreboardSortingData: 'Weekly', apiScoreBoardParam: 'weekly'),
      FilterScoreBoard(scoreboardSortingData: 'Monthly', apiScoreBoardParam: 'monthly'),
      FilterScoreBoard(scoreboardSortingData: 'Yearly', apiScoreBoardParam: 'yearly'),
      FilterScoreBoard(scoreboardSortingData: 'All Time', apiScoreBoardParam: 'all_time'),
    ];
    if (filterScoreBoardList.isNotEmpty) {
      filterScoreBoardList[0].isFilterSelected.value = true;
      scoreSortingData.value = filterScoreBoardList[0].scoreboardSortingData ?? '';
      sortingType.value = filterScoreBoardList[0].apiScoreBoardParam ?? '';
    }
    super.onInit();
  }

  onFilterScoreBoardSelect({required int index}) {
    loanList.clear();
    filterScoreBoardList.value = filterScoreBoardList.map((e) {
      e.isFilterSelected.value = false;

      return e;
    }).toList();
    filterScoreBoardList[index].isFilterSelected.value = true;
    sortingType.value = filterScoreBoardList[index].apiScoreBoardParam ?? '';
    scoreSortingData.value = filterScoreBoardList[index].scoreboardSortingData ?? '';
  }

  /// Fetch Loan list for Funder and Broker
  fetchLoanList({required int page, required String userType, List<int>? selectedIndustryList, List<int>? selectedLoanList,bool isShowLoader = false}) async {
    Map<String, dynamic> params = {};
    params["start"] = loanList.length;
    params["limit"] = defaultFetchLimit;
    params["user_type"] = userType;
    params["sort_by"] = sortingType.value;
    selectedIndustryList?.length != null ? params['industries'] = selectedIndustryList : null;
    selectedLoanList?.length != null ? params['tags'] = selectedLoanList : null;

    ResponseModel<LoanListModel> response = await sharedServiceManager.uploadRequest(ApiType.loanList, params: params);
    if(isShowLoader){
      ShowLoaderDialog.dismissLoaderDialog();
    }
    isScoreboardListLoaded.value = true;
    if (response.status == ApiConstant.statusCodeSuccess) {
      totalRecord.value = response.data?.totalRecord ?? 0;
      if (loanList.isEmpty) {
        loanList.value = response.data?.loanData ?? [];
      } else {
        loanList.addAll(response.data?.loanData ?? []);
      }
      isAllDataLoaded.value = (loanList.length < (response.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
      return true;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
      return false;
    }
  }

  ///pagination loader for funder/broker screen
  paginationLoadData() {
    if (loanList.length.toString() == totalRecord.value.toString()) {
      return true;
    } else {
      return false;
    }
  }

  scoreBoardPagination() {
    pageToShow.value++;
    Logger().i(pageToShow.value);
    fetchLoanList(page: pageToShow.value, userType: forumFilter.value);
  }

  Tuple2<bool, String> isValidFunderBroker() {
    List<Tuple2<ValidationType, String>> arrList = [];
    arrList.add(Tuple2(ValidationType.funderBrokerName, selectedFunderBrokerName.value));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);
    return Tuple2(validationResult.item1, validationResult.item2);
  }

  Tuple2<bool, String> isValidLoanFilter() {
    List<Tuple2<ValidationType, String>> arrList = [];
    arrList.add(Tuple2(ValidationType.addIndustries, (resIndustryList).toString()));
    arrList.add(Tuple2(ValidationType.addTagScoreBoard, (prefLoanList).toString()));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);
    return Tuple2(validationResult.item1, validationResult.item2);
  }
}

class TabFilterList {
  String? tabName;
  String? apiFilterName;

  TabFilterList({this.tabName, this.apiFilterName});
}

class FilterScoreBoard {
  String? scoreboardSortingData;
  String? apiScoreBoardParam;
  RxBool isFilterSelected = false.obs;

  FilterScoreBoard({this.scoreboardSortingData, this.apiScoreBoardParam});
}
