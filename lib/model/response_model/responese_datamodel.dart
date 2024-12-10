import 'package:iso_net/model/bottom_navigation_models/chat_model/chat_media_model.dart';
import 'package:iso_net/model/bottom_navigation_models/chat_model/one_to_one_chat_model.dart';
import 'package:iso_net/model/bottom_navigation_models/chat_model/recent_chat_model.dart';
import 'package:iso_net/model/bottom_navigation_models/forum_models/forum_list_model.dart';
import 'package:iso_net/model/bottom_navigation_models/network_model/network_tab_model.dart';
import 'package:iso_net/model/bottom_navigation_models/network_model/pending_suggetsion_request_model.dart';
import 'package:iso_net/model/bottom_navigation_models/network_model/viewmy_network_model.dart';
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/comments_model.dart';
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/company_profile_model.dart';
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/feed_category_model.dart';
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/feed_list_model.dart';
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/loan_list_model.dart';
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/specific_userfeed_model.dart';
import 'package:iso_net/model/bottom_navigation_models/search_model/global_search_model.dart';
import 'package:iso_net/model/dropdown_models/get_companies_list_model.dart';
import 'package:iso_net/model/dropdown_models/userdetail_dropdown_model.dart';
import 'package:iso_net/model/interest_chips_model.dart';
import 'package:iso_net/model/my_profile/bookmark_model.dart';
import 'package:iso_net/model/my_profile/my_profile_model.dart';
import 'package:iso_net/model/my_profile/notification_list_model.dart';
import 'package:iso_net/model/subscribtion_plan_model.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import '../bottom_navigation_models/comment_model.dart';
import '../bottom_navigation_models/news_feed_models/article_bookmark_model.dart';
import '../bottom_navigation_models/news_feed_models/article_detail_model.dart';
import '../bottom_navigation_models/news_feed_models/display_next_article_model.dart';
import '../bottom_navigation_models/news_feed_models/my_feed_profile_list.dart';
import '../bottom_navigation_models/news_feed_models/my_loan_list_model.dart';
import '../bottom_navigation_models/news_feed_models/setting_model/company_user_data_model.dart';
import '../bottom_navigation_models/search_model/company_review_setting_model.dart';
import '../bottom_navigation_models/search_model/findfunder_model.dart';
import '../dropdown_models/loan_preferences_models.dart';
import '../my_profile/block_connection_model.dart';
import '../my_profile/notification_setting_model.dart';
import '../my_profile/terms_privacy_model.dart';
import '../user_profile_model.dart';

class ResponseModel<T> {
  ResponseModel({required this.status, required this.message, this.data});

  late int status;
  late String message;
  T? data;

  ResponseModel.fromJson(Map<String, dynamic> json, int? statusCode) {
    status = json['status'];
    message = json['message'];

    data = (json['data'] == null || json['data'].length == 0)
        ? null
        : _handleClass(
            json['data'],
          );
  }

  T _handleClass(json) {
    if (T == UserModel) {
      return UserModel.fromJson(json) as T;
    } else if (T == List<GetCompaniesListModel>) {
      List tempList = <GetCompaniesListModel>[];
      if (json != null) {
        for (int i = 0; i < json.length; i++) {
          tempList.add(GetCompaniesListModel.fromJson(json[i]));
        }
      }
      return tempList as T;
    }else if(T == GetCompaniesListModel){
      return GetCompaniesListModel.fromJson(json) as T;
    } else if (T == List<ExperienceDropDownModel>) {
      List experienceDropDownList = <ExperienceDropDownModel>[];
      if (json != null) {
        for (int i = 0; i < json.length; i++) {
          experienceDropDownList.add(ExperienceDropDownModel.fromJson(json[i]));
        }
      }
      return experienceDropDownList as T;
    } else if (T == List<CreditRequirementModel>) {
      List creditReqList = <CreditRequirementModel>[];
      if (json != null) {
        for (int i = 0; i < json.length; i++) {
          creditReqList.add(CreditRequirementModel.fromJson(json[i]));
        }
      }
      return creditReqList as T;
    } else if (T == List<MinimumMonthRevenueListModel>) {
      List monthlyRevenueList = <MinimumMonthRevenueListModel>[];
      if (json != null) {
        for (int i = 0; i < json.length; i++) {
          monthlyRevenueList.add(MinimumMonthRevenueListModel.fromJson(json[i]));
        }
      }
      return monthlyRevenueList as T;
    } else if (T == List<MinimumTimeListModel>) {
      List minTimeList = <MinimumTimeListModel>[];
      if (json != null) {
        for (int i = 0; i < json.length; i++) {
          minTimeList.add(MinimumTimeListModel.fromJson(json[i]));
        }
      }
      return minTimeList as T;
    } else if (T == List<GetAllIndustryListModel>) {
      List getAllIndustry = <GetAllIndustryListModel>[];
      if (json != null) {
        for (int i = 0; i < json.length; i++) {
          getAllIndustry.add(GetAllIndustryListModel.fromJson(json[i]));
        }
      }
      return getAllIndustry as T;
    } else if (T == List<MinimumNSFListModel>) {
      List nsfList = <MinimumNSFListModel>[];
      if (json != null) {
        for (int i = 0; i < json.length; i++) {
          nsfList.add(MinimumNSFListModel.fromJson(json[i]));
        }
      }
      return nsfList as T;
    } else if (T == List<GetStatesListModel>) {
      List getAllStates = <GetStatesListModel>[];
      if (json != null) {
        for (int i = 0; i < json.length; i++) {
          getAllStates.add(GetStatesListModel.fromJson(json[i]));
        }
      }
      return getAllStates as T;
    } else if (T == List<MaxFundingAmountListModel>) {
      List maxFundAmountList = <MaxFundingAmountListModel>[];
      if (json != null) {
        for (int i = 0; i < json.length; i++) {
          maxFundAmountList.add(MaxFundingAmountListModel.fromJson(json[i]));
        }
      }
      return maxFundAmountList as T;
    } else if (T == List<MaxTermLengthListModel>) {
      List maxTermLengthList = <MaxTermLengthListModel>[];
      if (json != null) {
        for (int i = 0; i < json.length; i++) {
          maxTermLengthList.add(MaxTermLengthListModel.fromJson(json[i]));
        }
      }
      return maxTermLengthList as T;
    } else if (T == List<StartingBuyRatesListModel>) {
      List buyingRateList = <StartingBuyRatesListModel>[];
      if (json != null) {
        for (int i = 0; i < json.length; i++) {
          buyingRateList.add(StartingBuyRatesListModel.fromJson(json[i]));
        }
      }
      return buyingRateList as T;
    } else if (T == List<MaxUpSellPointsListModel>) {
      List maxUpSellList = <MaxUpSellPointsListModel>[];
      if (json != null) {
        for (int i = 0; i < json.length; i++) {
          maxUpSellList.add(MaxUpSellPointsListModel.fromJson(json[i]));
        }
      }
      return maxUpSellList as T;
    } else if (T == List<InterestChipListModel>) {
      List interestChipsList = <InterestChipListModel>[];
      if (json != null) {
        for (int i = 0; i < json.length; i++) {
          interestChipsList.add(InterestChipListModel.fromJson(json[i]));
        }
      }
      return interestChipsList as T;
    } else if (T == FeedListModel) {
      return FeedListModel.fromJson(json) as T;
    }else if (T == FeedData) {
      return FeedData.fromJson(json) as T;
    }else if (T == UserFeedList) {
      return UserFeedList.fromJson(json) as T;
    } else if (T == FeedCategoryModel) {
      return FeedCategoryModel.fromJson(json) as T;
    } else if (T == FeedCommentsModel) {
      return FeedCommentsModel.fromJson(json) as T;
    }else if (T == FeedCommentModel) {
      return FeedCommentModel.fromJson(json) as T;
    } else if (T == UserProfileData) {
      return UserProfileData.fromJson(json) as T;
    } else if (T == UserProfileFeedModel) {
      return UserProfileFeedModel.fromJson(json) as T;
    } else if (T == CompanyProfileModel) {
      return CompanyProfileModel.fromJson(json) as T;
    } else if (T == CompanyReviewModel) {
      return CompanyReviewModel.fromJson(json) as T;
    } else if (T == CompanyEmployeeModel) {
      return CompanyEmployeeModel.fromJson(json) as T;
    } else if (T == ForumListModel) {
      return ForumListModel.fromJson(json) as T;
    }else if (T == ForumData) {
      return ForumData.fromJson(json) as T;
    } else if (T == ForumCommentModel) {
      return ForumCommentModel.fromJson(json) as T;
    } else if (T == ArticleCommentModel) {
      return ArticleCommentModel.fromJson(json) as T;
    } else if (T == LoanListModel) {
      return LoanListModel.fromJson(json) as T;
    }else if (T == LoanApprovalModel) {
      return LoanApprovalModel.fromJson(json) as T;
    } else if (T == ArticleBookMarkModel) {
      return ArticleBookMarkModel.fromJson(json) as T;
    } else if (T == ArticleDetailListModel) {
      return ArticleDetailListModel.fromJson(json) as T;
    }
    // else if (T == List<GlobalSearchData>) {
    //   List searchList = <GlobalSearchData>[];
    //   if (json != null) {
    //     for (int i = 0; i < json.length; i++) {
    //       searchList.add(GlobalSearchData.fromJson(json[i]));
    //     }
    //   }
    //   return searchList as T;
    // }
    else if(T == GlobalSearch){
      return GlobalSearch.fromJson(json) as T;
    }
    else if (T == FindFunderModel) {
      return FindFunderModel.fromJson(json) as T;
    } else if (T == NextPreviousArticleModel) {
      return NextPreviousArticleModel.fromJson(json) as T;
    } else if (T == List<TagDetails>) {
      List interestChipsList = <TagDetails>[];
      if (json != null) {
        for (int i = 0; i < json.length; i++) {
          interestChipsList.add(TagDetails.fromJson(json[i]));
        }
      }
      return interestChipsList as T;
    }else if (T == NetworkTabModel){
      return NetworkTabModel.fromJson(json) as T;
    }else if (T == PendingRequestModel){
      return PendingRequestModel.fromJson(json) as T;
    }else if (T == ConnectionSuggestionModel){
      return ConnectionSuggestionModel.fromJson(json) as T;
    }else if (T == ViewMyNetworkModel){
      return ViewMyNetworkModel.fromJson(json) as T;
    } else if (T == MyLoanListModel) {
      return MyLoanListModel.fromJson(json) as T;
    } else if (T == MyFeedProfileList) {
      return MyFeedProfileList.fromJson(json) as T;
    }else if (T == MyProfileModel) {
      return MyProfileModel.fromJson(json) as T;
    }else if (T == CompanyUserDataModel) {
      return CompanyUserDataModel.fromJson(json) as T;
    }else if (T == CompanySettingModel) {
      return CompanySettingModel.fromJson(json) as T;
    }else if(T == NotificationSettingModel){
      return NotificationSettingModel.fromJson(json) as T;
    }else if(T == NotificationListModel){
      return NotificationListModel.fromJson(json) as T;
    }else if(T == BookMarkListModel){
      return BookMarkListModel.fromJson(json) as T;
    }else if(T == BookMarkDetailModel){
      return BookMarkDetailModel.fromJson(json) as T;
    }else if(T == TermsPrivacyModel){
      return TermsPrivacyModel.fromJson(json) as T;
    } else if (T == List<MediaData>) {
      List chatMediaList = <MediaData>[];
      if (json != null) {
        for (int i = 0; i < json.length; i++) {
          chatMediaList.add(MediaData.fromJson(json[i]));
        }
      }
      return chatMediaList as T;
    }else if (T == List<SubscribtionPlanModel>) {
      List subscribtionPlanModel = <SubscribtionPlanModel>[];
      if (json != null) {
        for (int i = 0; i < json.length; i++) {
          subscribtionPlanModel.add(SubscribtionPlanModel.fromJson(json[i]));
        }
      }
      return subscribtionPlanModel as T;
    }else if (T == BlockConnectionModel) {
      return BlockConnectionModel.fromJson(json) as T;
    }else if (T == ChatDataa) {
      return ChatDataa.fromJson(json) as T;
    }else if (T == MessageHistoryData) {
      return MessageHistoryData.fromJson(json) as T;
    }else if (T == ChatListData) {
      return ChatListData.fromJson(json) as T;
    } else if (T == HistoryDetails) {
      return HistoryDetails.fromJson(json) as T;
    }else {
      return json;
    }
  }
}
