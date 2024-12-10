import 'package:get/get.dart';

import '../../../utils/date_util.dart';

/*
class ArticleDetailListModel {
  int? totalRecord;
  int? filterRecord;
  List<ArticleList>? articleList;

  ArticleDetailListModel({this.totalRecord, this.filterRecord, this.articleList});

  ArticleDetailListModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    filterRecord = json['filter_record'];
    if (json['article_list'] != null) {
      articleList = <ArticleList>[];
      json['article_list'].forEach((v) {
        articleList!.add(new ArticleList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_record'] = this.totalRecord;
    data['filter_record'] = this.filterRecord;
    if (this.articleList != null) {
      data['article_list'] = this.articleList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ArticleList {
  int? id;
  List<LikeBy>? likeBy;
  List<ReportedBy>? reportedBy;
  List<ArticleDetailMedia>? articleMedia;
  bool? isBookmarkByYou;
  RxBool isBookmarkByMe = false.obs;
  bool? isLikeByYou;
  String? title;
  String? authorName;
  String? description;
  String? postedAt;
  String? updatedAt;
  int? postedBy;

  ArticleList(
      {this.id,
        this.likeBy,
        this.reportedBy,
        this.articleMedia,
        this.isBookmarkByYou,
        this.isLikeByYou,
        this.title,
        this.authorName,
        this.description,
        this.postedAt,
        this.updatedAt,
        this.postedBy});

  ArticleList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['like_by'] != null) {
      likeBy = <LikeBy>[];
      json['like_by'].forEach((v) {
        likeBy!.add(new LikeBy.fromJson(v));
      });
    }
    if (json['reported_by'] != null) {
      reportedBy = <ReportedBy>[];
      json['reported_by'].forEach((v) {
        reportedBy!.add(new ReportedBy.fromJson(v));
      });
    }
    if (json['article_media'] != null) {
      articleMedia = <ArticleDetailMedia>[];
      json['article_media'].forEach((v) {
        articleMedia!.add(ArticleDetailMedia.fromJson(v));
      });
    }
    isBookmarkByYou = json['is_bookmark_by_you'];
    isBookmarkByMe.value = json['is_bookmark_by_you'];
    isLikeByYou = json['is_like_by_you'];
    title = json['title'];
    authorName = json['author_name'];
    description = json['description'];
    postedAt = json['posted_at'];
    updatedAt = json['updated_at'];
    postedBy = json['posted_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.likeBy != null) {
      data['like_by'] = this.likeBy!.map((v) => v.toJson()).toList();
    }
    if (this.reportedBy != null) {
      data['reported_by'] = this.reportedBy!.map((v) => v.toJson()).toList();
    }
    if (this.articleMedia != null) {
      data['article_media'] =
          this.articleMedia!.map((v) => v.toJson()).toList();
    }
    data['is_bookmark_by_you'] = this.isBookmarkByYou;
    data['is_like_by_you'] = this.isLikeByYou;
    data['title'] = this.title;
    data['author_name'] = this.authorName;
    data['description'] = this.description;
    data['posted_at'] = this.postedAt;
    data['updated_at'] = this.updatedAt;
    data['posted_by'] = this.postedBy;
    return data;
  }
}

class LikeBy {
  String? firstName;
  String? profileImg;

  LikeBy({this.firstName, this.profileImg});

  LikeBy.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    profileImg = json['profile_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['profile_img'] = this.profileImg;
    return data;
  }
}

class ArticleDetailMedia {
  int? id;
  String? mediaType;
  String? articleMedia;
  Null? thumbnail;
  String? createdAt;
  String? updatedAt;
  String get getHoursAgo {
    if (createdAt != null || createdAt?.isNotEmpty == true) {
      return DateUtil.getLeftTime(createdAt ?? '');
    } else {
      return "";
    }
  }

  ArticleDetailMedia(
      {this.id,
        this.mediaType,
        this.articleMedia,
        this.thumbnail,
        this.createdAt,
        this.updatedAt});

  ArticleDetailMedia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mediaType = json['media_type'];
    articleMedia = json['article_media'];
    thumbnail = json['thumbnail'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['media_type'] = this.mediaType;
    data['article_media'] = this.articleMedia;
    data['thumbnail'] = this.thumbnail;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}*/


class ArticleDetailListModel {
  int? id;
  List<LikeBy>? likeBy;
  List<ReportedBy>? reportedBy;
  List<ArticleMediea>? articleMedia;
  bool? isBookmarkByYou;
  var isLikeFeed = false.obs;
  bool? isLikeByYou;
  int? likeCount;
  RxBool isBookmarkByMe = false.obs;
  String? title;
  String? authorName;
  String? description;
  String? postedAt;
  String? updatedAt;
  int? postedBy;
  String get getHoursAgo {
    if (postedAt != null || postedAt?.isNotEmpty == true) {
      return DateUtil.getLeftTime(postedAt ?? '');
    } else {
      return "";
    }
  }

  ArticleDetailListModel(
      {this.id,
        this.likeBy,
        this.reportedBy,
        this.articleMedia,
        this.isBookmarkByYou,
        this.isLikeByYou,
        this.likeCount,
        this.title,
        this.authorName,
        this.description,
        this.postedAt,
        this.updatedAt,
        this.postedBy});

  ArticleDetailListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['like_by'] != null) {
      likeBy = <LikeBy>[];
      json['like_by'].forEach((v) {
        likeBy!.add(LikeBy.fromJson(v));
      });
    }
    if (json['reported_by'] != null) {
      reportedBy = <ReportedBy>[];
      json['reported_by'].forEach((v) {
        reportedBy!.add(ReportedBy.fromJson(v));
      });
    }
    if (json['article_media'] != null) {
      articleMedia = <ArticleMediea>[];
      json['article_media'].forEach((v) {
        articleMedia!.add(ArticleMediea.fromJson(v));
      });
    }
    isBookmarkByYou = json['is_bookmark_by_you'];
    likeCount = json['like_count'];
    isLikeByYou = json['is_like_by_you'];
    isLikeFeed.value = json['is_like_by_you'];
    title = json['title'];
    authorName = json['author_name'];
    description = json['description'];
    postedAt = json['posted_at'];
    updatedAt = json['updated_at'];
    postedBy = json['posted_by'];
    isBookmarkByMe.value = json['is_bookmark_by_you'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (likeBy != null) {
      data['like_by'] = likeBy!.map((v) => v.toJson()).toList();
    }
    if (reportedBy != null) {
      data['reported_by'] = reportedBy!.map((v) => v.toJson()).toList();
    }
    if (articleMedia != null) {
      data['article_media'] =
          articleMedia!.map((v) => v.toJson()).toList();
    }
    data['is_bookmark_by_you'] = isBookmarkByYou;
    data['is_like_by_you'] = isLikeByYou;
    data['title'] = title;
    data['author_name'] = authorName;
    data['description'] = description;
    data['posted_at'] = postedAt;
    data['updated_at'] = updatedAt;
    data['posted_by'] = postedBy;
    return data;
  }
}

class ReportedBy {
  String? firstName;
  String? profileImg;

  ReportedBy({this.firstName, this.profileImg});

  ReportedBy.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    profileImg = json['profile_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['profile_img'] = profileImg;
    return data;
  }
}

class ArticleMediea {
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

  ArticleMediea(
      {this.id,
        this.mediaType,
        this.articleMedia,
        this.thumbnail,
        this.createdAt,
        this.updatedAt});

  ArticleMediea.fromJson(Map<String, dynamic> json) {
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

class LikeBy {
  String? firstName;
  String? profileImg;

  LikeBy({this.firstName, this.profileImg});

  LikeBy.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    profileImg = json['profile_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['profile_img'] = profileImg;
    return data;
  }
}

