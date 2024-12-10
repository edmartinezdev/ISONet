import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/feed_list_model.dart';

import '../utils/date_util.dart';

class UserProfileData {
  int? userId;
  String? firstName;
  String? lastName;
  String? profileImg;
  String? backgroundImg;
  String? companyName;
  String? bio;
  bool? isCompanyDeleted;
  bool? isVerified;
  String? userType;
  int? following;
  int? companyId;
  String? connectionStatus;
  bool? isBlockByYou;
  var isConnected = ''.obs;
  List<FeedData>? userFeedList;

  UserProfileData({
    this.userId,
    this.firstName,
    this.lastName,
    this.profileImg,
    this.companyName,
    this.companyId,
    this.bio,
    this.backgroundImg,
    this.isCompanyDeleted,
    this.following,
    this.connectionStatus,
    this.isVerified,
    this.userType
  });

  UserProfileData.fromJson(Map<String, dynamic> json) {
    userId = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImg = json['profile_img'];
    backgroundImg = json['background_img'];
    companyName = json['company_name'];
    companyId = json['company_id'];
    bio = json['bio'];
    isCompanyDeleted = json['company_is_deleted'];
    isVerified = json['is_verified'];
    userType= json['user_type'];
    following = json['following'];
    connectionStatus = json['connection_status'];
    isConnected.value = json['connection_status'];
    isBlockByYou = json['is_blocked_by_you'];
    if (json['feed_list'] != null) {
      userFeedList = <FeedData>[];
      json['feed_list'].forEach((v) {
        userFeedList!.add(FeedData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['profile_img'] = profileImg;
    data['background_img'] = backgroundImg;
    data['company_name'] = companyName;
    data['company_id'] = companyId;
    data['company_is_deleted'] = isCompanyDeleted;
    data['following'] = following;
    if (userFeedList != null) {
      data['feed_list'] = userFeedList!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

/*class UserProfileModel{
  User? user;
  List<UserFeedList>? userFeedList;

  UserProfileModel({this.user,this.userFeedList});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    user = json['data'] != null ? User.fromJson(json['data']) : null;
    if (json['feed_list'] != null) {
      userFeedList = <UserFeedList>[];
      json['feed_list'].forEach((v) {
        userFeedList!.add(UserFeedList.fromJson(v));
      });
    }

  }

  Map<String,dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (userFeedList != null) {
      data['feed_list'] = userFeedList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}*/

class UserFeedList {
  int? feedId;
  User? user;
  String? description;

  int? likes;
  int? comment;
  List<FeedMedia>? feedMedia;
  String? postedAt;
  String? updatedAt;
  bool? likedByUser;
  RxBool showMore = false.obs;
  RxBool isLiked = false.obs;
  var likesCounters = 0.obs;
  var isLikeFeed = false.obs;

  String get getHoursAgo {
    if (postedAt != null || postedAt?.isNotEmpty == true) {
      return DateUtil.getLeftTime(postedAt ?? '');
    } else {
      return "";
    }
  }

  UserFeedList({this.feedId, this.user, this.description, this.likes, this.comment, this.feedMedia, this.postedAt, this.updatedAt, this.likedByUser});

  UserFeedList.fromJson(Map<String, dynamic> json) {
    feedId = json['feed_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    description = json['description'];

    likes = json['likes'];
    comment = json['comment'];
    if (json['feed_media'] != null) {
      feedMedia = <FeedMedia>[];
      json['feed_media'].forEach((v) {
        feedMedia!.add(FeedMedia.fromJson(v));
      });
    }
    postedAt = json['posted_at'];
    updatedAt = json['updated_at'];
    likedByUser = json['is_like_by_you'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['feed_id'] = feedId;
    data['user'] = user;
    data['description'] = description;

    data['likes'] = likes;
    data['comment'] = comment;
    if (feedMedia != null) {
      data['feed_media'] = feedMedia!.map((v) => v.toJson()).toList();
    }
    data['posted_at'] = postedAt;
    data['updated_at'] = updatedAt;
    data['is_like_by_you'] = likedByUser;
    return data;
  }
}
