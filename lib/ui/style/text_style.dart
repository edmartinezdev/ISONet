import 'package:flutter/material.dart';

import '../../utils/app_common_stuffs/app_colors.dart';
import '../../utils/app_common_stuffs/app_fonts.dart';
import '../../utils/extensions/text_style_extension.dart';

class ISOTextStyles {
  /// DEV NOTE -: Common Styles
  static TextStyle hintTextStyle({Color? color,int? fontSize}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.hintTextColor, fontFamily: AppFont.openSenseRegular, fontSize: fontSize ?? 13);
  }

  static TextStyle textFieldTextStyle() {
    return ISOTextStyle.setTS(color: AppColors.textFieldTextColor, fontFamily: AppFont.openSenseSemiBold, fontSize: 13);
  }

  static TextStyle textFieldTitleTextStyle() {
    return ISOTextStyle.setTS(color: AppColors.textFieldTitleTextColor, fontFamily: AppFont.openSenseSemiBold, fontSize: 13);
  }

  static TextStyle buttonTextStyle({Color? color}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.whiteColor, fontFamily: AppFont.sfProDisplayMedium, fontSize: 17);
  }

  static TextStyle tabBarTextStyle({Color? color}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.greyColor, fontFamily: AppFont.sfProTextMedium, fontSize: 10);
  }

  static TextStyle appBarTitleTextStyle() {
    return ISOTextStyle.setTS(color: AppColors.blackColor, fontFamily: AppFont.sfProTextSemiBold, fontSize: 17);
  }

  /// DEV NOTE -: SFPro fonts
  static TextStyle sfPro({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.sfPro, fontSize: size ?? 16);
  }

  static TextStyle sfProMedium({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.sfPro, fontSize: size ?? 16, fontWeight: FontWeight.w500);
  }

  static TextStyle sfProSemiBold({Color? color, int? size, double? lineSpacing}) {
    return ISOTextStyle.setTS(
        color: color ?? AppColors.blackColor, fontFamily: AppFont.sfPro, fontSize: size ?? 16, fontWeight: FontWeight.w600, lineSpacing: lineSpacing);
  }

  static TextStyle sfProBold({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.sfPro, fontSize: size ?? 16, fontWeight: FontWeight.bold);
  }

  /// DEV NOTE -: SFProText fonts
  static TextStyle sfProText({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.sfProTextRegular, fontSize: size ?? 16);
  }

  static TextStyle sfProTextMedium({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.sfProTextMedium, fontSize: size ?? 16);
  }

  static TextStyle sfProTextSemiBold({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.sfProTextSemiBold, fontSize: size ?? 16);
  }

  static TextStyle sfProTextBold({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.sfProTextBold, fontSize: size ?? 16);
  }

  static TextStyle sfProTextThin({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.sfProTextThin, fontSize: size ?? 16);
  }

  static TextStyle sfProTextLight({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.sfProTextLight, fontSize: size ?? 16);
  }

  static TextStyle sfProTextUltraLight({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.sfProTextUltraLight, fontSize: size ?? 16);
  }

  /// DEV NOTE -: SFProDisplay fonts
  static TextStyle sfProDisplay({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.sfProDisplayRegular, fontSize: size ?? 16);
  }

  static TextStyle sfProDisplayBlack({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.sfProDisplayBlack, fontSize: size ?? 16);
  }

  static TextStyle sfProDisplayHeavy({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.sfProDisplayHeavy, fontSize: size ?? 16);
  }

  static TextStyle sfProDisplayLight({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.sfProDisplayLight, fontSize: size ?? 16);
  }

  static TextStyle sfProDisplayMedium({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.sfProDisplayMedium, fontSize: size ?? 16);
  }

  static TextStyle sfProDisplaySemiBold({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.sfProDisplaySemibold, fontSize: size ?? 16);
  }

  static TextStyle sfProDisplayThin({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.sfProDisplayThin, fontSize: size ?? 16);
  }

  static TextStyle sfProDisplayUltraLight({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.sFProDisplayUltralight, fontSize: size ?? 16);
  }

  /// DEV NOTE -: OpenSense fonts

  static TextStyle openSenseBold({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.openSansBold, fontSize: size ?? 16);
  }

  static TextStyle openSenseBoldItalic({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.openSenseBoldItalic, fontSize: size ?? 16);
  }

  static TextStyle openSenseExtraBold({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.openSenseExtraBold, fontSize: size ?? 16);
  }

  static TextStyle openSenseExtraBoldItalic({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.openSenseExtraBoldItalic, fontSize: size ?? 16);
  }

  static TextStyle openSenseItalic({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.openSenseItalic, fontSize: size ?? 16);
  }

  static TextStyle openSenseLight({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.openSenseLight, fontSize: size ?? 16);
  }

  static TextStyle openSenseLightItalic({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.openSenseLightItalic, fontSize: size ?? 16);
  }

  static TextStyle openSenseMedium({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.openSenseMedium, fontSize: size ?? 16);
  }

  static TextStyle openSenseMediumItalic({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.openSenseMediumItalic, fontSize: size ?? 16);
  }

  static TextStyle openSenseRegular({Color? color, int? size,double? linespacing}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.openSenseRegular, fontSize: size ?? 16,lineSpacing: linespacing);
  }

  static TextStyle openSenseSemiBold({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.openSenseSemiBold, fontSize: size ?? 16);
  }

  static TextStyle openSenseSemiBoldItalic({Color? color, int? size}) {
    return ISOTextStyle.setTS(color: color ?? AppColors.blackColor, fontFamily: AppFont.openSenseSemiBoldItalic, fontSize: size ?? 16);
  }
}
