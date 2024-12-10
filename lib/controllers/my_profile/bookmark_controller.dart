import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/my_profile/bookmark_model.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';

import '../../helper_manager/network_manager/api_const.dart';
import '../../utils/app_common_stuffs/app_logger.dart';

class BookMarkController extends GetxController {

  ///*******BookMark Listing Screen variables & Function declaration ******////
  var bookMarkList = <ArticleBookmarkData>[].obs;
  var page = 1.obs;
  var limit = 10.obs;
  var totalRecord = 0.obs;
  var isAllDataLoaded = false.obs;
  ScrollController scrollController = ScrollController();

  getMyBookMarkApi({bool}) async {
    Map<String, dynamic> params = {};
    params['start'] = bookMarkList.length;
    params['limit'] = defaultFetchLimit;
    ResponseModel<BookMarkListModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.myBookmark, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      totalRecord.value = responseModel.data?.totalRecord ?? 0;
      if (bookMarkList.isEmpty || page.value == 1) {
        bookMarkList.value = responseModel.data?.articleBookmarkData ?? [];
      } else {
        bookMarkList.addAll(responseModel.data?.articleBookmarkData ?? []);
      }
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  ///BookMark Pagination
  bookMarkPagination() {
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
          if (bookMarkList.length.toString() != totalRecord.value.toString() && isAllDataLoaded.isFalse) {
            page.value++;
            Logger().i(page.value);
            getMyBookMarkApi();
          } else {
            isAllDataLoaded.value = true;
            Logger().i('All Data Loaded');
          }
        }
      },
    );
  }

  ///pagination loader
  paginationLoadData() {
    if (bookMarkList.length.toString() == totalRecord.value.toString()) {
      return true;
    } else {
      return false;
    }
  }




}
