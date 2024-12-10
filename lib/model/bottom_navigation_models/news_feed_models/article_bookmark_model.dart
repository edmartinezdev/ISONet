class ArticleBookMarkModel {
  int? id;
  List<dynamic>? likeBy;
  List<ReportedBy>? reportedBy;
  List<ArticleMediaa>? articleMedia;
  bool? isBookmarkByYou;
  String? title;
  String? authorName;
  String? description;
  String? postedAt;
  String? updatedAt;
  int? postedBy;

  ArticleBookMarkModel(
      {this.id,
        this.likeBy,
        this.reportedBy,
        this.articleMedia,
        this.isBookmarkByYou,
        this.title,
        this.authorName,
        this.description,
        this.postedAt,
        this.updatedAt,
        this.postedBy});

  ArticleBookMarkModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['like_by'] != null) {
      likeBy = <dynamic>[];
      json['like_by'].forEach((v) {
        //likeBy!.add(new Null.fromJson(v));
      });
    }
    if (json['reported_by'] != null) {
      reportedBy = <ReportedBy>[];
      json['reported_by'].forEach((v) {
        reportedBy!.add(ReportedBy.fromJson(v));
      });
    }
    if (json['article_media'] != null) {
      articleMedia = <ArticleMediaa>[];
      json['article_media'].forEach((v) {
        articleMedia!.add(ArticleMediaa.fromJson(v));
      });
    }
    isBookmarkByYou = json['is_bookmark_by_you'];
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

class ArticleMediaa {
  int? id;
  String? mediaType;
  String? articleMedia;
  String? thumbnail;
  String? createdAt;
  String? updatedAt;

  ArticleMediaa(
      {this.id,
        this.mediaType,
        this.articleMedia,
        this.thumbnail,
        this.createdAt,
        this.updatedAt});

  ArticleMediaa.fromJson(Map<String, dynamic> json) {
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

