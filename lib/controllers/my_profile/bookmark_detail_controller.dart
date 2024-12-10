import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:iso_net/model/my_profile/bookmark_model.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';

import '../../helper_manager/network_manager/api_const.dart';
import '../../helper_manager/network_manager/remote_service.dart';
import '../../model/bottom_navigation_models/comment_model.dart';
import '../../model/bottom_navigation_models/news_feed_models/article_detail_model.dart';
import '../../model/response_model/responese_datamodel.dart';
import '../../ui/style/showloader_component.dart';
import '../../utils/app_common_stuffs/app_logger.dart';
import '../../utils/app_common_stuffs/snackbar_util.dart';

RxList<String> list = <String>['Tops comments', 'Newest comments'].obs;

class BookMarkDetailController extends GetxController {
  var bookMarkCurrentPage = Get.arguments;

  ///Bookmark article data variables
  var getAction = ''.obs;
  var apiCurrentPage = 1.obs;
  var apiTotalRecords = 0.obs;
  Rxn<ArticleBookMarkData> bookMarkDetail = Rxn();
  RxBool isBookMarkRemove = false.obs;
  var bookMarkRemoveId = <int>[].obs;
  var bookMarkId = 0.obs;

  ///BookMark article comment variables
  var isCommentLoad = false.obs;
  var commentText = ''.obs;
  RxString dropdownValue = list.first.obs;
  var articleCommentList = <CommentListData>[].obs;
  var isAllDataLoaded = false.obs;
  var pageToShow = 1.obs;
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController();
  var replyCommentId = 0.obs;
  var isReplyComment = false.obs;
  var totalCommentRecord = 0.obs;
  var pageLimitPagination = 3.obs;
  var bookmarkDataLoad = false.obs;
  var isLoadMoreRunningForViewAll = false;
  var isSendButtonEnable = true.obs;

  ///BookMark Detail Next Previous api
  nextArticleApi({required int currentPage}) async {
    Map<String, dynamic> params = {};
    params["current_page"] = currentPage;
    params["action"] = getAction.value;
    ShowLoaderDialog.showLoaderDialog(Get.context!);
    ResponseModel<BookMarkDetailModel> response = await sharedServiceManager.createPostRequest(params: params, typeOfEndPoint: ApiType.myBookmarkNext);
    ShowLoaderDialog.dismissLoaderDialog();
    if (response.status == ApiConstant.statusCodeSuccess) {
      bookmarkDataLoad.value = true;
      apiCurrentPage.value = response.data?.currentPage ?? 0;
      apiTotalRecords.value = response.data?.totalRecord ?? 0;
      bookMarkId.value = response.data?.articleData?.id ?? 0;

      bookMarkDetail.value = response.data?.articleData?.bookmark;
      if (isCommentLoad.value == false) {
        fetchArticleCommentApi(page: pageToShow.value);
      }
      return true;
    } else {
      bookmarkDataLoad.value = false;
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
      return false;
    }
  }

  ///fetch Bookmark comment list
  fetchArticleCommentApi({required int page, int? articleID}) async {
    Map<String, dynamic> params = {};
    params['start'] = articleCommentList.length;
    params["limit"] = defaultFetchLimit;
    params['article_id'] = articleID ?? bookMarkDetail.value?.id ?? 0;
    params['sort_comment'] = dropdownValue.value == 'Tops comments' ? 'tops comments' : 'newest comments';

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

  ///***** Add Bookmark Comment api function*****
  addCommentApiCall({required onErr}) async {
    Map<String, dynamic> params = {};
    params['article_id'] = bookMarkDetail.value?.id ?? 0;
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
    if (kDebugMode) {
      print("API $commentID");
    }
    Map<String, dynamic> params = {};
    params['article_id'] = bookMarkDetail.value?.id ?? 0;
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

  /// Article Comment Like
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

  /// Article Comment unlike
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

  /// Article Comment Reply Like
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

  /// Article Comment UnLike Reply
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
      return true;
    } else {
      onError(response.message);
      return false;
    }
  }

  ///pagination loader
  paginationLoadData() {
    if (articleCommentList.length.toString() == totalCommentRecord.value.toString()) {
      return true;
    } else {
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
        if (articleCommentList.length != totalCommentRecord.value && isAllDataLoaded.isFalse) {
          isCommentLoad.value = true;

        } else {
          isAllDataLoaded.value = true;
          Logger().i('All Data Loaded');
        }
      }
    });*/
  }
}
