

import 'package:get/get.dart';

// class FeedCategoryModel {
//   int? count;
//   dynamic next;
//   dynamic previous;
//   List<FeedCategoryList>? feedCategoryList;
//
//   FeedCategoryModel({this.count, this.next, this.previous, this.feedCategoryList});
//
//   FeedCategoryModel.fromJson(Map<String, dynamic> json) {
//     count = json['count'];
//     next = json['next'];
//     previous = json['previous'];
//     if (json['results'] != null) {
//       feedCategoryList = <FeedCategoryList>[];
//       json['results'].forEach((v) {
//         feedCategoryList!.add(FeedCategoryList.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['count'] = count;
//     data['next'] = next;
//     data['previous'] = previous;
//     if (feedCategoryList != null) {
//       data['results'] = feedCategoryList!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class FeedCategoryList {
//   int? id;
//   String? categoryName;
//   String? createdAt;
//   String? updatedAt;
//   RxBool isCategorySelect = false.obs;
//
//   FeedCategoryList({this.id, this.categoryName, this.createdAt, this.updatedAt});
//
//   FeedCategoryList.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     categoryName = json['category_name'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['category_name'] = categoryName;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     return data;
//   }
// }


class FeedCategoryModel {
  int? totalRecord;
  int? filterRecord;
  List<FeedCategoryList>? feedCategoryList;

  FeedCategoryModel({this.totalRecord, this.filterRecord, this.feedCategoryList});

  FeedCategoryModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    filterRecord = json['filter_record'];
    if (json['feed_data'] != null) {
      feedCategoryList = <FeedCategoryList>[];
      json['feed_data'].forEach((v) {
        feedCategoryList!.add(FeedCategoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_record'] = totalRecord;
    data['filter_record'] = filterRecord;
    if (feedCategoryList != null) {
      data['feed_data'] = feedCategoryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeedCategoryList {
  int? id;
  var forumPostCount = 0.obs;
  String? categoryName;
  String? createdAt;
  String? updatedAt;
  RxBool isCategorySelect = false.obs;

  FeedCategoryList({this.id,this.categoryName, this.createdAt, this.updatedAt});

  FeedCategoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    forumPostCount.value = json['forums'];
    categoryName = json['category_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['forums'] = forumPostCount.value;
    data['category_name'] = categoryName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

