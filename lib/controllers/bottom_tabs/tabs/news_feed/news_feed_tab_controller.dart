import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/feed_list_model.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';

import '../../../../helper_manager/firebase_notification_manager/firebase_cloud_messaging_manager.dart';
import '../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../utils/app_common_stuffs/snackbar_util.dart';

class NewsFeedController extends GetxController {
  ///********* variables declaration ********///
  RxnString profileImage = RxnString();
  var isFirstTimeLogin = false.obs;

  ScrollController scrollController = ScrollController();
  PageController pageController = PageController();
  var feedList = <FeedData>[].obs;
  var pageToShow = 1.obs;
  var isAllDataLoaded = false.obs;
  var isLoadMoreRunningForViewAll = false;
  var isApiResponseReceive = false.obs;

  var newsFeedType = ''.obs;
  var apiParam = ''.obs;
  var newFeedTypeList = <NewsFeedSelection>[].obs;
  var isNewFeedRefresh = false.obs;
  ///*******************************************///

  ///***** News Feed Pagination function *****///
  newsFeedPagination() {
    pageToShow.value++;
    Logger().i(pageToShow.value);
    apiCallFetchFeedList(page: pageToShow.value);
  }

  ///***** Fetch News Feed list api call *****///
  apiCallFetchFeedList({required int page, bool isShowLoader = false}) async {
    Logger().i('========================');
    Map<String, dynamic> requestParams = {};
    requestParams["start"] = isNewFeedRefresh.value ? 0 : feedList.length;
    requestParams["limit"] = defaultFetchLimit;
    requestParams['news_feed_type'] = apiParam.value;

    ResponseModel<FeedListModel> response = await sharedServiceManager.createPostRequest(
      typeOfEndPoint: ApiType.feedList,
      params: requestParams,
    );

    if (isShowLoader) {
      ShowLoaderDialog.dismissLoaderDialog();
    }
    if(isNewFeedRefresh.value){
      feedList.clear();
      isApiResponseReceive.value = false;
      pageToShow.value = 1;
      isAllDataLoaded.value = false;
      isNewFeedRefresh.value = false;
    }
    isApiResponseReceive.value = true;
    if (response.status == ApiConstant.statusCodeSuccess) {
      ///***** Api Success *****///
      if (feedList.isEmpty) {
        feedList.value = response.data?.feedData ?? [];
      } else {
        feedList.addAll(response.data?.feedData ?? []);
      }
      isAllDataLoaded.value = (feedList.length < (response.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
      if (FireBaseCloudMessagingWrapper().pendingNotification != null) {
        Future.delayed(const Duration(seconds: 1), () {
          FireBaseCloudMessagingWrapper().checkForPendingNotification();
        });
      }
    } else {
      ///***** Api Error *****///
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
    }
  }

  ///***** Handle newsfeed type select function *****///
  handleOnNewsFeedTypeSelect({required int index}) async {
    newFeedTypeList.value = newFeedTypeList.map((e) {
      e.isTypeSelected.value = false;

      return e;
    }).toList();
    newFeedTypeList[index].isTypeSelected.value = true;
    newsFeedType.value = newFeedTypeList[index].newsFeedType ?? '';
    apiParam.value = newFeedTypeList[index].apiParam ?? '';
    Logger().i(newFeedTypeList[index].isTypeSelected.value);
    Logger().i('Selected Feed Type Value :- ${newsFeedType.value}');

    isApiResponseReceive.value = false;
    feedList.clear();
    pageToShow.value = 1;
    isAllDataLoaded.value = false;
    Get.back();
    ShowLoaderDialog.showLoaderDialog(Get.context!);
    await apiCallFetchFeedList(page: pageToShow.value, isShowLoader: true);
  }

  @override
  void onInit() {
    /// ****** initialize newsfeed type list *****///
    newFeedTypeList.value = [
      NewsFeedSelection(newsFeedType: AppStrings.newsFeed, apiParam: 'ALL'),
      userSingleton.userType == 'FU' ? NewsFeedSelection(newsFeedType: AppStrings.funderFeed, apiParam: 'FU') : NewsFeedSelection(newsFeedType: AppStrings.brokerFeed, apiParam: 'BR'),
    ];

    ///***** Default newsfeed type is all selected *****///
    if (newFeedTypeList.isNotEmpty) {
      newFeedTypeList[0].isTypeSelected.value = true;
      newsFeedType.value = newFeedTypeList[0].newsFeedType ?? AppStrings.all;
      apiParam.value = newFeedTypeList[0].apiParam ?? 'ALL';
    }



    super.onInit();
  }
}

///*****[NewsFeedSelection] this class is use for title appbar list to select type of feed which user want to show*****/
class NewsFeedSelection {
  String? newsFeedType;
  String? apiParam;
  RxBool isTypeSelected = false.obs;

  NewsFeedSelection({this.newsFeedType, this.apiParam});
}
