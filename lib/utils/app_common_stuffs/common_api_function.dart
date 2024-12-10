import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/messenger_tab_controller.dart';
import 'package:iso_net/helper_manager/socket_manager/socket_manager_new.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';

import '../../helper_manager/network_manager/api_const.dart';
import '../../helper_manager/network_manager/remote_service.dart';
import '../../model/response_model/responese_datamodel.dart';
import '../../singelton_class/auth_singelton.dart';

class CommonApiFunction {
  /// Feed Like Api
  static likePostApi({required int feedId, required onSuccess, required onErr}) async {
    Map<String, dynamic> params = {};
    params['feed_id'] = feedId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.likePost, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      onErr(response.message);
      return false;
    }
  }

  /// Feed UnLike Api
  static unlikePostApi({required int feedId, required onSuccess, required onErr}) async {
    Map<String, dynamic> params = {};
    params['feed_id'] = feedId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.unlikePost, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      onErr(response.message);
      return false;
    }
  }

  /// Company Review Like Api
  static likeCompanyReviewApi({required int reviewId, required onSuccess, required onErr}) async {
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

  /// Company Review UnLike Api
  static unlikeCompanyReviewApi({required int reviewId, required onSuccess, required onErr}) async {
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

  ///Connection Request Api Function
  static commonConnectApi({required userId, required onErr}) async {
    Map<String, dynamic> params = {};
    params['connect_to'] = userId;

    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.connectRequest, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      return true;
    } else {
      onErr(responseModel.message);
      return false;
    }
  }

  /// Report Feed Api Function
  static flagFeedApi({required onError, required int feedId, onSucess}) async {
    Map<String, dynamic> params = {};
    params['feed_id'] = feedId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.feedFlag, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSucess(response.message);
      return true;
    } else {
      onError(response.message);
      return false;
    }
  }

  /// Report User Api Function
  static flagUserApi({required onError, required int userId, onSuccess}) async {
    Map<String, dynamic> params = {};
    params['user_id'] = userId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.flagUser, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.message);
      return true;
    } else {
      onError(response.message);
      return false;
    }
  }

  /// Report Feed Comment Api Function
  static reportFeedCommentApi({required onError, required int commentId, onSuccess}) async {
    Map<String, dynamic> params = {};
    params['comment_id'] = commentId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.reportComment, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.message);
      return true;
    } else {
      onError(response.message);
      return false;
    }
  }

  ///********** Forums Common Api Functions ************** ///
  /// Forum Like Api
  static likeForumApi({required int forumId, required onSuccess, required onErr}) async {
    Map<String, dynamic> params = {};
    params['forum_id'] = forumId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.forumLike, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(
        [response.data['like_count'], response.data['dislike_count']],
      );
      return true;
    } else {
      onErr(response.message);
      return false;
    }
  }

  /// Forum UnLike Api
  static unlikeForumApi({required int forumId, required onSuccess, required onErr}) async {
    Map<String, dynamic> params = {};
    params['forum_id'] = forumId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.forumUnlike, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(
        [response.data['like_count'], response.data['dislike_count']],
      );
      return true;
    } else {
      onErr(response.message);
      return false;
    }
  }

  ///Forum Report Api
  static flagForumApi({required onError, required int forumId, onSuccess}) async {
    Map<String, dynamic> params = {};
    params['forum_id'] = forumId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.forumFlag, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.message);
      return true;
    } else {
      onError(response.message);
      Get.back();
      return false;
    }
  }

  ///Report Forum Comment Api Function
  static reportForumCommentApi({required onErr, required int commentId, onSuccess}) async {
    Map<String, dynamic> params = {};
    params['comment_id'] = commentId;
    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.forumCommentReport, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      onSuccess(responseModel.message);
      return true;
    } else {
      onErr(responseModel.message);
      return false;
    }
  }

  ///Report Article Api
  static reportArticleApi({required onError, required int articleID, onSuccess}) async {
    Map<String, dynamic> params = {};
    params['article_id'] = articleID;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.articleReport, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.message);
      return true;
    } else {
      onError(response.message);
      return false;
    }
  }

  /// Report comment Article Api
  static reportCommentArticleApi({required onErr, required int commentId, onSuccess}) async {
    Map<String, dynamic> params = {};
    params['comment_id'] = commentId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.articleCommentReport, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.message);
      return true;
    } else {
      onErr(response.message);
      return false;
    }
  }

  ///Sign out Api
  static logoutApi({required onErr}) async {
    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.signOut);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      await userSingleton.clearPreference();
      MessengerController controller = Get.find();
      controller.clearAllValue();
      SocketManagerNew().disconnectFromServer();
      FlutterAppBadger.removeBadge();
      return true;
    } else {
      onErr(responseModel.message);
      return false;
    }
  }

  ///Forum Delete Comment Api
  static forumMainCommentDeleteApi({required onErr, required commentId, onSuccess}) async {
    Map<String, dynamic> params = {};
    params['comment_id'] = commentId;
    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.forumCommentDelete, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      onSuccess(responseModel.message);
      return true;
    } else {
      onErr(responseModel.message);
      return false;
    }
  }

  //Forum Delete reply Comment Api
  static forumReplyCommentDeleteApi({required onErr, required commentId, onSuccess}) async {
    Map<String, dynamic> params = {};
    params['reply_id'] = commentId;
    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.forumReplyCommentDelete, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      onSuccess(responseModel.message);
      return true;
    } else {
      onErr(responseModel.message);
      return false;
    }
  }

  //Article Delete reply Comment Api
  static articleMainCommentDeleteApi({required onErr, required commentId, onSuccess}) async {
    Map<String, dynamic> params = {};
    params['comment_id'] = commentId;
    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.articleDeleteMainComment, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      onSuccess(responseModel.message);
      return true;
    } else {
      onErr(responseModel.message);
      return false;
    }
  }

  //Article Delete reply Comment Api
  static articleReplyCommentDeleteApi({required onErr, required commentId, onSuccess}) async {
    Map<String, dynamic> params = {};
    params['reply_id'] = commentId;
    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.articleDeleteReplyComment, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      onSuccess(responseModel.message);
      return true;
    } else {
      onErr(responseModel.message);
      return false;
    }
  }

  //Feed Delete reply Comment Api
  static feedMainCommentDeleteApi({required onErr, required commentId, onSuccess}) async {
    Map<String, dynamic> params = {};
    params['comment_id'] = commentId;
    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.feedDeleteMainComment, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      onSuccess(responseModel.message);
      return true;
    } else {
      onErr(responseModel.message);
      return false;
    }
  }

  //Feed Delete reply Comment Api
  static feedReplyCommentDeleteApi({required onErr, required commentId, onSuccess}) async {
    Map<String, dynamic> params = {};
    params['reply_id'] = commentId;
    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.feedDeleteReplyComment, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      onSuccess(responseModel.message);
      return true;
    } else {
      onErr(responseModel.message);
      return false;
    }
  }

  ///Feed Delete
  static feedDeleteApi({required onErr, required feedId, onSuccess}) async {
    Map<String, dynamic> params = {};
    params['feed_id'] = feedId;
    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.feedDelete, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      onSuccess(responseModel.message);
      return true;
    } else {
      onErr(responseModel.message);
      return false;
    }
  }

  ///Forum Delete
  static forumDeleteApi({required onErr, required forumId, onSuccess}) async {
    Map<String, dynamic> params = {};
    params['forum_id'] = forumId;
    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.forumDelete, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      onSuccess(responseModel.message);
      return true;
    } else {
      onErr(responseModel.message);
      return false;
    }
  }

  ///Common Api For report
  static commonReportApi({required onErr, required onSuccess, required String reportType, required reportId, required description}) async {
    Map<String, dynamic> params = {};
    params['report_type'] = reportType;
    params['description'] = description;
    if (reportType.toLowerCase() == 'user') {
      params['user_id'] = reportId;
    } else if (reportType.toLowerCase() == 'feed') {
      params['feed_id'] = reportId;
    } else if (reportType.toLowerCase() == 'forum') {
      params['forum_id'] = reportId;
    }
    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.reportApi, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      onSuccess(responseModel.message);
    } else {
      onErr(responseModel.message);
    }
  }

  /// Block user api
  static blockUser({required onErr, required onSuccess, required int userId}) async {
    Map<String, dynamic> params = {};
    params['user_id'] = userId;
    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.blockUser, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      onSuccess(responseModel.message);
      return true;
    } else {
      onErr(responseModel.message);
      return false;
    }
  }

  /// Block user api
  static unBlockUser({required onErr, required onSuccess, required int userId}) async {
    Map<String, dynamic> params = {};
    params['user_id'] = userId;
    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.unBlockUser, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      onSuccess(responseModel.message);
      return true;
    } else {
      onErr(responseModel.message);
      return false;
    }
  }

  ///User Account delete Api;
  static deleteUserAccountApi({required onErr, required BuildContext context}) async {
    Map<String, dynamic> params = {};
    params['method'] = AppStrings.delete;
    ResponseModel responseModel = await sharedServiceManager.createDeleteRequest(typeOfEndPoint: ApiType.deleteUser, );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      Get.offAllNamed(ScreenRoutesConstants.startupScreen);
      userSingleton.clearPreference();
      SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: responseModel.message);
    } else {
      onErr(responseModel.message);
    }
  }
}
