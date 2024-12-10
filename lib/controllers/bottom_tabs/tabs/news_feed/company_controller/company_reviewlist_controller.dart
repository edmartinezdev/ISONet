import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';

import '../../../../../helper_manager/network_manager/api_const.dart';
import '../../../../../helper_manager/network_manager/remote_service.dart';
import '../../../../../model/bottom_navigation_models/news_feed_models/company_profile_model.dart';
import '../../../../../model/response_model/responese_datamodel.dart';
import '../../../../../ui/style/showloader_component.dart';
import '../../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../../utils/app_common_stuffs/snackbar_util.dart';

class CompanyReviewController extends GetxController {
  ///Company Review Screen variable declaration ***//
  var pageRecordLimit = 10.obs;
  var pageLimit = 1.obs;
  var companyReviewList = <CompanyReviewListData>[].obs;
  var reviewCounters = <int>[].obs;
  var isLikeReview = <bool>[].obs;
  var totalReviewRecord = 0.obs;
  var isAllDataLoaded = false.obs;
  var isLoadMoreRunningForViewAll = false;
  var isFullScreenLoader = true.obs;
  ScrollController scrollController = ScrollController();
  var companyId = Get.arguments;

  /// fetch List of company reviews
  ///this api function for ListCompanyReview screen api
  companyReviewListApi({required int companyId,bool isShowLoader = false}) async {
    Map<String, dynamic> params = {};
    params['limit'] = defaultFetchLimit;
    params['start'] = companyReviewList.length;
    params['company_id'] = companyId;

    ResponseModel<CompanyReviewModel> responseModel =
        await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.companyListReview, params: params);
    if (isShowLoader) {
      ShowLoaderDialog.dismissLoaderDialog();
    }
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      totalReviewRecord.value = responseModel.data?.totalRecord ?? 0;

      if (companyReviewList.isEmpty) {
        companyReviewList.value = responseModel.data?.companyReviewListData ?? [];
        /*List.generate(companyReviewList.length, (index) => reviewCounters.add(companyReviewList[index].totalLikes ?? 0));
        List.generate(companyReviewList.length, (index) => isLikeReview.add(companyReviewList[index].isLikeByYou ?? false));
        Logger().i(reviewCounters);
        Logger().i(isLikeReview);*/
      } else {
        companyReviewList.addAll(responseModel.data?.companyReviewListData ?? []);
        /*for (int i = 0; i < (responseModel.data?.companyReviewListData?.length ?? 0); i++) {
          reviewCounters.addAll([responseModel.data?.companyReviewListData?[i].totalLikes ?? 0]);
        }
        for (int i = 0; i < (responseModel.data?.companyReviewListData?.length ?? 0); i++) {
          isLikeReview.addAll([responseModel.data?.companyReviewListData?[i].isLikeByYou ?? false]);
        }*/
        Logger().i(reviewCounters);
        Logger().i(isLikeReview);
      }

      isAllDataLoaded.value = (companyReviewList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  ///Review Pagination Function
  reviewPagination({required int companyId}) {
    pageLimit.value++;
    Logger().i(pageLimit.value);
    companyReviewListApi(companyId: companyId,isShowLoader: false);
  }

  ///pagination loader
  paginationLoadData() {
    if (companyReviewList.length.toString() == totalReviewRecord.value.toString()) {
      return true;
    } else {
      return false;
    }
  }

  ///Review Like Api
  likeReviewApi({required int reviewId, required onSuccess, required onErr}) async {
    Map<String, dynamic> params = {};
    params['review_id'] = reviewId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.companyReviewLike, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      onErr(response.message);
      return false;
    }
  }

  ///Review UnLike Api
  unlikeReviewApi({required int reviewId, required onSuccess, required onErr}) async {
    Map<String, dynamic> params = {};
    params['review_id'] = reviewId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.companyReviewUnLike, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      onErr(response.message);
      return false;
    }
  }
}
