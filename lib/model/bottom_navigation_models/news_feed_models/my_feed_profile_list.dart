import '../../../utils/date_util.dart';

class MyFeedProfileList {
  int? totalRecord;
  int? filterRecord;
  List<UserFeedListData>? userFeedList;

  MyFeedProfileList({this.totalRecord, this.filterRecord, this.userFeedList});

  MyFeedProfileList.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    filterRecord = json['filter_record'];
    if (json['user_feed_list'] != null) {
      userFeedList = <UserFeedListData>[];
      json['user_feed_list'].forEach((v) {
        userFeedList!.add(UserFeedListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_record'] = totalRecord;
    data['filter_record'] = filterRecord;
    if (userFeedList != null) {
      data['user_feed_list'] =
          userFeedList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserFeedListData {
  int? feedId;
  User? user;
  String? description;
  int? feedCategoryId;
  bool? isLikeByYou;
  int? likes;
  int? comment;
  List<FeedMedia>? feedMedia;
  String? postedAt;
  String? updatedAt;
  String get getHoursAgo {
    if (postedAt != null || postedAt?.isNotEmpty == true) {
      return DateUtil.getLeftTime(postedAt ?? '');
    } else {
      return "";
    }
  }

  UserFeedListData(
      {this.feedId,
        this.user,
        this.description,
        this.feedCategoryId,
        this.isLikeByYou,
        this.likes,
        this.comment,
        this.feedMedia,
        this.postedAt,
        this.updatedAt});

  UserFeedListData.fromJson(Map<String, dynamic> json) {
    feedId = json['feed_id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    description = json['description'];
    feedCategoryId = json['feed_category_id'];
    isLikeByYou = json['is_like_by_you'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['feed_id'] = feedId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['description'] = description;
    data['feed_category_id'] = feedCategoryId;
    data['is_like_by_you'] = isLikeByYou;
    data['likes'] = likes;
    data['comment'] = comment;
    if (feedMedia != null) {
      data['feed_media'] = feedMedia!.map((v) => v.toJson()).toList();
    }
    data['posted_at'] = postedAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class User {
  int? userId;
  String? firstName;
  String? lastName;
  int? following;
  String? profileImg;
  String? backgroundImg;
  String? companyName;
  int? companyId;
  String? connectionStatus;

  User(
      {this.userId,
        this.firstName,
        this.lastName,
        this.following,
        this.profileImg,
        this.backgroundImg,
        this.companyName,
        this.companyId,
        this.connectionStatus});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    following = json['following'];
    profileImg = json['profile_img'];
    backgroundImg = json['background_img'];
    companyName = json['company_name'];
    companyId = json['company_id'];
    connectionStatus = json['connection_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['following'] = following;
    data['profile_img'] = profileImg;
    data['background_img'] = backgroundImg;
    data['company_name'] = companyName;
    data['company_id'] = companyId;
    data['connection_status'] = connectionStatus;
    return data;
  }
}

class FeedMedia {
  int? id;
  String? mediaType;
  String? feedMedia;
  String? thumbnail;
  String? createdAt;
  String? updatedAt;

  FeedMedia(
      {this.id,
        this.mediaType,
        this.feedMedia,
        this.thumbnail,
        this.createdAt,
        this.updatedAt});

  FeedMedia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mediaType = json['media_type'];
    feedMedia = json['feed_media'];
    thumbnail = json['thumbnail'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['media_type'] = mediaType;
    data['feed_media'] = feedMedia;
    data['thumbnail'] = thumbnail;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}