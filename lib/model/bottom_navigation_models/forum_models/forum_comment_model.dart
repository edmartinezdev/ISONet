// import 'package:get/get.dart';
//
// import '../../../utils/date_util.dart';
//
// class ForumCommentModel {
//   int? totalRecord;
//   int? filterRecord;
//   List<ForumCommentListData>? forumCommentListData;
//
//   ForumCommentModel({this.totalRecord, this.filterRecord, this.forumCommentListData});
//
//   ForumCommentModel.fromJson(Map<String, dynamic> json) {
//     totalRecord = json['total_record'];
//     filterRecord = json['filter_record'];
//     if (json['forum_comments'] != null) {
//       forumCommentListData = <ForumCommentListData>[];
//       json['forum_comments'].forEach((v) {
//         forumCommentListData!.add(ForumCommentListData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['total_record'] = totalRecord;
//     data['filter_record'] = filterRecord;
//     if (forumCommentListData != null) {
//       data['forum_comments'] = forumCommentListData!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class ForumCommentListData {
//   User? user;
//   int? mainCommentId;
//   String? comment;
//   int? likes;
//   RxInt commentLikes = 0.obs;
//   String? createdAt;
//   String? updatedAt;
//   RxBool isReplayShow = false.obs;
//   RxBool isSubReplyComment = false.obs;
//   bool? likedByUser;
//   RxBool isLikeComment = false.obs;
//
//   List<CommentReplies>? commentReplies;
//
//   String get getMainCommentTime {
//     if (createdAt != null || createdAt?.isNotEmpty == true) {
//       return DateUtil.getLeftTime(createdAt ?? '');
//     } else {
//       return "";
//     }
//   }
//
//   ForumCommentListData({this.user, this.mainCommentId, this.comment, this.likes, this.createdAt, this.updatedAt, this.commentReplies, this.likedByUser});
//
//   ForumCommentListData.fromJson(Map<String, dynamic> json) {
//     user = json['user_id'] != null ? User.fromJson(json['user_id']) : null;
//     mainCommentId = json['main_comment_id'];
//     comment = json['comment'];
//     likes = json['likes'];
//     commentLikes.value = json['likes'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     if (json['comment_replies'] != null) {
//       commentReplies = <CommentReplies>[];
//       json['comment_replies'].forEach((v) {
//         commentReplies!.add(CommentReplies.fromJson(v));
//       });
//     }
//     likedByUser = json['is_like_by_you'];
//     isLikeComment.value = json['is_like_by_you'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (user != null) {
//       data['user_id'] = user!.toJson();
//     }
//     data['main_comment_id'] = mainCommentId;
//     data['comment'] = comment;
//     data['likes'] = likes;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     if (commentReplies != null) {
//       data['comment_replies'] = commentReplies!.map((v) => v.toJson()).toList();
//     }
//     data['is_like_by_you'] = likedByUser;
//     return data;
//   }
// }
//
// class User {
//   int? userId;
//   String? firstName;
//   String? lastName;
//   String? profileImg;
//   int? companyId;
//   String? companyName;
//
//   User({this.userId, this.firstName, this.lastName, this.profileImg, this.companyId});
//
//   User.fromJson(Map<String, dynamic> json) {
//     userId = json['user_id'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     profileImg = json['profile_img'];
//     companyId = json['company_id'];
//     companyName = json['company_name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['user_id'] = userId;
//     data['first_name'] = firstName;
//     data['last_name'] = lastName;
//     data['profile_img'] = profileImg;
//     data['company_id'] = companyId;
//     data['company_name'] = companyName;
//     return data;
//   }
// }
//
// class CommentReplies {
//   int? userId;
//   String? firstName;
//   String? lastName;
//   String? profileImg;
//   int? repliesId;
//   String? replies;
//   int? repliesLikes;
//   bool? isLikeByYou;
//   RxInt repliesLikeCount = 0.obs;
//   RxBool isRepliesLike = false.obs;
//   String? createdAt;
//   String? updatedAt;
//   String? companyName;
//
//   String get getReplyCommentTime {
//     if (createdAt != null || createdAt?.isNotEmpty == true) {
//       return DateUtil.getLeftTime(createdAt ?? '');
//     } else {
//       return "";
//     }
//   }
//
//   CommentReplies({this.userId, this.firstName, this.lastName, this.profileImg, this.repliesId, this.replies, this.repliesLikes, this.isLikeByYou, this.createdAt, this.updatedAt, this.companyName});
//
//   CommentReplies.fromJson(Map<String, dynamic> json) {
//     userId = json['user_id'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     profileImg = json['profile_img'];
//     repliesId = json['replies_id'];
//     replies = json['replies'];
//     repliesLikes = json['replies_likes'];
//     repliesLikeCount.value = json['replies_likes'];
//     isLikeByYou = json['is_like_by_you'];
//     isRepliesLike.value = json['is_like_by_you'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     companyName = json['company_name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['user_id'] = userId;
//     data['first_name'] = firstName;
//     data['last_name'] = lastName;
//     data['profile_img'] = profileImg;
//     data['replies_id'] = repliesId;
//     data['replies'] = replies;
//     data['replies_likes'] = repliesLikes;
//     data['is_like_by_you'] = isLikeByYou;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     data['company_name'] = companyName;
//     return data;
//   }
// }
