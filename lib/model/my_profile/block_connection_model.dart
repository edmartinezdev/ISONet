class BlockConnectionModel {
  int? totalRecord;
  int? filterRecord;
  List<BlockedUserData>? blockedUserData;

  BlockConnectionModel({this.totalRecord, this.filterRecord, this.blockedUserData});

  BlockConnectionModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    filterRecord = json['filter_record'];
    if (json['blocked_user_data'] != null) {
      blockedUserData = <BlockedUserData>[];
      json['blocked_user_data'].forEach((v) {
        blockedUserData!.add(BlockedUserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_record'] = totalRecord;
    data['filter_record'] = filterRecord;
    if (blockedUserData != null) {
      data['blocked_user_data'] =
          blockedUserData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BlockedUserData {
  int? userId;
  String? firstName;
  String? lastName;
  int? following;
  String? profileImg;
  bool? isVerified;
  String? backgroundImg;
  String? companyName;
  int? companyId;
  String? connectionStatus;
  String? roomName;

  BlockedUserData(
      {this.userId,
        this.firstName,
        this.lastName,
        this.following,
        this.profileImg,
        this.isVerified,
        this.backgroundImg,
        this.companyName,
        this.companyId,
        this.connectionStatus,
        this.roomName});

  BlockedUserData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    following = json['following'];
    profileImg = json['profile_img'];
    isVerified = json['is_verified'];
    backgroundImg = json['background_img'];
    companyName = json['company_name'];
    companyId = json['company_id'];
    connectionStatus = json['connection_status'];
    roomName = json['room_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['following'] = following;
    data['profile_img'] = profileImg;
    data['is_verified'] = isVerified;
    data['background_img'] = backgroundImg;
    data['company_name'] = companyName;
    data['company_id'] = companyId;
    data['connection_status'] = connectionStatus;
    data['room_name'] = roomName;
    return data;
  }
}
