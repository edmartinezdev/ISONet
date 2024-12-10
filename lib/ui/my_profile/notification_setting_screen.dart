import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/my_profile/notifiation_setting_controller.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/app_common_stuffs/app_colors.dart';
import '../../utils/app_common_stuffs/app_logger.dart';
import '../../utils/app_common_stuffs/strings_constants.dart';
import '../style/appbar_components.dart';
import '../style/dialog_components.dart';
import '../style/text_style.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingScreen> createState() => _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  NotificationSettingController notificationSettingController = Get.find<NotificationSettingController>();
  RxBool isPermissionGranted = false.obs;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowLoaderDialog.showLoaderDialog(context);
    });
    notificationSettingController.getNotificationTypeListApi();
    if (Platform.isAndroid) {
      notificationPermission();
    }
    super.initState();
  }

  notificationPermission() async {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 32) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        badge: true,
        announcement: true,
        sound: true,
        alert: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        isPermissionGranted.value = true;
      } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
        // User has denied permission for the app to send notifications
        // ignore: use_build_context_synchronously
        DialogComponent.showAlert(

          context,
          arrButton: [AppStrings.cancel,AppStrings.settingText],
          callback: (btnIndex) {
            if(btnIndex == 1){
              openAppSettings();
            }
          },
          barrierDismissible: true,
        );
      } else {
        // User has not yet been prompted for permission
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBody(),
      body: buildBody(),
    );
  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      titleWidget: Text(
        AppStrings.pushNotification,
        style: ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.headingTitleColor),
      ),
      centerTitle: true,
    );
  }

  ///Scaffold Body
  Widget buildBody() {
    return SafeArea(
      child: Obx(
        () => ListView.builder(
          itemCount: notificationSettingController.notificationTypeList.length,
          itemBuilder: (BuildContext context, int index) {
            var notificationData = notificationSettingController.notificationTypeList[index];
            if (notificationData.notificationType == AppStrings.generalKey || notificationData.notificationType == AppStrings.adminKey) {
              return Container();
            } else {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25.0.w, vertical: 8.0.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notificationData.notificationType == AppStrings.newsFeedType
                                    ? AppStrings.newsFeedNotification
                                    : notificationData.notificationType == AppStrings.connectReType
                                        ? AppStrings.requestNotification
                                        : "${notificationData.notificationType ?? ''} ${notificationData.notificationType?.toLowerCase() == AppStrings.allC.toLowerCase() ? AppStrings.notifications : AppStrings.notification}",
                                style: ISOTextStyles.openSenseBold(size: 12, color: AppColors.notificationTitleBlack),
                              ),
                              4.sizedBoxH,
                              Text(
                                AppStrings.notificationSubtitle,
                                style: ISOTextStyles.openSenseRegular(size: 12, color: AppColors.lightGrey),
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => CupertinoSwitch(
                            value: notificationData.isNotificationEnable.value,
                            onChanged: (value) {
                              notificationData.isNotificationEnable.value = value;

                              ShowLoaderDialog.showLoaderDialog(context);
                              notificationSettingController.getNotificationTypeListApi(notificationOnOffType: notificationData.notificationType);
                              Logger().i(notificationData.isNotificationEnable.value);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                    child: const Divider(
                      thickness: 1,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
