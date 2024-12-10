import 'package:flutter/cupertino.dart';
import 'package:iso_net/model/bottom_navigation_models/chat_model/recent_chat_model.dart';
import 'package:iso_net/utils/date_util.dart';

import 'chat_media_model.dart';

class MessageHistory {
  MessageHistoryData? messageHistory;

  MessageHistory({this.messageHistory});

  MessageHistory.fromJson(Map<String, dynamic> json) {
    messageHistory = json['message_history'] != null
        ? MessageHistoryData.fromJson(json['message_history'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (messageHistory != null) {
      data['message_history'] = messageHistory!.toJson();
    }
    return data;
  }
}

class MessageHistoryData {
  int? totalRecord;
  bool? isBlockedByYou;
  String? imageUrl;
  String? reciverId;
  int? filterRecord;
  List<HistoryDetails>? data;

  MessageHistoryData({this.totalRecord, this.filterRecord, this.data,this.isBlockedByYou,this.reciverId});

  MessageHistoryData.fromJson(Map<String, dynamic> json) {
    totalRecord = json['totalRecord'];
    filterRecord = json['filter_record'];
    isBlockedByYou = json['is_blocked_by_you'];
    imageUrl = json['imageUrl'];
    reciverId = json['opp_user_id'];
    if (json['result'] != null) {
      data = <HistoryDetails>[];
      json['result'].forEach((v) {
        data!.add(HistoryDetails.fromJson(v));
      });
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

class HistoryDetails {
  int? id;
  String? roomName;
  int? roomId;
  String? groupName;
  String? message;
  int? sender;
  String? senderName;
  String? senderProfile;
  TextSpan? highlightedText;
  bool? isMessageSendByYou;
  bool? isGroup;
  String? type;
  String? timestamp;
  FeedId? feedId;
  ForumId? forumId;
  List<MediaData>? chatMedia;
  List<dynamic>? readBy;

  String get getTimesAgo {
    if (timestamp != null || timestamp?.isNotEmpty == true) {
      var datee = DateUtil.dateTimeToString(date: DateUtil.stringToDateTime(date: timestamp ?? "",isUTC:true,dateFormat: DateUtil.serverDateTimeFormat1));
      return DateUtil.getDateInRequiredFormat(date: datee, requiredFormat: "MMM dd yy, hh:mm a");
    } else {
      return "";
    }
  }
  String get getTimesRecentAgo {
    if (timestamp != null || timestamp?.isNotEmpty == true) {
      return _getTimeForChats();
    } else {
      return "";
    }
  }

  _getTimeForChats(){
    DateTime currentDateTime = DateTime.now();
    DateTime messageDateTime = DateUtil.stringToDate(timestamp ?? "", isUTCtime: true);
    int diffInMillisec = currentDateTime.millisecondsSinceEpoch - messageDateTime.millisecondsSinceEpoch;
    int elapsedDays = diffInMillisec / 1000 / 60 / 60 ~/ 24;

    if (elapsedDays >= 1) {
      return getTimesAgo;
    }else{
      return DateUtil.getLeftTime(timestamp ?? '');
    }
  }
  HistoryDetails(
      {this.id,
        this.roomName,
        this.groupName,
        this.message,
        this.sender,
        this.senderName,
        this.senderProfile,
        this.isMessageSendByYou,
        this.isGroup,
        this.type,
        this.timestamp,
        this.roomId,
        this.feedId,
        this.forumId,
        this.chatMedia,
        this.readBy});

  HistoryDetails.fromJson(Map<String, dynamic> json) {
    if(json['id'] is String){
      id = int.parse(json['id'] ?? "-1");
    }else{
      id = json['id'];
    }
    if(json['sender'] is String){
      id = int.parse(json['sender'] ?? "-1");
    }else{
      id = json['sender'];
    }

    if(json['room_id'] is String){
      roomId = int.parse(json['room_id'] ?? "-1");
    }else{
      roomId = json['room_id'];
    }

    roomName = json['room_name'];
    groupName = json['group_name'];
    message = json['message'];
    senderName = json['sender_name'];
    senderProfile = json['sender_profile'];
    isMessageSendByYou = json['is_message_send_by_you'];
    isGroup = json['is_group'];
    type = json['type'];
    timestamp = json['timestamp'];
    //feedId = json['feed_id'];
    if(json['feed_id'] is String){

    }else{
      feedId = json['feed_id'] != null
          ? FeedId.fromJson(json['feed_id'])
          : null;
    }

    if(json['forum_id'] is String){

    }else{
      forumId = json['forum_id'] != null
          ? ForumId.fromJson(json['forum_id'])
          : null;
    }


    //chatMedia = json['chat_media'];
    readBy = json['read_by'];
    if (json['chat_media'] != null) {
      chatMedia = <MediaData>[];
      json['chat_media'].forEach((v) {
        chatMedia!.add(MediaData.fromJson(v));
      });
    }
    // if (json['read_by'] != null) {
    //   readBy = <Null>[];
    //   json['read_by'].forEach((v) {
    //     readBy!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['room_name'] = roomName;
    data['group_name'] = groupName;
    data['message'] = message;
    data['sender'] = sender;
    data['sender_name'] = senderName;
    data['sender_profile'] = senderProfile;
    data['is_message_send_by_you'] = isMessageSendByYou;
    data['is_group'] = isGroup;
    data['type'] = type;
    data['timestamp'] = timestamp;
    //data['feed_id'] = feedId;

    if (forumId != null) {
      data['forum_id'] = forumId!.toJson();
    }
    if (chatMedia != null) {
      data['chat_media'] = chatMedia!.map((v) => v.toJson()).toList();
    }
    if (readBy != null) {
      data['read_by'] = readBy!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}