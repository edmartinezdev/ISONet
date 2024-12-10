import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iso_net/helper_manager/media_selector_manager/media_selector_manager.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/style/dialog_components.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';

import '../../controllers/user/user_profileimage_controller.dart';
import '../../ui/style/appbar_components.dart';
import '../../utils/app_common_stuffs/app_images.dart';
import '../../utils/app_common_stuffs/commom_utils.dart';
import '../../utils/app_common_stuffs/screen_routes.dart';
import '../../utils/app_common_stuffs/strings_constants.dart';
import '../style/button_components.dart';
import '../style/image_components.dart';
import '../style/text_style.dart';

class UserProfileImageScreen extends StatefulWidget {
  const UserProfileImageScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileImageScreen> createState() => _UserProfileImageScreenState();
}

class _UserProfileImageScreenState extends State<UserProfileImageScreen> {
  UserProfileImageController userProfileImageController = Get.find<UserProfileImageController>();

  @override
  Widget build(BuildContext context) {
    Logger().i(userSingleton.token);
    return Scaffold(
      appBar: appBarBody(),
      body: CommonUtils.constrainedBody(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              headingBody(),
              selectUserProfileImageBody(),
            ],
          ),
          nextButtonBody(),
        ],
      ),
    );
  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      leadingWidget: IconButton(
        onPressed: () {
          CommonUtils.buildExitAlert(context: context);
        },
        icon: ImageComponent.loadLocalImage(imageName: AppImages.arrow),
      ),
    );
  }

  ///title-heading body
  Widget headingBody() {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.symmetric(vertical: 16.0.h, horizontal: 16.0.w),
      child: CommonUtils.headingLabelBody(headingText: AppStrings.profileImage),
    );
  }

  ///select user profile image widget
  Widget selectUserProfileImageBody() {
    return Column(
      children: [
        Obx(
          () => InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              onTapImage();
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0.w),
              width: 212.h,
              height: 212.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.greyColor),
              ),
              child: userProfileImageController.profileImage.value == null
                  ? Center(
                    child: ImageComponent.loadLocalImage(
                        imageName: AppImages.imageUpload,
                      ),
                  )
                  : ClipOval(
                      child: Image.file(
                        File(
                          userProfileImageController.profileImage.value!.path,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  ///onTap Select user profile image function
  onTapImage() {
    chooseMediaOption();
  }

  ///choose media option
   chooseMediaOption() {
    return DialogComponent.showAlertDialog(
      context: context,
      title: AppStrings.mediaAlertTitle,
      content: AppStrings.mediaAlertMessage,
      barrierDismissible: true,
      arrButton: Platform.isAndroid
          ? <Widget>[
              ButtonComponents.textButton(
                  onTap: () {
                    MediaSelectorManager.chooseProfileImage(
                      imageSource: ImageSource.camera,
                      // imagePicker: userProfileImageController.imagePicker,
                      profileImage: userProfileImageController.profileImage,
                      context: context,
                    );
                    Get.back();
                  },
                  context: context,
                  title: 'Camera'),
              ButtonComponents.textButton(
                  onTap: () {
                    MediaSelectorManager.chooseProfileImage(
                      imageSource: ImageSource.gallery,
                      // imagePicker: userProfileImageController.imagePicker,
                      profileImage: userProfileImageController.profileImage,
                      context: context,
                    );
                    Get.back();
                  },
                  context: context,
                  title: 'Gallery'),
            ]
          : <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: const Text('Camera'),
                onPressed: () {
                  MediaSelectorManager.chooseProfileImage(
                    imageSource: ImageSource.camera,
                    // imagePicker: userProfileImageController.imagePicker,
                    profileImage: userProfileImageController.profileImage,
                    context: context,
                  );
                  Get.back();
                },
              ),
              CupertinoDialogAction(
                child: const Text('Gallery'),
                onPressed: () {
                  MediaSelectorManager.chooseProfileImage(
                    imageSource: ImageSource.gallery,
                    // imagePicker: userProfileImageController.imagePicker,
                    profileImage: userProfileImageController.profileImage,
                    context: context,
                  );
                  Get.back();
                },
              ),
            ],
    );
  }

  ///Next ButtonBody
  Widget nextButtonBody() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(vertical: 16.0.h, horizontal: 16.0.w),
        child: ButtonComponents.cupertinoButton(
            context: context,
            title: AppStrings.bNext,
            backgroundColor:  userProfileImageController.profileImage.value == null
                ? AppColors.disableButtonColor
                : AppColors.primaryColor,
            textStyle:  userProfileImageController.profileImage.value == null ? ISOTextStyles.openSenseRegular(size: 17,color: AppColors.disableTextColor): ISOTextStyles.openSenseSemiBold(size: 17,color: AppColors.blackColor),
            onTap: () {
              onNextButtonPress();
            },
            width: double.infinity),
      ),
    );
  }

  ///on next button function
  ///1.if user not select any image then button is disable & onTap function show error snackBar
  ///2.First check user added image then after button enable
  onNextButtonPress() async{
    if (userProfileImageController.profileImage.value == null) {
      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: AppStrings.validateProfileImage);
    } else {
      userProfileImageController.file.value = await CommonUtils.convertXFileSingle(imageFile: userProfileImageController.profileImage.value!);
      Get.toNamed(ScreenRoutesConstants.userBackImageScreen);
    }
  }
}
