import "package:flutter/material.dart";
import "package:image_cropper/image_cropper.dart";

import '../../../../../utils/app_common_stuffs/app_colors.dart';

List<PlatformUiSettings>? buildUiSettings(BuildContext context) {
  return [
    AndroidUiSettings(
      toolbarTitle: "Cropper",
      toolbarColor: AppColors.primaryColor,
      toolbarWidgetColor: Colors.white,
      initAspectRatio: CropAspectRatioPreset.original,
      lockAspectRatio: false,
    ),
    IOSUiSettings(
      title: "Cropper",
    ),
  ];
}
