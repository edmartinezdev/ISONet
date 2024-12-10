
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/feed_list_model.dart';

class UserProfileFeedModel {
  int? totalRecord;
  int? filterRecord;
  List<FeedData>? userFeedList;

  UserProfileFeedModel({this.totalRecord, this.filterRecord, this.userFeedList});

  UserProfileFeedModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    filterRecord = json['filter_record'];
    if (json['user_feed_list'] != null) {
      userFeedList = <FeedData>[];
      json['user_feed_list'].forEach((v) {
        userFeedList!.add(FeedData.fromJson(v));
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



// class FeedMedia {
//   int? id;
//   String? mediaType;
//   String? feedMedia;
//   String? thumbnail;
//   String? createdAt;
//   String? updatedAt;
//
//
//   FeedMedia(
//       {this.id,
//         this.mediaType,
//         this.feedMedia,
//         this.thumbnail,
//         this.createdAt,
//         this.updatedAt});
//
//   FeedMedia.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     mediaType = json['media_type'];
//     feedMedia = json['feed_media'];
//     thumbnail = json['thumbnail'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['media_type'] = mediaType;
//     data['feed_media'] = feedMedia;
//     data['thumbnail'] = thumbnail;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     return data;
//   }
// }
