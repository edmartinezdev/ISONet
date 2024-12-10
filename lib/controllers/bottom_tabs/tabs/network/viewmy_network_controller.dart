import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/bottom_navigation_models/network_model/viewmy_network_model.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';

import '../../../../helper_manager/network_manager/api_const.dart';
import '../../../../utils/app_common_stuffs/app_logger.dart';

class ViewMyNetworkController extends GetxController {
  var myNetworkList = <NetworkData>[].obs;
  var pageToShow = 1.obs;
  var pageLimitation = 20.obs;
  var totalRecord = 0.obs;
  var isAllDataLoaded = false.obs;
  var isSearchEnable = false.obs;
  var searchText = ''.obs;
  ScrollController scrollController = ScrollController();
  var roomName = ''.obs;
  var isDataLoad = false.obs;
  var isLoadMoreRunningForViewAll = false;
  var isApiResponseReceive = false.obs;
  var isTotalRecord = false.obs;

  ///My Network api call function
  getMyNetworkApi({required int pageToShow , bool isShowLoader = false}) async {
    Map<String, dynamic> params = {};
    params['start'] = myNetworkList.length;
    params['limit'] = defaultFetchLimit;
    params['query'] = searchText.value;
    ResponseModel<ViewMyNetworkModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.viewMyNetworkApi, params: params);
    if (isShowLoader) {
      ShowLoaderDialog.dismissLoaderDialog();
    }
    isDataLoad.value = true;
    isApiResponseReceive.value = true;
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      totalRecord.value = responseModel.data?.totalRecord ?? 0;
      if (totalRecord.value != 0) {
        isTotalRecord.value = true;
      } else {
        isTotalRecord.value = false;
      }
      if (myNetworkList.isEmpty) {
        myNetworkList.value = responseModel.data?.networkData ?? [];
      } else {
        myNetworkList.addAll(responseModel.data?.networkData ?? []);
      }
      isAllDataLoaded.value = (myNetworkList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
    }
  }

  ///View my network pagination
  viewMyNetworkPagination() {
    pageToShow.value++;
    Logger().i(pageToShow.value);
    getMyNetworkApi(pageToShow: pageToShow.value,isShowLoader: false);
  }

  ///Pagination Load Data
  paginationLoadData() {
    if (myNetworkList.length.toString() == totalRecord.value.toString()) {
      return true;
    } else {
      return false;
    }
  }
}
