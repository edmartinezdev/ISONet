import 'article_detail_model.dart';

class NextPreviousArticleModel {
  int? totalRecord;
  int? currentPage;
  ArticleDetailListModel? articleData;

  NextPreviousArticleModel(
      {this.totalRecord,
        this.currentPage,
        this.articleData,
        });

  NextPreviousArticleModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    currentPage = json['current_page'];
    articleData = json['article_data'] != null
        ? ArticleDetailListModel.fromJson(json['article_data'])
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