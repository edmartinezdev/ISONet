class CompanySettingModel {
  int? totalRecord;
  int? filterRecord;
  List<ReviewListData>? reviewListData;

  CompanySettingModel({this.totalRecord, this.filterRecord, this.reviewListData});

  CompanySettingModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    filterRecord = json['filter_record'];
    if (json['data'] != null) {
      reviewListData = <ReviewListData>[];
      json['data'].forEach((v) {
        reviewListData!.add(ReviewListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_record'] = totalRecord;
    data['filter_record'] = filterRecord;
    if (reviewListData != null) {
      data['data'] = reviewListData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReviewListData {
  int? id;
  String? review;
  String? companyName;
  String? companyImage;
  String? reviewBy;
  String? createdAt;
  String? updatedAt;

  ReviewListData(
      {this.id,
        this.review,
        this.companyName,
        this.companyImage,
        this.reviewBy,
        this.createdAt,
        this.updatedAt});

  ReviewListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    review = json['review'];
    companyName = json['company_name'];
    companyImage = json['company_image'];
    reviewBy = json['review_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['review'] = review;
    data['company_name'] = companyName;
    data['company_image'] = companyImage;
    data['review_by'] = reviewBy;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

