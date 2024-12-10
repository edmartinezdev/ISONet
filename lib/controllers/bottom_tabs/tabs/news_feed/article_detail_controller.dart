
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';

import '../../../../helper_manager/network_manager/api_const.dart';
import '../../../../helper_manager/network_manager/remote_service.dart';
import '../../../../model/bottom_navigation_models/comment_model.dart';
import '../../../../model/bottom_navigation_models/news_feed_models/article_detail_model.dart';
import '../../../../model/bottom_navigation_models/news_feed_models/display_next_article_model.dart';
import '../../../../model/response_model/responese_datamodel.dart';
import '../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../utils/app_common_stuffs/snackbar_util.dart';

RxList<String> list = <String>['Top Comments', 'Newest Comments'].obs;

class ArticleDetailController extends GetxController {
  // ArticleMedia articleMedia = Get.arguments[0];
  // FeedData feedData = Get.arguments[1];
  // List<FeedData> feedListData = Get.arguments[2];

  Rxn<ArticleDetailListModel> articleDetailList = Rxn();

  //Rxn<NextPreviousArticleModel> nextPreviousArticleModel = Rxn();
  var isCommentLoad = false.obs;
  var commentText = ''.obs;
  RxString dropdownValue = list.first.obs;
  var articleCommentList = <CommentListData>[].obs;
  var isAllDataLoaded = false.obs;
  var pageToShow = 1.obs;
  ScrollController scrollController = ScrollController();
  var replyCommentId = 0.obs;
  var isReplyComment = false.obs;
  var totalCommentRecord = 0.obs;
  var pageLimitPagination = 20.obs;
  var apiCurrentPage = 0.obs;
  var apiTotalRecords = 0.obs;
  PageController pageController = PageController();
  var getAction = ''.obs;
  bool isLoadMore = false;
  var isLoadMoreRunningForViewAll = false;
  var isArticleLoad = false.obs;
  var isSendButtonEnable = true.obs;

  ///fetch article comment list
  fetchArticleCommentApi({required int page, int? articleID}) async {
    Map<String, dynamic> params = {};
    params['start'] = articleCommentList.length;
    params["limit"] = defaultFetchLimit;
    params['article_id'] = articleID ?? articleDetailList.value?.id ?? 0;
    params['sort_comment'] = dropdownValue.value == 'Top Comments' ? 'tops comments' : 'newest comments';

    ResponseModel<ArticleCommentModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.articleCommentList, params: params);
    isCommentLoad.value = true;
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      totalCommentRecord.value = responseModel.data?.totalRecord ?? 0;
      if (articleCommentList.isEmpty) {
        articleCommentList.value = responseModel.data?.articleCommentListData ?? [];
      } else {
        articleCommentList.addAll(responseModel.data?.articleCommentListData ?? []);
      }
      isAllDataLoaded.value = (articleCommentList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  ///***** Add Forum Comment api function*****
  addCommentApiCall({required onErr}) async {
    Map<String, dynamic> params = {};
    params['article_id'] = articleDetailList.value?.id ?? 0;
    params['comment'] = commentText.value;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.createArticleComment, params: params);
    // isCommentLoaded.value = false;
    ShowLoaderDialog.dismissLoaderDialog();
    if (response.status == ApiConstant.statusCodeSuccess) {
      articleCommentList.clear();
      fetchArticleCommentApi(page: pageToShow.value);
      return true;
    } else {
      onErr(response.message);
      return false;
    }
  }



  ///***** Add Article Reply Comment api function******/////
  addArticleCommentReplyApiCall({required onErr, required int commentID}) async {
    print("API $commentID");
    Map<String, dynamic> params = {};
    params['article_id'] = articleDetailList.value?.id ?? 0;
    params['comment_id'] = commentID;
    params['comment'] = commentText.value;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.articleReplyComment, params: params);
    // isCommentLoaded.value = false;
    ShowLoaderDialog.dismissLoaderDialog();
    if (response.status == ApiConstant.statusCodeSuccess) {
      articleCommentList.clear();
      fetchArticleCommentApi(page: pageToShow.value);
      return true;
    } else {
      onErr(response.message);
      return false;
    }
  }

  /// Forum Comment Like
  articleCommentLikeApi({required int commentId, required onSuccess}) async {
    Map<String, dynamic> params = {};
    params['comment_id'] = commentId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.articleCommentLike, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      return false;
    }
  }

  /// Forum Comment unlike
  articleCommentUnlikeApi({required int commentId, required onSuccess}) async {
    Map<String, dynamic> params = {};
    params['comment_id'] = commentId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.articleCommentUnLike, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      return false;
    }
  }

  /// Forum Comment Reply Like
  articleCommentReplyLikeApi({required int replyId, required onSuccess}) async {
    Map<String, dynamic> params = {};
    params['reply_id'] = replyId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.articleReplyCommentLike, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      return false;
    }
  }

  /// Forum Comment UnLike Reply
  articleCommentReplyUnlikeApi({required int replyId, required onSuccess}) async {
    Map<String, dynamic> params = {};
    params['reply_id'] = replyId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.articleReplyCommentUnLike, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      return false;
    }
  }

  /// Report comment Article Api
  reportCommentArticleApi({required onError, required int commentID}) async {
    Map<String, dynamic> params = {};
    params['comment_id'] = commentID;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.articleCommentReport, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      return true;
    } else {
      onError(response.message);
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
      return false;
    }
  }

  /// Report Article Api
  reportArticleApi({required onError, required int articleID}) async {
    Map<String, dynamic> params = {};
    params['article_id'] = articleID;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.articleReport, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      return true;
    } else {
      onError(response.message);
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
      return false;
    }
  }

  ///Article Like Api
  articleLikeApi({required int articleId, required onSuccess}) async {
    Map<String, dynamic> params = {};
    params['article_id'] = articleId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.articleLike, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      return false;
    }
  }

  ///Article Unlike Api
  articleUnlikeApi({required int articleId, required onSuccess}) async {
    Map<String, dynamic> params = {};
    params['article_id'] = articleId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.articleUnLike, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      return false;
    }
  }

  /// Article BookMark
  articleBookMarkApi({required int articleId, required onError}) async {
    Map<String, dynamic> params = {};
    params['article_id'] = articleId;
    ResponseModel<ArticleDetailListModel> response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.articleBookmark, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      print('Success');
      return true;
    } else {
      onError(response.message);
      return false;
    }
  }

  nextArticleApi({required int currentPage,bool isArticleSearch = false,int? articleId}) async {
    Map<String, dynamic> params = {};
    if(isArticleSearch){
      params['article_id'] = articleId;
    }else{
      params["current_page"] = currentPage;
      params["action"] = getAction.value;
    }

    //params["action"] = getAction.value ? 'NEXT' : 'PREV';
    ShowLoaderDialog.showLoaderDialog(Get.context!);
    ResponseModel<NextPreviousArticleModel> response = await sharedServiceManager.createPostRequest(params: params, typeOfEndPoint: isArticleSearch == true ? ApiType.articleDetail: ApiType.nextPrevoiusArticleList);
    ShowLoaderDialog.dismissLoaderDialog();
    if (response.status == ApiConstant.statusCodeSuccess) {
      isArticleLoad.value = true;
      apiCurrentPage.value = response.data?.currentPage ?? 0;
      apiTotalRecords.value = response.data?.totalRecord ?? 0;
      // currentPages.value = response.data?.currentPage ?? 0;
      articleDetailList.value = response.data?.articleData;
      if (isCommentLoad.value == false) {
        fetchArticleCommentApi(page: pageToShow.value);
      }
      return true;
    } else {
      isArticleLoad.value = false;
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
      return false;
    }
  }

  ///pagination loader
  paginationLoadData() {
    if (articleCommentList.length.toString() == totalCommentRecord.value.toString()) {
      isAllDataLoaded.value = true;
      isLoadMore = isAllDataLoaded.value;
      return true;
    } else {
      isAllDataLoaded.value = false;
      isLoadMore = isAllDataLoaded.value;
      return false;
    }
  }

  ///Comment Pagination
  commentPagination() {
    pageToShow.value++;
    Logger().i(pageToShow.value);
    fetchArticleCommentApi(page: pageToShow.value);
    /*scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        if (articleCommentList.length != totalCommentRecord.value && !isLoadMore) {
          isCommentLoad.value = true;
          isAllDataLoaded.value = false;
          isLoadMore = isAllDataLoaded.value;
          pageToShow.value++;
          Logger().i(pageToShow.value);
          fetchArticleCommentApi(page: pageToShow.value);
        } else {
          isAllDataLoaded.value = true;
          isLoadMore = isAllDataLoaded.value;
          Logger().i('All Data Loaded');
        }
      }
    });*/
  }
}
