import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';

import 'image_components.dart';

class ButtonComponents {
  static cupertinoButton({
    required BuildContext context,
    required String title,
    Color? backgroundColor,
    Color? textColor,
    VoidCallback? onTap,
    double? width,
    TextStyle? textStyle,
    int? textSize,
  }) {
    return SizedBox(
      width: width,
      child: CupertinoButton(
        color: backgroundColor ?? AppColors.primaryColor,

        onPressed: onTap,
        child: FittedBox(
          child: Text(
            title,
            style:ISOTextStyles.openSenseSemiBold(color: textColor ?? AppColors.blackColor, size: textSize ?? 17),
          ),
        ),
      ),
    );
  }

  static textButton({
    required BuildContext context,
    required VoidCallback onTap,
    required String title,
    TextStyle? textStyle,
    Color? textColor,
    Alignment? alignment,
  }) {
    return Container(
      alignment: alignment,
      child: TextButton(
        style: TextButton.styleFrom(
          primary: textColor,
        ),
        onPressed: onTap,
        child: Text(
          title,
          style: textStyle,
        ),
      ),
    );
  }

  static textIconButton({
     VoidCallback? onTap,
    TextStyle? textStyle,
    Color? buttonColor,
    double? iconHeight,
    Alignment? alignment,
    required String icon,
    required String labelText,
    Color? iconColor,
    BoxFit? boxFit
  }) {
    return TextButton.icon(

      style: TextButton.styleFrom(
        primary: buttonColor ?? AppColors.hintTextColor, padding: EdgeInsets.zero,
        alignment: alignment,
      ),
      onPressed: onTap,
      icon: ImageComponent.loadLocalImage(imageName: icon, imageColor: iconColor,height: iconHeight,width: iconHeight,boxFit: boxFit),
      label: Text(
        labelText,
        style: textStyle ?? ISOTextStyles.sfProTextSemiBold(size: 14),
      ),
    );
  }

  static cupertinoTextButton({
    required BuildContext context,
    required VoidCallback onTap,
    required String title,
    TextStyle? textStyle,
    Color? textColor,
    Alignment? alignment,
  }) {
    return CupertinoButton(
      alignment: alignment ?? Alignment.center,
      onPressed: onTap,

      child: Text(
        title,
        style: textStyle,
      ),
    );
  }
}
