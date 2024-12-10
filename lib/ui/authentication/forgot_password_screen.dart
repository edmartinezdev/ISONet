import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/authentication/forgot_password_controller.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../utils/app_common_stuffs/app_colors.dart';
import '../../utils/app_common_stuffs/snackbar_util.dart';
import '../style/appbar_components.dart';
import '../style/button_components.dart';
import '../style/text_style.dart';
import '../style/textfield_components.dart';

class ForgotPwdScreen extends StatefulWidget {
  const ForgotPwdScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPwdScreen> createState() => _ForgotPwdScreenState();
}

class _ForgotPwdScreenState extends State<ForgotPwdScreen> {
  final ForgotPwdController forgotPwdController = Get.find<ForgotPwdController>();

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

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar();
  }

  ///Scaffold body
  Widget buildBody() {
    return CommonUtils.constrainedBody(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonUtils.headingLabelBody(headingText: AppStrings.tForgotPwd),
              emailTextFieldBody(),
            ],
          ),
        ),
        submitButtonBody(),
      ],
    );
  }

  ///Email TextField
  Widget emailTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.email, context: context),
        4.sizedBoxH,
        TextFieldComponents(
          context: context,
          hint: AppStrings.hintEmail,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          textInputFormatter: [
            FilteringTextInputFormatter.deny(
              RegExp(r'\s'),
            ),
          ],
          onChanged: (value) {
            forgotPwdController.emailChange.value = value;
            forgotPwdController.validateButton();
          },
        ),
      ],
    );
  }

  ///Submit Button
  Widget submitButtonBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
      child: Obx(
        () => ButtonComponents.cupertinoButton(
          width: double.infinity,
          context: context,
          title: AppStrings.bSubmit,
          backgroundColor: forgotPwdController.isButtonEnable.value ? AppColors.primaryColor : AppColors.disableButtonColor,
          textStyle: forgotPwdController.isButtonEnable.value ? ISOTextStyles.openSenseSemiBold(size: 17,color: AppColors.blackColor) :ISOTextStyles.openSenseRegular(size: 17,color: AppColors.disableTextColor),
          onTap: () {
            submitButtonPress();
          },
        ),
      ),
    );
  }

  ///Function on submit button will go here
  submitButtonPress() async {
    var validationResult = forgotPwdController.isValidFormForForgotPwd();
    if (!validationResult.item1) {
      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: validationResult.item2);
    } else {
      ShowLoaderDialog.showLoaderDialog(context);
      var forgotApiResult = await forgotPwdController.apiCallForgotPwd(onErr: (msg) {
        SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
      });
      if (forgotApiResult) {
        SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: AppStrings.resendSuccessMsg);
        Get.back();
      }
    }
  }
}
