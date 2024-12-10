// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:iso_net/helper_manager/network_manager/api_const.dart';
// import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
// import 'package:iso_net/model/bottom_navigation_models/news_feed_models/comments_model.dart';
// import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
//
// import '../../../../model/bottom_navigation_models/news_feed_models/feed_list_model.dart';
// import '../../../../model/response_model/responese_datamodel.dart';
// import '../../../../utils/app_common_stuffs/app_logger.dart';
//
// class PostDetailController extends GetxController{
//
//   var postCommentsList = <FeedComments>[].obs;
//   FeedData postDetail = Get.arguments;
//   var isCommentLoaded = false.obs;
//   var commentText = ''.obs;
//   var autoFocus = false.obs;
//   var pageToShow = 1.obs;
//   var pageLimitPagination = 10.obs;
//   var totalFeedRecord = 0.obs;
//   var isAllDataLoaded = false.obs;
//   var isReplyComment = false.obs;
//   var isRCommentReply = false.obs;
//   var likesCounters = <int>[].obs;
//   var isLikeFeed = <bool>[].obs;
//   var replyCommentId = 0.obs;
//   ScrollController scrollController = ScrollController();
//
//   @override
//   void onInit() {
//     scrollController.addListener(() {
//       if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
//         if (postCommentsList.length != totalFeedRecord.value && isAllDataLoaded.isFalse) {
//           pageToShow.value++;
//           Logger().i(pageToShow.value);
//           fetchPostCommentsApi(page: pageToShow.value);
//         } else {
//           isAllDataLoaded.value = true;
//           Logger().i('All Data Loaded');
//         }
//       }
//     });
//   }
//
//   ///pagination loader
//   paginationLoadData() {
//     if (postCommentsList.length.toString() == totalFeedRecord.value.toString()) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//
//   ///*****AddComment api function*****
//   addCommentApiCall({required onErr})async{
//     Map<String,dynamic> params = {};
//     params['feed_id'] = postDetail.feedId;
//     params['comment'] = commentText.value;
//     ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.addComment,params: params);
//     // isCommentLoaded.value = false;
//     if(response.status == ApiConstant.statusCodeSuccess){
//       fetchPostCommentsApi(page: pageToShow.value);
//       return true;
//     }else{
//       onErr(response.message);
//       return false;
//     }
//   }
//
//   addFeedCommentReplyApiCall({required onErr, required int index})async{
//     Map<String,dynamic> params = {};
//     params['feed_id'] = postDetail.feedId;
//     params['comment_id'] = postCommentsList[index].mainCommentId;
//     params['comment'] = commentText.value;
//     ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.feedCommentReply,params: params);
//     // isCommentLoaded.value = false;
//     if(response.status == ApiConstant.statusCodeSuccess){
//       fetchPostCommentsApi(page: pageToShow.value);
//       return true;
//     }else{
//       onErr(response.message);
//       return false;
//     }
//   }
//
//   fetchPostCommentsApi({required int page})async{
//     Map<String,dynamic> params = {};
//     params["page"] = page;
//     params["limit"] = pageLimitPagination.value;
//     params['feed_id'] = postDetail.feedId ?? '';
//     ResponseModel<CommentsModel> response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.getComment,params: params);
//     isCommentLoaded.value = true;
//     if(response.status == ApiConstant.statusCodeSuccess){
//       //likesCounters.clear();
//       totalFeedRecord.value = response.data?.totalRecord ?? 0;
//       if(postCommentsList.isEmpty){
//         postCommentsList.value = response.data?.feedComments ?? [];
//         List.generate(postCommentsList.length, (index) => likesCounters.add(postCommentsList[index].likes ?? 0));
//         List.generate(postCommentsList.length, (index) => isLikeFeed.add(postCommentsList[index].likedByUser ?? false));
//         //List.generate(postCommentsList.length, (index) => postCommentsList[index].isReplayShow.add(false));
//       }else{
//         postCommentsList.addAll(response.data?.feedComments ?? []);
//         for (int i = 0; i < (response.data?.feedComments?.length ?? 0); i++) {
//           likesCounters.addAll([response.data?.feedComments?[i].likes ?? 0]);
//         }
//         for (int i = 0; i < (response.data?.feedComments?.length ?? 0); i++) {
//           isLikeFeed.addAll([response.data?.feedComments?[i].likedByUser ?? false]);
//         }
//       }
//
//     }else{
//       // onErr(response.message);
//       SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
//     }
//   }
//
//   /// Feed Comment Like
//
//   feedCommentLikeApi({required int commentId, required onSuccess}) async {
//     Map<String, dynamic> params = {};
//     params['comment_id'] = commentId;
//     ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.feedCommentLike, params: params);
//     if (response.status == ApiConstant.statusCodeSuccess) {
//       onSuccess(response.data['total_likes']);
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   /// Feed Comment unlike
//
//   feedCommentUnlikeApi({required int commentId, required onSuccess}) async {
//     Map<String, dynamic> params = {};
//     params['comment_id'] = commentId;
//     ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.feedCommentUnLike, params: params);
//     if (response.status == ApiConstant.statusCodeSuccess) {
//       onSuccess(response.data['total_likes']);
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//
//   likePostApi({required String feedId, required onSuccess}) async {
//     Map<String, dynamic> params = {};
//     params['feed_id'] = feedId;
//     ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.likePost, params: params);
//     if (response.status == ApiConstant.statusCodeSuccess) {
//       onSuccess(response.data['total_likes']);
//       return true;
//     } else {
//       return false;
//     }
//   }
//   unlikePostApi({required String feedId, required onSuccess}) async {
//     Map<String, dynamic> params = {};
//     params['feed_id'] = feedId;
//     ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.unlikePost, params: params);
//     if (response.status == ApiConstant.statusCodeSuccess) {
//       onSuccess(response.data['total_likes']);
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   // @override
//   // void onInit() {
//   //   // fetchPostCommentsApi(feedId: feedId, onErr: onErr)
//   //   super.onInit();
//   // }
//
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/comments_model.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';

import '../../../../model/bottom_navigation_models/news_feed_models/feed_list_model.dart';
import '../../../../model/response_model/responese_datamodel.dart';
import '../../../../utils/app_common_stuffs/app_logger.dart';

RxList<String> list = <String>['Tops comments', 'Newest comments'].obs;

class PostDetailController extends GetxController {
  var postCommentsList = <CommentListData>[].obs;
  FeedData postDetail = Get.arguments;

  //int likeCounters  = Get.arguments[1];
  //bool isLikedFeed = Get.arguments[2];
  var isCommentLoaded = false.obs;
  var commentText = ''.obs;

  var pageToShow = 1.obs;
  var pageLimitPagination = 3.obs;
  var totalFeedRecord = 0.obs;
  var isAllDataLoaded = false.obs;
  var isReplyComment = false.obs;
  RxString dropdownValue = list.first.obs;

  // var isRCommentReply = false.obs;
  var likesCounters = <int>[].obs;

  var isLikeFeed = <bool>[].obs;

  var replyCommentId = 0.obs;
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
        if (postCommentsList.length != totalFeedRecord.value && isAllDataLoaded.isFalse) {
          isCommentLoaded.value = true;
          pageToShow.value++;
          Logger().i(pageToShow.value);
          fetchPostCommentsApi(page: pageToShow.value);
        } else {
          isAllDataLoaded.value = true;
          Logger().i('All Data Loaded');
        }
      }
    });
    super.onInit();
  }

  ///pagination loader
  paginationLoadData() {
    if (postCommentsList.length.toString() == totalFeedRecord.value.toString()) {
      return true;
    } else {
      return false;
    }
  }

  ///*****AddComment api function*****
  addCommentApiCall({required onErr}) async {
    Map<String, dynamic> params = {};
    params['feed_id'] = postDetail.feedId;
    params['comment'] = commentText.value;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.addComment, params: params);
    // isCommentLoaded.value = false;
    if (response.status == ApiConstant.statusCodeSuccess) {
      postCommentsList.clear();
        fetchPostCommentsApi(page: pageToShow.value);
      return true;
    } else {
      onErr(response.message);
      return false;
    }
  }

  addFeedCommentReplyApiCall({required onErr, required int commentID}) async {
    if (kDebugMode) {
      print("API $commentID");
    }
    Map<String, dynamic> params = {};
    params['feed_id'] = postDetail.feedId;
    params['comment_id'] = commentID;
    params['comment'] = commentText.value;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.feedCommentReply, params: params);
    // isCommentLoaded.value = false;
    if (response.status == ApiConstant.statusCodeSuccess) {
      postCommentsList.clear();
      fetchPostCommentsApi(page: pageToShow.value);
      return true;
    } else {
      onErr(response.message);
      return false;
    }
  }

  fetchPostCommentsApi({required int page}) async {
    // isCommentLoaded.value = false;
    Map<String, dynamic> params = {};
    params["page"] = page;
    params["limit"] = defaultFetchLimit;
    params['feed_id'] = postDetail.feedId ?? '';
    params['sort_comment'] = dropdownValue.value == 'Tops comments' ? 'tops comments' : 'newest comments';
    ResponseModel<FeedCommentsModel> response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.getComment, params: params);
    isCommentLoaded.value = true;
    if (response.status == ApiConstant.statusCodeSuccess) {
      //likesCounters.clear();
      totalFeedRecord.value = response.data?.totalRecord ?? 0;
      if (postCommentsList.isEmpty) {
        postCommentsList.value = response.data?.commentListData ?? [];
        List.generate(postCommentsList.length, (index) {
          likesCounters.add(postCommentsList[index].likes ?? 0);
          List.generate(
              postCommentsList[index].commentReplies?.length ?? 0, (subIndex) => postCommentsList[index].likesReplyCounters.add(postCommentsList[index].commentReplies?[subIndex].repliesLikes ?? 0));
        });
        List.generate(postCommentsList.length, (index) {
          isLikeFeed.add(postCommentsList[index].likedByUser ?? false);
          List.generate(
              postCommentsList[index].commentReplies?.length ?? 0, (subIndex) => postCommentsList[index].isLikeReplyFeed.add(postCommentsList[index].commentReplies?[subIndex].isLikeByYou ?? false));
        });
        Logger().i(likesCounters.length);
      } else {
        postCommentsList.addAll(response.data?.commentListData ?? []);
        for (int i = 0; i < (response.data?.commentListData?.length ?? 0); i++) {
          likesCounters.addAll([response.data?.commentListData?[i].likes ?? 0]);
          for (int j = 0; j < (response.data?.commentListData?[i].commentReplies?.length ?? 0); j++) {
            response.data?.commentListData?[i].likesReplyCounters.addAll([response.data?.commentListData?[i].commentReplies?[j].repliesLikes ?? 0]);
          }
        }
        for (int i = 0; i < (response.data?.commentListData?.length ?? 0); i++) {
          isLikeFeed.addAll([response.data?.commentListData?[i].likedByUser ?? false]);
          for (int j = 0; j < (response.data?.commentListData?[i].commentReplies?.length ?? 0); j++) {
            response.data?.commentListData?[i].isLikeReplyFeed.addAll([response.data?.commentListData?[i].commentReplies?[j].isLikeByYou ?? false]);
          }
        }
      }
    } else {
      // onErr(response.message);
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
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

  likePostApi({required int feedId, required onSuccess}) async {
    Map<String, dynamic> params = {};
    params['feed_id'] = feedId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.likePost, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      return false;
    }
  }

  unlikePostApi({required int feedId, required onSuccess}) async {
    Map<String, dynamic> params = {};
    params['feed_id'] = feedId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.unlikePost, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      onSuccess(response.data['total_likes']);
      return true;
    } else {
      return false;
    }
  }

  /// Report Feed Api

  reportFeedApi({required onError}) async {
    Map<String, dynamic> params = {};
    params['feed_id'] = postDetail.feedId;
    ResponseModel response = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.feedFlag, params: params);
    if (response.status == ApiConstant.statusCodeSuccess) {
      return true;
    } else {
      onError(response.message);
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
    }
  }

// @override
// void onInit() {
//   // fetchPostCommentsApi(feedId: feedId, onErr: onErr)
//   super.onInit();
// }

}
