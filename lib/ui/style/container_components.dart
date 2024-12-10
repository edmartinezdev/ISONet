import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContainerComponents {
  static elevatedContainer({
    required BuildContext context,
    double? height,
    double? width,
    EdgeInsetsGeometry? padding,
    List<BoxShadow>? shadow,
    double? borderRadius,
    Color? backGroundColor,
    required Widget child,
    Alignment? alignment,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: alignment,
        height: height ?? MediaQuery.of(context).size.height / 3,
        width: width ?? MediaQuery.of(context).size.width,
        padding: padding ?? EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.0.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius?.r ?? 0.0),
          color: backGroundColor,
          boxShadow: shadow ??
              [
                /* BoxShadow(
              color: AppColors.greyColor,
              blurRadius: 4.0.r,
              spreadRadius: 2.0.r,
            ),*/
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 4,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
        ),
        child: child,
      ),
    );
  }
}
