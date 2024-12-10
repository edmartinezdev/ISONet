import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iso_net/controllers/user/detail_info_controller.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/style/dialog_components.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/ui/style/textfield_components.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/app_common_stuffs/text_input_formatters.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../utils/app_common_stuffs/app_colors.dart';
import '../../utils/app_common_stuffs/app_images.dart';
import '../../utils/app_common_stuffs/dropdown_component.dart';
import '../../utils/app_common_stuffs/screen_routes.dart';
import '../../utils/app_common_stuffs/snackbar_util.dart';
import '../style/appbar_components.dart';
import '../style/button_components.dart';
import '../style/image_components.dart';

class DetailInfoScreen extends StatefulWidget {
  const DetailInfoScreen({Key? key}) : super(key: key);

  @override
  State<DetailInfoScreen> createState() => _DetailInfoScreenState();
}

class _DetailInfoScreenState extends State<DetailInfoScreen> {
  DetailInfoController detailInfoController = Get.find();
  TextEditingController birthdateEditingController = TextEditingController();

  DateTime now = DateTime.now();
  DateTime? lastDayOfYear;

  @override
  void initState() {
    lastDayOfYear = DateTime(now.year, now.month, now.day);

    ///Fetching company & experience dropdown list
        detailInfoController.detailInfoApiCall();

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

  ///Appbar Body
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      leadingWidget: GestureDetector(
        onTap: () {
          CommonUtils.buildExitAlert(context: context);
        },
        child: Container(color: AppColors.transparentColor, child: ImageComponent.loadLocalImage(imageName: AppImages.arrow)),
      ),
      centerTitle: false,
      actionWidgets: [
        Align(alignment: Alignment.center,child: skipButton()),
      ],
    );
  }

  ///Scaffold body
  Widget buildBody() {
    return CommonUtils.constrainedBody(
      children: [
        detailsFormBody(),
        nextButtonBody(),
      ],
    );
  }

  /// Skip button body
  Widget skipButton() {
    return GestureDetector(
        onTap: () async{
          ShowLoaderDialog.showLoaderDialog(context);
          var signUpStage3Result = await detailInfoController.apiCallSignUpStage3(
              onError: (msg) {
                SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
              },
              isSkip: true);
          if(signUpStage3Result){
            Get.offAllNamed(ScreenRoutesConstants.userProfileImageScreen);
          }
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

  ///title - heading
  Widget headingBody() {
    return CommonUtils.headingLabelBody(headingText: AppStrings.details);
  }

  ///detail text form body
  Widget detailsFormBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headingBody(),
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
          experienceTextFieldBody(),
          bioTextFieldBody(),
          publicPrivateOption(),
        ],
      ),
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
              detailInfoController.cityChange.value = value;
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
            () => DropdownComponent.commonDropdown(
              context: context,
              items: detailInfoController.stateDropDownList,
              value: detailInfoController.stateDropDownModel.value,
              hint: AppStrings.state,
              onChanged: (value) {
                detailInfoController.stateDropDownModel.value = value;
                validateButton();
              },
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
          onTap: () {
            if (Platform.isIOS) {
              cupertinoModelPopup();
            } else {
              //cupertinoDatePicker();
              detailInfoController.pickDateRange(context, birthdateEditingController);
            }

            validateButton();
          },
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
        Obx(
          ()=> GestureDetector(
            onTap: (userSingleton.isOwner.value ) ? (){} :  () {
              detailInfoController.loadCompanyListData();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 16.0.h, horizontal: 16.0.w),
                            child: Text(
                              AppStrings.companySearch,
                              style: ISOTextStyles.openSenseBold(size: 16),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                            child: CupertinoSearchTextField(
                              onChanged: (value) => detailInfoController.onSearch(value),
                            ),
                          ),
                          Obx(
                            () => Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                                child: detailInfoController.isCompanyDataLoad.value == false
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primaryColor,
                                        ),
                                      )
                                    : detailInfoController.searchCompanyList.isEmpty
                                        ? Center(
                                            child: Text(
                                              AppStrings.noCompanyFound,
                                              style: ISOTextStyles.openSenseBold(size: 14),
                                            ),
                                          )
                                        : ListView.builder(
                                            itemCount: detailInfoController.searchCompanyList.length,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context, int index) {
                                              return ListTile(
                                                onTap: () {
                                                  handleOnCompanySelectTap(listIndex: index);
                                                },
                                                title: Text(
                                                  detailInfoController.searchCompanyList[index].companyName ?? '',
                                                  style: ISOTextStyles.openSenseSemiBold(size: 13),
                                                ),
                                              );
                                            },
                                          ),
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 1.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8.0.h, bottom: 16.0.h),
                            child: GestureDetector(
                              onTap: () {
                                Get.back();
                                Get.toNamed(ScreenRoutesConstants.createCompany);
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  AppStrings.createYourCompanyProfile,
                                  style: ISOTextStyles.openSenseBold(size: 14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: TextFieldComponents(
              context: context,
              enable: false,
              hint: AppStrings.companyName,
              textEditingController: detailInfoController.companyNameEditingController,
            ),
          ),
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///handle company name select event function
  handleOnCompanySelectTap({required listIndex}) {
    detailInfoController.companyNameEditingController.text = detailInfoController.searchCompanyList[listIndex].companyName ?? '';
    detailInfoController.selectedCompanyId.value = '${detailInfoController.searchCompanyList[listIndex].id ?? 0}';
    validateButton();
    Get.back();
  }

  ///Position text Field
  Widget positionTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.position, context: context),
        4.sizedBoxH,
        TextFieldComponents(
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
            detailInfoController.positionChange.value = value;
            validateButton();
          },
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
          () => detailInfoController.experienceErr.isEmpty
              ? DropdownComponent.commonDropdown(
                  context: context,
                  items: detailInfoController.experienceList,
                  value: detailInfoController.experienceDropDownModel.value,
                  hint: detailInfoController.experienceList.isEmpty ? 'Loading...' : AppStrings.experience,
                  onChanged: (value) {
                    detailInfoController.experienceDropDownModel.value = value;

                    validateButton();
                  },
                )
              : TextFieldComponents(
                  context: context,
                  hint: detailInfoController.experienceErr.value,
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
            detailInfoController.bioChange.value = value;
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
          value: detailInfoController.isPublic.value,
          onChanged: detailInfoController.toggleSwitch,
        ),
      ),
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
          backgroundColor: detailInfoController.isButtonEnable.value ? AppColors.primaryColor : AppColors.disableButtonColor,
          textStyle: detailInfoController.isButtonEnable.value
              ? ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.blackColor)
              : ISOTextStyles.openSenseRegular(size: 17, color: AppColors.disableTextColor),
          onTap: () {
            handleNextButtonPress();
          },
        ),
      ),
    );
  }

  /// Function on next button will go here
  handleNextButtonPress() async {
    var validationResult = detailInfoController.isValidFormForDetails(
      dateOfBirth: birthdateEditingController.text,
      companyName: detailInfoController.companyNameEditingController.text,
    );
    if (!validationResult.item1) {
      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: validationResult.item2);
    } else {
      var signUpStage3Result = await detailInfoController.apiCallSignUpStage3(
        onError: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg.toString());
        },
      );
      if (signUpStage3Result) {
        Get.offAllNamed(ScreenRoutesConstants.userProfileImageScreen);
      }
    }
  }

  /// button validation function
  validateButton() {
    detailInfoController.validateButton(
      dateOfBirth: birthdateEditingController.text,
      companyName: detailInfoController.companyNameEditingController.text,
    );
  }

  cupertinoModelPopup() {
    return DialogComponent.showCupertinoModelPopupDatePicker(
        context: context,
        onDateTimeChangedFunction: (value) {
          String formattedDate = DateFormat('MM/dd/yyyy').format(value);
          String yyMMddFormattedDate = DateFormat('yyyy-MM-dd').format(value);
          detailInfoController.yyMMddStringDob.value = yyMMddFormattedDate;
          detailInfoController.stringDob.value = formattedDate;
          birthdateEditingController.text = detailInfoController.stringDob.value;
        },
        onDoneButtonPress: () {
          if (detailInfoController.stringDob.value.isEmpty) {
            String formattedDate = DateFormat('MM/dd/yyyy').format(DateTime.now());
            String yyMMddFormattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
            detailInfoController.yyMMddStringDob.value = yyMMddFormattedDate;
            detailInfoController.stringDob.value = formattedDate;
            birthdateEditingController.text = detailInfoController.stringDob.value;
            Get.back();
          } else {
            Get.back();
          }
        });
  }
}
