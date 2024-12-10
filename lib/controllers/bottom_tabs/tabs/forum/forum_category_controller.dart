import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';

import '../../../../helper_manager/network_manager/api_const.dart';
import '../../../../helper_manager/network_manager/remote_service.dart';
import '../../../../model/bottom_navigation_models/forum_models/forum_list_model.dart';
import '../../../../model/response_model/responese_datamodel.dart';
import '../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../utils/app_common_stuffs/common_api_function.dart';
import '../../../../utils/app_common_stuffs/snackbar_util.dart';

class ForumCategoryController extends GetxController {
  var categoryId = Get.arguments[0];
  var categoryName = Get.arguments[1];
  var totalRecord = 0.obs;
  var pageToShow = 1.obs;
  var forumRecordLimit = 5.obs;
  var forumList = <ForumData>[].obs;
  var isAllDataLoaded = false.obs;
  var isLoadMoreRunningForViewAll = false;
  bool isLoadMore = false;
  var currentPageIndex = 0.obs;
  var isForumListLoaded = false.obs;
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController();
  var isCategoryRefresh = false.obs;
  var isApiResponseReceive = false.obs;

  ///Fetch Forum List Api Function
  forumApiCall({ bool isShowLoader = false}) async {
    Map<String, dynamic> params = {};
    params['category_id'] = categoryId;
    params['start'] = isCategoryRefresh.value ? 0 : forumList.length;
    params['limit'] = defaultFetchLimit;
    ResponseModel<ForumListModel> responseModel =
        await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.categoryForumList, params: params);
    if(isShowLoader == true){
      ShowLoaderDialog.dismissLoaderDialog();
    }
    if(isCategoryRefresh.value){
      forumList.clear();
      pageToShow.value = 1;
      totalRecord.value = 0;
      isAllDataLoaded.value = false;
      isCategoryRefresh.value = false;
    }
    isApiResponseReceive.value = true;
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      totalRecord.value = responseModel.data?.totalRecord ?? 0;
      if (forumList.isEmpty) {
        forumList.value = responseModel.data?.forumDataList ?? [];
      } else {
        forumList.addAll(responseModel.data?.forumDataList ?? []);
      }

      isAllDataLoaded.value = (forumList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  ///Pagination of Forum List
  forumPagination() {
    pageToShow.value++;
    Logger().i(pageToShow.value);
    forumApiCall(isShowLoader : false);
  }

  ///pagination loader
  paginationLoadData() {
    if (forumList.length == totalRecord.value) {
      isAllDataLoaded.value = true;
      isLoadMore = isAllDataLoaded.value;
      return isLoadMore;
    } else {
      isAllDataLoaded.value = false;
      isLoadMore = isAllDataLoaded.value;
      return isLoadMore;
    }
  }

  ///******Forum Like Event handle function*****////
  handleUpArrowTap({required int index}) async {
    if (forumList[index].isLikeForum.value == false) {
      await CommonApiFunction.likeForumApi(
        forumId: forumList[index].forumId ?? 0,
        onSuccess: (likeCount) {
          forumList[index].likeCount.value = likeCount[0];
          forumList[index].disLikeCount.value = likeCount[1];
          forumList[index].isLikeForum.value = true;
          forumList[index].isUnlikeForum.value = false;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
        },
      );
    }

  }

  ///******Forum DisLike Event handle function*****////
  handleDownArrowTap({required int index}) async {
    if (forumList[index].isUnlikeForum.value == false) {
      await CommonApiFunction.unlikeForumApi(
        forumId: forumList[index].forumId ?? 0,
        onSuccess: (disLikeCount) {
          forumList[index].likeCount.value = disLikeCount[0];
          forumList[index].disLikeCount.value = disLikeCount[1];
          forumList[index].isLikeForum.value = false;
          forumList[index].isUnlikeForum.value = true;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
        },
      );
    }
  }

  ///***** Forum Report handle function ******///
  handleForumReport({required int index}) async {
    await CommonApiFunction.flagForumApi(
      forumId: forumList[index].forumId ?? 0,
      onError: (msg) {
        SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
      },
    );
  }
}
