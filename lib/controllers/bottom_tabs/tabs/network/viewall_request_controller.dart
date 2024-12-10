import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/model/bottom_navigation_models/network_model/pending_suggetsion_request_model.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';

import '../../../../helper_manager/network_manager/api_const.dart';
import '../../../../helper_manager/network_manager/remote_service.dart';
import '../../../../model/bottom_navigation_models/network_model/network_tab_model.dart';
import '../../../../model/response_model/responese_datamodel.dart';
import '../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../utils/app_common_stuffs/snackbar_util.dart';

class ViewAllRequestController extends GetxController {
  var requestList = <PendingRequest>[].obs;
  var totalRecord = 0.obs;
  var isAllDataLoaded = false.obs;
  var pageToShow = 1.obs;
  var pageLimitation = 15.obs;
  ScrollController scrollController = ScrollController();
  var isNetworkDataLoaded = false.obs;
  var isLoadMoreRunningForViewAll = false;

  ///ViewAll Request Pagination
  viewAllRequestPagination() {
    pageToShow.value++;
    Logger().i(pageToShow.value);
    viewAllRequestApiCall(pageToShow: pageToShow.value);
  }

  ///pagination all data loaded
  paginationLoadData() {
    if (requestList.length.toString() == totalRecord.value.toString()) {
      return true;
    } else {
      return false;
    }
  }

  ///View all pending request list api call
  viewAllRequestApiCall({required int pageToShow}) async {
    Map<String, dynamic> params = {};
    params['limit'] = defaultFetchLimit;
    params['start'] = requestList.length;
    ResponseModel<PendingRequestModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.pendingRequestApi, params: params);
    if (isNetworkDataLoaded.value == false) {
      ShowLoaderDialog.dismissLoaderDialog();
    }
    isNetworkDataLoaded.value = true;

    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      totalRecord.value = responseModel.data?.totalRecord ?? 0;
      if (requestList.isEmpty ) {
        requestList.value = responseModel.data?.pendingRequestList ?? [];
      } else {
        requestList.addAll(responseModel.data?.pendingRequestList ?? []);
      }
      isAllDataLoaded.value = (requestList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  ///Accept request api
  acceptRequestApiCall({required int requestUserId, required onErr}) async {
    isNetworkDataLoaded.value = true;
    Map<String, dynamic> params = {};
    params['requested_user'] = requestUserId;
    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.acceptRequest, params: params);

    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      isNetworkDataLoaded.value = true;
      //viewAllRequestApiCall(pageToShow: pageToShow.value);

      return true;
    } else {
      onErr(responseModel.message);
      return false;
    }
  }

  ///Cancel request api
  cancelRequestApiCall({required int requestUserId, required onErr}) async {
    isNetworkDataLoaded.value = true;
    Map<String, dynamic> params = {};
    params['requested_user'] = requestUserId;
    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.cancelRequest, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      isNetworkDataLoaded.value = true;
      //viewAllRequestApiCall(pageToShow: pageToShow.value);
      return true;
    } else {
      onErr(responseModel.message);
      return false;
    }
  }
}
