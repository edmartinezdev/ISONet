import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iso_net/bindings/user/user_interest_binding.dart';
import 'package:iso_net/controllers/user/user_backimage_controller.dart';
import 'package:iso_net/ui/user/user_interest_screen.dart';

import '../../helper_manager/media_selector_manager/media_selector_manager.dart';
import '../../utils/app_common_stuffs/app_colors.dart';
import '../../utils/app_common_stuffs/app_images.dart';
import '../../utils/app_common_stuffs/commom_utils.dart';
import '../../utils/app_common_stuffs/snackbar_util.dart';
import '../../utils/app_common_stuffs/strings_constants.dart';
import '../style/appbar_components.dart';
import '../style/button_components.dart';
import '../style/image_components.dart';
import '../style/text_style.dart';

class UserBackImageScreen extends StatefulWidget {
  const UserBackImageScreen({Key? key}) : super(key: key);

  @override
  State<UserBackImageScreen> createState() => _UserBackImageScreenState();
}

class _UserBackImageScreenState extends State<UserBackImageScreen> {
  UserBackImageController userBackImageController = Get.find<UserBackImageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBody(),
      body: CommonUtils.constrainedBody(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              headingBody(),
              selectUserBackgroundImage(),
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
      actionWidgets: [
        Align(alignment: Alignment.center,child: skipButton()),
      ]
    );
  }

  /// Skip button body
  Widget skipButton() {
    return GestureDetector(
      onTap: () async {
        Get.to(
            UserInterestScreen(
              isEditInterest: false,
              isSkipBackGroundImage: true,
            ),
            binding: UserInterestBinding());
      },
      child: Container(
        color: AppColors.transparentColor,
        padding: EdgeInsets.symmetric(
          horizontal: 12.0.w,
        ),
        child: Text(
          AppStrings.skip,
          style: ISOTextStyles.openSenseRegular(size: 17, color: AppColors.disableTextColor),
        ),
      ),
    );
  }

  ///title-heading body
  Widget headingBody() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0.h, horizontal: 16.0.w),
      child: CommonUtils.headingLabelBody(headingText: AppStrings.backGroundImage),
    );
  }

  ///select User Background image widget
  Widget selectUserBackgroundImage() {
    return Obx(
      () => GestureDetector(
        onTap: () {
          onTapImage();
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0.w),
          height: 212.h,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyColor),
            borderRadius: BorderRadius.circular(10.0.r),
            color: AppColors.transparentColor,
          ),
          width: double.infinity,
          child: userBackImageController.backgroundImage.value == null
              ? ImageComponent.loadLocalImage(
                  imageName: AppImages.imageUpload,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10.0.r),
                  child: Image.file(
                    File(
                      userBackImageController.backgroundImage.value!.path,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }

  ///onTap Select background image function
  onTapImage() {
    MediaSelectorManager.chooseProfileImage(
      imageSource: ImageSource.gallery,
      // imagePicker: userProfileImageController.imagePicker,
      profileImage: userBackImageController.backgroundImage,
      context: context,
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
            backgroundColor: userBackImageController.backgroundImage.value == null ? AppColors.disableButtonColor : AppColors.primaryColor,
            textStyle: userBackImageController.backgroundImage.value == null
                ? ISOTextStyles.openSenseRegular(size: 17, color: AppColors.disableTextColor)
                : ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.blackColor),
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
  onNextButtonPress() async {
    if (userBackImageController.backgroundImage.value == null) {
      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: AppStrings.validateBackGroundImage);
    } else {
      /*userBackImageController.convertXFile();*/
      userBackImageController.file.value = await CommonUtils.convertXFileSingle(imageFile: userBackImageController.backgroundImage.value!);
      Get.to(
          UserInterestScreen(
            isEditInterest: false,
            isSkipBackGroundImage: false,
          ),
          binding: UserInterestBinding());
    }
  }
}
