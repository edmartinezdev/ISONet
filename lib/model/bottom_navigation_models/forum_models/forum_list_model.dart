import 'package:get/get.dart';

import '../../../utils/date_util.dart';
import '../news_feed_models/feed_list_model.dart';

class ForumListModel {
  int? totalRecord;
  int? filterRecord;
  List<ForumData>? forumDataList;

  ForumListModel({this.totalRecord, this.filterRecord, this.forumDataList});

  ForumListModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    filterRecord = json['filter_record'];
    if (json['forum_data'] != null) {
      forumDataList = <ForumData>[];
      json['forum_data'].forEach((v) {
        forumDataList!.add(ForumData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_record'] = totalRecord;
    data['filter_record'] = filterRecord;
    if (forumDataList != null) {
      data['forum_data'] = forumDataList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ForumData {
  User? user;
  int? forumId;
  String? description;
  int? forumCategoryId;
  String? forumCategoryName;
  int? likes;
  int? dislikes;
  int? comment;
  List<ForumMedia>? forumMedia;
  String? postedAt;
  String? updatedAt;
 /* bool? isLikeByYou;
  bool? isUnlikeByYou;*/
  List<ReportedBy>? reportedBy;
  RxBool isLikeForum = false.obs;
  RxBool isUnlikeForum = false.obs;
  RxBool showMore = false.obs;
  RxInt likeCount = 0.obs;
  RxInt commentCounter = 0.obs;
  RxInt disLikeCount = 0.obs;
  String get getHoursAgo {
    if (postedAt != null || postedAt?.isNotEmpty == true) {
      return DateUtil.getLeftTime(postedAt ?? '');
    } else {
      return "";
    }
  }

  ForumData({
    this.user,
    this.forumId,
    this.description,
    this.forumCategoryId,
    this.forumCategoryName,
    this.likes,
    this.dislikes,
    this.comment,
    this.forumMedia,
    this.postedAt,
    this.updatedAt,
   /* this.isLikeByYou,
    this.isUnlikeByYou,*/
    this.reportedBy,
  });

  ForumData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    forumId = json['forum_id'];
    description = json['description'];
    forumCategoryId = json['forum_category_id'];
    forumCategoryName = json['forum_category_name'];
    likes = json['likes'];
    likeCount.value = json['likes'];
    dislikes = json['dislikes'];
    disLikeCount.value = json['dislikes'];
    comment = json['comment'];
    commentCounter.value = json['comment'];
    if (json['forum_media'] != null) {
      forumMedia = <ForumMedia>[];
      json['forum_media'].forEach((v) {
        forumMedia!.add(ForumMedia.fromJson(v));
      });
    }
    postedAt = json['posted_at'];
    updatedAt = json['updated_at'];
    // isLikeByYou = json['is_like_by_you'];
    isLikeForum.value = json['is_like_by_you'];
    isUnlikeForum.value = json['is_unlike_by_you'];
    // isUnlikeByYou = json['is_unlike_by_you'];

    if (json['reported_by'] != null) {
      reportedBy = <ReportedBy>[];
      json['reported_by'].forEach((v) {
        reportedBy!.add(ReportedBy.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['forum_id'] = forumId;
    data['description'] = description;
    data['forum_category_id'] = forumCategoryId;
    data['likes'] = likes;
    data['dislikes'] = dislikes;
    data['comment'] = comment;
    if (forumMedia != null) {
      data['forum_media'] = forumMedia!.map((v) => v.toJson()).toList();
    }
    data['posted_at'] = postedAt;
    data['updated_at'] = updatedAt;
    data['is_like_by_you'] = isLikeForum.value;
    data['is_unlike_by_you'] = isUnlikeForum.value;
    if (reportedBy != null) {
      data['reported_by'] = reportedBy!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ForumMedia {
  int? id;
  String? mediaType;
  String? forumMedia;
  String? thumbnail;
  String? createdAt;
  String? updatedAt;
  var isOnImageTap = false.obs;

  ForumMedia({this.id, this.mediaType, this.forumMedia, this.thumbnail, this.createdAt, this.updatedAt});

  ForumMedia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mediaType = json['media_type'];
    forumMedia = json['forum_media'];
    thumbnail = json['thumbnail'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['media_type'] = mediaType;
    data['forum_media'] = forumMedia;
    data['thumbnail'] = thumbnail;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
