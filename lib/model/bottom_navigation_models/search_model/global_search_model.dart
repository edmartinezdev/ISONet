import 'package:get/get.dart';

import '../forum_models/forum_list_model.dart';
import '../news_feed_models/feed_list_model.dart';

class GlobalSearch {
  int? totalRecord;
  int? filterRecord;
  List<GlobalForumFeedArticle>? globalForumFeedArticle;

  GlobalSearch({
    this.totalRecord,
    this.filterRecord,
  });

  GlobalSearch.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    filterRecord = json['filter_record'];
    if (json['data'] != null) {
      globalForumFeedArticle = <GlobalForumFeedArticle>[];
      json['data'].forEach((v) {
        globalForumFeedArticle?.add(GlobalForumFeedArticle.fromJson(v));
      });
    }
  }
}

class GlobalForumFeedArticle {
  String? feedType;
  Rxn<FeedData> feedData = Rxn();
  Rxn<ForumData> forumData = Rxn();

  GlobalSearchData? globalSearchData;

  GlobalForumFeedArticle({
    this.feedType,
    this.globalSearchData,
  });

  GlobalForumFeedArticle.fromJson(Map<String, dynamic> json) {
    feedType = json['feed_type'];
    if (feedType == 'Post' || feedType == 'Article') {
      feedData.value = FeedData.fromJson(json);
    } else if (feedType == 'Forum') {
      forumData.value = ForumData.fromJson(json);
    } else {
      globalSearchData = GlobalSearchData.fromJson(json);
    }
  }
}

class GlobalSearchData {
  int? userId;
  String? firstName;
  String? lastName;
  String? profileImg;
  String? backgroundImg;
  String? companyName;
  int? following;
  bool? isVerified;
  String? userType;
  int? companyId;
  String? connectionStatus;
  RxString isConnected = ''.obs;
  int? id;
  int? totalReviews;
  String? address;
  String? companyImage;
  bool? isCompany;

  GlobalSearchData({
    this.userId,
    this.firstName,
    this.lastName,
    this.profileImg,
    this.companyName,
    this.companyId,
    this.backgroundImg,
    this.following,
    this.isVerified,
    this.userType,
    this.connectionStatus,
    this.id,
    this.totalReviews,
    this.address,
    this.companyImage,
    this.isCompany,
  });

  GlobalSearchData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImg = json['profile_img'];
    backgroundImg = json['background_img'];
    companyName = json['company_name'];
    companyId = json['company_id'];
    following = json['following'];
    isVerified = json['is_verified'];
    userType = json['user_type'];
    connectionStatus = json['connection_status'];
    if (connectionStatus != null) {
      isConnected.value = json['connection_status'];
    }

    id = json['id'];
    totalReviews = json['total_reviews'];
    address = json['address'];
    isCompany = json['is_company'];
    companyImage = json['company_image'];
  }
}


