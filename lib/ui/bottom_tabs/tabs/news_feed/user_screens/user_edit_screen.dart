import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../../utils/app_common_stuffs/commom_utils.dart';
import '../../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../../style/image_components.dart';
import '../../../../style/text_style.dart';
import '../../../../style/textfield_components.dart';

class UserEditScreen extends StatefulWidget {
  const UserEditScreen({Key? key}) : super(key: key);

  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBody(),
      body: buildBody(),
    );
  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBar(
      leading: IconButton(
        onPressed: () => Get.back(result: true),
        //onPressed: () => Get.back(),
        icon: ImageComponent.loadLocalImage(
          imageName: AppImages.arrow,
        ),
      ),
      title: Text(
        AppStrings.accountText,
        style: ISOTextStyles.openSenseSemiBold(size: 17),
      ),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: () {
            //Get.toNamed(ScreenRoutesConstants.filterScoreboardLoanScreen);
          },
          child: CircleAvatar(
            backgroundColor: AppColors.whiteColor,
            radius: 14,
            child: ImageComponent.loadLocalImage(imageName: AppImages.editFill),
          ),
        ),
        10.sizedBoxW,
      ],
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 17),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              height: 118,
              width: 118,
              child: profilePictureWidget(),
            ),
            39.sizedBoxH,
            firstNameTextFieldBody(),
            14.sizedBoxH,
            lastNameTextFieldBody(),
            14.sizedBoxH,
            emailTextFieldBody(),
            14.sizedBoxH,
            phoneNoTextFieldBody(),
            14.sizedBoxH,
            cityStateTextFieldBody()
          ],
        ),
      ),
    );
  }

  Widget profilePictureWidget() {
    return ImageComponent.loadLocalImage(imageName: AppImages.appLogo);
  }

  ///First Name TextField
  Widget firstNameTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.firstName, context: context),
        4.sizedBoxH,
        TextFieldComponents(
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
            // getStartedController.firstNameChange.value = value;
            // getStartedController.validateButton();
          },
        ),
      ],
    );
  }

  Widget lastNameTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.lastName, context: context),
        4.sizedBoxH,
        TextFieldComponents(
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
            // getStartedController.lastNameChange.value = value;
            // getStartedController.validateButton();
          },
        ),
      ],
    );
  }

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
          textInputFormatter: [
            FilteringTextInputFormatter.deny(
              RegExp(r'\s'),
            ),
          ],
          onChanged: (value) {
            // getStartedController.emailChange.value = value;
            // getStartedController.validateButton();
          },
        ),
      ],
    );
  }

  Widget phoneNoTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.phoneNumber, context: context),
        4.sizedBoxH,
        TextFieldComponents(
          context: context,
          hint: AppStrings.phoneNumber,
          keyboardType: TextInputType.phone,
          textInputFormatter: [
            LengthLimitingTextInputFormatter(14),
            FilteringTextInputFormatter.digitsOnly,
            // TextInputFormatter.withFunction((oldValue, newValue) => convert(oldValue, newValue)),
            PhoneNumberTextInputFormatter(),
          ],
          onChanged: (value) {
            // getStartedController.phoneChange.value = value;
            // getStartedController.validateButton();
          },
        ),
      ],
    );
  }

  Widget cityStateTextFieldBody() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldComponents.buildLabelForTextField(text: AppStrings.phoneNumber, context: context),
              4.sizedBoxH,
              TextFieldComponents(
                context: context,
                hint: AppStrings.phoneNumber,
                keyboardType: TextInputType.phone,
                textInputFormatter: [
                  LengthLimitingTextInputFormatter(14),
                  FilteringTextInputFormatter.digitsOnly,
                  // TextInputFormatter.withFunction((oldValue, newValue) => convert(oldValue, newValue)),
                  PhoneNumberTextInputFormatter(),
                ],
                onChanged: (value) {
                  // getStartedController.phoneChange.value = value;
                  // getStartedController.validateButton();
                },
              ),
            ],
          ),
        ),
        10.sizedBoxW,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldComponents.buildLabelForTextField(text: AppStrings.phoneNumber, context: context),
              4.sizedBoxH,
              TextFieldComponents(
                context: context,
                hint: AppStrings.phoneNumber,
                keyboardType: TextInputType.phone,
                textInputFormatter: [
                  LengthLimitingTextInputFormatter(14),
                  FilteringTextInputFormatter.digitsOnly,
                  // TextInputFormatter.withFunction((oldValue, newValue) => convert(oldValue, newValue)),
                  PhoneNumberTextInputFormatter(),
                ],
                onChanged: (value) {
                  // getStartedController.phoneChange.value = value;
                  // getStartedController.validateButton();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
