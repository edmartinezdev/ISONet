import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';

import 'package:iso_net/model/bottom_navigation_models/search_model/global_search_model.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';

import '../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../utils/app_common_stuffs/common_api_function.dart';

class SearchController extends GetxController {
  var searchFieldEnable = false.obs;
  var filterSearchList = <FilterSearch>[].obs;
  var searchListController = <GlobalSearchData>[].obs;
  var searchPostFormList = <GlobalForumFeedArticle>[].obs;
  PageController pageController = PageController();
  ScrollController scrollController = ScrollController();
  var pageLimitPagination = 6.obs;
  var pageToShow = 1.obs;
  var totalRecords = 0.obs;
  var isAllDataLoaded = false.obs;
  var searchSelectIndex = Rxn();
  var userType = 'KEYWORDS'.obs;
  var searchText = ''.obs;
  var isFilterEnable = true.obs;
  var isLoadMoreRunningForViewAll = false;
  var isDataLoaded = false.obs;
  var currentTabIndex = 0.obs;
  var isSearching = false.obs;


  onFilterSearchSelect({required int index}) async {
    filterSearchList.value = filterSearchList.map((e) {
      e.isFilterSelected.value = false;

      return e;
    }).toList();
    filterSearchList[index].isFilterSelected.value = true;
    userType.value = filterSearchList[index].apiSearchParam ?? '';
    // ignore: avoid_print
    print(filterSearchList[index].isFilterSelected.value);
    await searchApiCall();
  }

  @override
  void onInit() {
    filterSearchList.value = [
      FilterSearch(search: 'Keywords', apiSearchParam: 'KEYWORDS'),
      FilterSearch(search: 'Brokers', apiSearchParam: 'BR'),
      FilterSearch(search: 'Funders', apiSearchParam: 'FU'),
      FilterSearch(search: 'Companies', apiSearchParam: 'COMPANY'),
    ];
    super.onInit();
  }

  ///Search Pagination
  searchPagination() {
    pageToShow.value++;
    Logger().i(pageToShow.value);
    searchApiCall();
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
  searchApiCall({bool isShowLoader = false}) async {
    Map<String, dynamic> params = {};
    params['query'] = searchText.value;
    params['limit'] = defaultFetchLimit;
    params['start'] = searchPostFormList.length;
    userType.value.isEmpty ? null : params['user_type'] = userType.value;

    ResponseModel<GlobalSearch> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.searchApi, params: params);
    if (isShowLoader) {
      ShowLoaderDialog.dismissLoaderDialog();
    }

    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      totalRecords.value = responseModel.data?.totalRecord ?? 0;
      if (totalRecords.value != 0) {
        isDataLoaded.value = true;
      } else {
        isDataLoaded.value = false;
      }
      isSearching.value = false;
      if (searchPostFormList.isEmpty) {
        searchPostFormList.value = responseModel.data?.globalForumFeedArticle ?? [];

        Logger().i('Global ForumList Length :- ${searchPostFormList.length}');
        Logger().i('Global search Length :- ${searchListController.length}');
      } else {
        searchPostFormList.addAll(responseModel.data?.globalForumFeedArticle ?? []);
        Logger().i('Global ForumList Length :- ${searchPostFormList.length}');
        Logger().i('Global search Length :- ${searchListController.length}');
      }
      isAllDataLoaded.value = (searchPostFormList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  ///******Forum Like Event handle function*****////
  handleUpArrowTap({required int index}) async {

    if (searchPostFormList[index].forumData.value?.isLikeForum.value == false) {
      searchPostFormList[index].forumData.value?.likeCount.value = (searchPostFormList[index].forumData.value?.likeCount.value ?? 0) + 1;
      searchPostFormList[index].forumData.value?.isLikeForum.value = true;
      searchPostFormList[index].forumData.value?.disLikeCount.value = ( (searchPostFormList[index].forumData.value?.disLikeCount.value ?? 0) - 1) > 0 ?  (searchPostFormList[index].forumData.value?.disLikeCount.value ?? 0) - 1 : 0;
      searchPostFormList[index].forumData.value?.isUnlikeForum.value = false;
      await CommonApiFunction.likeForumApi(
        forumId: searchPostFormList[index].forumData.value?.forumId ?? 0,
        onSuccess: (likeCount) {
          searchPostFormList[index].forumData.value?.likeCount.value = likeCount[0];
          searchPostFormList[index].forumData.value?.disLikeCount.value = likeCount[1];
          searchPostFormList[index].forumData.value?.isLikeForum.value = true;
          searchPostFormList[index].forumData.value?.isUnlikeForum.value = false;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
          searchPostFormList[index].forumData.value?.likeCount.value = ((searchPostFormList[index].forumData.value?.likeCount.value ?? 0) - 1) > 0 ? (searchPostFormList[index].forumData.value?.likeCount.value ?? 0) - 1 : 0;
          searchPostFormList[index].forumData.value?.isLikeForum.value = false;
        },
      );
    }
  }

  ///******Forum DisLike Event handle function*****////
  handleDownArrowTap({required int index}) async {
    if (searchPostFormList[index].forumData.value?.isUnlikeForum.value == false) {
      searchPostFormList[index].forumData.value?.disLikeCount.value = (searchPostFormList[index].forumData.value?.disLikeCount.value ?? 0) + 1;
      searchPostFormList[index].forumData.value?.isUnlikeForum.value = true;
      searchPostFormList[index].forumData.value?.likeCount.value = ( (searchPostFormList[index].forumData.value?.likeCount.value ?? 0) - 1) > 0 ?  (searchPostFormList[index].forumData.value?.likeCount.value ?? 0) - 1 : 0;
      searchPostFormList[index].forumData.value?.isLikeForum.value = false;
      await CommonApiFunction.unlikeForumApi(
        forumId: searchPostFormList[index].forumData.value?.forumId ?? 0,
        onSuccess: (disLikeCount) {
          searchPostFormList[index].forumData.value?.likeCount.value = disLikeCount[0];
          searchPostFormList[index].forumData.value?.disLikeCount.value = disLikeCount[1];
          searchPostFormList[index].forumData.value?.isLikeForum.value = false;
          searchPostFormList[index].forumData.value?.isUnlikeForum.value = true;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
          searchPostFormList[index].forumData.value?.disLikeCount.value = ((searchPostFormList[index].forumData.value?.disLikeCount.value ?? 0) - 1) > 0 ? (searchPostFormList[index].forumData.value?.disLikeCount.value ?? 0) - 1 : 0;
          searchPostFormList[index].forumData.value?.isUnlikeForum.value = false;
        },
      );
    }
  }
}

class FilterSearch {
  String? search;
  String? apiSearchParam;
  RxBool isFilterSelected = false.obs;

  FilterSearch({this.search, this.apiSearchParam});
}
