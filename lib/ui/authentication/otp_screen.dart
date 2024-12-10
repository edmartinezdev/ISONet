import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/authentication/otp_controller.dart';
import 'package:iso_net/ui/style/appbar_components.dart';
import 'package:iso_net/ui/style/button_components.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/textfield_components.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../style/text_style.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  OtpController otpController = Get.find<OtpController>();

  TextEditingController otpEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CommonUtils.scopeUnFocus(context),
      child: Scaffold(
        appBar: appBarBody(),
        body: buildBody(),
      ),
    );
  }

  ///Appbar Body
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

  ///Scaffold body
  Widget buildBody() {
    return CommonUtils.constrainedBody(
      children: [
        headingBody(),
        otpBody(),
        nextButtonBody(),
      ],
    );
  }

  ///title-heading body
  Widget headingBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.confirmYourEmail,
            style: ISOTextStyles.openSenseBold(size: 20, color: AppColors.headingTitleColor),
          ),
          4.sizedBoxH,
          Text(
            AppStrings.enterOtp,
            style: ISOTextStyles.openSenseLight(color: AppColors.hintTextColor, size: 14),
          ),
        ],
      ),
    );
  }

  ///otp - textField , resend button
  Widget otpBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldComponents.buildLabelForTextField(text: AppStrings.oneTimePassword, context: context),
          4.sizedBoxH,
          Obx(
            () => TextFieldComponents(
              context: context,
              hint: AppStrings.oneTimePassword,
              textEditingController: otpEditingController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                otpController.otpChange.value = value;
                otpController.validateButton();
              },
              iconSuffix: otpController.otpChange.isNotEmpty
                  ? GestureDetector(
                      onTap: () => otpController.onClearIconTap(otpEditingController),
                      child: Container(color: AppColors.transparentColor,child: ImageComponent.loadLocalImage(imageName: AppImages.cancelFill)),
                    )
                  : null,
              textInputFormatter: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
            ),
          ),
          32.sizedBoxH,
          ButtonComponents.textButton(
            context: context,
            onTap: () => handleResendButtonPress(),
            title: AppStrings.resendCode,
            textColor: AppColors.notificationTitleBlack,
            alignment: Alignment.center,
          ),
        ],
      ),
    );
  }

  ///on resend button pressed
  handleResendButtonPress() async {
    otpController.onClearIconTap(otpEditingController);

    await otpController.apiCallResendOtp(
      onSuccess: (msg) {
        SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
      },
      onErr: (msg) {
        SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
      },
    );
  }

  /// next button body
  Widget nextButtonBody() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
        child: ButtonComponents.cupertinoButton(
          width: double.infinity,
          context: context,
          title: AppStrings.bNext,
          backgroundColor: otpController.isEnabled.value ? AppColors.primaryColor : AppColors.disableButtonColor,
          textStyle:
              otpController.isEnabled.value ? ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.blackColor) : ISOTextStyles.openSenseRegular(size: 17, color: AppColors.disableTextColor),
          onTap: () {
            handleNextButtonPress();
          },
        ),
      ),
    );
  }

  /// Function on next button will go here
  handleNextButtonPress() async {
    var validationResult = otpController.isValidFormForOtp();
    if (!validationResult.item1) {
      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: validationResult.item2);
    } else {

      var otpApiResult = await otpController.apiCallOtp(
        onError: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
        },
      );
      if (otpApiResult) {
        Get.offAllNamed(ScreenRoutesConstants.detailScreen);
      }
    }
  }
}
