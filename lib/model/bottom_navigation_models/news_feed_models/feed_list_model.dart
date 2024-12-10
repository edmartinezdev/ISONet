import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';

import '../../../utils/date_util.dart';

class FeedListModel {
  int? totalRecord;
  int? filterRecord;
  List<FeedData>? feedData;

  FeedListModel({this.totalRecord, this.filterRecord, this.feedData});

  FeedListModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    filterRecord = json['filter_record'];
    if (json['feed_data'] != null) {
      feedData = <FeedData>[];
      json['feed_data'].forEach((v) {
        feedData!.add(FeedData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_record'] = totalRecord;
    data['filter_record'] = filterRecord;
    if (feedData != null) {
      data['feed_data'] = feedData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeedData {
  User? user;
  String? feedType;
  int? feedId;
  String? description;
  int? likes;
  int? comment;
  int? articleId;
  int? currentPage;
  List<FeedMedia>? feedMedia;
  List<ArticleMedia>? article;
  List<ReportedBy>? reportedBy;
  String? articleTitle;
  String? articleAuthorName;
  String? postedAt;
  String? updatedAt;
  bool? likedByUser;
  RxBool showMore = false.obs;
  var likesCounters = 0.obs;
  var commentCounter = 0.obs;
  var isLikeFeed = false.obs;
  var isOnImageTap = false.obs;

  String get getHoursAgo {
    if (postedAt != null || postedAt?.isNotEmpty == true) {
      return DateUtil.getLeftTime(postedAt ?? '');
    } else {
      return "";
    }
  }

  FeedData(
      {this.user,
      this.feedType,
      this.feedId,
      this.description,
      this.likes,
      this.comment,
      this.feedMedia,
      this.article,
      this.articleAuthorName,
      this.articleTitle,
      this.reportedBy,
      this.postedAt,
      this.updatedAt,
      this.likedByUser,
      this.currentPage,
      this.articleId});

  FeedData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;

    feedType = json['feed_type'];
    feedId = json['feed_id'];
    description = json['description'];

    likes = json['likes'];
    likesCounters.value = json['likes'];
    comment = json['comment'];
    commentCounter.value = json['comment'];
    currentPage = json['current_page'];
    if (json['feed_media'] != null) {
      feedMedia = <FeedMedia>[];
      json['feed_media'].forEach((v) {
        feedMedia!.add(FeedMedia.fromJson(v));
      });
    }
    if (json['article_media'] != null) {
      article = <ArticleMedia>[];
      json['article_media'].forEach((v) {
        article!.add(ArticleMedia.fromJson(v));
      });
    }
    if (json['reported_by'] != null) {
      reportedBy = <ReportedBy>[];
      json['reported_by'].forEach((v) {
        reportedBy!.add(ReportedBy.fromJson(v));
      });
    }
    articleTitle = json['title'];
    articleAuthorName = json['author_name'];
    postedAt = json['posted_at'];
    updatedAt = json['updated_at'];
    likedByUser = json['is_like_by_you'];
    isLikeFeed.value = json['is_like_by_you'];
    articleId = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['feed_type'] = feedType;
    data['feed_id'] = feedId;
    data['description'] = description;

    data['likes'] = likes;
    data['comment'] = comment;
    if (feedMedia != null) {
      data['feed_media'] = feedMedia!.map((v) => v.toJson()).toList();
    }
    if (article != null) {
      data['article_media'] = article!.map((v) => v.toJson()).toList();
    }
    if (reportedBy != null) {
      data['reported_by'] = reportedBy!.map((v) => v.toJson()).toList();
      data['reported_by'] = reportedBy;
    }
    data['posted_at'] = postedAt;
    data['updated_at'] = updatedAt;
    data['is_like_by_you'] = likedByUser;
    data['id'] = articleId;
    return data;
  }
}

class User {
  int? userId;
  String? firstName;
  String? lastName;
  String? profileImg;
  String? backgroundImg;
  String? companyName;
  int? following;
  int? companyId;
  bool? isAdmin;
  String? connectionStatus;
  bool? isVerified;
  String? userType;
  var isConnected = ''.obs;

  bool get isNotConnected {
    return isConnected.value == 'NotConnected' ? true : false;
  }

  User({
    this.userId,
    this.firstName,
    this.lastName,
    this.profileImg,
    this.companyName,
    this.companyId,
    this.isAdmin,
    this.backgroundImg,
    this.following,
    this.isVerified,
    this.userType,
    this.connectionStatus,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImg = json['profile_img'];
    backgroundImg = json['background_img'];
    companyName = json['company_name'];
    companyId = json['company_id'];
    isAdmin = json['is_admin'];
    following = json['following'];
    isVerified = json['is_verified'];
    userType = json['user_type'];
    connectionStatus = json['connection_status'];
    isConnected.value = json['connection_status'];
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
    data['following'] = following;
    data['is_admin'] = isAdmin;
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
  var isOnImageTap = false.obs;

  FeedMedia({this.id, this.mediaType, this.feedMedia, this.thumbnail, this.createdAt, this.updatedAt});

  FeedMedia.fromJson(Map<String, dynamic> json) {
    if (json["feedmedia_id"] != null) {
      var newJson = json["feedmedia_id"] as Map<String, dynamic>;
      if (newJson['id'] is String) {
        id = int.parse(newJson['id'] ?? "-1");
      } else {
        id = newJson['id'];
      }
      mediaType = newJson['media_type'];
      feedMedia = newJson['feed_media'];
      thumbnail = newJson['thumbnail'];
      // feedMedia = newJson['feed_media'] != null
      //     ? (newJson['feed_media'].toString().startsWith('http') ? (newJson['feed_media']) : ("${ApiConstant.imageBaseDomain}/${newJson['feed_media']}"))
      //     : newJson['feed_media'];
      // thumbnail = newJson['thumbnail'] != null
      //     ? (newJson['thumbnail'].toString().startsWith('http') ? (newJson['thumbnail']) : ("${ApiConstant.imageBaseDomain}/${newJson['thumbnail']}"))
      //     : newJson['thumbnail'];
      createdAt = newJson['created_at'];
      updatedAt = newJson['updated_at'];
    } else {
      if (json['id'] is String) {
        id = int.parse(json['id'] ?? "-1");
      } else {
        id = json['id'];
      }
      mediaType = json['media_type'];
      feedMedia = json['feed_media']; /*!= null ? "${ApiConstant.imageBaseDomain}/${json['feed_media']}":json['feed_media'];*/
      thumbnail = json['thumbnail']; /*!= null ? "${ApiConstant.imageBaseDomain}/${json['thumbnail']}":json['thumbnail'];*/
      createdAt = json['created_at'];
      updatedAt = json['updated_at'];
    }
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

class ArticleMedia {
  int? id;
  String? mediaType;
  String? articleMedia;
  String? thumbnail;
  String? createdAt;
  String? updatedAt;

  String get getHoursAgo {
    if (createdAt != null || createdAt?.isNotEmpty == true) {
      return DateUtil.getLeftTime(createdAt ?? '');
    } else {
      return "";
    }
  }

  ArticleMedia({this.id, this.mediaType, this.articleMedia, this.thumbnail, this.createdAt, this.updatedAt});

  ArticleMedia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mediaType = json['media_type'];
    articleMedia = json['article_media'];
    thumbnail = json['thumbnail'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['media_type'] = mediaType;
    data['article_media'] = articleMedia;
    data['thumbnail'] = thumbnail;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ReportedBy {
  String? email;
  String? firstName;
  String? lastName;

  ReportedBy({this.email, this.firstName, this.lastName});

  ReportedBy.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    return data;
  }
}
