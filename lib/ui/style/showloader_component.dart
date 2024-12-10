import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../utils/app_common_stuffs/app_colors.dart';

class ShowLoaderDialog {
  static showLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const WillPopScope(
          onWillPop: willPop,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          ),
        );
      },
    );
  }

  static showLoaderDialogCreateGroup(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: willPop,
          child: Center(
            child: Column(
              children: [
                const CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
                8.sizedBoxH,
                Text(
                  'Creating group',
                  style: ISOTextStyles.openSenseRegular(color: AppColors.whiteColor, size: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static dismissLoaderDialog() {
    Get.back();
  }

  static showLinearProgressIndicatorForFileUpload({required BuildContext context, double? percentage}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: willPop,
          child: Dialog(
            backgroundColor: AppColors.transparentColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Uploading',
                      style: TextStyle(color: AppColors.whiteColor, fontSize: 28.0.sp, fontWeight: FontWeight.w900),
                    ),
                    /*Text(
                      '${((percentage ?? 0.0) * 100).toStringAsFixed(0)} %',
                      style: TextStyle(color: AppColors.whiteColor, fontSize: 22.0.sp, fontWeight: FontWeight.w900),
                    ),*/
                  ],
                ),
                25.sizedBoxH,
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.greyColor,
                    color: AppColors.primaryColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                    value: percentage,
                    minHeight: 10.0.h,
                  ),
                ),
                25.sizedBoxH,
                Text(
                  'Do not press back or close an app while uploading',
                  style: TextStyle(color: AppColors.whiteColor, fontSize: 12.0.sp, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<bool> willPop() async {
    return false;
  }
}
