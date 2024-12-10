// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iso_net/helper_manager/permission_handler.dart';
import 'package:iso_net/ui/style/button_components.dart';
import 'package:iso_net/ui/style/dialog_components.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MediaSelectorManager {
  /*MethodChannel platform = const MethodChannel('flutter.native/helper');*/
  /*RxBool hasPermission = false.obs;*/

  MediaSelectorManager._internal();

  static final MediaSelectorManager _mediaSelectManager = MediaSelectorManager._internal();

  factory MediaSelectorManager() {
    return _mediaSelectManager;
  }

  static Future chooseProfileImage({
    required ImageSource imageSource,
    required Rxn<XFile> profileImage,
    required BuildContext context,
  }) async {
    try {
      CroppedFile? croppedFile;
      late var androidInfo;
      androidInfo = Platform.isIOS ? await DeviceInfoPlugin().iosInfo : await DeviceInfoPlugin().androidInfo;
      await PermissionHandler.checkPermissions(
        permission: Platform.isAndroid
            ? (androidInfo.version.sdkInt < 33)
                ? Permission.storage
                : Permission.photos
            : Permission.photos,
        onGranted: () async {
          final pickedImage = await ImagePicker().pickImage(
            source: imageSource,
          );
          if (pickedImage != null) {
            croppedFile = await ImageCropper().cropImage(
              sourcePath: pickedImage.path,
              aspectRatioPresets: CommonUtils.setAspectRatios(),
              uiSettings: CommonUtils.buildUiSettings(),
            );

            //profileImage.value = pickedImage;
            profileImage.value = XFile(croppedFile?.path ?? pickedImage.path);
            Logger().i('Path -> ${profileImage.value?.path}');
          }
        },
        onLimited: () async {
          final pickedImage = await ImagePicker().pickImage(
            source: imageSource,
          );
          if (pickedImage != null) {
            profileImage.value = pickedImage;
          }
        },
        onPermanentlyDenied: () {
          DialogComponent.showAlertDialog(
            context: context,
            barrierDismissible: true,
            title: AppStrings.mediaAlertTitle,
            content: AppStrings.mediaAlertMessage,
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
    } on PlatformException catch (e) {
      Logger().i(e.toString());
    }
  }

  static Future chooseMultipleImage({
    required ImageSource imageSource,
    //required ImagePicker imagePicker,
    required RxList<XFile> tempDisplayList,
    required RxList<XFile> multipleImages,
    required BuildContext context,
    VoidCallback? imageVideoCallBack,
  }) async {
    try {
      late var androidInfo;
      androidInfo = Platform.isIOS ? await DeviceInfoPlugin().iosInfo : await DeviceInfoPlugin().androidInfo;
      await PermissionHandler.checkPermissions(
        permission: Platform.isAndroid
            ? (androidInfo.version.sdkInt < 33)
                ? Permission.storage
                : Permission.photos
            : Permission.photos,
        onGranted: () async {
          final List<XFile> pickedMultipleImages = await ImagePicker().pickMultiImage();
          if (pickedMultipleImages.isNotEmpty) {
            tempDisplayList.addAll(pickedMultipleImages);
            multipleImages.addAll(pickedMultipleImages);
            for (var i in pickedMultipleImages) {
              Logger().i('Path -> ${i.path}');
              CommonUtils.calculateFileSize(File(i.path));
            }

            if (imageVideoCallBack != null) imageVideoCallBack();
          }
        },
        onLimited: () async {
          final List<XFile> pickedMultipleImages = await ImagePicker().pickMultiImage();
          if (pickedMultipleImages.isNotEmpty) {
            tempDisplayList.addAll(pickedMultipleImages);
            multipleImages.addAll(pickedMultipleImages);
            for (var i in multipleImages) {
              Logger().i('Path -> ${i.path}');
            }
            //Logger().i('Path -> ${pickedMultipleImages.length}');
          }
          if (imageVideoCallBack != null) imageVideoCallBack();
        },
        onPermanentlyDenied: () {
          DialogComponent.showAlertDialog(
            context: context,
            title: AppStrings.mediaAlertTitle,
            barrierDismissible: true,
            content: AppStrings.mediaAlertMessage,
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
    } on PlatformException catch (e) {
      Logger().i(e.toString());
    }
  }

  static Future chooseCameraImage({
    required ImageSource imageSource,
    required BuildContext context,
    required RxList<XFile> multipleImage,
    required RxList<XFile> tempDisplayList,
    VoidCallback? cameraCallBack,
  }) async {
    try {

      await PermissionHandler.checkPermissions(
        permission: Permission.camera,
        onGranted: () async {
          final pickedImage = await ImagePicker().pickImage(
            source: imageSource,
          );
          if (pickedImage != null) {
            tempDisplayList.add(pickedImage);
            multipleImage.add(pickedImage);
            if (cameraCallBack != null) cameraCallBack();

            Logger().i('Path -> $multipleImage');
          }
        },
        onLimited: () async {
          final pickedImage = await ImagePicker().pickImage(
            source: imageSource,
          );
          if (pickedImage != null) {
            tempDisplayList.add(pickedImage);
            multipleImage.add(pickedImage);
          }
          if (cameraCallBack != null) cameraCallBack();
        },
        onPermanentlyDenied: () {
          DialogComponent.showAlertDialog(
            context: context,
            title: AppStrings.mediaAlertTitle,
            content: AppStrings.mediaAlertMessage,
            barrierDismissible: true,
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
    } on PlatformException catch (e) {
      Logger().i(e.toString());
    }
  }

  static Future chooseVideoFromGallery({
    required ImageSource imageSource,
    //required ImagePicker imagePicker,
    //File? imageFile,
    required RxList<XFile> multipleVideoList,
    required RxList<XFile> tempDisplayList,
    required RxString thumbnails,
    required BuildContext context,
    VoidCallback? cameraVideoCallBack,
  }) async {
    try {
      if (Platform.isIOS) {
        final pickedVideo = await ImagePicker().pickVideo(
          source: imageSource,
          maxDuration: const Duration(minutes: 1),
        );
        if (pickedVideo != null) {
          var imageFile = XFile(pickedVideo.path);
          thumbnails.value = await VideoThumbnail.thumbnailFile(video: imageFile.path, imageFormat: ImageFormat.PNG) ?? '';

          tempDisplayList.add(XFile(thumbnails.value));
          var size = CommonUtils.calculateFileSize(File(pickedVideo.path));
          Logger().i('Total Video File Size Mb :-$size');
          multipleVideoList.add(pickedVideo);

          Logger().i('Path Video -> ${pickedVideo.path}');
        }
        if (cameraVideoCallBack != null) cameraVideoCallBack();
      } else {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        await PermissionHandler.checkPermissions(
          permission: (androidInfo.version.sdkInt < 33) ? Permission.storage : Permission.videos,
          //permission : Permission.storage,
          onGranted: () async {
            final pickedVideo = await ImagePicker().pickVideo(
              source: imageSource,
              maxDuration: const Duration(minutes: 1),
            );
            if (pickedVideo != null) {
              var imageFile = XFile(pickedVideo.path);
              thumbnails.value = await VideoThumbnail.thumbnailFile(video: imageFile.path, imageFormat: ImageFormat.PNG) ?? '';

              tempDisplayList.add(XFile(thumbnails.value));
              var size = CommonUtils.calculateFileSize(File(pickedVideo.path));
              Logger().i('Total Video File Size Mb :-$size');
              multipleVideoList.add(pickedVideo);

              Logger().i('Path Video -> ${pickedVideo.path}');
            }
            if (cameraVideoCallBack != null) cameraVideoCallBack();
          },
          onLimited: () async {
            final pickedVideo = await ImagePicker().pickVideo(
              source: imageSource,
            );
            if (pickedVideo != null) {
              var imageFile = XFile(pickedVideo.path);
              thumbnails.value = await VideoThumbnail.thumbnailFile(video: imageFile.path, imageFormat: ImageFormat.PNG) ?? '';

              tempDisplayList.add(XFile(thumbnails.value));
              multipleVideoList.add(pickedVideo);
              Logger().i('Path Video -> ${pickedVideo.path}');
            }
          },
          onPermanentlyDenied: () {
            DialogComponent.showAlertDialog(
              context: context,
              barrierDismissible: true,
              title: AppStrings.mediaAlertTitle,
              content: AppStrings.mediaAlertMessage,
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
    } on PlatformException catch (e) {
      Logger().i(e.toString());
    }
  }

  static Future recordVideo({
    required ImageSource imageSource,
    required RxList<XFile> multipleVideoList,
    required RxList<XFile> tempDisplayList,
    required RxString thumbnails,
    required BuildContext context,
    VoidCallback? videoCallBack,
  }) async {
    try {
      late var androidInfo;
      androidInfo = Platform.isIOS ? await DeviceInfoPlugin().iosInfo : await DeviceInfoPlugin().androidInfo;
      await PermissionHandler.checkPermissions(
        permission: Platform.isIOS
            ? Permission.microphone
            : (androidInfo.version.sdkInt < 33)
                ? Permission.storage
                : Permission.videos,
        //permission : Permission.storage,
        onGranted: () async {
          final pickedVideo = await ImagePicker().pickVideo(
            source: imageSource,
            maxDuration: const Duration(minutes: 1),
          );
          if (pickedVideo != null) {
            var imageFile = XFile(pickedVideo.path);
            thumbnails.value = await VideoThumbnail.thumbnailFile(video: imageFile.path, imageFormat: ImageFormat.PNG) ?? '';

            tempDisplayList.add(XFile(thumbnails.value));
            multipleVideoList.add(pickedVideo);
            Logger().i('Path Video -> ${pickedVideo.path}');
            if (videoCallBack != null) videoCallBack();
          }
        },
        onLimited: () async {
          final pickedVideo = await ImagePicker().pickVideo(
            source: imageSource,
          );
          if (pickedVideo != null) {
            var imageFile = XFile(pickedVideo.path);
            thumbnails.value = await VideoThumbnail.thumbnailFile(video: imageFile.path, imageFormat: ImageFormat.PNG) ?? '';

            tempDisplayList.add(XFile(thumbnails.value));
            multipleVideoList.add(pickedVideo);
            Logger().i('Path Video -> ${pickedVideo.path}');
          }
          if (videoCallBack != null) videoCallBack();
        },
        onPermanentlyDenied: () {
          DialogComponent.showAlertDialog(
            context: context,
            barrierDismissible: true,
            title: AppStrings.mediaAlertTitle,
            content: AppStrings.mediaAlertMessage,
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
    } on PlatformException catch (e) {
      Logger().i(e.toString());
    }
  }
}

/*if (Platform.isIOS) {
        await PermissionHandler.checkPermissions(
          permission: Platform.isAndroid ? Permission.storage : Permission.photos,
          onGranted: () async {
            await openGallery(croppedFile, imageSource, profileImage);
          },
          onLimited: () async {
            final pickedImage = await ImagePicker().pickImage(
              source: imageSource,
            );
            if (pickedImage != null) {
              profileImage.value = pickedImage;
            }
          },
          onPermanentlyDenied: () {
            DialogComponent.showAlertDialog(
              context: context,
              barrierDismissible: true,
              title: AppStrings.mediaAlertTitle,
              content: AppStrings.mediaAlertMessage,
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
      }else {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
          await PermissionHandler.checkPermissions(
            permission: Platform.isAndroid ? Permission.storage : Permission.photos,
            onGranted: () async {
              await openGallery(croppedFile, imageSource, profileImage);
            },
            onLimited: () async {
              final pickedImage = await ImagePicker().pickImage(
                source: imageSource,
              );
              if (pickedImage != null) {
                profileImage.value = pickedImage;
              }
            },
            onPermanentlyDenied: () {
              DialogComponent.showAlertDialog(
                context: context,
                barrierDismissible: true,
                title: AppStrings.mediaAlertTitle,
                content: AppStrings.mediaAlertMessage,
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
        }  else {
          MediaSelectorManager().permissionCheck(croppedFile, imageSource, profileImage, context);
        }
      }*/
/*static Future<void> openGallery(CroppedFile? croppedFile, ImageSource imageSource, Rxn<XFile> profileImage) async {
    final pickedImage = await ImagePicker().pickImage(
      source: imageSource,
    );
    if (pickedImage != null) {
      croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatioPresets: CommonUtils.setAspectRatios(),
        uiSettings: CommonUtils.buildUiSettings(),
      );

      //profileImage.value = pickedImage;
      profileImage.value = XFile(croppedFile?.path ?? pickedImage.path);
      Logger().i('Path -> ${profileImage.value?.path}');
    }
  }*/
/*void permissionCheck(CroppedFile? croppedFile, ImageSource imageSource, Rxn<XFile> profileImage, BuildContext context) async {
    try {
      final bool result = await platform.invokeMethod('permissionCheck');
      hasPermission.value = result;
      if (hasPermission == true) {
        await openGallery(croppedFile, imageSource, profileImage);
      } else {
        DialogComponent.showAlertDialog(
          context: context,
          title: AppStrings.mediaAlertTitle,
          barrierDismissible: true,
          content: AppStrings.mediaAlertMessage,
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
      }

      Logger().d(result);
    } on PlatformException catch (e) {
      hasPermission.value = false;
      Logger().d(e.message);
    }
  }*/
