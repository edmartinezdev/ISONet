import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';

import '../../utils/app_common_stuffs/app_images.dart';

class AppBarComponents {
  static AppBar appBar({
    Widget? titleWidget,
    Color? backgroundColor,
    Widget? leadingWidget,
    VoidCallback? onTap,
    double? leadingWidth,
    List<Widget>? actionWidgets,
    PreferredSizeWidget? bottomWidget,
    bool? autoImplyLeading,
    bool? centerTitle,
  }) {
    return AppBar(
      centerTitle: centerTitle,
      leadingWidth: leadingWidth ?? 56.0,
      automaticallyImplyLeading: autoImplyLeading ?? true,
      title: titleWidget,
      backgroundColor: backgroundColor ?? AppColors.whiteColor,
      leading: leadingWidget ??
          GestureDetector(
            onTap: () => onTap ?? Get.back(),
            child: ImageComponent.loadLocalImage(
              imageName: AppImages.arrow,
            ),
          ),
      actions: actionWidgets,
      bottom: bottomWidget,
    );
  }
}
