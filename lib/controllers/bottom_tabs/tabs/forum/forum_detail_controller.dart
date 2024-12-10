import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';

import '../../../../helper_manager/network_manager/api_const.dart';
import '../../../../helper_manager/network_manager/remote_service.dart';
import '../../../../model/bottom_navigation_models/comment_model.dart';
import '../../../../model/bottom_navigation_models/forum_models/forum_list_model.dart';
import '../../../../model/response_model/responese_datamodel.dart';
import '../../../../utils/app_common_stuffs/app_logger.dart';

RxList<String> list = <String>['Tops comments', 'Newest comments'].obs;

class ForumDetailController extends GetxController {
  Rxn<ForumData> forumData = Rxn();

  PageController pageController = PageController();
  var commentText = ''.obs;
  ScrollController scrollController = ScrollController();
  RxString dropdownValue = list.first.obs;
  var pageToShow = 1.obs;
  var pageLimitPagination = 3.obs;
  var totalCommentRecord = 0.obs;
  var isCommentLoad = false.obs;
  var isAllDataLoaded = false.obs;
  var forumCommentList = <CommentListData>[].obs;

  var isReplyComment = false.obs;
  var replyCommentId = 0.obs;
  var isLoadMoreRunningForViewAll = false;
  var isForumDetailLoad = false.obs;
  var isSendButtonEnable = true.obs;


  ///Forum Detail api function
  forumDetailApiCall({required int forumId, bool isDataLoad = false}) async {
    Map<String, dynamic> params = {};
    params['forum_id'] = forumId;
    ResponseModel<ForumData> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.forumDetail, params: params);
    if (isDataLoad == false) {
      ShowLoaderDialog.dismissLoaderDialog();
    }

    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      isForumDetailLoad.value = true;
      forumData.value = responseModel.data;
      fetchForumCommentApi(page: pageToShow.value);
    } else {
      isForumDetailLoad.value = false;
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  ///Comment Pagination
  commentPagination() {
    pageToShow.value++;
    Logger().i(pageToShow.value);
    fetchForumCommentApi(page: pageToShow.value);
  }

  ///fetch forum comment list
  fetchForumCommentApi({required int page}) async {
    Map<String, dynamic> params = {};
    params['start'] = forumCommentList.length;
    params["limit"] = defaultFetchLimit;
    params['forum_id'] = forumData.value?.forumId ?? 0;
    params['sort_comment'] = dropdownValue.value == 'Tops comments' ? 'tops comments' : 'newest comments';

    ResponseModel<ForumCommentModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.forumCommentList, params: params);
    isCommentLoad.value = true;
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      totalCommentRecord.value = responseModel.data?.totalRecord ?? 0;
      forumData.value?.commentCounter.value = responseModel.data?.commentCount ?? 0;
      if (forumCommentList.isEmpty) {
        forumCommentList.value = responseModel.data?.forumCommentListData ?? [];
      } else {
        forumCommentList.addAll(responseModel.data?.forumCommentListData ?? []);
      }
      isAllDataLoaded.value = (forumCommentList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  ///***** Add Forum Comment api function*****
  addCommentApiCall({required onErr}) async {
    Map<String, dynamic> params = {};
    params['forum_id'] = forumData.value?.forumId ?? 0;
    params['comment'] = commentText.value;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.forumAddComment, params: params);
    // isCommentLoaded.value = false;
    ShowLoaderDialog.dismissLoaderDialog();
    if (response.status == ApiConstant.statusCodeSuccess) {
      forumCommentList.clear();

      fetchForumCommentApi(page: pageToShow.value);
      return true;
    } else {
      onErr(response.message);
      return false;
    }
  }

  ///***** Add Forum Reply Comment api function******/////
  addForumCommentReplyApiCall({required onErr, required int commentID}) async {
    // ignore: avoid_print
    print("API $commentID");
    Map<String, dynamic> params = {};
    params['forum_id'] = forumData.value?.forumId ?? 0;
    params['comment_id'] = commentID;
    params['comment'] = commentText.value;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.forumReplyComment, params: params);
    ShowLoaderDialog.dismissLoaderDialog();
    // isCommentLoaded.value = false;
    if (response.status == ApiConstant.statusCodeSuccess) {
      forumCommentList.clear();
      fetchForumCommentApi(page: pageToShow.value);
      return true;
    } else {
      onErr(response.message);
      return false;
    }
  }

  /// Forum Comment Like

  forumCommentLikeApi({required int commentId, required onSuccess}) async {
    Map<String, dynamic> params = {};
    params['comment_id'] = commentId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.forumCommentLike, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      return false;
    }
  }

  /// Forum Comment unlike

  forumCommentUnlikeApi({required int commentId, required onSuccess}) async {
    Map<String, dynamic> params = {};
    params['comment_id'] = commentId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.forumCommentUnlike, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      return false;
    }
  }

  /// Forum Comment Reply Like
  forumCommentReplyLikeApi({required int replyId, required onSuccess}) async {
    Map<String, dynamic> params = {};
    params['reply_id'] = replyId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.forumReplyCommentLike, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      return false;
    }
  }

  /// Forum Comment UnLike Reply

  forumCommentReplyUnlikeApi({required int replyId, required onSuccess}) async {
    Map<String, dynamic> params = {};
    params['reply_id'] = replyId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.forumReplyCommentUnlike, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      return false;
    }
  }

  ///Forum Comment Report

  ///pagination loader
  paginationLoadData() {
    if (forumCommentList.length.toString() == totalCommentRecord.value.toString()) {
      return true;
    } else {
      return false;
    }
  }
}
