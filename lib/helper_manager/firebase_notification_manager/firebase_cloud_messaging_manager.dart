import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:iso_net/bindings/bottom_tabs/forum_detail_binding.dart';
import 'package:iso_net/controllers/app/app_controller.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/setting_controller/company_setting_controller.dart';
import 'package:iso_net/controllers/my_profile/my_profile_controller.dart';
import 'package:iso_net/helper_manager/socket_manager/socket_manager_new.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/forum/forum_detail_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/feed_detail_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/settings_screen/company_setting_screen.dart';
import 'package:iso_net/utils/app_map_keys.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';

import '../../bindings/bottom_tabs/feed_detail_binding.dart';
import '../../bindings/bottom_tabs/setting_binding/company_setting_binding.dart';
import '../../utils/app_common_stuffs/app_logger.dart';
import '../../utils/app_common_stuffs/commom_utils.dart';
import '../../utils/app_common_stuffs/screen_routes.dart';

class FireBaseCloudMessagingWrapper extends Object {
  RemoteMessage? pendingNotification;

  FirebaseMessaging? _fireBaseMessaging;
  String _fcmToken = "";

  //final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  String get fcmToken => _fcmToken;
  String newMessageId = '';

  bool _isAppStarted = false; // Used for identify if navigation instance created

  factory FireBaseCloudMessagingWrapper() {
    return _singleton;
  }

  static final FireBaseCloudMessagingWrapper _singleton = FireBaseCloudMessagingWrapper._internal();

  FireBaseCloudMessagingWrapper._internal() {
    Logger().e("===== Firebase Messaging instance created =====");
    _fireBaseMessaging = FirebaseMessaging.instance;
    firebaseCloudMessagingListeners();
  }

  void iOSPermission() async {
    /*NotificationSettings settings = await _fireBaseMessaging!.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
    );*/
    _fireBaseMessaging!.getNotificationSettings();
  }

  Future<String?> getFCMToken() async {
    try {
      String? token = await _fireBaseMessaging?.getToken();
      if ((token ?? '').isNotEmpty) {
        Logger().i("FCM Token :: $token");
        _fcmToken = token ?? '';
      }
      return _fcmToken;
    } catch (e) {
      if (kDebugMode) {
        print("Error :: ${e.toString()}");
      }
      return null;
    }
  }

  Future<void> deleteFCMToken() async {
    await _fireBaseMessaging?.deleteToken();
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    _fireBaseMessaging?.getInitialMessage().then((RemoteMessage? message) {
      Logger().i("getInitialMessage :: $message");
      if (message != null) {
        //goToSignUp(payload: message.data);
        if (_isAppStarted) {
        } else {
          pendingNotification = message;
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Logger().v("onMessage notification :: ${message.notification.toString()}");
      Logger().v("onMessage data :: ${message.data.toString()}");
      if (message.data.isNotEmpty && (message.data[AppStrings.notificationTypeKey] == null || message.data[AppStrings.notificationTypeKey] == '8')) {
        var msg = json.decode(message.data["data"]);
        if (msg[AppStrings.notificationTypeKey] == '8') {
          return;
        }
      } else {
        MyProfileController myProfileController = Get.put(MyProfileController());
        myProfileController.myProfileData.value?.isReadNotification.value = false;
        /*if(Get.isRegistered<NotificationListingController>() == true){
          NotificationListingController notificationListingController = Get.find();
          notificationListingController.notificationListApi(isShowLoader: true);
          FlutterAppBadger.removeBadge();
        }*/

      }

      FlutterAppBadger.updateBadgeCount(int.parse(message.data['badge'] ?? '0'));

      if (SocketManagerNew().isChatScreenOpened == false && message.messageId != newMessageId) {
        newMessageId = message.messageId!;
        String? title = message.notification?.title ?? AppStrings.appName;
        String body = message.notification?.body ?? "";
        String? channelID = message.notification?.android?.channelId;
        String color = message.notification?.android?.color ?? "#eb3434";
        //Map<String, String> stringQueryParameters = message.data.map((key, value) => MapEntry(key, value.toString()));
        if (Platform.isAndroid) {
          Future.delayed(const Duration(seconds: 1), () async {
            await AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: DateTime.now().millisecondsSinceEpoch.remainder(10),
                  title: title,
                  body: body,
                  channelKey: channelID ?? 'default',
                  notificationLayout: NotificationLayout.Default,
                  payload: Map.castFrom(message.data),
                  color: hexToColor(color)),
            );
          });
        }

        /*Future.delayed(const Duration(seconds: 1), () => displayNotificationView(payload: message));*/

      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Logger().v("onMessageOpenedApp :: $message");
      notificationClickActionEvent(payload: message.data, name: message.notification?.body?.split('sent').first ?? '');
      FlutterAppBadger.updateBadgeCount(int.parse(message.data['badge'] ?? '0'));
      /*CommonUtils.setNotificationStatus(false);
      CommonUtils.notificationStatus.sink.add(false);*/
      if (message.data.isNotEmpty && message.data[AppStrings.notificationTypeKey] == null) {
        var msg = json.decode(message.data["data"]);
        if (msg[AppStrings.notificationTypeKey] == '8') {
          return;
        }
        return;
      } else {
        MyProfileController myProfileController = Get.put(MyProfileController());
        myProfileController.myProfileData.value?.isReadNotification.value = false;
        /*if(Get.isRegistered<NotificationListingController>() == true){
          NotificationListingController notificationListingController = Get.find();
          notificationListingController.notificationListApi(isShowLoader: true);
          FlutterAppBadger.removeBadge();
        }*/
      }
    });

    FirebaseMessaging.onBackgroundMessage.call(handleBackgroundMessage);
  }

  checkForPendingNotification() async {
    _isAppStarted = true;
    Logger().e("Check Operation for pending notification");
    if (pendingNotification == null) {
      Logger().i("onBackgroundMessage :: hhhhhhhhh*********");
      return null;
    }
    Logger().i("onBackgroundMessage :: hhhhhhhhh*********////////////////////");
    await handleRoutes(pendingNotification?.data, pendingNotification?.notification?.body?.split('sent').first ?? '');
    pendingNotification = null;
  }
}

Future<void> handleBackgroundMessage(RemoteMessage remoteMessage) async {
  CommonUtils.setNotificationStatus(true);
  CommonUtils.notificationStatus.sink.add(true);
  Logger().i("onBackgroundMessage :: $remoteMessage");
  FlutterAppBadger.updateBadgeCount(int.parse(remoteMessage.data['badge']));
  Logger().i(FlutterAppBadger.updateBadgeCount(int.parse(remoteMessage.data['badge'])));

  //FireBaseCloudMessagingWrapper().goToSignUp(payload: remoteMessage.data);
  //AwesomeNotifications().createNotificationFromJsonData(remoteMessage.data);
}

void displayNotificationView({required RemoteMessage payload}) async {
  MyProfileController myProfileController = Get.put(MyProfileController());
  myProfileController.myProfileData.value?.isReadNotification.value = false;
  String icon = 'resource://mipmap/ic_launcher';
  String title = payload.notification?.title ?? 'pushNotification';
  String body = payload.notification?.body ?? "";
  String channelID = payload.notification?.android?.channelId ?? 'default';
  String color = payload.notification?.android?.color ?? "#eb3434";
  Logger().v("--- Display notification view ---");
  Logger().v("displayNotificationView: channel id -> $channelID");

  await AwesomeNotifications().createNotification(
    actionButtons: [NotificationActionButton(key: 'Close', label: 'Close')],
    content: NotificationContent(
      icon: icon,
      id: DateTime.now().millisecondsSinceEpoch.remainder(10),
      title: title,
      body: body,
      channelKey: channelID.isEmpty ? 'default' : channelID,
      color: hexToColor(color),
      payload: Map.castFrom(payload.data),
    ),
  );
}

extension NOperation on FireBaseCloudMessagingWrapper {
  void notificationClickActionEvent({dynamic payload, String? name}) {
    handleRoutes(payload, name);
  }
}

handleRoutes(payload, String? name) async {
  Logger().i("Payload $payload");

  if (payload[AppStrings.notificationTypeKey] != null) {
    String notificationType = payload[AppStrings.notificationTypeKey];
    if (notificationType == '1' || notificationType == '2') {
      Future.delayed(
        const Duration(milliseconds: 100),
        () => Get.to(FeedDetailScreen(feedId: int.parse(payload[AppStrings.feedIdKey])), binding: FeedDetailBinding()),
      );
    } else if (notificationType == '3' || notificationType == '4') {
      Future.delayed(
        const Duration(milliseconds: 100),
        () => Get.to(ForumDetailScreen(forumId: int.parse(payload[AppStrings.forumIdKey])), binding: ForumDetailBinding()),
      );
    } else if (notificationType == '5') {
      /*BottomTabsController bottomTabsController = Get.find();
      bottomTabsController.currentIndex.value = 3;
      bottomTabsController.tabController.index = 3;*/
      Future.delayed(
        const Duration(milliseconds: 100),
        () => Get.toNamed(ScreenRoutesConstants.viewAllRequestScreen),
      );
      // Future.delayed(
      //   const Duration(milliseconds: 100),
      //       () => Get.to(ForumDetailScreen(forumId: int.parse(payload[AppStrings.forumIdKey])), binding: ForumDetailBinding()),
      // );
    } else if (notificationType == '6') {
      CompanySettingController companySettingController = Get.put(CompanySettingController());
      await companySettingController.companyProfileApiCall();
      await companySettingController.companyReviewListApi();
      companySettingController.currentTabIndex.value = 1;

      Future.delayed(const Duration(milliseconds: 100), () {
        Get.to(
          const CompanySettingScreen(),
          binding: CompanySettingBinding(),
        );
      });
      // Future.delayed(
      //   const Duration(milliseconds: 100),
      //       () => Get.to(ForumDetailScreen(forumId: int.parse(payload[AppStrings.forumIdKey])), binding: ForumDetailBinding()),
      // );
    } else if (notificationType == '8') {
      var jsonData = json.decode(payload["data"]);
      if (jsonData != null) {
        Future.delayed(const Duration(milliseconds: 100), () {
          Get.toNamed(ScreenRoutesConstants.oneToOneChatScreen, arguments: [jsonData[AppMapKeys.room_id], jsonData[AppMapKeys.group_name] ?? '', jsonData[AppStrings.isGroupKey]]);
        });
      }
    } else if (notificationType == '13') {
      Future.delayed(const Duration(milliseconds: 100), () {
        Get.toNamed(
          ScreenRoutesConstants.loanApprovalScreen,
        );
      });
    } else if (notificationType == '14') {
      MyProfileController myProfileController = Get.put(MyProfileController());
      myProfileController.currentTabIndex.value = 1;
      Future.delayed(const Duration(milliseconds: 100), () {
        Get.toNamed(ScreenRoutesConstants.myProfileScreen, arguments: userSingleton.id);
      });
    }
  } else if (payload['data'] != null) {
    var jsonData = json.decode(payload["data"]);
    if (jsonData != null) {
      if (jsonData[AppStrings.notificationTypeKey] == 8) {
        if (SocketManagerNew().isChatScreenOpened == false) {
          Future.delayed(const Duration(milliseconds: 100), () {
            Get.toNamed(ScreenRoutesConstants.oneToOneChatScreen, arguments: [jsonData[AppMapKeys.room_id], jsonData[AppMapKeys.group_name] ?? '', jsonData[AppStrings.isGroupKey]]);
          });
        }
      }
    }
  } else {
    AppController appController = Get.find();
    if (userSingleton.isSubscribed == false) {
      Future.delayed(
        const Duration(milliseconds: 100),
        () => Get.offAllNamed(appController.route),
      );
    } else {
      Future.delayed(
        const Duration(milliseconds: 100),
        () => Get.toNamed(ScreenRoutesConstants.notificationListingScreen),
      );
    }
  }
}

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}
