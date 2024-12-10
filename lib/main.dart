import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_places_picker/google_places_picker.dart';
import 'package:iso_net/bindings/bottom_tabs/bottom_tabs_bindings.dart';
import 'package:iso_net/controllers/app/app_controller.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';

import 'EnvironmentHelper.dart';
import 'helper_manager/firebase_notification_manager/awesome_notification_util.dart';
import 'helper_manager/firebase_notification_manager/firebase_cloud_messaging_manager.dart';
import 'utils/app_common_stuffs/app_routes.dart';
import 'utils/enums_all/enums.dart';

var env = Environment.prod;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AppController appController = Get.put<AppController>(AppController());
  await appController.initUserData();
  AwesomeNotificationUtil.initNotification();
  if (Platform.isIOS) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  } else {
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 32) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.requestPermission(
        badge: true,
        announcement: true,
        sound: true,
        alert: true,
      );
    }
  }

  var envData = await CommonUtils.getDataFromJsonEnvironment();
  EnvironmentHelper().environmentMap = envData;

  /// Place picker api key initialize
  PluginGooglePlacePicker.initialize(
    androidApiKey: EnvironmentHelper().environmentMap["place_api_key"] as String,
    iosApiKey: EnvironmentHelper().environmentMap["place_api_key"] as String,
  );

  await FireBaseCloudMessagingWrapper().getFCMToken();

  //PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 500; // 300 MB

  runApp(const IsoNet());
}

class IsoNet extends StatelessWidget {
  const IsoNet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp],
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparentColor,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return GetBuilder<AppController>(
      builder: (controller) {
        return ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (BuildContext context, Widget? child) {
            return GetMaterialApp(
              title: AppStrings.appName,
              theme: ThemeData(
                appBarTheme: const AppBarTheme(
                  surfaceTintColor: AppColors.whiteColor,
                ),
                useMaterial3: true,
                scaffoldBackgroundColor: AppColors.whiteColor,
                primaryColor: AppColors.primaryColor,
                cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: ISOTextStyles.openSenseRegular(size: 16),
                  ),
                ),
              ),
              debugShowCheckedModeBanner: false,
              initialBinding: ChatBindings(),
              getPages: AppRoutes.routes,
              initialRoute: controller.route,
            );
          },
        );
      },
    );
  }
}
