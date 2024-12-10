import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/bindings/user/loan_preference_binding.dart';
import 'package:iso_net/controllers/user/loan_preference_controller.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/search/findfunder_companylist_screen.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../utils/app_common_stuffs/commom_utils.dart';
import '../../../../utils/app_common_stuffs/dropdown_component.dart';
import '../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../style/appbar_components.dart';
import '../../../style/button_components.dart';
import '../../../style/showloader_component.dart';
import '../../../style/text_style.dart';
import '../../../style/textfield_components.dart';

class LoanForumScreen extends StatefulWidget {
  const LoanForumScreen({Key? key}) : super(key: key);

  @override
  State<LoanForumScreen> createState() => _LoanForumScreenState();
}

class _LoanForumScreenState extends State<LoanForumScreen> {
  LoanPreferenceController loanPreferenceController = Get.find<LoanPreferenceController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowLoaderDialog.showLoaderDialog(context);
    });
    initApiCall();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBody(),
      body: buildBody(),
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
          padding: EdgeInsets.symmetric(vertical: 16.0.h, horizontal: 16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headingBody(),
              creditRequireDropDownBody(),
              /*minimumMonthlyDropDownBody(),*/
              minimumMonthlyRevenueTextField(),
              minimumTimeDropDownBody(),
              industriesBody(),
              statesBody(),
            ],
          ),
        ),
        findFunderButtonBody(),
      ],
    );
  }

  ///title-heading body
  Widget headingBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.dealDetails,
          style: ISOTextStyles.openSenseBold(size: 20, color: AppColors.headingTitleColor),
        ),
        11.sizedBoxH,
        Text(
          AppStrings.tellUsTypeDeal,
          style: ISOTextStyles.openSenseLight(color: AppColors.hintTextColor, size: 14),
        ),
      ],
    );
  }

  ///Credit Requirement
  Widget creditRequireDropDownBody() {
    return Container(
      padding: EdgeInsets.only(top: 25.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldComponents.buildLabelForTextField(text: AppStrings.creditScore, context: context),
          4.sizedBoxH,
          Obx(
            () => loanPreferenceController.strList[0].isEmpty
                ? DropdownComponent.commonDropdown(
                    context: context,
                    items: loanPreferenceController.creditRequirementList,
                    value: loanPreferenceController.creditRequirementModel.value,
                    hint: loanPreferenceController.creditRequirementList.isEmpty ? 'Loading...' : AppStrings.borrowerCreditRequirement,
                    onChanged: (value) {
                      loanPreferenceController.creditRequirementModel.value = value;
                      loanPreferenceController.validateFindFunderButton();
                    },
                  )
                : errorTextField(index: 0),
          ),
          12.sizedBoxH,
        ],
      ),
    );
  }

  ///minimum time body
  Widget minimumTimeDropDownBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.minimumTimeInBusiness, context: context),
        4.sizedBoxH,
        Obx(
          () => loanPreferenceController.strList[1].isEmpty
              ? DropdownComponent.commonDropdown(
                  context: context,
                  items: loanPreferenceController.minTimeList,
                  value: loanPreferenceController.minTimeRevModel.value,
                  hint: loanPreferenceController.minTimeList.isEmpty ? 'Loading...' : AppStrings.selectTime,
                  onChanged: (value) {
                    loanPreferenceController.minTimeRevModel.value = value;
                    loanPreferenceController.validateFindFunderButton();
                  },
                )
              : errorTextField(index: 1),
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///minimum monthly body
  Widget minimumMonthlyRevenueTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.minimumMonthlyRevenue, context: context),
        4.sizedBoxH,
        TextFieldComponents(
          context: context,
          hint: AppStrings.minimumMonthlyRevenue,
          keyboardType: TextInputType.number,
          textInputFormatter: [
            FilteringTextInputFormatter.digitsOnly,
            CurrencyPtBrInputFormatter(maxDigits: 12),
          ],
          onChanged: (value) {
            loanPreferenceController.monthlyRevenue.value = value;
            Logger().i(loanPreferenceController.monthlyRevenue.value);
            loanPreferenceController.validateFindFunderButton();
          },
        ),
        12.sizedBoxH,
      ],
    );
  }
  /*Widget minimumMonthlyDropDownBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.minimumMonthlyRevenue, context: context),
        4.sizedBoxH,
        Obx(
          () =>

              //loanPreferenceController.errMonthStr.isEmpty ?
              loanPreferenceController.strList[2].isEmpty
                  ? DropdownComponent.commonDropdown(
                      context: context,
                      items: loanPreferenceController.monthlyRevenueList,
                      value: loanPreferenceController.minMonthRevModel.value,
                      hint: loanPreferenceController.monthlyRevenueList.isEmpty ? 'Loading...' : AppStrings.selectMonthlyRevenue,
                      onChanged: (value) {
                        loanPreferenceController.minMonthRevModel.value = value;
                        loanPreferenceController.validateFindFunderButton();
                      },
                    )
                  : errorTextField(index: 2),
        ),
        12.sizedBoxH,
      ],
    );
  }*/

  ///restricted industries
  Widget industriesBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.industries, context: context),
        4.sizedBoxH,
        Obx(
          () => loanPreferenceController.strList[3].isEmpty
              ? InkWell(
                  onTap: () {
                    loanPreferenceController.loadDropdownTempListsForSearch();
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                            height: MediaQuery.of(context).size.height / 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 16.0.h),
                                  child: Text(
                                    AppStrings.industrySearch,
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0.sp),
                                  ),
                                ),
                                CupertinoSearchTextField(
                                  onChanged: (value) => loanPreferenceController.onRestrictedIndSearch(value),
                                ),
                                Obx(
                                  () => Expanded(
                                    child: ListView.builder(
                                      itemCount: loanPreferenceController.searchResIndustryList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context, int index) {
                                        return ListTile(
                                          contentPadding: EdgeInsets.only(
                                            left: 8.0.w,
                                          ),
                                          title: Text(loanPreferenceController.searchResIndustryList[index].industryName ?? ''),
                                          trailing: Obx(
                                            () => Checkbox(
                                              activeColor: AppColors.primaryColor,
                                              value: loanPreferenceController.searchResIndustryList[index].isResIndustryChecked.value,
                                              onChanged: (value) {
                                                loanPreferenceController.checkBoxResIndustry(index, value ?? false);

                                                loanPreferenceController.validateFindFunderButton();
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 8.0.h),
                                  child: ButtonComponents.cupertinoButton(
                                    width: double.infinity,
                                    context: context,
                                    onTap: () {
                                      Get.back();
                                    },
                                    title: AppStrings.bDone,
                                    textColor: AppColors.blackColor,
                                    textStyle: ISOTextStyles.openSenseBold(size: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: loanPreferenceController.selectedResIndustryChipList.isEmpty
                      ? TextFieldComponents(
                          context: context,
                          enable: false,
                          hint: AppStrings.selectIndustry,
                        )
                      : Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 12.0.h),
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
                                loanPreferenceController.getAllIndustryList.isEmpty ? 'Loading...' : AppStrings.selectIndustry,
                                style: ISOTextStyles.hintTextStyle(),
                              ),
                              8.sizedBoxH,
                              Obx(
                                () => Wrap(
                                  runSpacing: 10,
                                  spacing: 10,
                                  children: [
                                    ...List.generate(
                                      loanPreferenceController.selectedResIndustryChipList.length,
                                      (index) {
                                        return CommonUtils.customChip(
                                          chipText: loanPreferenceController.selectedResIndustryChipList[index].industryName ?? '',
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
                )
              : errorTextField(index: 3),
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///states body
  Widget statesBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.state, context: context),
        4.sizedBoxH,
        Obx(
          () => loanPreferenceController.strList[5].isEmpty
              ? InkWell(
                  onTap: () {
                    loanPreferenceController.loadDropdownTempListsForSearch();
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                            height: MediaQuery.of(context).size.height / 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 16.0.h),
                                  child: Text(
                                    AppStrings.stateSearch,
                                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0.sp),
                                  ),
                                ),
                                CupertinoSearchTextField(
                                  onChanged: (value) => loanPreferenceController.onResStatesSearch(value),
                                ),
                                Obx(
                                  () => Expanded(
                                    child: ListView.builder(
                                      itemCount: loanPreferenceController.searchGetAllStates.length,
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context, int index) {
                                        return ListTile(
                                          contentPadding: EdgeInsets.only(
                                            left: 8.0.w,
                                          ),
                                          title: Text(loanPreferenceController.searchGetAllStates[index].stateName ?? ''),
                                          trailing: Obx(
                                            () => Checkbox(
                                                activeColor: AppColors.primaryColor,
                                                value: loanPreferenceController.searchGetAllStates[index].isStateChecked.value,
                                                onChanged: (value) {
                                                  loanPreferenceController.checkBoxTap(index, value ?? false);

                                                  loanPreferenceController.validateFindFunderButton();
                                                }),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 8.0.h),
                                  child: ButtonComponents.cupertinoButton(
                                    width: double.infinity,
                                    context: context,
                                    onTap: () {
                                      Get.back();
                                    },
                                    title: AppStrings.bDone,
                                    textColor: AppColors.blackColor,
                                    textStyle: ISOTextStyles.openSenseBold(size: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: loanPreferenceController.selectedStateChipList.isEmpty
                      ? TextFieldComponents(
                          context: context,
                          enable: false,
                          hint: AppStrings.selectState,
                        )
                      : Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 12.0.h),
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
                                loanPreferenceController.getAllStates.isEmpty ? 'Loading...' : AppStrings.selectState,
                                style: ISOTextStyles.hintTextStyle(),
                              ),
                              8.sizedBoxH,
                              Obx(
                                () => Wrap(
                                  runSpacing: 10,
                                  spacing: 10,
                                  children: [
                                    ...List.generate(
                                      loanPreferenceController.selectedStateChipList.length,
                                      (index) {
                                        return CommonUtils.customChip(
                                          chipText: loanPreferenceController.selectedStateChipList[index].stateName ?? '',
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
                )
              : errorTextField(index: 5),
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///Error handle textfield
  Widget errorTextField({required int index}) {
    return TextFieldComponents(
      context: context,
      hint: loanPreferenceController.strList[index],
      enable: false,
      hintColor: AppColors.redColor,
    );
  }

  ///InitState api's function
  initApiCall() async {
    loanPreferenceController.apiCallFetchCreditRequirementList();
    loanPreferenceController.apiCallFetchMinimumTimeList();
    /*loanPreferenceController.apiCallFetchMonthlyRevenueList();*/
    loanPreferenceController.apiCallFetchIndustryList();
    await loanPreferenceController.apiCallFetchStatesList().whenComplete(() => ShowLoaderDialog.dismissLoaderDialog());
  }

  ///Create Company Profile button body
  Widget findFunderButtonBody() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
        child: ButtonComponents.cupertinoButton(
          width: double.infinity,
          context: context,
          title: AppStrings.findFunder,
          backgroundColor: loanPreferenceController.isButtonEnable.value ? AppColors.primaryColor : AppColors.disableButtonColor,
          textStyle: loanPreferenceController.isButtonEnable.value
              ? ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.blackColor)
              : ISOTextStyles.openSenseRegular(size: 17, color: AppColors.disableTextColor),
          onTap: () {
            onButtonPressed();
          },
        ),
      ),
    );
  }

  ///***** on final button pressed
  onButtonPressed() async {
    var validationResult = loanPreferenceController.isValidFindFunderForm();
    if (!validationResult.item1) {
      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: validationResult.item2);
    } else {
      loanPreferenceController.funderCompanyList.clear();
      loanPreferenceController.pageToShow.value = 1;
      loanPreferenceController.totalRecords.value = 0;
      loanPreferenceController.isAllDataLoaded.value = false;
      ShowLoaderDialog.showLoaderDialog(context);
      var findFunderApiResult = await loanPreferenceController.apiCallFindFunder(
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
        },
      );
      if (findFunderApiResult) {
        Get.to(
          const FindFunderCompanyListScreen(),
          binding: LoanPreferenceBinding(),
        );
      }
    }
  }
}
