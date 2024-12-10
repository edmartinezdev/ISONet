import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';

import '../../../../helper_manager/network_manager/api_const.dart';
import '../../../../helper_manager/network_manager/remote_service.dart';
import '../../../../model/bottom_navigation_models/network_model/network_tab_model.dart';
import '../../../../model/bottom_navigation_models/network_model/pending_suggetsion_request_model.dart';
import '../../../../model/response_model/responese_datamodel.dart';
import '../../../../ui/style/showloader_component.dart';
import '../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../utils/app_common_stuffs/snackbar_util.dart';

class ViewAllSuggestionController extends GetxController{
  var suggestionList = <ConnectionSuggestion>[].obs;
  var totalSuggestionRecord = 0.obs;
  var isAllSuggestionDataLoaded = false.obs;
  var pageOfSuggestionToShow = 1.obs;
  var pageOfSuggestionLimitation = 15.obs;
  ScrollController suggestionScrollController = ScrollController();
  var isLoadMoreRunningForViewAll = false;
  var isLoaderShow = true.obs;


  ///ViewAll Request Pagination
  viewAllSuggestionPagination() {
    pageOfSuggestionToShow.value++;
    Logger().i(pageOfSuggestionToShow.value);
    viewAllSuggestionApiCall(pageOfSuggestionToShow: pageOfSuggestionToShow.value);
  }

  ///pagination all data loaded
  paginationSuggestionLoadData() {
    if (suggestionList.length.toString() == totalSuggestionRecord.value.toString()) {
      return true;
    } else {
      return false;
    }
  }



  ///View all suggestion request list api call
  viewAllSuggestionApiCall({required int pageOfSuggestionToShow}) async {
    Map<String, dynamic> params = {};
    params['limit'] = defaultFetchLimit;
    params['start'] = suggestionList.length;
    ResponseModel<ConnectionSuggestionModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.connectSuggestionApi, params: params);
    if(isLoaderShow.value){
      ShowLoaderDialog.dismissLoaderDialog();
    }

    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      totalSuggestionRecord.value = responseModel.data?.totalRecord ?? 0;
      if (suggestionList.isEmpty) {
        suggestionList.value = responseModel.data?.connectionSuggestionList ?? [];
      } else {
        suggestionList.addAll(responseModel.data?.connectionSuggestionList ?? []);
      }
      isAllSuggestionDataLoaded.value = (suggestionList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }
}