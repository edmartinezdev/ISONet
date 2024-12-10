

import 'package:get/get.dart';

import '../../utils/date_util.dart';
import '../bottom_navigation_models/news_feed_models/article_detail_model.dart';

class BookMarkListModel {
  int? totalRecord;
  int? filterRecord;
  List<ArticleBookmarkData>? articleBookmarkData;

  BookMarkListModel({this.totalRecord, this.filterRecord, this.articleBookmarkData});

  BookMarkListModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    filterRecord = json['filter_record'];
    if (json['article_bookmark_data'] != null) {
      articleBookmarkData = <ArticleBookmarkData>[];
      json['article_bookmark_data'].forEach((v) {
        articleBookmarkData!.add(ArticleBookmarkData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_record'] = totalRecord;
    data['filter_record'] = filterRecord;
    if (articleBookmarkData != null) {
      data['article_bookmark_data'] =
          articleBookmarkData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ArticleBookmarkData {
  int? id;
  Bookmark? bookmark;
  bool? isBookmarkByYou;
  int? currentPage;

  ArticleBookmarkData({this.bookmark, this.isBookmarkByYou, this.currentPage});

  ArticleBookmarkData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookmark = json['bookmark'] != null
        ? Bookmark.fromJson(json['bookmark'])
        : null;
    isBookmarkByYou = json['is_bookmark_by_you'];
    currentPage = json['current_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bookmark != null) {
      data['bookmark'] = bookmark!.toJson();
    }
    data['is_bookmark_by_you'] = isBookmarkByYou;
    data['current_page'] = currentPage;
    return data;
  }
}

class Bookmark {

  List<ArticleMedia>? articleMedia;
  String? authorName;
  String? title;
  String? postedAt;
  String? updatedAt;
  String get getHoursAgo {
    if (postedAt != null || postedAt?.isNotEmpty == true) {
      return DateUtil.getLeftTime(postedAt ?? '');
    } else {
      return "";
    }
  }
  Bookmark(
      {this.articleMedia,
        this.authorName,
        this.title,
        this.postedAt,
        this.updatedAt});

  Bookmark.fromJson(Map<String, dynamic> json) {
    if (json['article_media'] != null) {
      articleMedia = <ArticleMedia>[];
      json['article_media'].forEach((v) {
        articleMedia!.add(ArticleMedia.fromJson(v));
      });
    }
    authorName = json['author_name'];
    title = json['title'];
    postedAt = json['posted_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (articleMedia != null) {
      data['article_media'] =
          articleMedia!.map((v) => v.toJson()).toList();
    }
    data['author_name'] = authorName;
    data['title'] = title;
    data['posted_at'] = postedAt;
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

  ArticleMedia(
      {this.id,
        this.mediaType,
        this.articleMedia,
        this.thumbnail,
        this.createdAt,
        this.updatedAt});

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

///***************** Next Previous Bookmark Detail Model *******************///

class BookMarkDetailModel {
  int? totalRecord;
  int? currentPage;
  ArticleData? articleData;


  BookMarkDetailModel({this.totalRecord, this.currentPage, this.articleData});

  BookMarkDetailModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    currentPage = json['current_page'];
    articleData = json['article_data'] != null
        ? ArticleData.fromJson(json['article_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_record'] = totalRecord;
    data['current_page'] = currentPage;
    if (articleData != null) {
      data['article_data'] = articleData!.toJson();
    }
    return data;
  }
}

class ArticleData {
  int? id;
  ArticleBookMarkData? bookmark;
  int? currentPage;

  ArticleData({this.bookmark, this.currentPage});

  ArticleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookmark = json['bookmark'] != null
        ? ArticleBookMarkData.fromJson(json['bookmark'])
        : null;
    currentPage = json['current_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bookmark != null) {
      data['bookmark'] = bookmark!.toJson();
    }
    data['current_page'] = currentPage;
    return data;
  }
}

class ArticleBookMarkData {
  int? id;
  List<LikeBy>? likeBy;
  List<ReportedBy>? reportedBy;
  List<ArticleMedia>? articleMedia;
  bool? isBookmarkByYou;
  RxBool isBookmarkByMe = false.obs;
  bool? isLikeByYou;
  RxBool isLikeArticle = false.obs;
  int? likeCount;
  RxInt totalLikeCount = 0.obs;
  int? currentPage;
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

  ArticleBookMarkData(
      {this.id,
        this.likeBy,
        this.reportedBy,
        this.articleMedia,
        this.isBookmarkByYou,
        this.isLikeByYou,
        this.likeCount,
        this.currentPage,
        this.title,
        this.authorName,
        this.description,
        this.postedAt,
        this.updatedAt,
        this.postedBy});

  ArticleBookMarkData.fromJson(Map<String, dynamic> json) {
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
      articleMedia = <ArticleMedia>[];
      json['article_media'].forEach((v) {
        articleMedia!.add(ArticleMedia.fromJson(v));
      });
    }
    isBookmarkByYou = json['is_bookmark_by_you'];
    isBookmarkByMe.value = json['is_bookmark_by_you'];
    isLikeByYou = json['is_like_by_you'];
    isLikeArticle.value = json['is_like_by_you'];
    likeCount = json['like_count'];
    totalLikeCount.value = json['like_count'];
    currentPage = json['current_page'];
    title = json['title'];
    authorName = json['author_name'];
    description = json['description'];
    postedAt = json['posted_at'];
    updatedAt = json['updated_at'];
    postedBy = json['posted_by'];
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
    data['like_count'] = likeCount;
    data['current_page'] = currentPage;
    data['title'] = title;
    data['author_name'] = authorName;
    data['description'] = description;
    data['posted_at'] = postedAt;
    data['updated_at'] = updatedAt;
    data['posted_by'] = postedBy;
    return data;
  }
}


