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

class EmployeeProfileController extends GetxController {
  //User employeeData = Get.arguments;
  var totalFeedRecord = 0.obs;

  Rxn<UserProfileData> employeeProfileData = Rxn();
  var employeeProfileFeedList = <FeedData>[].obs;
  var employeeAllFeedList = <FeedData>[].obs;
  PageController pageController = PageController();
  var pageLimitPagination = 5.obs;
  var slidingPageIndicatorIndex = 0.obs;
  var pageToShow = 1.obs;
  var isEmployeeProfileLoad = false.obs;
  var isLoadMoreRunningForViewAll = false;

  var isAllDataLoaded = false.obs;
  ScrollController scrollController = ScrollController();

  ///Employee Profile Api Call
  employeeProfileApiCall({required int employeeId}) async {
    Map<String, dynamic> params = {};
    params['user_id'] = employeeId;

    ResponseModel<UserProfileData> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.userProfile, params: params);
    ShowLoaderDialog.dismissLoaderDialog();
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      isEmployeeProfileLoad.value = true;
      employeeProfileData.value = responseModel.data;
      employeeProfileFeedList.value = responseModel.data?.userFeedList ?? [];
      if (employeeProfileData.value?.isBlockByYou == true) {
        CommonUtils.unBlockUserDialog(
            userId: employeeId,
            userName: '${employeeProfileData.value?.firstName ?? ''} ${employeeProfileData.value?.lastName ?? ''}',
            context: Get.context!,
            apiMessage: '${AppStrings.alreadyBlockMessage} ${employeeProfileData.value?.firstName ?? ''} ${employeeProfileData.value?.lastName ?? ''}.',
            onSuccess: (msg) {
              ShowLoaderDialog.showLoaderDialog(Get.context!);

              employeeProfileApiCall(employeeId: employeeId);
            });
      }
    } else {
      isEmployeeProfileLoad.value = false;
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  feedPagination() {
    pageToShow.value++;
    Logger().i(pageToShow.value);
    employeeFeedApiCall(page: pageToShow.value);
  }

  ///get employee feed list
  employeeFeedApiCall({
    required int page,
  }) async {
    Map<String, dynamic> params = {};
    params['user_id'] = employeeProfileData.value?.userId;
    params['start'] = employeeAllFeedList.length;
    params['limit'] = defaultFetchLimit;

    ResponseModel<UserProfileFeedModel> response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.userProfileFeed, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      totalFeedRecord.value = response.data?.totalRecord ?? 0;
      if (employeeAllFeedList.isEmpty) {
        employeeAllFeedList.value = response.data?.userFeedList ?? [];
      } else {
        employeeAllFeedList.addAll(response.data?.userFeedList ?? []);
      }
      isAllDataLoaded.value = (employeeAllFeedList.length < (response.data?.totalRecord ?? 0)) ? true : false;
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
    if (employeeAllFeedList.length.toString() == totalFeedRecord.value.toString()) {
      return true;
    } else {
      return false;
    }
  }
}
