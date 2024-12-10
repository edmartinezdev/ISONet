import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iso_net/helper_manager/permission_handler.dart';
import 'package:iso_net/ui/style/dialog_components.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/app_common_stuffs/app_colors.dart';
import '../../utils/app_common_stuffs/app_images.dart';
import '../style/appbar_components.dart';
import '../style/button_components.dart';

class CheckLocationScreen extends StatefulWidget {
  const CheckLocationScreen({Key? key}) : super(key: key);

  @override
  State<CheckLocationScreen> createState() => _CheckLocationScreenState();
}

class _CheckLocationScreenState extends State<CheckLocationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }

  ///AppBar Widget
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar();
  }

  /// Scaffold Body
  Widget buildBody() {
    return SafeArea(
      child: Column(
        children: [
          locationImageBody(),
          locationTextBody(),
          locationButtonBody(),
        ],
      ),
    );
  }

  ///location Image widget
  Widget locationImageBody() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0.h),
        alignment: Alignment.bottomCenter,
        width: double.infinity,
        child: ImageComponent.loadLocalImage(imageName: AppImages.locationServices),
      ),
    );
  }

  ///location service text widget
  Widget locationTextBody() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0.h),
        alignment: Alignment.topCenter,
        child: Text(
          'Location Service',
          style: ISOTextStyles.openSenseBold(
            size: 24,
          ),
        ),
      ),
    );
  }

  ///Allow location button
  Widget locationButtonBody() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0.w,
        vertical: 16.0.h,
      ),
      child: ButtonComponents.cupertinoButton(
        context: context,
        title: 'Allow Location Service',
        onTap: () {
          checkForLocationPermission();
        },
        width: double.infinity,
      ),
    );
  }

  /// checkForLocationPermission function check location permission when user tap on allow location button
  void checkForLocationPermission() async {
    /// DEV NOTE -: all callbacks are optional
    await PermissionHandler.checkPermissions(
      permission: Permission.location,
      onLimited: () {
        Geolocator.getCurrentPosition().then(
          // ignore: avoid_print
          (value) => print(value),
        );
      },
      onGranted: () {
        Geolocator.getCurrentPosition().then(
          (value) => showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height / 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Demo Purpose showing your current lat,long',
                          style: ISOTextStyles.openSenseBold(size: 16),
                        ),
                        Text('Longitude => ${value.longitude}'),
                        Text('Latitude => ${value.latitude}'),
                      ],
                    ),
                  ),
                );
              }),
        );
      },
      onPermanentlyDenied: () {
        DialogComponent.showAlertDialog(
          context: context,
          title: AppStrings.locationAlertTitle,
          content: AppStrings.locationAlertMessage,
          arrButton: [
            Platform.isAndroid
                ? ButtonComponents.textButton(
                    context: context,
                    onTap: () => openAppSettings(),
                    title: 'Settings',
                    textColor: AppColors.blackColor,
                  )
                : ButtonComponents.cupertinoTextButton(
                    context: context,
                    onTap: () => openAppSettings(),
                    title: 'Settings',
                    textColor: AppColors.blackColor,
                  ),
          ],
        );
      },
    );
  }
}
