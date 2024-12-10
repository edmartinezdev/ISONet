import 'package:get/get_rx/src/rx_types/rx_types.dart';

/// ******** For Scoreboard Listing use this model ******///
class LoanListModel {
  int? totalRecord;
  int? filterRecord;
  List<LoanData>? loanData;

  LoanListModel({this.totalRecord, this.filterRecord, this.loanData});

  LoanListModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    filterRecord = json['filter_record'];
    if (json['loan_data'] != null) {
      loanData = <LoanData>[];
      json['loan_data'].forEach((v) {
        loanData!.add(LoanData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_record'] = totalRecord;
    data['filter_record'] = filterRecord;
    if (loanData != null) {
      data['loan_data'] = loanData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/// ******** For LoanApproval Listing use this model ******///
class LoanApprovalModel {
  int? totalRecord;
  int? filterRecord;
  List<LoanData>? loanData;

  LoanApprovalModel({this.totalRecord, this.filterRecord, this.loanData});

  LoanApprovalModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    filterRecord = json['filter_record'];
    if (json['loan_approvals'] != null) {
      loanData = <LoanData>[];
      json['loan_approvals'].forEach((v) {
        loanData!.add(LoanData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_record'] = totalRecord;
    data['filter_record'] = filterRecord;
    if (loanData != null) {
      data['loan_approvals'] = loanData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LoanData {
  int? id;
  String? loanAmount;
  String? loanIndustries;
  CreatedBy? createdByUser;
  String? createdAt;
  String? updatedAt;
  List<String>? selectedTags;
  String? loanStatus;
  bool? createByCompanyOwner;

  LoanData({
    this.id,
    this.loanAmount,
    this.loanIndustries,
    this.createdByUser,
    this.createdAt,
    this.updatedAt,
    this.selectedTags,
    this.loanStatus,
    this.createByCompanyOwner,
  });

  LoanData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    loanAmount = json['loan_amount'];
    loanIndustries = json['loan_industries'];
    createdByUser = json['created_by'] != null ? CreatedBy.fromJson(json['created_by']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    loanStatus = json['loan_status'];
    selectedTags = json['selected_tags'].cast<String>();
    createByCompanyOwner = json['created_by_is_company_owner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['loan_amount'] = loanAmount;
    data['loan_industries'] = loanIndustries;
    if (createdByUser != null) {
      data['created_by'] = createdByUser!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['selected_tags'] = selectedTags;
    data['created_by_is_company_owner'] = createByCompanyOwner;
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
  bool? isVerified;
  String? userType;
  String? companyImage;

  CreatedBy({
    this.userId,
    this.firstName,
    this.lastName,
    this.following,
    this.profileImg,
    this.backgroundImg,
    this.companyName,
    this.companyId,
    this.connectionStatus,
    this.isVerified,
    this.userType,
    this.companyImage,
  });

  CreatedBy.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    following = json['following'];
    profileImg = json['profile_img'];
    backgroundImg = json['background_img'];
    companyImage = json['company_image'];
    companyName = json['company_name'];
    companyId = json['company_id'];
    connectionStatus = json['connection_status'];
    isVerified = json['is_verified'];
    userType = json['user_type'];
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

class LoanTagModel {
  int? status;
  String? message;
  List<TagDetails>? tagDetails;

  LoanTagModel({this.status, this.message, this.tagDetails});

  LoanTagModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      tagDetails = <TagDetails>[];
      json['data'].forEach((v) {
        tagDetails!.add(TagDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (tagDetails != null) {
      data['data'] = tagDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TagDetails {
  int? id;
  String? tagName;
  RxBool isPrefIndustryChecked = false.obs;

  TagDetails({this.id, this.tagName});

  TagDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tagName = json['tag_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tag_name'] = tagName;
    return data;
  }
}
