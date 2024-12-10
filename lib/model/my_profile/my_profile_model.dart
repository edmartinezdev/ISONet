import 'package:get/get.dart';
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/feed_list_model.dart';

import '../bottom_navigation_models/news_feed_models/my_loan_list_model.dart';

class MyProfileModel {
  int? userId;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? email;
  String? city;
  String? state;
  String? dob;
  int? companyId;
  String? position;
  int? experienceId;
  String? experienceName;
  int? following;
  String? bio;
  String? userType;
  bool? isOwner;
  bool? isVerified;
  String? profileImg;
  String? backgroundImg;
  String? isApproved;
  bool? isSupAdmin;
  bool? isBlocked;
  bool? isActive;
  bool? isDeleted;
  bool? deleteByUser;
  bool? isStaff;
  bool? isSuperuser;
  String? lastLogin;
  int? userStage;
  bool? isPublic;
  RxBool isUserPublic = false.obs;
  bool? isSubscribed;
  String? currentSubscriptionType;
  String? subscriptionStartDate;
  String? subscriptionEndDate;
  bool? isCanceled;
  String? createdAt;
  String? updatedAt;
  var isReadNotification = true.obs;
  var unreadCount = 0.obs;
  String? connectionStatus;
  List<int>? interestIn;
  List<FeedData>? feedList;
  String? companyName;
  bool? isCompanyDeleted;
  List<UserLoanList>? myLoanList;
  int? expValue;
  String? expType;
  String? referralCode;

  MyProfileModel(
      {this.userId,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.email,
      this.city,
      this.state,
      this.dob,
      this.companyId,
      this.position,
      this.experienceId,
      this.experienceName,
      this.bio,
      this.userType,
      this.isOwner,
      this.profileImg,
      this.backgroundImg,
      this.isApproved,
      this.isSupAdmin,
      this.isBlocked,
      this.isActive,
      this.isDeleted,
      this.deleteByUser,
      this.isStaff,
      this.isSuperuser,
      this.lastLogin,
      this.userStage,
      this.isPublic,
      this.isSubscribed,
      this.currentSubscriptionType,
      this.subscriptionStartDate,
      this.subscriptionEndDate,
      this.isCanceled,
      this.createdAt,
      this.updatedAt,
      this.connectionStatus,
      this.interestIn,
      this.feedList,
      this.companyName,
      this.isVerified,
      this.isCompanyDeleted,
      this.myLoanList,
      this.expValue,
      this.expType,
      this.referralCode});

  MyProfileModel.fromJson(Map<String, dynamic> json) {
    userId = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    city = json['city'];
    state = json['state'];
    dob = json['dob'];
    companyId = json['company_id'];
    position = json['position'];
    experienceId = json['experience_id'];
    experienceName = json['experience_name'];
    bio = json['bio'];
    userType = json['user_type'];
    isOwner = json['is_owner'];
    profileImg = json['profile_img'];
    isVerified = json['is_verified'];
    backgroundImg = json['background_img'];
    isApproved = json['is_approved'];
    isSupAdmin = json['is_sup_admin'];
    isBlocked = json['is_blocked'];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    deleteByUser = json['delete_by_user'];
    following = json['following'];
    isStaff = json['is_staff'];
    isSuperuser = json['is_superuser'];
    lastLogin = json['last_login'];
    userStage = json['user_stage'];
    isPublic = json['is_public'];
    isUserPublic.value = json['is_public'];
    isSubscribed = json['is_subscribed'];
    currentSubscriptionType = json['current_subscription_type'];
    subscriptionStartDate = json['subscription_start_date'];
    subscriptionEndDate = json['subscription_end_date'];
    isCanceled = json['is_canceled'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isReadNotification.value = json['is_read'] ?? false;
    unreadCount.value = json['unread_chat_count'] ?? 0;
    connectionStatus = json['connection_status'];
    interestIn = json['interest_in'].cast<int>();
    // if (json['interest_in'] != null) {
    //   interestIn = <InterestIn>[];
    //   json['interest_in'].forEach((v) {
    //     interestIn!.add( InterestIn.fromJson(v));
    //   });
    // }
    if (json['feed_list'] != null) {
      feedList = <FeedData>[];
      json['feed_list'].forEach((v) {
        feedList!.add(FeedData.fromJson(v));
      });
    }
    companyName = json['company_name'];
    isCompanyDeleted = json['company_is_deleted'];
    if (json['loan_list'] != null) {
      myLoanList = <UserLoanList>[];
      json['loan_list'].forEach((v) {
        myLoanList!.add(UserLoanList.fromJson(v));
      });
    }
    expValue = json['exp_value'];
    expType = json['exp_type'];
    referralCode = json['referral'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['city'] = city;
    data['state'] = state;
    data['dob'] = dob;
    data['company_id'] = companyId;
    data['position'] = position;
    data['experience_id'] = experienceId;
    data['bio'] = bio;
    data['user_type'] = userType;
    data['is_owner'] = isOwner;
    data['profile_img'] = profileImg;
    data['background_img'] = backgroundImg;
    data['is_approved'] = isApproved;
    data['is_sup_admin'] = isSupAdmin;
    data['is_blocked'] = isBlocked;
    data['is_active'] = isActive;
    data['is_deleted'] = isDeleted;
    data['delete_by_user'] = deleteByUser;
    data['is_staff'] = isStaff;
    data['is_superuser'] = isSuperuser;
    data['last_login'] = lastLogin;
    data['is_verified'] = isVerified;
    data['user_stage'] = userStage;
    data['is_public'] = isPublic;
    data['is_subscribed'] = isSubscribed;
    data['current_subscription_type'] = currentSubscriptionType;
    data['subscription_start_date'] = subscriptionStartDate;
    data['subscription_end_date'] = subscriptionEndDate;
    data['is_canceled'] = isCanceled;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['connection_status'] = connectionStatus;
    if (feedList != null) {
      data['feed_list'] = feedList!.map((v) => v.toJson()).toList();
    }
    data['company_name'] = companyName;
    if (myLoanList != null) {
      data['loan_list'] = myLoanList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InterestIn {
  int? id;
  String? tagName;
  String? createdAt;
  String? updatedAt;

  InterestIn({this.id, this.tagName, this.createdAt, this.updatedAt});

  InterestIn.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tagName = json['tag_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tag_name'] = tagName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
