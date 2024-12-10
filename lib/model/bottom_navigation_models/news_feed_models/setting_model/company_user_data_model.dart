class CompanyUserDataModel {
  int? totalRecord;
  int? filterRecord;
  List<UserDetails>? userDetail;

  CompanyUserDataModel({this.totalRecord, this.filterRecord, this.userDetail});

  CompanyUserDataModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    filterRecord = json['filter_record'];
    if (json['data'] != null) {
      userDetail = <UserDetails>[];
      json['data'].forEach((v) {
        userDetail!.add(UserDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_record'] = totalRecord;
    data['filter_record'] = filterRecord;
    if (userDetail != null) {
      data['data'] = userDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserDetails {
  String? firstName;
  String? profileImg;

  UserDetails({this.firstName, this.profileImg});

  UserDetails.fromJson(Map<String, dynamic> json) {
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