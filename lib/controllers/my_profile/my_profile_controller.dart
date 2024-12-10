import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/feed_list_model.dart';
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/my_loan_list_model.dart';

import '../../helper_manager/network_manager/api_const.dart';
import '../../helper_manager/network_manager/remote_service.dart';
import '../../model/my_profile/my_profile_model.dart';
import '../../model/response_model/responese_datamodel.dart';
import '../../ui/style/showloader_component.dart';
import '../../utils/app_common_stuffs/snackbar_util.dart';

class MyProfileController extends GetxController {
  Rxn<MyProfileModel> myProfileData = Rxn();
  var myFeedList = <FeedData>[].obs;
  var myLoanList = <UserLoanList>[].obs;
  var userId = Get.arguments;

  var currentTabIndex = 0.obs;
  var notificationRead = false.obs;
  var isAllDataLoaded = false.obs;
  var showLoading = true.obs;
  var isScreenOpen = false.obs;
  var myProfileTab = <MyProfileTabs>[
    MyProfileTabs(tabName: 'Feed'),
    MyProfileTabs(tabName: 'My Loans'),
  ].obs;

  PageController pageController = PageController();

  ///Fetch My Profile data api function
  fetchProfileDataApi({required int userId,bool isShowLoading = false}) async {
    Map<String, dynamic> params = {};
    params['user_id'] = userId;

    ResponseModel<MyProfileModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.userProfile, params: params);

    if (isShowLoading) {
      ShowLoaderDialog.dismissLoaderDialog();
    }

    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      isAllDataLoaded.value = true;
      myProfileData.value = responseModel.data;
      notificationRead.value = responseModel.data?.isReadNotification.value ?? false;
      myFeedList.value = responseModel.data?.feedList ?? [];
      myLoanList.value = responseModel.data?.myLoanList ?? [];
    } else {
      isAllDataLoaded.value = false;
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }
}

class MyProfileTabs {
  String? tabName;
  RxBool isTabSelected = false.obs;

  MyProfileTabs({this.tabName});
}
