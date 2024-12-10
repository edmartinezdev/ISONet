import 'package:flutter/material.dart';

import 'app_colors.dart';

enum SnackType { success, error, warning, info }

class SnackBarUtil {
  static void showSnackBar({
    required BuildContext context,
    required SnackType type,
    required String message,
  }) {
    SnackBar snackBar = SnackBar(
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.whiteColor,
              /*fontFamily: StringConstants.robotoFont,*/
            ),
      ),
      backgroundColor: getBackgroundColorByType(snackType: type),
    );
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Color getBackgroundColorByType({required SnackType snackType}) {
    if (snackType == SnackType.success) {
      return AppColors.primaryColor;
    } else if (snackType == SnackType.warning) {
      return AppColors.primaryColor;
    } else if (snackType == SnackType.error) {
      return AppColors.redColor;
    } else {
      return AppColors.primaryColor;
    }
  }
}
