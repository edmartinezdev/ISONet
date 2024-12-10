import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';

import '../../model/bottom_navigation_models/news_feed_models/my_loan_list_model.dart';
import '../../utils/app_common_stuffs/app_logger.dart';

class MyLoanListController extends GetxController {
  var userId = Get.arguments;
  var myLoanList = <UserLoanList>[].obs;
  PageController pageController = PageController();
  ScrollController scrollController = ScrollController();
  var pageLimitPagination = 20.obs;
  var pageToShow = 1.obs;
  var isAllDataLoaded = false.obs;
  var isLoadMoreRunningForViewAllCategory = false;
  var totalRecord = 0.obs;

  ///MyFeed list api call
  myLoanApiCall({required int pageToShow,}) async {
    Map<String, dynamic> params = {};
    params['limit'] = defaultFetchLimit;
    params['page'] = myLoanList.length;
    params['user_id'] = userId;

    ResponseModel<MyLoanListModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.myLoanList, params: params);

    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      totalRecord.value = responseModel.data?.totalRecord ?? 0;
      if (myLoanList.isEmpty) {
        myLoanList.value = responseModel.data?.userLoanList ?? [];
      } else {
        myLoanList.addAll(responseModel.data?.userLoanList ?? []);
      }
      isAllDataLoaded.value = (myLoanList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAllCategory = false;
    }
  }

  ///MyLoanList pagination
  loanListPagination() {
    pageToShow.value++;
    Logger().i(pageToShow.value);
    myLoanApiCall(pageToShow: pageToShow.value);
  }

  ///pagination loader
  paginationLoadData() {
    if (myLoanList.length.toString() == totalRecord.value.toString()) {
      return true;
    } else {
      return false;
    }
  }
}
