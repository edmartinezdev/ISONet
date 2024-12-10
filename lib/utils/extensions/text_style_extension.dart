import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_common_stuffs/app_colors.dart';
import '../app_common_stuffs/app_fonts.dart';

extension ISOTextStyle on TextStyle {
  static TextStyle setTS({
    FontStyle? fontStyle,
    String? fontFamily,
    int? fontSize,
    Color? color,
    FontWeight? fontWeight,
    bool isFixed = false,
    double? characterSpacing,
    double? wordSpacing,
    double? lineSpacing,
    TextDecoration? decoration,
  }) {
    double finalFontSize = (fontSize ?? 12).toDouble();
    if (!isFixed) {
      finalFontSize = finalFontSize.sp;
    }

    return TextStyle(
      fontSize: finalFontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily ?? AppFont.sfProDisplayRegular,
      color: color ?? AppColors.blackColor,
      letterSpacing: characterSpacing,
      wordSpacing: wordSpacing,
      height: lineSpacing,
      decoration: decoration,
    );
  }
}
