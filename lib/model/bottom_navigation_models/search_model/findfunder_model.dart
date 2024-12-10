class FindFunderModel {
  int? totalRecord;
  int? filterRecord;

  List<CompanyList>? companyList;

  FindFunderModel({this.totalRecord, this.filterRecord, this.companyList});

  FindFunderModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    totalRecord = json['filter_record'];
    if (json['forum_data'] != null) {
      companyList = <CompanyList>[];
      json['forum_data'].forEach((v) {
        companyList!.add(CompanyList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_record'] = totalRecord;
    data['filter_record'] = filterRecord;
    if (companyList != null) {
      data['forum_data'] = companyList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CompanyList {
  int? companyId;
  String? companyName;
  bool? isPreferred;
  int? totalReviews;
  String? companyImage;
  String? address;
  String? city;
  String? state;
  String? zipcode;

  CompanyList({this.companyId, this.companyName, this.isPreferred, this.totalReviews, this.companyImage, this.address, this.city, this.state, this.zipcode});

  CompanyList.fromJson(Map<String, dynamic> json) {
    companyId = json['id'];
    companyName = json['company_name'];
    isPreferred = json['is_preferred'];
    totalReviews = json['total_reviews'];
    companyImage = json['company_image'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = companyId;
    data['company_name'] = companyName;
    data['is_preferred'] = isPreferred;
    data['total_reviews'] = totalReviews;
    data['company_image'] = companyImage;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['zipcode'] = zipcode;
    return data;
  }
}
