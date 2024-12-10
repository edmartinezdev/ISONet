// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/chat/search_message_controller.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/model/bottom_navigation_models/chat_model/one_to_one_chat_model.dart';
import 'package:iso_net/utils/date_util.dart';

import '../news_feed_models/feed_list_model.dart';

class RecentChatListModell {
  RecentChatList? recentChatList;

  RecentChatListModell({this.recentChatList});

  RecentChatListModell.fromJson(Map<String, dynamic> json) {
    recentChatList = json['recent_chat_list'] != null ? RecentChatList.fromJson(json['recent_chat_list']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (recentChatList != null) {
      data['recent_chat_list'] = recentChatList!.toJson();
    }
    return data;
  }

  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class RecentChatList {
  int? status;
  String? message;
  ChatListData? data;

  RecentChatList({this.status, this.message, this.data});

  RecentChatList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['result'] != null ? ChatListData.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ChatListData {
  int? totalRecord;
  int? filterRecord;
  List<ChatDataa>? data;

  ChatListData({this.totalRecord, this.filterRecord, this.data});

  ChatListData.fromJson(Map<String, dynamic> json) {
    totalRecord = json['totalRecord'];
    filterRecord = json['filterRecord'];
    if(Get.isRegistered<SearchMessageController>() == true){
      if (json['data'] != null) {
        data = <ChatDataa>[];
        json['data'].forEach((v) {
          data!.add(ChatDataa.fromJson(v));
        });
      }
    }else{
      if (json['result'] != null) {
        data = <ChatDataa>[];
        json['result'].forEach((v) {
          data!.add(ChatDataa.fromJson(v));
        });
      }
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_record'] = totalRecord;
    data['filter_record'] = filterRecord;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatDataObject{
  int? status;
  String? message;
  ChatDataa? data;

  ChatDataObject({this.status, this.message, this.data});

  ChatDataObject.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ChatDataa.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class ChatDataa {
  int? id;
  String? roomName;
  bool? isBlockedByYou;
  int? roomID;
  String? groupName;
  String? groupImage;
  bool? isGroup;
  bool? isPinned;
  RxBool isChatPinned = false.obs;
  RxBool isSend = false.obs;
  Rxn<HistoryDetails> lastMessage = Rxn();
  RxBool isReadByYou = false.obs;
  String? createdAt;
  String? updatedAt;
  double? epoch_time;
  int? index;
  int? totalHistoryRecords;

  List<Participate>? participate;
  //String? lastMessageAt;
  bool? isConnectionVerified;
  String? userType;

  int get getEpochTimeNew {
      var date = DateUtil.stringToDateTime(date: updatedAt ?? "",isUTC: true,dateFormat: DateUtil.serverDateTimeFormat1);
      return date.microsecondsSinceEpoch;
  }
  ChatDataa(
      {this.id,
        this.roomName,
        this.roomID,
        this.isBlockedByYou,
        this.groupName,
        this.groupImage,
        this.isGroup,
        this.isPinned,
        this.epoch_time,
        this.createdAt,
        this.updatedAt,
        this.participate,
        this.totalHistoryRecords,
         //this.lastMessageAt,
      this.isConnectionVerified,this.userType,this.index});

  ChatDataa.fromHistoryObject(HistoryDetails obj) {
    id = obj.roomId ?? -1;
    roomID = obj.roomId ?? -1;
    roomName = obj.roomName ?? "";
    groupName = obj.groupName ?? "";
    groupImage = obj.senderProfile ?? "";
    isGroup = obj.isGroup ?? false;
    lastMessage.value = obj ;
  }


  ChatDataa.fromJson(Map<String, dynamic> json) {
    if(json['id'] is String){
      id = int.parse(json['id'] ?? "-1");
    }else{
      id = json['id'];
    }

    if(json['room_id'] is String){
      roomID = int.parse(json['room_id'] ?? "-1");
    }else{
      roomID = json['room_id'];
    }
    if(json['epoch_time'] is int){
      epoch_time = (json['epoch_time'] as int).toDouble();
    }else{
      epoch_time = json['epoch_time'];
    }
    isBlockedByYou = json['is_blocked_by_you'];
    roomName = json['room_name'];
    groupName = json['group_name'];
    if(json['group_image'] != null){
      var image = json['group_image'] as String ;
      if(image.startsWith("http")){
        groupImage = json['group_image'];
      }else{
        groupImage = "${ApiConstant.baseDomain}/media/${json['group_image']}";
      }

    }

    isGroup = json['is_group'];
    isPinned = json['is_pinned'];
    isChatPinned.value = isPinned ?? false;
    lastMessage.value = json['last_message'] != null ? HistoryDetails.fromJson(json['last_message']) : null;
    isReadByYou.value = json['is_read_by_you'] ?? false;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['participant'] != null) {
      participate = <Participate>[];
      json['participant'].forEach((v) {
        participate!.add(Participate.fromJson(v));
      });
    }
    if (json['participants'] != null) {
      participate = <Participate>[];
      json['participants'].forEach((v) {
        participate!.add(Participate.fromJson(v));
      });
    }


    //lastMessageAt = json['last_message_at'];
    isConnectionVerified = json['is_connection_verified'];
    userType = json['user_type'];
    index = json['index'];
    totalHistoryRecords = json['totalRecord'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['room_id'] = roomID;
    data['room_name'] = roomName;
    data['room_name'] = roomName;
    data['group_name'] = groupName;
    data['group_image'] = groupImage;
    data['is_group'] = isGroup;
    data['is_pinned'] = isPinned;
    if (lastMessage.value != null) {
      data['last_message'] = lastMessage.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (participate != null) {
      data['participate'] = participate!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ForumId {
  int? forumId;
  PostedBy? postedBy;
  String? description;
  List<ForumMedia>? forumMedia;

  ForumId({this.forumId, this.postedBy, this.description, this.forumMedia});

  ForumId.fromJson(Map<String, dynamic> json) {

    if(json['id'] is String){
      forumId = int.parse(json['id'] ?? "-1");
    }else{
      forumId = json['id'];
    }
    postedBy = json['postedBy'] != null
        ? PostedBy.fromJson(json['postedBy'])
        : null;
    description = json['description'];
    if (json['formMedia'] != null) {
      forumMedia = <ForumMedia>[];
      json['formMedia'].forEach((v) {
        forumMedia!.add(ForumMedia.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['forum_id'] = forumId;
    if (postedBy != null) {
      data['postedBy'] = postedBy!.toJson();
    }
    data['description'] = description;
    if (forumMedia != null) {
      data['forumMedias'] = forumMedia!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ForumMedia {
  int? id;
  String? mediaType;
  String? forumMedia;
  String? thumbnail;
  String? createdAt;

  ForumMedia(
      {this.id,
        this.mediaType,
        this.forumMedia,
        this.thumbnail,
        this.createdAt});

  ForumMedia.fromJson(Map<String, dynamic> json) {
    if(json["forummedia_id"] != null ){
      var newJson =  json["forummedia_id"] as Map<String, dynamic>;
      if(newJson['id'] is String){
        id = int.parse(newJson['id'] ?? "-1");
      }else{
        id = newJson['id'];
      }
      mediaType = newJson['media_type'];
      forumMedia = newJson['forum_media'];
      thumbnail = newJson['thumbnail'];
      //forumMedia = newJson['forum_media'] != null ? (newJson['forum_media'].toString().startsWith('http') ? (newJson['forum_media']) : ("${ApiConstant.imageBaseDomain}/${newJson['forum_media']}")) : newJson['forum_media'];
      //thumbnail = newJson['thumbnail'] != null ? (newJson['thumbnail'].toString().startsWith('http') ? (newJson['thumbnail']) : ("${ApiConstant.imageBaseDomain}/${newJson['thumbnail']}")) : newJson['thumbnail'];
      createdAt = newJson['created_at'];
    }else{
      if(json['id'] is String){
        id = int.parse(json['id'] ?? "-1");
      }else{
        id = json['id'];
      }
      mediaType = json['media_type'];
      forumMedia = json['forum_media'] != null ? "${ApiConstant.imageBaseDomain}/${json['forum_media']}":json['forum_media'];
      thumbnail = json['thumbnail'] != null ? "${ApiConstant.imageBaseDomain}/${json['thumbnail']}":json['thumbnail'];
      createdAt = json['created_at'];
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['media_type'] = mediaType;
    data['forum_media'] = forumMedia;
    data['thumbnail'] = thumbnail;
    data['created_at'] = createdAt;
    return data;
  }
}


class FeedId {
  int? feedId;
  PostedBy? postedBy;
  String? description;

  List<FeedMedia>? feedMedia;

  FeedId({this.feedId, this.postedBy, this.description, this.feedMedia});

  FeedId.fromJson(Map<String, dynamic> json) {
    if(json['id'] is String){
      feedId = int.parse(json['id'] ?? "-1");
    }else{
      feedId = json['id'];
    }

    postedBy = json['postedBy'] != null
        ? PostedBy.fromJson(json['postedBy'])
        : null;
    description = json['description'];
    if (json['feedMedias'] != null) {
      feedMedia = <FeedMedia>[];
      json['feedMedias'].forEach((v) {
        feedMedia!.add(FeedMedia.fromJson(v));
      });
    }
  }

}

class PostedBy {
  int? id;
  String? firstName;
  String? lastName;
  String? profileImg;

  PostedBy({this.id, this.firstName, this.lastName, this.profileImg});

  PostedBy.fromJson(Map<String, dynamic> json) {
    if(json['id'] is String){
      id = int.parse(json['id'] ?? "-1");
    }else{
      id = json['id'];
    }
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImg = json['profile_img'] != null ? (json['profile_img'].toString().startsWith('http') ? (json['profile_img']) : ("${ApiConstant.imageBaseDomain}/${json['profile_img']}")) : json['profile_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['profile_img'] = profileImg;
    return data;
  }
}

class ChatMedia {
  int? id;
  String? mediaType;
  String? chatMedia;
  String? thumbnail;
  String? createdAt;

  ChatMedia({this.id, this.mediaType, this.chatMedia, this.thumbnail, this.createdAt});

  ChatMedia.fromJson(Map<String, dynamic> json) {
    if(json['id'] is String){
      id = int.parse(json['id'] ?? "-1");
    }else{
      id = json['id'];
    }
    mediaType = json['media_type'];
    chatMedia = json['chat_media'];
    thumbnail = json['thumbnail'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['media_type'] = mediaType;
    data['chat_media'] = chatMedia;
    data['thumbnail'] = thumbnail;
    data['created_at'] = createdAt;
    return data;
  }
}

class Participate {
  int? id;
  String? firstName;
  String? lastName;
  String? profileImg;

  Participate({this.id, this.firstName, this.lastName, this.profileImg});

  Participate.fromJson(Map<String, dynamic> json) {
    if(json['id'] is String){
      id = int.parse(json['id'] ?? "-1");
    }else{
      id = json['id'];
    }
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImg = json['profile_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['profile_img'] = profileImg;
    return data;
  }
}
