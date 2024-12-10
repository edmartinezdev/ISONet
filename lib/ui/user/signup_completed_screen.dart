import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../utils/app_common_stuffs/app_colors.dart';
import '../../utils/app_common_stuffs/screen_routes.dart';
import '../style/appbar_components.dart';
import '../style/button_components.dart';
import '../style/text_style.dart';

class SignUpCompletedScreen extends StatefulWidget {
  const SignUpCompletedScreen({Key? key}) : super(key: key);

  @override
  State<SignUpCompletedScreen> createState() => _SignUpCompletedScreenState();
}

class _SignUpCompletedScreenState extends State<SignUpCompletedScreen> {
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
      leadingWidget: Container(),
    );
  }

  ///Scaffold Body
  Widget buildBody() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0.h, horizontal: 16.0.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          titleBody(),
          doneButtonBody(),
        ],
      ),
    );
  }

  ///title body
  Widget titleBody() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.thanksSubmission,
            style: ISOTextStyles.openSenseBold(size: 24),
            textAlign: TextAlign.center,
          ),
          18.sizedBoxH,
          Text(
            AppStrings.weWillBeInTouch,
            style: ISOTextStyles.openSenseLight(size: 20),
          ),
        ],
      ),
    );
  }

  ///button body
  Widget doneButtonBody() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0.h),
      child: ButtonComponents.cupertinoButton(
        width: double.infinity,
        context: context,
        title: AppStrings.bDone,
        backgroundColor: AppColors.primaryColor,
        onTap: () {
          Get.offAllNamed(ScreenRoutesConstants.userApproveWaitingScreen);
        },
      ),
    );
  }
}
