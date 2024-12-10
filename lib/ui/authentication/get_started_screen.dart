import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/authentication/get_started_controller.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/app_fonts.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../utils/app_common_stuffs/app_colors.dart';
import '../../utils/app_common_stuffs/app_images.dart';
import '../../utils/app_common_stuffs/app_logger.dart';
import '../../utils/app_common_stuffs/commom_utils.dart';
import '../../utils/app_common_stuffs/snackbar_util.dart';
import '../../utils/app_common_stuffs/strings_constants.dart';
import '../style/appbar_components.dart';
import '../style/button_components.dart';
import '../style/image_components.dart';
import '../style/text_style.dart';
import '../style/textfield_components.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({Key? key}) : super(key: key);

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final GetStartedController getStartedController = Get.find<GetStartedController>();
  var funderBroker = Get.arguments;

  @override
  Widget build(BuildContext context) {
    Logger().i(funderBroker);
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
    return AppBarComponents.appBar();
  }

  ///Scaffold Body
  Widget buildBody() {
    return CommonUtils.constrainedBody(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headingBody(),
              TextFieldComponents.buildLabelForTextField(text: AppStrings.firstName, context: context),
              4.sizedBoxH,
              firstNameTextFieldBody(),
              12.sizedBoxH,
              TextFieldComponents.buildLabelForTextField(text: AppStrings.lastName, context: context),
              4.sizedBoxH,
              lastNameTextFieldBody(),
              12.sizedBoxH,
              TextFieldComponents.buildLabelForTextField(text: AppStrings.email, context: context),
              4.sizedBoxH,
              emailTextFieldBody(),
              12.sizedBoxH,
              TextFieldComponents.buildLabelForTextField(text: AppStrings.phoneNumber, context: context),
              4.sizedBoxH,
              phoneNoTextFieldBody(),
              12.sizedBoxH,
              TextFieldComponents.buildLabelForTextField(text: AppStrings.password, context: context),
              4.sizedBoxH,
              passwordTextFieldBody(),
              12.sizedBoxH,
              TextFieldComponents.buildLabelForTextField(text: AppStrings.confirmPassword, context: context),
              4.sizedBoxH,
              confirmPwdTextFieldBody(),
              16.sizedBoxH,
            ],
          ),
        ),
        acceptTermsCondition(),
        4.sizedBoxH,
        nextButtonBody(),
      ],
    );
  }

  ///title-heading body
  Widget headingBody() {
    return CommonUtils.headingLabelBody(headingText: AppStrings.getStarted);
  }

  ///First Name TextField
  Widget firstNameTextFieldBody() {
    return TextFieldComponents(
      context: context,
      hint: AppStrings.firstName,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      textInputFormatter: [
        FilteringTextInputFormatter.allow(
          RegExp(r"[a-zA-Z]+|"),
        ),
        FilteringTextInputFormatter.deny(
          RegExp(r'\s'),
        ),
      ],
      onChanged: (value) {
        getStartedController.firstNameChange.value = value;
        getStartedController.validateButton();
      },
    );
  }

  ///Last Name TextField
  Widget lastNameTextFieldBody() {
    return TextFieldComponents(
      context: context,
      hint: AppStrings.lastName,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      textInputFormatter: [
        FilteringTextInputFormatter.allow(
          RegExp(r"[a-zA-Z]+|"),
        ),
        FilteringTextInputFormatter.deny(
          RegExp(r'\s'),
        ),
      ],
      onChanged: (value) {
        getStartedController.lastNameChange.value = value;
        getStartedController.validateButton();
      },
    );
  }

  ///Email TextField
  Widget emailTextFieldBody() {
    return TextFieldComponents(
      context: context,
      hint: AppStrings.hintEmail,
      keyboardType: TextInputType.emailAddress,
      textInputFormatter: [
        FilteringTextInputFormatter.deny(
          RegExp(r'\s'),
        ),
      ],
      onChanged: (value) {
        getStartedController.emailChange.value = value;
        getStartedController.validateButton();
      },
    );
  }

  ///Phone No TextField
  Widget phoneNoTextFieldBody() {
    return TextFieldComponents(
      context: context,
      hint: AppStrings.phoneNumber,
      keyboardType: TextInputType.phone,
      textInputFormatter: [
        LengthLimitingTextInputFormatter(14),
        FilteringTextInputFormatter.digitsOnly,
        PhoneNumberTextInputFormatter(),
      ],
      onChanged: (value) {
        getStartedController.phoneChange.value = value;
        getStartedController.validateButton();
      },
    );
  }

  ///Password TextField
  Widget passwordTextFieldBody() {
    return Obx(
      () => TextFieldComponents(
        context: context,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.next,
        obscure: getStartedController.isPwdObSecure.value,
        iconSuffix: CommonUtils.visibleOption(getStartedController.passwordChange.value) == true
            ? IconButton(
                hoverColor: AppColors.transparentColor,
                splashColor: AppColors.transparentColor,
                onPressed: () => getStartedController.showHidePassword(),
                icon: getStartedController.isPwdObSecure.value
                    ? ImageComponent.loadLocalImage(
                        imageName: AppImages.eye,
                      )
                    : ImageComponent.loadLocalImage(
                        imageName: AppImages.eyeHidden,
                      ),
              )
            : null,
        onChanged: (value) {
          getStartedController.passwordChange.value = value;
          getStartedController.validateButton();
        },
        textInputFormatter: [
          FilteringTextInputFormatter.deny(
            RegExp(r'\s'),
          ),
          LengthLimitingTextInputFormatter(16),
        ],
      ),
    );
  }

  ///Confirm Password TextField
  Widget confirmPwdTextFieldBody() {
    return Obx(
      () => TextFieldComponents(
        context: context,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.done,
        obscure: getStartedController.isConPwdObSecure.value,
        iconSuffix: CommonUtils.visibleOption(getStartedController.confirmPwdChange.value) == true
            ? IconButton(
                hoverColor: AppColors.transparentColor,
                splashColor: AppColors.transparentColor,
                onPressed: () => getStartedController.showHideConfirmPassword(),
                icon: getStartedController.isConPwdObSecure.value
                    ? ImageComponent.loadLocalImage(
                        imageName: AppImages.eye,
                      )
                    : ImageComponent.loadLocalImage(
                        imageName: AppImages.eyeHidden,
                      ),
              )
            : null,
        onChanged: (value) {
          getStartedController.confirmPwdChange.value = value;
          getStartedController.validateButton();
        },
        textInputFormatter: [
          FilteringTextInputFormatter.deny(
            RegExp(r'\s'),
          ),
          LengthLimitingTextInputFormatter(16),
        ],
      ),
    );
  }

  ///Next Button
  Widget nextButtonBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
      child: Obx(
        () => ButtonComponents.cupertinoButton(
          width: double.infinity,
          context: context,
          title: AppStrings.bNext,
          backgroundColor: getStartedController.isButtonEnable.value ? AppColors.primaryColor : AppColors.disableButtonColor,
          textStyle: getStartedController.isButtonEnable.value
              ? ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.blackColor)
              : ISOTextStyles.openSenseRegular(size: 17, color: AppColors.disableTextColor),
          onTap: () {
            handleNextButtonPress();
          },
        ),
      ),
    );
  }

  Widget acceptTermsCondition() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Obx(
          () => Container(
            height: 28.h,
            alignment: Alignment.topCenter,
            child: Checkbox(
              activeColor: AppColors.primaryColor,
              value: getStartedController.isCheckTermsCondition.value,
              onChanged: (value) {
                getStartedController.isCheckTermsCondition.value = value ?? false;
                getStartedController.validateButton();
              },
            ),
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${AppStrings.byContinueAgree} ',
                  style: ISOTextStyles.openSenseRegular(size: 16, color: AppColors.headingTitleColor),
                ),
                TextSpan(
                  text: AppStrings.termsOfUseText,
                  style: TextStyle(color: AppColors.headingTitleColor, decoration: TextDecoration.underline, fontSize: 16, fontFamily: AppFont.openSenseSemiBold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.toNamed(ScreenRoutesConstants.termsConditionScreen, arguments: 'TC');
                    },
                ),
                TextSpan(
                  text: ' ${AppStrings.and} ',
                  style: ISOTextStyles.openSenseRegular(size: 16, color: AppColors.headingTitleColor),
                ),
                TextSpan(
                  text: AppStrings.privacyPolicyText,
                  style: TextStyle(
                    color: AppColors.headingTitleColor,
                    decoration: TextDecoration.underline,
                    fontFamily: AppFont.openSenseSemiBold,
                    fontSize: 16,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Get.toNamed(ScreenRoutesConstants.privacyPolicyScreen, arguments: 'PP');
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///Function on next button will go here
  handleNextButtonPress() async {
    var validationResult = getStartedController.isValidFormForGetStarted();

    if (!validationResult.item1) {
      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: validationResult.item2);
    } else {
      getStartedController.phoneNoForApi.value = CommonUtils.convertToPhoneNumber(updatedStr: getStartedController.phoneChange.value);
      ShowLoaderDialog.showLoaderDialog(context);
      var signUpApiCall = await getStartedController.apiCallSignUp(
          onError: (msg) {
            SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
          },
          userType: funderBroker);
      if (signUpApiCall) {
        Get.offAllNamed(ScreenRoutesConstants.otpScreen);
      }
    }
  }
}
