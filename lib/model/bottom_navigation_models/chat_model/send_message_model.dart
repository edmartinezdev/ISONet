class SendMessageModel {
  ChatMessage? chatMessage;

  SendMessageModel({this.chatMessage});

  SendMessageModel.fromJson(Map<String, dynamic> json) {
    chatMessage = json['chat_message'] != null
        ? ChatMessage.fromJson(json['chat_message'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (chatMessage != null) {
      data['chat_message'] = chatMessage!.toJson();
    }
    return data;
  }
}

class ChatMessage {
  int? id;
  String? roomName;
  String? groupName;
  String? message;
  int? sender;
  String? senderName;
  String? senderProfile;
  bool? isMessageSendByYou;
  String? type;
  String? timestamp;
  int? feedId;
  List<dynamic>? chatMedia;
  List<dynamic>? readBy;

  ChatMessage(
      {this.id,
        this.roomName,
        this.groupName,
        this.message,
        this.sender,
        this.senderName,
        this.senderProfile,
        this.isMessageSendByYou,
        this.type,
        this.timestamp,
        this.feedId,
        this.chatMedia,
        this.readBy});

  ChatMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomName = json['room_name'];
    groupName = json['group_name'];
    message = json['message'];
    sender = json['sender'];
    senderName = json['sender_name'];
    senderProfile = json['sender_profile'];
    isMessageSendByYou = json['is_message_send_by_you'];
    type = json['type'];
    timestamp = json['timestamp'];
    feedId = json['feed_id'];
    chatMedia = json['chat_media'];
    readBy = json['read_by'];
    // if (json['chat_media'] != null) {
    //   chatMedia = <Null>[];
    //   json['chat_media'].forEach((v) {
    //     chatMedia!.add(new Null.fromJson(v));
    //   });
    // }
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
    data['type'] = type;
    data['timestamp'] = timestamp;
    data['feed_id'] = feedId;
    if (chatMedia != null) {
      data['chat_media'] = chatMedia!.map((v) => v.toJson()).toList();
    }
    if (readBy != null) {
      data['read_by'] = readBy!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}