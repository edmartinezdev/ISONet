import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../../utils/app_common_stuffs/app_logger.dart';
import 'firebase_cloud_messaging_manager.dart';

class AwesomeNotificationUtil {
  static initNotification() {
    AwesomeNotifications().initialize(
      'resource://mipmap/ic_launcher',
      [
        NotificationChannel(

          icon: 'resource://mipmap/ic_launcher',
          playSound: true,
          channelKey: 'default',
          channelName: 'Default notification',
          channelDescription: 'This is default notification channel',
          importance: NotificationImportance.Max,
          channelShowBadge: true,

        ),
      ],

    );

    /// DEV NOTE -:
    /// keep this [actionStream] listener as this is needed while the app is in foreground and you have to handle notification click.
    AwesomeNotifications().actionStream.listen(
      (ReceivedAction event) {
       /* CommonUtils.setNotificationStatus(false);
        CommonUtils.notificationStatus.sink.add(false);*/
        Logger().i("On Action streams: $event");
        if(event.payload != null){
          AwesomeNotifications().setGlobalBadgeCounter(int.parse(event.payload?['badge'] ?? '0'));
          /*MyProfileController myProfileController = Get.put(MyProfileController());
          myProfileController.myProfileData.value?.isReadNotification.value = true;*/
        }

        //FireBaseCloudMessagingWrapper().firebaseCloudMessagingListeners();
        FireBaseCloudMessagingWrapper().notificationClickActionEvent(payload: event.payload,name:event.body?.split('sent').first ?? '');
      },
    );
  }

  static checkForPermission(BuildContext context) async {
    bool isNotificationAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (isNotificationAllowed) {
      Logger().v("isNotificationAllowed: $isNotificationAllowed");
    } else {
      Logger().v("isNotificationAllowed: $isNotificationAllowed");

      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Notification'),
            content: const Text('Our app requires your permission for providing you notifications.'),
            actions: [
              TextButton(
                onPressed: () {
                  Logger().v("User pressed don't allow");
                  Navigator.pop(ctx);
                },
                child: const Text("Dismiss"),
              ),
              TextButton(
                onPressed: () async {
                  Logger().v("User pressed allow");
                  Navigator.pop(ctx);
                  bool requestPermissionToSendNotifications = await AwesomeNotifications().requestPermissionToSendNotifications();
                  Logger().v("requestPermissionToSendNotifications: $requestPermissionToSendNotifications");
                },
                child: const Text("Allow"),
              ),
            ],
          );
        },
      );
    }
  }
}
