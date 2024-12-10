import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';

import '../../../../../model/bottom_navigation_models/news_feed_models/feed_list_model.dart';
import '../../../../../model/bottom_navigation_models/news_feed_models/specific_userfeed_model.dart';
import '../../../../../model/user_profile_model.dart';
import '../../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../../utils/app_common_stuffs/strings_constants.dart';

class UserProfileController extends GetxController {
  ///********* variables declaration ********///
  //User userData = Get.arguments;
  var id = 0.obs;
  var totalFeedRecord = 0.obs;

  Rxn<UserProfileData> userProfileData = Rxn();
  var userProfileFeedList = <FeedData>[].obs;

  var userAllFeedList = <FeedData>[].obs;
  PageController pageController = PageController();
  var pageLimitPagination = 5.obs;
  var slidingPageIndicatorIndex = 0.obs;
  var pageToShow = 1.obs;

  var isAllDataLoaded = false.obs;
  var isLoadMoreRunningForViewAll = false;

  var isUserProfileLoad = false.obs;

  ///*******************************************

  ///User Profile Api Call
  userProfileApiCall({required int userId,}) async {
    Map<String, dynamic> params = {};
    params['user_id'] = userId;

    ResponseModel<UserProfileData> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.userProfile, params: params);
    ShowLoaderDialog.dismissLoaderDialog();
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      isUserProfileLoad.value = true;
      userProfileData.value = responseModel.data;
      userProfileFeedList.value = responseModel.data?.userFeedList ?? [];
      if (userProfileData.value?.isBlockByYou == true) {
        CommonUtils.unBlockUserDialog(
          userId: userId,
          userName: '${userProfileData.value?.firstName ?? ''} ${userProfileData.value?.lastName ?? ''}',
          context: Get.context!,
          apiMessage: '${AppStrings.alreadyBlockMessage} ${userProfileData.value?.firstName ?? ''} ${userProfileData.value?.lastName ?? ''}.',
          onSuccess: (msg) {
            ShowLoaderDialog.showLoaderDialog(Get.context!);

            userProfileApiCall(userId: userId);
          },
        );
      }
    } else {
      isUserProfileLoad.value = false;
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  feedPagination() {
    pageToShow.value++;
    Logger().i(pageToShow.value);
    userFeedApiCall(page: pageToShow.value);
  }

  ///get user feed list
  userFeedApiCall({
    required int page,
    int? userId,
    String? userName,
  }) async {
    Map<String, dynamic> params = {};
    params['user_id'] = userProfileData.value?.userId;
    params['start'] = userAllFeedList.length;
    params['limit'] = pageLimitPagination.value;

    ResponseModel<UserProfileFeedModel> response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.userProfileFeed, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      totalFeedRecord.value = response.data?.totalRecord ?? 0;

      if (userAllFeedList.isEmpty || pageToShow.value == 1) {
        userAllFeedList.value = response.data?.userFeedList ?? [];
      } else {
        userAllFeedList.addAll(response.data?.userFeedList ?? []);
      }
      isAllDataLoaded.value = (userAllFeedList.length < (response.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
    }
  }

  ///like api call
  likePostApi({required String feedId, required onSuccess}) async {
    Map<String, dynamic> params = {};
    params['feed_id'] = feedId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.likePost, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      return false;
    }
  }

  ///unlike api call
  unlikePostApi({required String feedId, required onSuccess}) async {
    Map<String, dynamic> params = {};
    params['feed_id'] = feedId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.unlikePost, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      return false;
    }
  }

  ///pagination loader
  paginationLoadData() {
    if (userAllFeedList.length.toString() == totalFeedRecord.value.toString()) {
      return true;
    } else {
      return false;
    }
  }
}
