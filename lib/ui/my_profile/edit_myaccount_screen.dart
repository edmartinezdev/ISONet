// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:iso_net/bindings/user/user_interest_binding.dart';
import 'package:iso_net/controllers/my_profile/edit_myaccount_controller.dart';
import 'package:iso_net/controllers/my_profile/my_profile_controller.dart';
import 'package:iso_net/controllers/user/user_interest_controller.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/style/ImageWidget.dart';
import 'package:iso_net/ui/user/user_interest_screen.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/date_util.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';


import '../../helper_manager/media_selector_manager/media_selector_manager.dart';
import '../../utils/app_common_stuffs/app_colors.dart';
import '../../utils/app_common_stuffs/app_images.dart';
import '../../utils/app_common_stuffs/dropdown_component.dart';
import '../../utils/app_common_stuffs/snackbar_util.dart';
import '../../utils/app_common_stuffs/text_input_formatters.dart';
import '../style/appbar_components.dart';
import '../style/button_components.dart';
import '../style/dialog_components.dart';
import '../style/image_components.dart';
import '../style/showloader_component.dart';
import '../style/text_style.dart';
import '../style/textfield_components.dart';

class EditMyAccountScreen extends StatefulWidget {
  bool isCompanyDeleted = false;
  bool? isCompanyOwner;

  EditMyAccountScreen({Key? key, required this.isCompanyDeleted, this.isCompanyOwner}) : super(key: key);

  @override
  State<EditMyAccountScreen> createState() => _EditMyAccountScreenState();
}

class _EditMyAccountScreenState extends State<EditMyAccountScreen> {
  UserInterestController userInterestController = Get.find<UserInterestController>();
  EditMyAccountController editMyAccountController = Get.find<EditMyAccountController>();
  MyProfileController myProfileController = Get.find<MyProfileController>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController birthdateEditingController = TextEditingController();
  TextEditingController companyNameEditingController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  converUsFormatter({required String newText}) {
    // The below code gives a range error if not 10.
    RegExp phone = RegExp(r'(\d{3})(\d{3})(\d{4})');
    var matches = phone.allMatches(newText);
    var match = matches.elementAt(0);
    newText = '(${match.group(1)}) ${match.group(2)}-${match.group(3)}';
    return newText;
  }

  @override
  void initState() {
    editMyAccountController.fetchCompaniesList();
    editMyAccountController.fetchExperienceList();
    getUserData();
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

  ///AppBar
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      titleWidget: Obx(
        () => Text(
          editMyAccountController.isEditEnable.value ? AppStrings.editAccountText : AppStrings.accountText,
          style: ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.headingTitleColor),
        ),
      ),
      centerTitle: true,
      actionWidgets: [
        GestureDetector(
          onTap: () {
            editMyAccountController.isEditEnable.value = !editMyAccountController.isEditEnable.value;
            validateButton();
          },
          child: Container(
            color: AppColors.transparentColor,
            child: ImageComponent.loadLocalImage(imageName: AppImages.editFillCircle, height: 29.w, width: 29.w, boxFit: BoxFit.contain),
          ),
        ),
        15.sizedBoxW,
      ],
    );
  }

  ///Scaffold body
  Widget buildBody() {
    return CommonUtils.constrainedBody(
      children: [
        Center(child: userProfileSection()),
        8.sizedBoxH,
        Center(child: backImageSection()),
        accountForum(),
        updateButtonBody(),
      ],
    );
  }

  ///user profile section
  Widget userProfileSection() {
    return Obx(
      () => InkWell(
        customBorder: const CircleBorder(),
        onTap: editMyAccountController.isEditEnable.value
            ? () {
                onTapImage();
              }
            : null,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0.w),
          width: 192.w,
          height: 192.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.greyColor),
          ),
          child: editMyAccountController.profileImage.value == null
              ? ClipOval(
                  child: ImageWidget(
                    url: myProfileController.myProfileData.value?.profileImg ?? '',
                    fit: BoxFit.cover,
                  ),
                )
              : ClipOval(
                  child: Image.file(
                    File(
                      editMyAccountController.profileImage.value!.path,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }

  ///user profile section
  Widget backImageSection() {
    return Obx(
      () => GestureDetector(
        onTap: editMyAccountController.isEditEnable.value
            ? () {
                onBackGroundImage();
              }
            : null,
        child: Container(
          margin: EdgeInsets.only(left: 16.0.w, right: 16.w, top: 10.h, bottom: 6.h),
          height: 190.h,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyColor),
            borderRadius: BorderRadius.circular(10.0.r),
          ),
          width: double.infinity,
          child: editMyAccountController.backGroundImage.value == null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10.0.r),
                  child: ImageWidget(
                    url: myProfileController.myProfileData.value?.backgroundImg ?? '',
                    fit: BoxFit.cover,
                    placeholder: AppImages.backGroundDefaultImage,
                  ))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10.0.r),
                  child: Image.file(
                    File(
                      editMyAccountController.backGroundImage.value!.path,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
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
      barrierDismissible: true,
      title: AppStrings.mediaAlertTitle,
      content: AppStrings.mediaAlertMessage,
      arrButton: Platform.isAndroid
          ? [
              ButtonComponents.textButton(
                  onTap: () {
                    MediaSelectorManager.chooseProfileImage(
                      imageSource: ImageSource.camera,
                      // imagePicker: userProfileImageController.imagePicker,
                      profileImage: editMyAccountController.profileImage,
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
                      profileImage: editMyAccountController.profileImage,
                      context: context,
                    );
                    Get.back();
                  },
                  context: context,
                  title: 'Gallery'),
            ]
          : [
              CupertinoDialogAction(
                child: const Text('Camera'),
                onPressed: () {
                  MediaSelectorManager.chooseProfileImage(
                    imageSource: ImageSource.camera,
                    // imagePicker: userProfileImageController.imagePicker,
                    profileImage: editMyAccountController.profileImage,
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
                    profileImage: editMyAccountController.profileImage,
                    context: context,
                  );
                  Get.back();
                },
              ),
            ],
    );
  }

  ///onTap Select background image function
  onBackGroundImage() {
    MediaSelectorManager.chooseProfileImage(
      imageSource: ImageSource.gallery,
      // imagePicker: userProfileImageController.imagePicker,
      profileImage: editMyAccountController.backGroundImage,
      context: context,
    );
  }

  ///TextFields
  Widget accountForum() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Row(
              children: [
                cityTextFieldBody(),
                8.sizedBoxW,
                stateTextFieldBody(),
              ],
            ),
            12.sizedBoxH,
            birthDateTextFieldBody(),
            companyTextFieldBody(),
            positionTextFieldBody(),
            userInterestBody(),
            experienceTextFieldBody(),
            bioTextFieldBody(),
            publicPrivateOption(),
          ],
        ),
      ),
    );
  }

  ///First Name TextField
  Widget firstNameTextFieldBody() {
    return TextFieldComponents(
      enable: editMyAccountController.isEditEnable.value,
      textEditingController: firstNameController,
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
        editMyAccountController.firstNameChange.value = value;
        validateButton();
      },
    );
  }

  ///Last Name TextField
  Widget lastNameTextFieldBody() {
    return TextFieldComponents(
      enable: editMyAccountController.isEditEnable.value,
      textEditingController: lastNameController,
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
        editMyAccountController.lastNameChange.value = value;
        validateButton();
      },
    );
  }

  ///Email TextField
  Widget emailTextFieldBody() {
    return TextFieldComponents(
      enable: editMyAccountController.isEditEnable.value,
      textEditingController: emailNameController,
      context: context,
      hint: AppStrings.hintEmail,
      keyboardType: TextInputType.emailAddress,
      textInputFormatter: [
        FilteringTextInputFormatter.deny(
          RegExp(r'\s'),
        ),
      ],
      onChanged: (value) {
        editMyAccountController.emailChange.value = value;
        validateButton();
      },
    );
  }

  ///Phone No TextField
  Widget phoneNoTextFieldBody() {
    return TextFieldComponents(
      enable: editMyAccountController.isEditEnable.value,
      textEditingController: phoneController,
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
        editMyAccountController.phoneChange.value = value;
        validateButton();
      },
    );
  }

  ///city text field
  Widget cityTextFieldBody() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldComponents.buildLabelForTextField(text: AppStrings.city, context: context),
          4.sizedBoxH,
          TextFieldComponents(
            enable: editMyAccountController.isEditEnable.value,
            textEditingController: cityController,
            context: context,
            hint: AppStrings.city,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            textInputFormatter: [
              NoLeadingSpaceFormatter(),
              FilteringTextInputFormatter.allow(
                RegExp(r"[a-zA-Z]+|\s"),
              ),
              LengthLimitingTextInputFormatter(20),
            ],
            onChanged: (value) {
              editMyAccountController.cityChange.value = value;
              validateButton();
            },
          )
        ],
      ),
    );
  }

  ///state text field
  Widget stateTextFieldBody() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldComponents.buildLabelForTextField(text: AppStrings.state, context: context),
          4.sizedBoxH,
          Obx(
            () => (myProfileController.myProfileData.value?.state ?? '').isEmpty
                ? DropdownComponent.commonDropdown(
                    context: context,
                    items: editMyAccountController.stateDropDownList,
                    value: editMyAccountController.stateDropDownModel.value,
                    hint: AppStrings.state,
                    onChanged: editMyAccountController.isEditEnable.value
                        ? (value) {
                            editMyAccountController.stateDropDownModel.value = value;
                            editMyAccountController.selectedStateName.value = editMyAccountController.stateDropDownModel.value?.stateName ?? '';
                            validateButton();
                          }
                        : null,
                  )
                : DropdownComponent.commonDropdown(
                    context: context,
                    items: editMyAccountController.stateDropDownList.map((element) => element.stateName).toList(),
                    value: myProfileController.myProfileData.value?.state ?? '',
                    hint: AppStrings.state,
                    onChanged: editMyAccountController.isEditEnable.value
                        ? (value) {
                            editMyAccountController.stateDropDownModel.value?.stateName = value;
                            editMyAccountController.selectedStateName.value = value;
                            validateButton();
                          }
                        : null,
                  ),
          ),
        ],
      ),
    );
  }

  ///birthdate text Field
  Widget birthDateTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.birthDate, context: context),
        4.sizedBoxH,
        InkWell(
          onTap: editMyAccountController.isEditEnable.value
              ? () async {
                  if (Platform.isIOS) {
                    cupertinoModelPopup();
                  } else {
                    birthdateEditingController.text = await editMyAccountController.pickDateRange(context, birthdateEditingController);
                    Logger().i(birthdateEditingController.text);
                  }

                  validateButton();
                }
              : null,
          child: TextFieldComponents(
            context: context,
            hint: AppStrings.birthDate,
            enable: false,
            textEditingController: birthdateEditingController,
          ),
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///company name text Field
  Widget companyTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.companyName, context: context),
        4.sizedBoxH,
        InkWell(
          onTap: editMyAccountController.isEditEnable.value && widget.isCompanyOwner == false /*|| widget.isCompanyDeleted*/
              ? () {
                  editMyAccountController.loadCompanyListData();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                          height: MediaQuery.of(context).size.height / 2.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 16.0.h),
                                child: Text(
                                  AppStrings.companySearch,
                                  style: ISOTextStyles.openSenseBold(size: 16),
                                ),
                              ),
                              CupertinoSearchTextField(
                                onChanged: (value) => editMyAccountController.onSearch(value),
                              ),
                              Obx(
                                () => Expanded(
                                  child: editMyAccountController.isCompanyDataLoad.value == false
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.primaryColor,
                                          ),
                                        )
                                      : editMyAccountController.searchCompanyList.isEmpty
                                          ? Center(
                                              child: Text(
                                                AppStrings.noCompanyFound,
                                                style: ISOTextStyles.openSenseBold(size: 14),
                                              ),
                                            )
                                          : ListView.builder(
                                              itemCount: editMyAccountController.searchCompanyList.length,
                                              shrinkWrap: true,
                                              itemBuilder: (BuildContext context, int index) {
                                                return ListTile(
                                                  onTap: () {
                                                    companyNameEditingController.text = editMyAccountController.searchCompanyList[index].companyName ?? '';
                                                    editMyAccountController.selectedCompanyId.value = editMyAccountController.searchCompanyList[index].id ?? 0;
                                                    validateButton();
                                                    Get.back();
                                                  },
                                                  title: Text(
                                                    editMyAccountController.searchCompanyList[index].companyName ?? '',
                                                    style: ISOTextStyles.openSenseSemiBold(size: 13),
                                                  ),
                                                );
                                              },
                                            ),
                                ),
                              ),

                              /*ButtonComponents.textButton(
                          alignment: Alignment.center,
                          context: context,
                          onTap: () {
                            Get.back();
                            //Get.toNamed(ScreenRoutesConstants.createCompany);
                          },
                          title: AppStrings.createCompanyProfile,
                          textColor: AppColors.blackColor,
                          textStyle: ISOTextStyles.openSenseBold(size: 16),
                        ),*/
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              : null,
          child: TextFieldComponents(
            context: context,
            enable: false,
            hint: AppStrings.companyName,
            textEditingController: companyNameEditingController,
          ),
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///Position text Field
  Widget positionTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.position, context: context),
        4.sizedBoxH,
        TextFieldComponents(
          enable: editMyAccountController.isEditEnable.value,
          textEditingController: positionController,
          context: context,
          hint: AppStrings.position,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          textInputFormatter: [
            NoLeadingSpaceFormatter(),
            FilteringTextInputFormatter.allow(
              RegExp(r"[a-zA-Z]+|\s"),
            ),
            LengthLimitingTextInputFormatter(30),
          ],
          onChanged: (value) {
            editMyAccountController.positionChange.value = value;
            Logger().i(birthdateEditingController.text);
            validateButton();
          },
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///Preferred  industries body
  Widget userInterestBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.userInterest, context: context),
        4.sizedBoxH,
        InkWell(
          onTap: editMyAccountController.isEditEnable.value
              ? () {
                  Get.to(
                      UserInterestScreen(
                        tagId: userInterestController.selectedCategoryList,
                        isEditInterest: true,
                        isSkipBackGroundImage: false,
                      ),
                      binding: UserInterestBinding());
                }
              : null,
          child: userInterestController.selectedCategoryNameList.isEmpty
              ? TextFieldComponents(
                  context: context,
                  enable: false,
                  hint: AppStrings.selectUserInterest,
                )
              : Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0.r),
                    border: Border.all(
                      color: AppColors.greyColor,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.selectUserInterest,
                        style: ISOTextStyles.hintTextStyle(),
                      ),
                      8.sizedBoxH,
                      Obx(
                        () => Wrap(
                          runSpacing: 10,
                          spacing: 10,
                          children: [
                            ...List.generate(
                              userInterestController.selectedCategoryNameList.length,
                              (index) {
                                return CommonUtils.customChip(
                                  chipText: userInterestController.selectedCategoryNameList[index],
                                  trailingIcon: AppImages.cancelFill,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///experience text Field
  Widget experienceTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.experience, context: context),
        4.sizedBoxH,
        Obx(
          () => (myProfileController.myProfileData.value?.expType ?? '').isEmpty
              ? editMyAccountController.experienceErr.isEmpty
                  ? DropdownComponent.commonDropdown(
                      context: context,
                      items: editMyAccountController.experienceList,
                      value: editMyAccountController.experienceDropDownModel.value,
                      hint: editMyAccountController.experienceList.isEmpty ? 'Loading...' : AppStrings.experience,
                      onChanged: editMyAccountController.isEditEnable.value
                          ? (value) {
                              editMyAccountController.experienceDropDownModel.value = value;
                              editMyAccountController.selectedExpName.value = CommonUtils.getMonthYear(
                                  type: editMyAccountController.experienceDropDownModel.value?.expType ?? '', value: editMyAccountController.experienceDropDownModel.value?.expValue ?? 0);
                              for (int i = 0; i < (editMyAccountController.experienceList.length); i++) {
                                if (CommonUtils.getMonthYear(type: editMyAccountController.experienceList[i].expType ?? '', value: editMyAccountController.experienceList[i].expValue ?? 0) ==
                                    editMyAccountController.selectedExpName.value) {
                                  editMyAccountController.selectedExpId.value = editMyAccountController.experienceList[i].id ?? 0;
                                  Logger().i(editMyAccountController.selectedExpId.value);
                                }
                              }
                              validateButton();
                            }
                          : null,
                    )
                  : TextFieldComponents(
                      context: context,
                      hint: editMyAccountController.experienceErr.value,
                      enable: false,
                      hintColor: AppColors.redColor,
                    )
              : editMyAccountController.experienceErr.isEmpty
                  ? DropdownComponent.commonDropdown(
                      context: context,
                      items: editMyAccountController.experienceList.map((element) => CommonUtils.getMonthYear(type: element.expType ?? '', value: element.expValue ?? 0)).toList(),
                      value: CommonUtils.getMonthYear(type: myProfileController.myProfileData.value?.expType ?? '', value: myProfileController.myProfileData.value?.expValue ?? 0),
                      hint: editMyAccountController.experienceList.isEmpty ? 'Loading...' : AppStrings.experience,
                      onChanged: editMyAccountController.isEditEnable.value
                          ? (value) {
                              editMyAccountController.experienceDropDownModel.value?.expName = value;
                              editMyAccountController.selectedExpName.value = value;
                              for (int i = 0; i < (editMyAccountController.experienceList.length); i++) {
                                if (CommonUtils.getMonthYear(type: editMyAccountController.experienceList[i].expType ?? '', value: editMyAccountController.experienceList[i].expValue ?? 0) ==
                                    editMyAccountController.selectedExpName.value) {
                                  editMyAccountController.selectedExpId.value = editMyAccountController.experienceList[i].id ?? 0;
                                  Logger().i(editMyAccountController.selectedExpId.value);
                                }
                              }

                              validateButton();
                            }
                          : null,
                    )
                  : TextFieldComponents(
                      context: context,
                      hint: editMyAccountController.experienceErr.value,
                      enable: false,
                      hintColor: AppColors.redColor,
                    ),
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///Bio text Field
  Widget bioTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.bio, context: context),
        4.sizedBoxH,
        TextFieldComponents(
          enable: editMyAccountController.isEditEnable.value,
          textEditingController: bioController,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          textInputFormatter: [
            NoLeadingSpaceFormatter(),
            LengthLimitingTextInputFormatter(250),
          ],
          maxLines: 6,
          context: context,
          hint: AppStrings.bio,
          onChanged: (value) {
            editMyAccountController.bioChange.value = value;
            validateButton();
          },
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///public / private switch
  Widget publicPrivateOption() {
    return Obx(
      () => ListTile(
        contentPadding: EdgeInsets.zero,
        title: FittedBox(
          child: Text(
            AppStrings.publicPrivate,
            style: TextStyle(color: AppColors.blackColor, fontSize: 14.0.sp),
          ),
        ),
        trailing: CupertinoSwitch(
          value: myProfileController.myProfileData.value?.isUserPublic.value ?? false,
          onChanged: editMyAccountController.isEditEnable.value
              ? (value) {
                  myProfileController.myProfileData.value!.isUserPublic.value = value;
                  Logger().i(myProfileController.myProfileData.value!.isUserPublic.value);
                }
              : null,
        ),
      ),
    );
  }

  ///Update Button body
  Widget updateButtonBody() {
    return Obx(
      () => editMyAccountController.isEditEnable.value
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
              child: ButtonComponents.cupertinoButton(
                width: double.infinity,
                context: context,
                title: AppStrings.bSubmit,
                backgroundColor: editMyAccountController.isEnabled.value ? AppColors.primaryColor : AppColors.disableButtonColor,
                textStyle: editMyAccountController.isEnabled.value
                    ? ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.blackColor)
                    : ISOTextStyles.openSenseRegular(size: 17, color: AppColors.disableTextColor),
                onTap: () {
                  handleUpdateButtonPress();
                },
              ),
            )
          : Container(),
    );
  }

  ///UpdateButton Press
  handleUpdateButtonPress() async {
    var validationResult = editMyAccountController.isValidFormForGetStarted(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailNameController.text,
      phoneNo: phoneController.text,
      city: cityController.text,
      dateOfBirth: birthdateEditingController.text,
      companyName: companyNameEditingController.text,
      position: positionController.text,
      bio: bioController.text,
      state: editMyAccountController.selectedStateName.value,
      expName: editMyAccountController.selectedExpName.value,
    );
    if (!validationResult.item1) {
      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: validationResult.item2);
    } else {
      editMyAccountController.phoneNoForApi.value = CommonUtils.convertToPhoneNumber(updatedStr: phoneController.text);
      if (editMyAccountController.profileImage.value != null || editMyAccountController.backGroundImage.value != null) {
        await editMyAccountController.convertXFile();
      }
      ShowLoaderDialog.showLoaderDialog(context);
      var upDateApiResult = await editMyAccountController.accountUpdateApiCall(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailNameController.text,
        phoneNo: editMyAccountController.phoneNoForApi.value,
        city: cityController.text,
        dateOfBirth: editMyAccountController.yyMMddStringDob.value,
        position: positionController.text,
        bio: bioController.text,
        state: editMyAccountController.selectedStateName.value,
        myProfileModel: myProfileController.myProfileData.value,
        isUserPublic: myProfileController.myProfileData.value?.isUserPublic.value ?? false,
        onError: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg.toString());
        },
        onSuccess: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
        },
        tagId: userInterestController.selectedCategoryList,
      );
      if (upDateApiResult) {
        editMyAccountController.isEditEnable.value = false;
        myProfileController.isAllDataLoaded.value = true;
        myProfileController.showLoading.value = false;
        myProfileController.fetchProfileDataApi(userId: userSingleton.id ?? myProfileController.userId, isShowLoading: false);
      }
    }
  }

  ///Validate Button
  validateButton() {
    editMyAccountController.validateButton(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailNameController.text,
      phoneNo: phoneController.text,
      city: cityController.text,
      dateOfBirth: birthdateEditingController.text,
      companyName: companyNameEditingController.text,
      position: positionController.text,
      bio: bioController.text,
      state: editMyAccountController.selectedStateName.value,
    );
  }

  ///Get User Data
  getUserData() async {
    firstNameController.text = myProfileController.myProfileData.value?.firstName ?? '';
    CommonUtils.textFieldEndLength(textEditingController: firstNameController);
    lastNameController.text = myProfileController.myProfileData.value?.lastName ?? '';
    CommonUtils.textFieldEndLength(textEditingController: lastNameController);
    emailNameController.text = myProfileController.myProfileData.value?.email ?? '';
    CommonUtils.textFieldEndLength(textEditingController: emailNameController);
    phoneController.text = converUsFormatter(newText: (myProfileController.myProfileData.value?.phoneNumber ?? ''));
    CommonUtils.textFieldEndLength(textEditingController: phoneController);

    cityController.text = myProfileController.myProfileData.value?.city ?? '';
    CommonUtils.textFieldEndLength(textEditingController: cityController);
    editMyAccountController.selectedStateName.value = myProfileController.myProfileData.value?.state ?? '';
    // birthdateEditingController.text = DateFormat('MM/dd/yyyy').format(DateTime.parse(myProfileController.myProfileData.value?.dob ?? ''));
    birthdateEditingController.text =
        (myProfileController.myProfileData.value?.dob ?? '').isEmpty ? '' : DateFormat('MM/dd/yyyy').format(DateTime.parse(myProfileController.myProfileData.value?.dob ?? ''));
    editMyAccountController.yyMMddStringDob.value =
        (myProfileController.myProfileData.value?.dob ?? '').isEmpty ? '' : DateUtil.getFormattedDate(date: myProfileController.myProfileData.value?.dob ?? '', flag: 1);
    companyNameEditingController.text = myProfileController.myProfileData.value?.companyName ?? '';
    editMyAccountController.selectedCompanyId.value = myProfileController.myProfileData.value?.companyId ?? -1;

    CommonUtils.textFieldEndLength(textEditingController: companyNameEditingController);
    positionController.text = myProfileController.myProfileData.value?.position ?? '';
    CommonUtils.textFieldEndLength(textEditingController: positionController);
    editMyAccountController.selectedExpName.value = (myProfileController.myProfileData.value?.expType ?? '').isEmpty
        ? ''
        : CommonUtils.getMonthYear(type: myProfileController.myProfileData.value?.expType ?? '', value: myProfileController.myProfileData.value?.expValue ?? 0);
    editMyAccountController.selectedExpId.value = myProfileController.myProfileData.value?.experienceId ?? -1;
    bioController.text = myProfileController.myProfileData.value?.bio ?? '';
    CommonUtils.textFieldEndLength(textEditingController: bioController);
    editMyAccountController.isPublic.value = myProfileController.myProfileData.value?.isPublic ?? false;
    await userInterestController.fetchFeedCategory();
    if (myProfileController.myProfileData.value?.interestIn != null) {
      for (int i = 0; i < userInterestController.categoryChipList.length; i++) {
        if (myProfileController.myProfileData.value!.interestIn!.contains(userInterestController.categoryChipList[i].id)) {
          userInterestController.selectedCategoryList.add(userInterestController.categoryChipList[i].id ?? 0);
          userInterestController.selectedCategoryNameList.add(userInterestController.categoryChipList[i].categoryName ?? '');
          userInterestController.categoryChipList[i].isCategorySelect.value = true;
        }
      }
    }
  }

  cupertinoModelPopup() {
    return DialogComponent.showCupertinoModelPopupDatePicker(
      initialDatTime: birthdateEditingController.text.isNotEmpty ? DateFormat('MM/dd/yyyy').parse(birthdateEditingController.text) : DateTime.now(),
      context: context,
      onDateTimeChangedFunction: (value) {
        String formattedDate = DateFormat('MM/dd/yyyy').format(value);
        String yyMMddFormattedDate = DateFormat('yyyy-MM-dd').format(value);
        editMyAccountController.yyMMddStringDob.value = yyMMddFormattedDate;
        editMyAccountController.stringDob.value = formattedDate;
        birthdateEditingController.text = editMyAccountController.stringDob.value;
      },
    );
  }
}
