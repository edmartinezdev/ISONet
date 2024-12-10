import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/authentication/sign_in_screen_controller.dart';
import 'package:iso_net/ui/style/appbar_components.dart';
import 'package:iso_net/ui/style/button_components.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/textfield_components.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../utils/app_common_stuffs/app_images.dart';
import '../../utils/app_common_stuffs/screen_routes.dart';
import '../style/text_style.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  SignInScreenController signInScreenController = Get.find<SignInScreenController>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    if (kDebugMode) {
      emailController.text = "sasha.b@yopmail.com";
      passwordController.text = "123456";
      signInScreenController.emailChange.value = "sasha.b@yopmail.com";
      signInScreenController.passwordChange.value = "123456";
    }
    super.initState();
  }

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
    return AppBarComponents.appBar(
      bottomWidget: PreferredSize(
        preferredSize: Size(double.infinity, 8.0.h),
        child: Divider(
          thickness: 1.0.w,
        ),
      ),
      leadingWidget: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          color: AppColors.transparentColor,
          child: ImageComponent.loadLocalImage(
            imageName: AppImages.x,
          ),
        ),
      ),
    );
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
              CommonUtils.headingLabelBody(headingText: AppStrings.tSignIn),
              emailTextFieldBody(),
              passwordTextFieldBody(),
              forgotPasswordBody(),
            ],
          ),
        ),
        loginButtonBody()
      ],
    );
  }

  ///Email TextField
  Widget emailTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.logIn, context: context),
        4.sizedBoxH,
        TextFieldComponents(
          context: context,
          textEditingController: emailController,
          hint: AppStrings.hintEmail,
          keyboardType: TextInputType.emailAddress,
          textInputFormatter: [
            FilteringTextInputFormatter.deny(
              RegExp(r'\s'),
            ),
          ],
          onChanged: (value) {
            signInScreenController.emailChange.value = value;
            signInScreenController.validateButton();
          },
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///Password TextField
  Widget passwordTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.password, context: context),
        4.sizedBoxH,
        Obx(
          () => TextFieldComponents(
            context: context,
            textEditingController: passwordController,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            obscure: signInScreenController.isObscure.value,
            iconSuffix: CommonUtils.visibleOption(signInScreenController.passwordChange.value) == true
                ? IconButton(
                    hoverColor: AppColors.transparentColor,
                    splashColor: AppColors.transparentColor,
                    onPressed: () => signInScreenController.showHidePassword(),
                    icon: signInScreenController.isObscure.value
                        ? ImageComponent.loadLocalImage(
                            imageName: AppImages.eye,
                          )
                        : ImageComponent.loadLocalImage(
                            imageName: AppImages.eyeHidden,
                          ),
                  )
                : null,
            onChanged: (value) {
              signInScreenController.passwordChange.value = value;
              signInScreenController.validateButton();
            },
            textInputFormatter: [
              LengthLimitingTextInputFormatter(16),
              FilteringTextInputFormatter.deny(
                RegExp(r'\s'),
              ),
            ],
          ),
        ),
        4.sizedBoxH,
      ],
    );
  }

  ///Forgot password
  Widget forgotPasswordBody() {
    return ButtonComponents.textButton(
      alignment: Alignment.centerRight,
      context: context,
      onTap: () => Get.toNamed(ScreenRoutesConstants.forgotPwdScreen),
      title: AppStrings.bForgotPwd,
      textColor: AppColors.blackColor,
      textStyle: ISOTextStyles.openSenseRegular(size: 12, color: AppColors.headingTitleColor),
    );
  }

  ///Login Button
  Widget loginButtonBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
      child: Obx(
        () => ButtonComponents.cupertinoButton(
          width: double.infinity,
          context: context,
          title: AppStrings.logIn,
          backgroundColor: signInScreenController.isButtonEnable.value ? AppColors.primaryColor : AppColors.disableButtonColor,
          textStyle: signInScreenController.isButtonEnable.value
              ? ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.blackColor)
              : ISOTextStyles.openSenseRegular(size: 17, color: AppColors.disableTextColor),
          onTap: () {
            handleLoginButtonPress();
            /*Get.to(SignInScreen(),binding: SignInScreenBinding());*/
          },
        ),
      ),
    );
  }

  ///Function on login button will go here
  void handleLoginButtonPress() async {
    var validationResult = signInScreenController.isValidFormForLogin();
    if (!validationResult.item1) {
      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: validationResult.item2);
    } else {
      await signInScreenController.apiCallSignIn(
        onErr: (msg) => SnackBarUtil.showSnackBar(
          context: context,
          type: SnackType.error,
          message: msg,
        ),
      );
    }
  }
}
