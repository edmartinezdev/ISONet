class NotificationListModel {
  int? totalRecord;
  int? filterRecord;
  List<NotificationListData>? data;

  NotificationListModel({this.totalRecord, this.filterRecord, this.data});

  NotificationListModel.fromJson(Map<String, dynamic> json) {
    totalRecord = json['total_record'];
    filterRecord = json['filter_record'];
    if (json['data'] != null) {
      data = <NotificationListData>[];
      json['data'].forEach((v) {
        data!.add(NotificationListData.fromJson(v));
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

class NotificationListData {
  int? id;
  String? title;
  String? description;
  String? notificationType;
  ExtraData? extraData;
  bool? isRead;
  String? createdAt;
  String? updatedAt;
  int? user;

  NotificationListData({this.id, this.title, this.description, this.notificationType, this.extraData, this.isRead, this.createdAt, this.updatedAt, this.user});

  NotificationListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    notificationType = json['notification_type'];
    extraData = json['extra_data'] != null ? ExtraData.fromJson(json['extra_data']) : null;
    isRead = json['is_read'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['notification_type'] = notificationType;
    data['extra_data'] = extraData;
    data['is_read'] = isRead;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user'] = user;
    return data;
  }
}

class ExtraData {
  int? notificationType;
  int? feedId;
  int? forumId;
  int? companyId;
  String? roomName;
  String? groupName;
  bool? isGroup;
  String? link;

  ExtraData({this.notificationType, this.feedId, this.forumId, this.companyId,this.link,this.groupName,this.isGroup,this.roomName});

  ExtraData.fromJson(Map<String, dynamic> json) {
    notificationType = json['notification_type'];
    feedId = json['feed_id'];
    forumId = json['forum_id'];
    companyId = json['company_id'];
    roomName = json['room_name'];
    groupName = json['group_name'];
    isGroup = json['is_group'];
    link = json['link'];
  }
}
