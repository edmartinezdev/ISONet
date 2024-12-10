// import '../forum_models/forum_comment_model.dart';
//
// class ArticleCommentModel {
//   int? totalRecord;
//   int? filterRecord;
//   List<ForumCommentListData>? articleCommentListData;
//
//   ArticleCommentModel({this.totalRecord, this.filterRecord, this.articleCommentListData});
//
//   ArticleCommentModel.fromJson(Map<String, dynamic> json) {
//     totalRecord = json['total_record'];
//     filterRecord = json['filter_record'];
//     if (json['article_comments'] != null) {
//       articleCommentListData = <ForumCommentListData>[];
//       json['article_comments'].forEach((v) {
//         articleCommentListData!.add(ForumCommentListData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['total_record'] = totalRecord;
//     data['filter_record'] = filterRecord;
//     if (articleCommentListData != null) {
//       data['article_comments'] = articleCommentListData!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }