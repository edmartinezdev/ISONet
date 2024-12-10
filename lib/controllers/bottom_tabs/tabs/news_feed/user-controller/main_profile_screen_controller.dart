import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';

import '../../../../../helper_manager/network_manager/api_const.dart';
import '../../../../../helper_manager/network_manager/remote_service.dart';
import '../../../../../model/bottom_navigation_models/news_feed_models/my_feed_profile_list.dart';
import '../../../../../model/bottom_navigation_models/news_feed_models/my_loan_list_model.dart';
import '../../../../../model/response_model/responese_datamodel.dart';
import '../../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../../utils/app_common_stuffs/snackbar_util.dart';


class MainScreenProfileController extends GetxController {

  var currentPageIndex = 0.obs;
  var pageToShow = 1.obs;
  var isAllDataLoaded = false.obs;
  var tabName = 'Feed'.obs;
  var currentIndex = 0.obs;
  var myLoanList = <UserLoanList>[].obs;
  var myFeedList = <UserFeedListData>[].obs;
  var pageLimitPagination = 5.obs;
  var totalRecord = 0.obs;
  PageController pageController = PageController();
  ScrollController scrollController = ScrollController();

  RxList<TabFilterList> tabFilterList = <TabFilterList>[
    TabFilterList(tabName:'Feed', apiFilterName: 'feed'),
    TabFilterList(tabName: 'My Loans', apiFilterName: 'myLoans'),
  ].obs;

  fetchMyLoanList({required int page}) async {

    Map<String, dynamic> params = {};
    params["page"] = page;
    params["limit"] = defaultFetchLimit;

    ResponseModel<MyLoanListModel> response = await sharedServiceManager.createPostRequest(
        typeOfEndPoint: ApiType.myLoanList, params: params,
    );
    if (response.status == ApiConstant.statusCodeSuccess) {
      totalRecord.value = response.data?.totalRecord ?? 0;
      if(myLoanList.isEmpty){
        myLoanList.value = response.data?.userLoanList ?? [];
      } else {
        myLoanList.addAll(response.data?.userLoanList ?? []);
      }
      return true;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
      return false;
    }
  }

  fetchMyFeedList({required int page}) async {

    Map<String, dynamic> params = {};
    params["page"] = page;
    params["limit"] = defaultFetchLimit;
    params["user_id"] = userSingleton.id;

    ResponseModel<MyFeedProfileList> response = await sharedServiceManager.createPostRequest(
        typeOfEndPoint: ApiType.myFeedList, params: params,
    );
    if (response.status == ApiConstant.statusCodeSuccess) {
      totalRecord.value = response.data?.totalRecord ?? 0;
      if(myFeedList.isEmpty){
        myFeedList.value = response.data?.userFeedList ?? [];
      } else {
        myFeedList.addAll(response.data?.userFeedList ?? []);
      }
      return true;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
      return false;
    }
  }

  ///pagination loader for feed/myLoanList screen
  paginationLoadData() {
    if (myLoanList.length.toString() == totalRecord.value.toString()) {
      return true;
    } else {
      return false;
    }
  }

  myFeedListPagination(){
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        if (myFeedList.length != totalRecord.value && isAllDataLoaded.isFalse) {
          pageToShow.value++;
          Logger().i(pageToShow.value);
          fetchMyFeedList(page: pageToShow.value);
        } else {
          isAllDataLoaded.value = true;
          Logger().i('All Data Loaded');
        }
      }
    });
  }
}

class TabFilterList{
  String? tabName;
  String? apiFilterName;
  TabFilterList({this.tabName,this.apiFilterName});
}