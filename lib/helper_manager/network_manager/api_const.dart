import 'dart:io';

import 'package:iso_net/main.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/utils/enums_all/enums.dart';
import 'package:tuple/tuple.dart';

import '../../utils/app_common_stuffs/app_logger.dart';

enum ApiType {
  signUp,
  otp,
  resendOtp,
  getCompaniesList,
  getExperienceList,
  signUpStage3,
  login,
  creditRequirementList,
  monthlyRevenueList,
  timeInBusinessList,
  industriesList,
  nsfList,
  stateList,
  maxFundList,
  maxTermLengthList,
  startBuyRatesList,
  maxUpsellPointsList,
  createCompany,
  createCompanyBroker,
  interestChips,
  signUpStage4,
  forgotPassword,
  alreadySubscribed,
  addSubscriptions,

  ///******* News Feed tab api ***********
  feedList,
  feedDetail,
  createFeed,
  feeCategoryList,
  likePost,
  unlikePost,
  addComment,
  getComment,
  userProfile,
  userProfileFeed,
  feedCommentLike,
  feedCommentUnLike,
  feedCommentReply,
  feedFlag,
  feedCommentReplyLike,
  feedCommentReplyUnLike,
  feedDeleteMainComment,
  feedDeleteReplyComment,
  feedDelete,
  companyProfile,
  createCompanyReview,
  companyListReview,
  companyReviewLike,
  companyReviewUnLike,
  companyEmployeeList,

  connectRequest,
  flagUser,
  reportComment,
  loanList,
  createLoan,
  loanApprovalListApi,
  loanApproveRejectApi,
  loanSearch,


  ///******* forums tab api ***********
  forumList,
  forumDetail,
  forumLike,
  forumUnlike,
  forumFlag,
  forumCommentList,
  forumAddComment,
  forumCommentLike,
  forumCommentUnlike,
  forumReplyComment,
  forumReplyCommentLike,
  forumReplyCommentUnlike,
  categoryForumList,
  createForum,
  forumCommentReport,
  forumCommentDelete,
  forumReplyCommentDelete,
  forumDelete,

  ///****** article api *****///
  articleCommentList,
  createArticleComment,
  articleReplyComment,
  articleCommentLike,
  articleCommentUnLike,
  articleReplyCommentLike,
  articleReplyCommentUnLike,
  articleCommentReport,
  articleReport,
  articleLike,
  articleUnLike,
  articleBookmark,
  articleDetailList,
  articleDeleteMainComment,
  articleDeleteReplyComment,
  nextPrevoiusArticleList,
  articleDetail,
  scoreboardTagList,

  ///****Search tab api ******///
  searchApi,
  findFunder,

  ///******Network tab api *****/////
  networkTabApi,
  pendingRequestApi,
  connectSuggestionApi,
  viewMyNetworkApi,
  acceptRequest,
  cancelRequest,

  /// Chat List
  recentChatList,
  deleteGroup,

  ///User Setting profile api's
  myLoanList,
  myFeedList,
  accountUpdate,
  termsPrivacyCms,
  updateCompanyDetails,
  updateCompanyLoanData,
  companyReviewData,
  companyUserData,
  notificationSetting,
  notificationList,
  notificationClear,
  signOut,
  myBookmark,
  myBookmarkNext,
  createChatMedia,
  blockUser,
  unBlockUser,
  blockUserList,
  deleteUser,

  subscription,
  ///********** report api *********////
  reportApi,
  ///********** Search message api *********////
  searchMessage,

}

class ApiParams{
  static const String oneToOne = "ONE_TO_ONE";
  static const String group = "GROUP";
}

class ApiConstant {
  static const int statusCodeSuccess = 200;
  static const int statusCodeCreated = 201;
  static const int statusCodeUnAuthorize = 401;
  static const int statusCodeNotFound = 404;
  static const int statusCodeServiceNotAvailable = 503;
  static const int statusCodeBadGateway = 502;
  static const int statusCodeServerError = 500;

  static const int timeoutDurationNormalAPIs = 30000;

  static const String appleAppSecret = '9020bcc85eec44bb83e6d36b3969172b';

  /// 30 seconds
  static const int timeoutDurationMultipartAPIs = 120000;

  /// 120 seconds

  ///default location
  static double staticLatitude = 33.78151350894746;
  static double staticLongitude = -84.41362900386731;

  static String prefixBaseApp = '/baseapp';
  static String prefixAdminApp = '/adminapp';
  static String prefixAllPostApp = '/allpostapp';

  static String get basDomainLocal => 'http://192.168.2.209:7157';

  static String get baseDomain {
    switch (env) {
      case Environment.local:
        return 'http://192.168.2.209:7157';
      case Environment.dev:
        return 'http://202.131.117.92:7157';
      case Environment.prod:
        return 'https://isonetapi.admindd.com';
      default:
        return "";
    }
  }

  static String get imageBaseDomain {
    switch (env) {
      case Environment.local:
        return 'http://192.168.2.209:7157';
      case Environment.dev:
        return 'http://202.131.117.92:7157';
      case Environment.prod:
        return 'https://storage.googleapis.com/isonet-buket';
      default:
        return "";
    }
  }



  static String getValue(ApiType type) {
    switch (type) {
      case ApiType.signUp:
        return '$prefixBaseApp/user_signup/get_started_stage_1/';
      case ApiType.otp:
        return '$prefixBaseApp/user_signup/otp_stage_2/';
      case ApiType.resendOtp:
        return '$prefixBaseApp/user_signup/resend_OTP/';
      case ApiType.getCompaniesList:
        return '$prefixBaseApp/manage_company/get_company/';
      case ApiType.getExperienceList:
        return '$prefixAdminApp/experience_list';
      case ApiType.signUpStage3:
        return '$prefixBaseApp/user_signup/user_details_stage_3/';
      case ApiType.login:
        return '$prefixBaseApp/mobile_login/';
      case ApiType.creditRequirementList:
        return '$prefixAdminApp/creditscore_list';
      case ApiType.monthlyRevenueList:
        return '$prefixAdminApp/monthlyrevenue_list';
      case ApiType.timeInBusinessList:
        return '$prefixAdminApp/timeinbusiness_list';
      case ApiType.industriesList:
        return '$prefixAdminApp/industries_crud/';
      case ApiType.nsfList:
        return '$prefixAdminApp/nsf_list';
      case ApiType.stateList:
        return '$prefixAdminApp/state_crud/';
      case ApiType.maxFundList:
        return '$prefixAdminApp/fund_crud/';
      case ApiType.maxTermLengthList:
        return '$prefixAdminApp/termlength_crud/';
      case ApiType.startBuyRatesList:
        return '$prefixAdminApp/buyrates_crud/';
      case ApiType.maxUpsellPointsList:
        return '$prefixAdminApp/upsellpoints_crud/';
      case ApiType.createCompany:
        return '$prefixBaseApp/manage_company/create_company/';
      case ApiType.createCompanyBroker:
        return '$prefixBaseApp/manage_company/create_company_broker/';
      case ApiType.interestChips:
        return '$prefixAdminApp/intrestcrud/';
      case ApiType.signUpStage4:
        return '$prefixBaseApp/user_signup/user_profile_pic_stage_4/';
      case ApiType.forgotPassword:
        return '$prefixBaseApp/mobile_login/forgot_password/';
      case ApiType.alreadySubscribed:
        return '$prefixBaseApp/manage_subscription/get_subscription_details/';
      case ApiType.addSubscriptions:
        return '$prefixBaseApp/manage_subscription/create_subscription/';
      case ApiType.feedList:
        return '$prefixBaseApp/manage_feed/list_feed/';
      case ApiType.feedDetail:
        return '$prefixBaseApp/manage_feed/get_secific_feed_detail/';
      case ApiType.createFeed:
        return '$prefixBaseApp/manage_feed/create_feed/';
      case ApiType.feeCategoryList:
        return '$prefixAdminApp/feed_category_crud/feed_category_list/';
      case ApiType.likePost:
        return '$prefixBaseApp/manage_feed/like_feed/';
      case ApiType.unlikePost:
        return '$prefixBaseApp/manage_feed/unlike_feed/';
      case ApiType.addComment:
        return '$prefixBaseApp/manage_comment_reply/create_feed_comment/';
      case ApiType.getComment:
        return '$prefixBaseApp/manage_comment_reply/get_feed_comment_details/';
      case ApiType.userProfile:
        return '$prefixBaseApp/get_user_data/get_user_details/';
      case ApiType.userProfileFeed:
        return '$prefixBaseApp/get_user_data/get_specific_user_feed_list/';
      case ApiType.feedCommentLike:
        return '$prefixBaseApp/manage_comment_reply/feed_comment_like/';
      case ApiType.feedCommentUnLike:
        return '$prefixBaseApp/manage_comment_reply/feed_comment_unlike/';
      case ApiType.feedCommentReply:
        return '$prefixBaseApp/manage_comment_reply/feed_comment_reply/';
      case ApiType.feedFlag:
        return '$prefixBaseApp/manage_feed/flag_feed/';
      case ApiType.feedCommentReplyLike:
        return '$prefixBaseApp/manage_comment_reply/feed_comment_reply_like/';
      case ApiType.feedCommentReplyUnLike:
        return '$prefixBaseApp/manage_comment_reply/feed_comment_reply_unlike/';
      case ApiType.feedDeleteMainComment:
        return '$prefixBaseApp/manage_comment_reply/delete_feed_comment/';
      case ApiType.feedDeleteReplyComment:
        return '$prefixBaseApp/manage_comment_reply/delete_feed_comment_reply/';
      case ApiType.feedDelete:
        return '$prefixBaseApp/manage_feed/delete_feed/';
      case ApiType.loanApprovalListApi:
        return '$prefixBaseApp/manage_loan/loan_approvals/';
      case ApiType.loanApproveRejectApi:
        return '$prefixBaseApp/manage_loan/approve_reject_loan/';


    case ApiType.companyProfile:
        return '$prefixBaseApp/manage_company/get_company_details/';
      case ApiType.createCompanyReview:
        return '$prefixBaseApp/manage_company_review/create_company_review/';
      case ApiType.companyListReview:
        return '$prefixBaseApp/manage_company_review/list_review/';
      case ApiType.companyReviewLike:
        return '$prefixBaseApp/manage_company/company_review_like/';
      case ApiType.companyReviewUnLike:
        return '$prefixBaseApp/manage_company/company_review_unlike/';
      case ApiType.companyEmployeeList:
        return '$prefixBaseApp/manage_company/get_company_employee/';
      case ApiType.connectRequest:
        return '$prefixBaseApp/manage_connection/send_connection_request/';
      case ApiType.flagUser:
        return '$prefixBaseApp/manage_users/flag_user/';
      case ApiType.reportComment:
        return '$prefixBaseApp/manage_comment_reply/report_feed_comment/';

      ///******Forum Tab Apis******///
      case ApiType.forumList:
        return '$prefixAllPostApp/manage_forum/list_forum/';
      case ApiType.forumDetail:
        return '$prefixAllPostApp/manage_forum/get_secific_forum_detail/';
      case ApiType.forumLike:
        return '$prefixAllPostApp/manage_forum/like_forum/';
      case ApiType.forumUnlike:
        return '$prefixAllPostApp/manage_forum/dislike_forum/';
      case ApiType.forumFlag:
        return '$prefixAllPostApp/manage_forum/flag_forum/';
      case ApiType.forumCommentList:
        return '$prefixAllPostApp/manage_forum/get_forum_comment_list/';
      case ApiType.forumAddComment:
        return '$prefixAllPostApp/manage_comment_forum/create_forum_comment/';
      case ApiType.forumCommentLike:
        return '$prefixAllPostApp/manage_comment_forum/forum_comment_like/';
      case ApiType.forumCommentUnlike:
        return '$prefixAllPostApp/manage_comment_forum/forum_comment_unlike/';
      case ApiType.forumReplyComment:
        return '$prefixAllPostApp/manage_comment_forum/forum_comment_reply/';
      case ApiType.forumReplyCommentLike:
        return '$prefixAllPostApp/manage_comment_forum/forum_comment_reply_like/';
      case ApiType.forumReplyCommentUnlike:
        return '$prefixAllPostApp/manage_comment_forum/forum_comment_reply_unlike/';
      case ApiType.categoryForumList:
        return '$prefixAllPostApp/manage_forum/list_category_forum/';
      case ApiType.createForum:
        return '$prefixAllPostApp/manage_forum/create_forum/';
      case ApiType.forumCommentReport:
        return '$prefixAllPostApp/manage_comment_forum/report_forum_comment/';
      case ApiType.forumCommentDelete:
        return '$prefixAllPostApp/manage_comment_forum/delete_forum_comment/';
      case ApiType.forumReplyCommentDelete:
        return '$prefixAllPostApp/manage_comment_forum/delete_forum_comment_reply/';
      case ApiType.forumDelete:
        return '$prefixAllPostApp/manage_forum/delete_forum/';

      ///*****article api******/
      case ApiType.articleCommentList:
        return '$prefixAdminApp/article_comment/get_article_comment_details/';
      case ApiType.createArticleComment:
        return '$prefixBaseApp/manage_article_comment/create_article_comment/';
      case ApiType.articleReplyComment:
        return '$prefixBaseApp/manage_article_comment/article_comment_reply/';
      case ApiType.articleCommentLike:
        return '$prefixBaseApp/manage_article_comment/article_comment_like/';
      case ApiType.articleCommentUnLike:
        return '$prefixBaseApp/manage_article_comment/article_comment_unlike/';
      case ApiType.articleReplyCommentLike:
        return '$prefixBaseApp/manage_article_comment/article_comment_reply_like/';
      case ApiType.articleReplyCommentUnLike:
        return '$prefixBaseApp/manage_article_comment/article_comment_reply_unlike/';
      case ApiType.articleCommentReport:
        return '$prefixBaseApp/manage_article_comment/report_article_comment/';
      case ApiType.articleReport:
        return '$prefixBaseApp/manage_article/report_article/';
      case ApiType.articleLike:
        return '$prefixBaseApp/manage_article/like_article/';
      case ApiType.articleUnLike:
        return '$prefixBaseApp/manage_article/unlike_article/';
      case ApiType.articleBookmark:
        return '$prefixBaseApp/manage_article/article_bookmark/';
      case ApiType.articleDeleteMainComment:
        return '$prefixAdminApp/article_comment_delete/delete_article_comment/';
      case ApiType.articleDeleteReplyComment:
        return '$prefixAdminApp/article_comment_delete/delete_article_comment_reply/';

      case ApiType.loanList:
        return '$prefixBaseApp/manage_loan/list_loan/';
      case ApiType.articleDetailList:
        return '$prefixBaseApp/manage_article/list_article/';
      case ApiType.nextPrevoiusArticleList:
        return '$prefixBaseApp/manage_article/next_article/';
      case ApiType.articleDetail:
        return '$prefixBaseApp/manage_article/get_article_details/';
      case ApiType.scoreboardTagList:
        return '$prefixAdminApp/loan_tag_crud/';
      case ApiType.createLoan:
        return '$prefixBaseApp/manage_loan/create_loan/';
      case ApiType.loanSearch:
        return '$prefixAdminApp/searchresult/loan_search/';

      ///*****Search Api *******///
      case ApiType.searchApi:
        return '$prefixAdminApp/searchresult/get_queryset/';
      case ApiType.findFunder:
        return '$prefixBaseApp/find_funder/find_a_funder/';

      ///*****Network Api *******///
      case ApiType.networkTabApi:
        return '$prefixBaseApp/manage_connection/network_page/';
      case ApiType.pendingRequestApi:
        return '$prefixBaseApp/manage_connection/my_pending_requests/';
      case ApiType.connectSuggestionApi:
        return '$prefixBaseApp/manage_connection/connection_suggestion/';
      case ApiType.viewMyNetworkApi:
        return '$prefixBaseApp/manage_connection/my_network/';
      case ApiType.acceptRequest:
        return '$prefixBaseApp/manage_connection/accept_connection_request/';
      case ApiType.cancelRequest:
        return '$prefixBaseApp/manage_connection/cancel_connection_request/';

      case ApiType.recentChatList:
        return '$prefixBaseApp/manage_chat/recent_chat_all/';
      case ApiType.deleteGroup:
        return '$prefixBaseApp/manage_chat/delete_group/';
      case ApiType.myLoanList:
        return '$prefixBaseApp/get_user_data/get_specific_user_loans/';
      case ApiType.myFeedList:
        return '$prefixBaseApp/get_user_data/get_specific_user_feed_list/';
      case ApiType.accountUpdate:
        return '$prefixAdminApp/data_update/update_profile/';
      case ApiType.termsPrivacyCms:
        return '$prefixAdminApp/mobile_cms/cms_list/';
      case ApiType.updateCompanyDetails:
        return '$prefixAdminApp/data_update/update_company_data/';
      case ApiType.companyReviewData:
        return '$prefixAdminApp/data_update/company_review_data/';
      case ApiType.companyUserData:
        return '$prefixAdminApp/data_update/company_user_data/';
      case ApiType.updateCompanyLoanData:
        return '$prefixAdminApp/data_update/update_loan_data/';
      case ApiType.notificationSetting:
        return '$prefixBaseApp/notification/notification_setting/';
      case ApiType.notificationList:
        return '$prefixBaseApp/notification/notification_listing/';
      case ApiType.notificationClear:
        return '$prefixBaseApp/notification/clear_notification/';
      case ApiType.myBookmark:
        return '$prefixBaseApp/manage_article/bookmark_lisitng/';
      case ApiType.myBookmarkNext:
        return '$prefixBaseApp/manage_article/bookmark_next_article/';
        case ApiType.createChatMedia:
        return '$prefixBaseApp/manage_chat/create_chat_media/';
      case ApiType.blockUser:
        return '$prefixBaseApp/manage_users/block_user/';
      case ApiType.unBlockUser:
        return '$prefixBaseApp/manage_users/unblock_user/';
      case ApiType.blockUserList:
        return '$prefixBaseApp/manage_users/my_block_user_list/';
      case ApiType.deleteUser:
        return '$prefixAdminApp/user_management/${userSingleton.id}/';


        ///******Report Api ***///
      case ApiType.reportApi:
        return '$prefixBaseApp/manage_report/report/';

      case ApiType.subscription:
        return '$prefixBaseApp/manage_subscription/get_all_plans/';

      case ApiType.signOut:
        return '$prefixAdminApp/logout/';

        ///***** Search Message *******///
      case ApiType.searchMessage:
        if(env == Environment.prod){
          return 'https://isonetchat.admindd.com/v3/auth/search_message';

        }else{
          return 'http://202.131.117.92:7160/v3/auth/search_message';
        }

    }
  }

  static Tuple4<String, Map<String, String>, Map<String, dynamic>, List<AppMultiPartFile>> requestParamsForSync(
    ApiType type, {
    Map<String, dynamic>? params,
    List<AppMultiPartFile> arrFile = const [],
    String? urlParams,
  }) {
    //String apiUrl = ApiConstant.basDomainLocal + ApiConstant.getValue(type);

    String apiUrl = ApiConstant.getValue(type) == ApiConstant.getValue(ApiType.searchMessage) ? ApiConstant.getValue(type) : ApiConstant.baseDomain + ApiConstant.getValue(type);

    if (urlParams != null) apiUrl = apiUrl + urlParams;

    Map<String, dynamic> paramsFinal = params ?? <String, dynamic>{};

    Map<String, String> headers = <String, String>{};
    if ((userSingleton.token ?? '').isNotEmpty) {
      headers['Authorization'] = 'Token ${userSingleton.token ?? ''}';
    }
/*
    if (type == ApiType.home) {
      Map<String, String> extraHeader = {"language": "en"};
      headers.addAll(extraHeader);
    }*/

    Logger().d("Request Url :: $apiUrl");
    Logger().d("Request Params :: $paramsFinal");
    Logger().d("Request headers :: $headers");

    return Tuple4(apiUrl, headers, paramsFinal, arrFile);
  }
}

class AppMultiPartFile {
  List<File>? localFiles;
  String? key;

  AppMultiPartFile({this.localFiles, this.key});

  AppMultiPartFile.fromType({this.localFiles, this.key});
}
