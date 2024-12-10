import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/helper_manager/socket_manager/socket_manager_new.dart';
import 'package:iso_net/ui/style/dialog_components.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/preferences_key.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


var userSingleton = UserModel.authModelSingleton;

class UserModel {
  UserModel._internal();

  static final UserModel authModelSingleton = UserModel._internal();

  factory UserModel() {
    return authModelSingleton;
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    updateValue(json);
  }

  int? id;
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? city;
  String? state;
  String? dob;
  String? position;
  int? experienceId;
  String? bio;
  String? userType;
  RxBool isOwner = false.obs;
  //bool? isOwner ;
  String? profileImg;
  String? backgroundImg;
  String? isApproved;
  bool? isSupAdmin;
  bool? isBlocked;
  bool? isActive;
  bool? isDeleted;
  bool? isVerified;
  bool? deleteByUser;
  bool? isStaff;
  bool? isSuperuser;

  String? lastLogin;
  int? userStage;
  bool? isPublic;
  String? createdAt;
  String? updatedAt;
  int? companyId;
  bool? isSubscribed;
  String? subscriptionType;
  String? subscriptionStartDate;
  String? subscriptionEndDate;
  bool? isCanceled;
  List<dynamic>? interestIn;
  String? token;
  String? referral;

  Future<void> updateValue(Map<String, dynamic> json) async {
    id = json['id'];
    email = json['email'];
    password = json['password'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phoneNumber = json['phone_number'];
    city = json['city'];
    state = json['state'];
    dob = json['dob'];
    position = json['position'];
    experienceId = json['experience'];
    bio = json['bio'];
    userType = json['user_type'];
    isOwner.value = json['is_owner'] ;
    profileImg = json['profile_img'];
    backgroundImg = json['background_img'];
    isApproved = json['is_approved'];
    isSupAdmin = json['is_sup_admin'];
    isBlocked = json['is_blocked'];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    isVerified = json['is_verified'];
    deleteByUser = json['delete_by_user'];
    isStaff = json['is_staff'];
    isSuperuser = json['is_superuser'];

    lastLogin = json['last_login'];
    userStage = json['user_stage'];
    isPublic = json['is_public'];
    isSubscribed = json['is_subscribed'];
    subscriptionType = json['current_subscription_type'];
    subscriptionStartDate = json['subscription_start_date'];
    subscriptionEndDate = json['subscription_end_date'];
    isCanceled = json['is_canceled'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    companyId = json['company_id'];
    token = json['token'];
    referral = json['referral'];
    interestIn = json['interest_in'];
    saveUserData();
  }

  Future<void> saveUserData() async {
    final userDetails = toJson();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(PreferenceKeys.prefUserData, json.encode(userDetails));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['password'] = password;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone_number'] = phoneNumber;
    data['city'] = city;
    data['state'] = state;
    data['dob'] = dob;
    data['position'] = position;
    data['experience'] = experienceId;
    data['bio'] = bio;
    data['user_type'] = userType;
    data['is_owner'] = isOwner.value;
    data['profile_img'] = profileImg;
    data['background_img'] = backgroundImg;
    data['is_approved'] = isApproved;
    data['is_sup_admin'] = isSupAdmin;
    data['is_blocked'] = isBlocked;
    data['is_active'] = isActive;
    data['is_deleted'] = isDeleted;
    data['is_verified'] = isVerified;
    data['delete_by_user'] = deleteByUser;
    data['is_staff'] = isStaff;
    data['is_superuser'] = isSuperuser;
    data['last_login'] = lastLogin;
    data['user_stage'] = userStage;
    data['is_public'] = isPublic;
    data['is_subscribed'] = isSubscribed;
    data['current_subscription_type'] = subscriptionType;
    data['subscription_start_date'] = subscriptionStartDate;
    data['subscription_end_date'] = subscriptionEndDate;
    data['is_canceled'] = isCanceled;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['company_id'] = companyId;
    data['token'] = token;
    data['interest_in'] = interestIn;

    return data;
  }

  static Future<void> saveIsLoginVerified() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(PreferenceKeys.loginVerified, true);
  }

  static Future<bool> isLoginVerified() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(PreferenceKeys.loginVerified) ?? false;
  }

  Future<void> clearPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(PreferenceKeys.prefUserData);
    // updateValue({});
  }

  Future<void> loadUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userStoredDetails = preferences.getString(PreferenceKeys.prefUserData) ?? '';
    if (userStoredDetails.isNotEmpty) {
      Map<String, dynamic> userDetails = json.decode(userStoredDetails);
      await updateValue(userDetails);
    }
  }

  user401LogOut() {
    return DialogComponent.showAlert(
      Get.context!,
      title: AppStrings.appName,
      message: AppStrings.sessionExpire,
      arrButton: [AppStrings.okB],
      callback: (btnIndex) {
        if (btnIndex == 0) {
          Get.offAllNamed(ScreenRoutesConstants.startupScreen);
          SocketManagerNew().disconnectFromServer();
          userSingleton.clearPreference();
        }
      },
      barrierDismissible: false,
    );
  }

  userBlock406({required String message}){
    return DialogComponent.showAlert(
      Get.context!,
      title: AppStrings.appName,
      message: message,
      arrButton: [AppStrings.okB],
      callback: (btnIndex) {
        if (btnIndex == 0) {
          Get.offAllNamed(ScreenRoutesConstants.startupScreen);
          userSingleton.clearPreference();
        }
      },
      barrierDismissible: false,
    );
  }


  userSubscriptionCancel() {
    return WillPopScope(
      child: CommonUtils.buildSubscriptionAlert(context: Get.context!),
      onWillPop: () async {
        return false;
      },
    );
  }
}
