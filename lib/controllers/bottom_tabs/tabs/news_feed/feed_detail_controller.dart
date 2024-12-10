import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/feed_list_model.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';

import '../../../../model/bottom_navigation_models/comment_model.dart';
import '../../../../utils/app_common_stuffs/app_logger.dart';

RxList<String> list = <String>['Top Comments', 'Newest Comments'].obs;

class FeedDetailController extends GetxController {
  Rxn<FeedData> feedData = Rxn();
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController();

  var commentText = ''.obs;

  RxString dropdownValue = list.first.obs;
  var pageToShow = 1.obs;
  var pageLimitPagination = 20.obs;
  var totalCommentRecord = 0.obs;
  var isCommentLoad = false.obs;
  var isAllDataLoaded = false.obs;
  var feedCommentListData = <CommentListData>[].obs;
  var isLoadMoreRunningForViewAll = false;
  var isReplyComment = false.obs;
  var replyCommentId = 0.obs;
  bool isLoadMore = false;
  var feedDetailLoad = false.obs;
  var isSendButtonEnable = true.obs;

  ///Comment Pagination
  commentPagination() {
    pageToShow.value++;
    Logger().i(pageToShow.value);
    fetchFeedCommentApi(page: pageToShow.value);
  }

  feedDetailApiCall({required int feedId, bool isDataLoad = false}) async {
    Map<String, dynamic> params = {};
    params['feed_id'] = feedId;
    ResponseModel<FeedData> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.feedDetail, params: params);
    if (isDataLoad == false) {
      ShowLoaderDialog.dismissLoaderDialog();
    }

    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      feedDetailLoad.value = true;
      feedData.value = responseModel.data;
      fetchFeedCommentApi(page: pageToShow.value);
    } else {
      feedDetailLoad.value = false;
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  ///Fetch Feed comment list
  fetchFeedCommentApi({required int page}) async {
    Map<String, dynamic> params = {};
    params['start'] = feedCommentListData.length;
    params["limit"] = defaultFetchLimit;
    params['feed_id'] = feedData.value?.feedId ?? '';
    params['sort_comment'] = dropdownValue.value == 'Top Comments' ? 'tops comments' : 'newest comments';

    ResponseModel<FeedCommentModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.getComment, params: params);
    isCommentLoad.value = true;
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      totalCommentRecord.value = responseModel.data?.totalRecord ?? 0;
      feedData.value?.commentCounter.value = responseModel.data?.commentCount ?? 0;
      if (feedCommentListData.isEmpty) {
        feedCommentListData.value = responseModel.data?.commentListData ?? [];
      } else {
        feedCommentListData.addAll(responseModel.data?.commentListData ?? []);
      }
      isAllDataLoaded.value = (feedCommentListData.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  ///***** Add Feed Comment api function*****
  addCommentApiCall({required onErr}) async {
    Map<String, dynamic> params = {};
    params['feed_id'] = feedData.value?.feedId ?? '';
    params['comment'] = commentText.value;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.addComment, params: params);
    ShowLoaderDialog.dismissLoaderDialog();

    // isCommentLoaded.value = false;
    if (response.status == ApiConstant.statusCodeSuccess) {
      feedCommentListData.clear();
      fetchFeedCommentApi(page: pageToShow.value);
      return true;
    } else {
      onErr(response.message);
      return false;
    }
  }

  ///***** Add Feed Reply Comment api function******/////
  addFeedCommentReplyApiCall({required onErr, required int commentID}) async {
    Map<String, dynamic> params = {};
    params['feed_id'] = feedData.value?.feedId ?? '';
    params['comment_id'] = commentID;
    params['comment'] = commentText.value;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.feedCommentReply, params: params);
    ShowLoaderDialog.dismissLoaderDialog();
    // isCommentLoaded.value = false;
    if (response.status == ApiConstant.statusCodeSuccess) {

      feedCommentListData.clear();
      fetchFeedCommentApi(page: pageToShow.value);
      return true;
    } else {
      onErr(response.message);
      return false;
    }
  }

  /// Feed Comment Like

  feedCommentLikeApi({required int commentId, required onSuccess}) async {
    Map<String, dynamic> params = {};
    params['comment_id'] = commentId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.feedCommentLike, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      return false;
    }
  }

  /// Feed Comment unlike

  feedCommentUnlikeApi({required int commentId, required onSuccess}) async {
    Map<String, dynamic> params = {};
    params['comment_id'] = commentId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.feedCommentUnLike, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      return false;
    }
  }

  /// Feed Comment Reply Like
  feedCommentReplyLikeApi({required int replyId, required onSuccess}) async {
    Map<String, dynamic> params = {};
    params['reply_id'] = replyId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.feedCommentReplyLike, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      return false;
    }
  }

  /// Feed Comment UnLike Reply

  feedCommentReplyUnlikeApi({required int replyId, required onSuccess}) async {
    Map<String, dynamic> params = {};
    params['reply_id'] = replyId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.feedCommentReplyUnLike, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      return false;
    }
  }

  ///Feed Comment Report

  ///pagination loader
  paginationLoadData() {
    if (feedCommentListData.length.toString() == totalCommentRecord.value.toString()) {
      isAllDataLoaded.value = true;
      isLoadMore = isAllDataLoaded.value;
      return true;
    } else {
      isAllDataLoaded.value = false;
      isLoadMore = isAllDataLoaded.value;
      return false;
    }
  }
}
