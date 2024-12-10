

import 'package:get/get.dart';

class NotificationSettingModel {
  int? id;
  List<NotificationTypesList>? notificationTypesList;

  NotificationSettingModel({this.id, this.notificationTypesList});

  NotificationSettingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['notification_types'] != null) {
      notificationTypesList = <NotificationTypesList>[];
      json['notification_types'].forEach((v) {
        notificationTypesList!.add(NotificationTypesList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (notificationTypesList != null) {
      data['notification_types'] =
          notificationTypesList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationTypesList {
  String? notificationType;
  bool? isEnable;
  RxBool isNotificationEnable = false.obs;

  NotificationTypesList({this.notificationType, this.isEnable});

  NotificationTypesList.fromJson(Map<String, dynamic> json) {
    notificationType = json['notification_type'];
    isEnable = json['is_enable'];
    isNotificationEnable.value = json['is_enable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notification_type'] = notificationType;
    data['is_enable'] = isEnable;
    return data;
  }
}
