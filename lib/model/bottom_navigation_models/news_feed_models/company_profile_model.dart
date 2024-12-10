import 'package:get/get.dart';
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/feed_list_model.dart';

import '../../../utils/date_util.dart';

class CompanyProfileModel {
  int? id;
  int? createdBy;
  String? companyName;
  String? address;
  String? city;
  String? state;
  String? zipcode;
  String? phoneNumber;
  String? website;
  String? description;
  String? companyImage;
  int? creditScore;
  String? minMonthlyRev;
  int? minTimeBusiness;
  int? nsfId;
  String? maxFundAmount;
  int? maxTermLength;
  String? buyingRates;
  int? maxUpsellPoints;
  String? createdAt;
  String? updatedAt;
  String? latitude;
  String? longitude;
  int? totalReviews;
  int? totalEmployeesCount;

  // List<int>? resIndustries;
  // List<int>? prefIndustries;
  // List<int>? resStates;
  List<Reviews>? reviews;
  List<User>? employees;
  List<int>? restrIndusties;
  List<int>? restrState;
  List<int>? prefIndustries;

  CompanyProfileModel(
      {this.id,
      this.createdBy,
      this.companyName,
      this.address,
      this.city,
      this.state,
      this.zipcode,
      this.phoneNumber,
      this.website,
      this.description,
      this.companyImage,
      this.creditScore,
      this.minMonthlyRev,
      this.minTimeBusiness,
      this.nsfId,
      this.maxFundAmount,
      this.maxTermLength,
      this.buyingRates,
      this.maxUpsellPoints,
      this.createdAt,
      this.updatedAt,
      this.latitude,
      this.longitude,
      this.totalReviews,
      this.reviews,
      this.employees,
      this.restrIndusties,
      this.restrState,
      this.prefIndustries,
      this.totalEmployeesCount});

  CompanyProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['created_by'];
    companyName = json['company_name'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
    phoneNumber = json['phone_number'];
    website = json['website'];
    description = json['description'];
    companyImage = json['company_image'];
    if (json['credit_score'] != null) {
      creditScore = json['credit_score'];
    }

    minMonthlyRev = json['min_monthly_rev'];
    minTimeBusiness = json['min_time_business'];
    nsfId = json['nsf_id'];
    maxFundAmount = json['max_fund_amount'];
    maxTermLength = json['max_term_length'];
    buyingRates = json['buying_rates'];
    maxUpsellPoints = json['max_upsell_points'];
    // resIndustries = json['restr_industies'].cast<int>;
    // resStates = json['restr_state'];
    // prefIndustries = json['pref_industries'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    // latitude = json['latitude'].toDouble();
    // longitude = json['longitude'].toDouble();
    latitude = json['latitude'];
    longitude = json['longitude'];

    totalReviews = json['total_reviews'];
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
    if (json['employees'] != null) {
      employees = <User>[];
      json['employees'].forEach((v) {
        employees!.add(User.fromJson(v));
      });
    }
    if (json['restr_industies'] != null) {
      restrIndusties = json['restr_industies'].cast<int>();
    }
    if (json['restr_state'] != null) {
      restrState = json['restr_state'].cast<int>();
    }
    if (json['pref_industries'] != null) {
      prefIndustries = json['pref_industries'].cast<int>();
    }
    totalEmployeesCount = json['total_employees'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_by'] = createdBy;
    data['company_name'] = companyName;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['zipcode'] = zipcode;
    data['phone_number'] = phoneNumber;
    data['website'] = website;
    data['description'] = description;
    data['company_image'] = companyImage;
    data['credit_score'] = creditScore;
    data['min_monthly_rev'] = minMonthlyRev;
    data['min_time_business'] = minTimeBusiness;
    data['nsf_id'] = nsfId;
    data['max_fund_amount'] = maxFundAmount;
    data['max_term_length'] = maxTermLength;
    data['buying_rates'] = buyingRates;
    data['max_upsell_points'] = maxUpsellPoints;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['total_reviews'] = totalReviews;
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    if (employees != null) {
      data['employees'] = employees!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reviews {
  int? id;
  int? companyId;
  String? review;
  ReviewBy? reviewBy;
  String? createdAt;
  String? updatedAt;
  int? totalLikes;
  bool? isLikeByYou;
  bool? isVerified;
  String? userType;

  String get getHoursAgo {
    if (createdAt != null || createdAt?.isNotEmpty == true) {
      return DateUtil.getLeftTime(createdAt ?? '');
    } else {
      return "";
    }
  }

  Reviews({this.id, this.companyId, this.review, this.reviewBy, this.createdAt, this.updatedAt, this.totalLikes, this.isLikeByYou, this.isVerified,this.userType});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    review = json['review'];
    reviewBy = json['review_by'] != null ? ReviewBy.fromJson(json['review_by']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalLikes = json['total_likes'];
    isLikeByYou = json['is_like_by_you'];
    isVerified = json['is_verified'];
    userType = json['user_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['review'] = review;
    // if (reviewBy != null) {
    //   data['review_by'] = reviewBy!.map((v) => v.toJson()).toList();
    // }

    if (reviewBy != null) {
      data['review_by'] = reviewBy;
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['total_likes'] = totalLikes;
    data['is_like_by_you'] = isLikeByYou;
    data['is_verified'] = isVerified;
    return data;
  }
}

class ReviewBy {
  int? userId;
  String? firstName;
  String? lastName;
  String? profileImg;
  int? following;
  String? backGroundImage;
  String? companyName;
  bool? isVerified;
  String? userType;
  int? companyId;

  ReviewBy({
    this.userId,
    this.firstName,
    this.lastName,
    this.profileImg,
    this.following,
    this.backGroundImage,
    this.companyId,
    this.isVerified,
    this.userType,
    this.companyName,
  });

  ReviewBy.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImg = json['profile_img'];
    following = json['following'];
    backGroundImage = json['background_img'];
    companyName = json['company_name'];
    isVerified = json['is_verified'];
    userType = json['user_type'];
    companyId = json['company_id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['profile_img'] = profileImg;
    data['following'] = following;
    data['background_img'] = backGroundImage;
    data['company_name'] = companyName;
    data['company_id'] = companyId;
    return data;
  }
}

class Employees {
  int? userId;
  String? firstName;
  String? lastName;
  String? profileImg;
  int? following;
  String? backGroundImage;
  String? companyName;
  int? companyId;
  bool? isVerified;

  Employees({this.userId, this.firstName, this.lastName, this.profileImg, this.following, this.backGroundImage, this.companyId, this.companyName,this.isVerified});

  Employees.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImg = json['profile_img'];
    following = json['following'];
    backGroundImage = json['background_img'];
    companyName = json['company_name'];
    companyId = json['company_id'];
    isVerified = json['is_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['profile_img'] = profileImg;
    data['following'] = following;
    data['background_img'] = backGroundImage;
    data['company_name'] = companyName;
    data['company_id'] = companyId;
    data['is_verified'] = isVerified;
    return data;
  }
}

/// ***************** CompanyReview Screen Model *********** ///

class CompanyReviewModel {
  int? totalRecord;
  int? filterRecord;
  List<CompanyReviewListData>? companyReviewListData;

  CompanyReviewModel({this.totalRecord, this.filterRecord, this.companyReviewListData});

  CompanyReviewModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    filterRecord = json['filter_record'];
    if (json['company_review_data'] != null) {
      companyReviewListData = <CompanyReviewListData>[];
      json['company_review_data'].forEach((v) {
        companyReviewListData!.add(CompanyReviewListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_record'] = totalRecord;
    data['filter_record'] = filterRecord;
    if (companyReviewListData != null) {
      data['company_review_data'] = companyReviewListData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CompanyReviewListData {
  int? id;
  int? companyId;
  String? review;
  ReviewBy? reviewBy;
  String? createdAt;
  String? updatedAt;
  int? totalLikes;
  bool? isLikeByYou;
  RxInt totalReviewLike = 0.obs;
  RxBool isReviewLikeByMe = false.obs;

  String get getHoursAgo {
    if (createdAt != null || createdAt?.isNotEmpty == true) {
      return DateUtil.getLeftTime(createdAt ?? '');
    } else {
      return "";
    }
  }

  CompanyReviewListData({this.id, this.companyId, this.review, this.reviewBy, this.createdAt, this.updatedAt, this.totalLikes, this.isLikeByYou});

  CompanyReviewListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    review = json['review'];
    reviewBy = json['review_by'] != null ? ReviewBy.fromJson(json['review_by']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    totalLikes = json['total_likes'];
    totalReviewLike.value = json['total_likes'];
    isLikeByYou = json['is_like_by_you'];
    isReviewLikeByMe.value = json['is_like_by_you'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['review'] = review;
    if (reviewBy != null) {
      data['review_by'] = reviewBy!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['total_likes'] = totalLikes;
    data['is_like_by_you'] = isLikeByYou;
    return data;
  }
}

/// ***************** Company Employee Screen Model *********** ///

class CompanyEmployeeModel {
  int? totalRecord;
  int? filterRecord;
  List<User>? companyEmployeeListData;

  CompanyEmployeeModel({this.totalRecord, this.filterRecord, this.companyEmployeeListData});

  CompanyEmployeeModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    filterRecord = json['filter_record'];
    if (json['employee_data'] != null) {
      companyEmployeeListData = <User>[];
      json['employee_data'].forEach((v) {
        companyEmployeeListData!.add(User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_record'] = totalRecord;
    data['filter_record'] = filterRecord;
    if (companyEmployeeListData != null) {
      data['employee_data'] = companyEmployeeListData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CompanyEmployeeData {
  int? employeeId;
  String? firstName;
  String? lastName;
  String? profileImg;
  int? following;
  String? backGroundImage;
  String? companyName;
  int? companyId;

  CompanyEmployeeData({this.employeeId, this.firstName, this.lastName, this.profileImg, this.following, this.backGroundImage, this.companyId, this.companyName});

  CompanyEmployeeData.fromJson(Map<String, dynamic> json) {
    employeeId = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImg = json['profile_img'];
    following = json['following'];
    backGroundImage = json['background_img'];
    companyName = json['company_name'];
    companyId = json['company_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = employeeId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['profile_img'] = profileImg;
    data['following'] = following;
    data['background_img'] = backGroundImage;
    data['company_name'] = companyName;
    data['company_id'] = companyId;
    return data;
  }
}
