import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/company_profile_model.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';

import '../../../../../model/bottom_navigation_models/news_feed_models/feed_list_model.dart';
import '../../../../../utils/app_common_stuffs/app_logger.dart';

class CompanyEmployeeListController extends GetxController {
  var totalRecord = 0.obs;
  var companyEmployeeList = <User>[].obs;

  //var searchCompanyEmployeeList = <Employees>[].obs;
  String searchEmployee = '';
  var isAllDataLoaded = false.obs;
  var isLoadMoreRunningForViewAll = false;
  var pageRecordLimit = 10.obs;
  var pageToShow = 1.obs;
  var isFullScreenLoader = true.obs;
  var searchFieldEnable = false.obs;
  var companyId = Get.arguments;
  var isDataLoaded = false.obs;

  ScrollController scrollController = ScrollController();

  ///get company employee data api function
  companyEmployeeListApi({bool isShowLoader = false} ) async {
    Map<String, dynamic> params = {};
    params['company_id'] = companyId;
    searchEmployee.isNotEmpty ? params['search_content'] = searchEmployee : null;
    params['start'] = companyEmployeeList.length;
    params['limit'] = defaultFetchLimit;

    //params['search_content'] = searchEmployee.value;

    ResponseModel<CompanyEmployeeModel> responseModel =
        await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.companyEmployeeList, params: params);

    if (isShowLoader) {
      ShowLoaderDialog.dismissLoaderDialog();
    }
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      totalRecord.value = responseModel.data?.totalRecord ?? 0;
      if (totalRecord.value != 0) {
        isDataLoaded.value = true;
      } else {
        isDataLoaded.value = false;
      }
      if (companyEmployeeList.isEmpty) {
        companyEmployeeList.value = responseModel.data?.companyEmployeeListData ?? [];
      } else {
        companyEmployeeList.addAll(responseModel.data?.companyEmployeeListData ?? []);
      }

      isAllDataLoaded.value = (companyEmployeeList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  paginationFunction() {
    pageToShow.value++;
    Logger().i(pageToShow.value);
    companyEmployeeListApi(isShowLoader: false);
  }

  ///pagination loader
  paginationLoadData() {
    if (companyEmployeeList.length.toString() == totalRecord.value.toString()) {
      return true;
    } else {
      return false;
    }
  }

  ///******* onClear text function *******
  ///******* onClear icon press all text clear which type in textField *******
  onClearIconTap(TextEditingController otpEditingController) {
    otpEditingController.clear();
    searchEmployee = '';
    searchFieldEnable.value = false;
  }

  /*@override
  void onInit() {
    companyEmployeeListApi();
    super.onInit();
  }*/
}
