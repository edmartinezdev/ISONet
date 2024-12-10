import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';

import '../../helper_manager/network_manager/api_const.dart';
import '../../helper_manager/network_manager/remote_service.dart';
import '../../model/bottom_navigation_models/news_feed_models/feed_list_model.dart';
import '../../model/bottom_navigation_models/news_feed_models/specific_userfeed_model.dart';
import '../../model/response_model/responese_datamodel.dart';
import '../../utils/app_common_stuffs/app_logger.dart';

class MyAllFeedController extends GetxController{
  var userId = Get.arguments;
  var myAllFeedList = <FeedData>[].obs;
  PageController pageController = PageController();
  ScrollController scrollController = ScrollController();
  var pageLimitPagination = 5.obs;
  var pageToShow = 1.obs;
  var isAllDataLoaded = false.obs;
  bool isLoadMore = false;
  var totalRecord = 0.obs;
  var isLoadMoreRunningForViewAllCategory = false;

  ///MyFeed list api call
  myFeedApiCall({required int pageToShow}) async {
    Map<String, dynamic> params = {};
    params['limit'] = defaultFetchLimit;
    params['start'] = myAllFeedList.length;
    params['user_id'] = userId;

    ResponseModel<UserProfileFeedModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.userProfileFeed, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      totalRecord.value = responseModel.data?.totalRecord ?? 0;
      if (myAllFeedList.isEmpty) {
        myAllFeedList.value = responseModel.data?.userFeedList ?? [];
      } else {
        myAllFeedList.addAll(responseModel.data?.userFeedList ?? []);
      }
      isAllDataLoaded.value = (myAllFeedList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAllCategory = false;
    }
  }

  ///MyFeed pagination
  feedPagination() {
    pageToShow.value++;
    Logger().i(pageToShow.value);

    myFeedApiCall(pageToShow: pageToShow.value);
  }

  ///pagination loader
  paginationLoadData() {
    if (myAllFeedList.length.toString() == totalRecord.value.toString()) {
      isAllDataLoaded.value = true;
      isLoadMore = isAllDataLoaded.value;
      Logger().i(isLoadMore);
      return true;
    } else {
      isAllDataLoaded.value = false;
      isLoadMore = isAllDataLoaded.value;
      Logger().i(isLoadMore);
      return false;
    }
  }
}