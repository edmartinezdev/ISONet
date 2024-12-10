import 'package:get/get.dart';

class NetworkTabModel {
  int? viewMyNetwork;
    List<PendingRequest>? pendingRequest;
  List<ConnectionSuggestion>? connectionSuggestion;

  NetworkTabModel({this.viewMyNetwork, this.pendingRequest, this.connectionSuggestion});

  NetworkTabModel.fromJson(Map<String, dynamic> json) {
    viewMyNetwork = json['view_my_network'];
    if (json['pending_request'] != null) {
      pendingRequest = <PendingRequest>[];
      json['pending_request'].forEach((v) {
        pendingRequest!.add(PendingRequest.fromJson(v));
      });
    }
    if (json['connection_suggestion'] != null) {
      connectionSuggestion = <ConnectionSuggestion>[];
      json['connection_suggestion'].forEach((v) {
        connectionSuggestion!.add(ConnectionSuggestion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['view_my_network'] = viewMyNetwork;
    if (pendingRequest != null) {
      data['pending_request'] =
          pendingRequest!.map((v) => v.toJson()).toList();
    }
    if (connectionSuggestion != null) {
      data['connection_suggestion'] =
          connectionSuggestion!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PendingRequest {
  int? userId;
  String? firstName;
  String? lastName;
  int? following;
  String? profileImg;
  String? backgroundImg;
  String? companyName;
  int? companyId;
  String? connectionStatus;
  bool? isVerify;
  String? userType;

  PendingRequest(
      {this.userId,
        this.firstName,
        this.lastName,
        this.following,
        this.profileImg,
        this.backgroundImg,
        this.companyName,
        this.companyId,
        this.connectionStatus,
      this.isVerify,this.userType});

  PendingRequest.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    following = json['following'];
    profileImg = json['profile_img'];
    backgroundImg = json['background_img'];
    companyName = json['company_name'];
    companyId = json['company_id'];
    connectionStatus = json['connection_status'];
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
    return data;
  }
}

class ConnectionSuggestion {
  int? userId;
  String? firstName;
  String? lastName;
  int? following;
  String? profileImg;
  String? backgroundImg;
  String? companyName;
  int? companyId;
  String? connectionStatus;
  RxString connectStatus = ''.obs;
  bool? isVerify;
  String? userType;

  ConnectionSuggestion(
      {this.userId,
        this.firstName,
        this.lastName,
        this.following,
        this.profileImg,
        this.backgroundImg,
        this.companyName,
        this.companyId,
        this.connectionStatus,
        this.isVerify,this.userType});

  ConnectionSuggestion.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    following = json['following'];
    profileImg = json['profile_img'];
    backgroundImg = json['background_img'];
    companyName = json['company_name'];
    companyId = json['company_id'];
    connectionStatus = json['connection_status'];
    connectStatus.value = json['connection_status'];
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
    return data;
  }
}
