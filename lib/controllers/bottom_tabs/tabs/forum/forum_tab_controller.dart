import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/bottom_navigation_models/forum_models/forum_list_model.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';

import '../../../../helper_manager/network_manager/api_const.dart';
import '../../../../model/bottom_navigation_models/news_feed_models/feed_category_model.dart';
import '../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../utils/app_common_stuffs/common_api_function.dart';

class ForumController extends GetxController {
  ///***** Variables declaration ******///
  var totalRecord = 0.obs;
  var pageToShow = 1.obs;
  var pageForCategory = 1.obs;

  var forumList = <ForumData>[].obs;
  var isAllDataLoaded = false.obs;
  var currentPageIndex = 1.obs;
  var isForumListLoaded = false.obs;
  var forumFilter = 'recent'.obs;

  var isLoadMoreRunningForViewAll = false;
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController();
  var isAllDataLoadedCategory = false.obs;
  var isLoadMoreRunningForViewAllCategory = false;
  var isApiResponseReceive = false.obs;
  var isForumRefresh = false.obs;

  /// Forum tab list [tabFilterList]
  RxList<TabFilterList> tabFilterList = <TabFilterList>[
    TabFilterList(tabName: 'Popular', apiFilterName: 'popular'),
    TabFilterList(tabName: 'Most Recent', apiFilterName: 'recent'),
    TabFilterList(tabName: 'Recommended', apiFilterName: 'recommended'),
  ].obs;

  Rxn<FeedCategoryModel> categoryModel = Rxn();
  var categoryList = <FeedCategoryList>[].obs;

  ///*******************************************

  ///Fetch Forum List Api Function
  forumApiCall({bool isShowLoader = false}) async {
    Map<String, dynamic> params = {};
    params['start'] = isForumRefresh.value ? 0 : forumList.length;
    params['limit'] = defaultFetchLimit;
    params['forum_filter'] = forumFilter.value;
    ResponseModel<ForumListModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.forumList, params: params);
    if (isShowLoader) {
      ShowLoaderDialog.dismissLoaderDialog();
    }
    if (isForumRefresh.value) {
      forumList.clear();
      totalRecord.value = 0;
      isAllDataLoaded.value = false;
      isForumRefresh.value = false;
    }
    isForumListLoaded.value = true;
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      totalRecord.value = responseModel.data?.totalRecord ?? 0;
      isApiResponseReceive.value = true;
      if (forumList.isEmpty) {
        forumList.value = responseModel.data?.forumDataList ?? [];
      } else {
        forumList.addAll(responseModel.data?.forumDataList ?? []);
      }
      isAllDataLoaded.value = (forumList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  ///Pagination of Forum List
  forumPagination() {
    pageToShow.value++;
    Logger().i(pageToShow.value);
    forumApiCall();
  }

  ///Pagination of Forum List
  forumCategoryPagination() {
    pageForCategory.value++;
    Logger().i(pageForCategory.value);
    fetchFeedCategory();
  }

  ///******Forum Like Event handle function*****////
  handleUpArrowTap({required int index}) async {
    if (forumList[index].isLikeForum.value == false) {
      await CommonApiFunction.likeForumApi(
        forumId: forumList[index].forumId ?? 0,
        onSuccess: (likeCount) {
          forumList[index].likeCount.value = likeCount[0];
          forumList[index].disLikeCount.value = likeCount[1];
          forumList[index].isLikeForum.value = true;
          forumList[index].isUnlikeForum.value = false;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
        },
      );
    }
  }

  ///******Forum DisLike Event handle function*****////
  handleDownArrowTap({required int index}) async {
    if (forumList[index].isUnlikeForum.value == false) {
      await CommonApiFunction.unlikeForumApi(
        forumId: forumList[index].forumId ?? 0,
        onSuccess: (disLikeCount) {
          forumList[index].likeCount.value = disLikeCount[0];
          forumList[index].disLikeCount.value = disLikeCount[1];
          forumList[index].isLikeForum.value = false;
          forumList[index].isUnlikeForum.value = true;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
        },
      );
    }
  }

  ///***** Forum Report handle function ******///
  handleForumReport({required int index}) async {
    await CommonApiFunction.flagForumApi(
      forumId: forumList[index].forumId ?? 0,
      onError: (msg) {
        SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
        Get.back();
      },
    );
  }

  ///Forum Category api function *******///
  fetchFeedCategory() async {
    Map<String, dynamic> params = {};
    params['start'] = isForumRefresh.value ? 0 : categoryList.length;
    params['limit'] = defaultFetchLimit;
    ResponseModel<FeedCategoryModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.feeCategoryList, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      if (isForumRefresh.value) {
        categoryList.clear();
      }
      categoryModel.value = responseModel.data;
      if (categoryList.isEmpty) {
        categoryList.value = categoryModel.value?.feedCategoryList ?? [];
      } else {
        categoryList.addAll(categoryModel.value?.feedCategoryList ?? []);
      }
      isAllDataLoadedCategory.value = (categoryList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAllCategory = false;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

/*@override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowLoaderDialog.showLoaderDialog(Get.context!);
      fetchFeedCategory(page: pageForCategory.value);
      forumApiCall(pageToShow: pageToShow.value, isShowLoader: true);
    });

    super.onInit();
  }*/
}

///*****[TabFilterList] this class is use for 3 forum type tab
///[Popular,Most Recent , Recommended] currently there's 3 type of of forum tab in forum_tab screen ******///
class TabFilterList {
  String? tabName;
  String? apiFilterName;

  TabFilterList({this.tabName, this.apiFilterName});
}
