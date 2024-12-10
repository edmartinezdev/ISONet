

import 'package:get/get.dart';

class ViewMyNetworkModel {
  int? totalRecord;
  int? filterRecord;
  List<NetworkData>? networkData;

  ViewMyNetworkModel({this.totalRecord, this.filterRecord, this.networkData});

  ViewMyNetworkModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    filterRecord = json['filter_record'];
    if (json['network_data'] != null) {
      networkData = <NetworkData>[];
      json['network_data'].forEach((v) {
        networkData!.add(NetworkData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_record'] = totalRecord;
    data['filter_record'] = filterRecord;
    if (networkData != null) {
      data['network_data'] = networkData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NetworkData {
  int? userId;
  String? firstName;
  String? lastName;
  int? following;
  String? profileImg;
  String? backgroundImg;
  String? companyName;
  int? companyId;
  String? connectionStatus;
  int? roomId;
  bool? isVerify;
  String? userType;

  RxBool isSelected = false.obs;
  RxBool isSend = false.obs;

  NetworkData(
      {this.userId,
        this.firstName,
        this.lastName,
        this.following,
        this.profileImg,
        this.backgroundImg,
        this.companyName,
        this.companyId,
        this.connectionStatus,
      this.roomId,
      this.isVerify,this.userType});

  NetworkData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    following = json['following'];
    profileImg = json['profile_img'];
    backgroundImg = json['background_img'];
    companyName = json['company_name'];
    companyId = json['company_id'];
    connectionStatus = json['connection_status'];

    if(json['room_name'] is String){
      roomId = int.parse(json['room_id'] ?? "-1");
    }else{
      roomId = json['room_id'];
    }

    isVerify = json['is_verified'];
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
    data['room_id'] = roomId;
    return data;
  }
}
