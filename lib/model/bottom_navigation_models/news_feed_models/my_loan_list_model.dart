import '../../../utils/date_util.dart';

class MyLoanListModel {
  int? totalRecord;
  int? filterRecord;
  List<UserLoanList>? userLoanList;

  MyLoanListModel({this.totalRecord, this.filterRecord, this.userLoanList});

  MyLoanListModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    filterRecord = json['filter_record'];
    if (json['user_loan_list'] != null) {
      userLoanList = <UserLoanList>[];
      json['user_loan_list'].forEach((v) {
        userLoanList!.add(UserLoanList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_record'] = totalRecord;
    data['filter_record'] = filterRecord;
    if (userLoanList != null) {
      data['user_loan_list'] =
          userLoanList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserLoanList {
  int? id;
  String? loanAmount;
  CreatedBy? createdBy;
  String? loanIndustries;
  int? funderOrBrokerName;
  String? createdAt;
  String? updatedAt;
  List<String>? selectedTags;
  String? loanStatus;
  String get getTagTime {
    if (createdAt != null || createdAt?.isNotEmpty == true) {
      return DateUtil.getLeftTime(createdAt ?? '');
    } else {
      return "";
    }
  }

  UserLoanList(
      {this.id,
        this.loanAmount,
        this.createdBy,
        this.loanIndustries,
        this.funderOrBrokerName,
        this.createdAt,
        this.updatedAt,
        this.loanStatus,
        this.selectedTags});

  UserLoanList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    loanAmount = json['loan_amount'];
    createdBy = json['created_by'] != null
        ? CreatedBy.fromJson(json['created_by'])
        : null;
    loanIndustries = json['loan_industries'];
    funderOrBrokerName = json['funder_or_broker_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    loanStatus = json['loan_status'];
    selectedTags = json['selected_tags'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['loan_amount'] = loanAmount;
    if (createdBy != null) {
      data['created_by'] = createdBy!.toJson();
    }
    data['loan_industries'] = loanIndustries;
    data['funder_or_broker_name'] = funderOrBrokerName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['selected_tags'] = selectedTags;
    return data;
  }
}

class CreatedBy {
  int? userId;
  String? firstName;
  String? lastName;
  int? following;
  String? profileImg;
  String? backgroundImg;
  String? companyName;
  int? companyId;
  String? connectionStatus;

  CreatedBy(
      {this.userId,
        this.firstName,
        this.lastName,
        this.following,
        this.profileImg,
        this.backgroundImg,
        this.companyName,
        this.companyId,
        this.connectionStatus});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    following = json['following'];
    profileImg = json['profile_img'];
    backgroundImg = json['background_img'];
    companyName = json['company_name'];
    companyId = json['company_id'];
    connectionStatus = json['connection_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['following'] = following;
    data['profile_img'] = profileImg;
    data['background_img'] = backgroundImg;
    data['company_name'] = companyName;
    data['company_id'] = companyId;
    data['connection_status'] = connectionStatus;
    return data;
  }
}