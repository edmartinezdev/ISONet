import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/user/company_image_controller.dart';
import 'package:iso_net/controllers/user/create_company_controller.dart';
import 'package:iso_net/controllers/user/detail_info_controller.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/ui/style/textfield_components.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/dropdown_component.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../controllers/user/loan_preference_controller.dart';
import '../../singelton_class/auth_singelton.dart';
import '../../utils/app_common_stuffs/app_logger.dart';
import '../../utils/app_common_stuffs/screen_routes.dart';
import '../../utils/app_common_stuffs/strings_constants.dart';
import '../style/appbar_components.dart';
import '../style/button_components.dart';

class LoanPreferencesScreen extends StatefulWidget {
  const LoanPreferencesScreen({Key? key}) : super(key: key);

  @override
  State<LoanPreferencesScreen> createState() => _LoanPreferencesScreenState();
}

class _LoanPreferencesScreenState extends State<LoanPreferencesScreen> {
  LoanPreferenceController loanPreferenceController = Get.find<LoanPreferenceController>();
  CreateCompanyController createCompanyController = Get.find<CreateCompanyController>();
  CompanyImageController companyImageController = Get.find<CompanyImageController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowLoaderDialog.showLoaderDialog(context);
    });
    apiCall();
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

  ///Scaffold Body
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
              restrictedIndustriesBody(),
              maximumNsfDropDownBody(),
              restrictedStatesBody(),
              preferredIndustriesBody(),
              /*maximumFundingDropDownBody(),*/
              maximumFundingTextField(),
              maximumTermDropDownBody(),
              startByRateDropDownBody(),
              maxUpsellDropDownBody(),
            ],
          ),
        ),
        companyProfileButtonBody(),
      ],
    );
  }

  ///title-heading body
  Widget headingBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.loanPreferences,
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
      padding: EdgeInsets.only(top: 16.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldComponents.buildLabelForTextField(text: AppStrings.creditScore, context: context),
          4.sizedBoxH,
          TextFieldComponents(
            context: context,
            hint: AppStrings.creditScore,
            textEditingController: loanPreferenceController.creditTextController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              loanPreferenceController.validateButton();
            },
            textInputFormatter: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),

          ///Comment code is credit score dropdown
          /*Obx(
            () => loanPreferenceController.strList[0].isEmpty
                ? DropdownComponent.commonDropdown(
                    context: context,
                    items: loanPreferenceController.creditRequirementList,
                    value: loanPreferenceController.creditRequirementModel.value,
                    hint: loanPreferenceController.creditRequirementList.isEmpty ? AppStrings.loading : AppStrings.minCredScore,
                    onChanged: (value) {
                      loanPreferenceController.creditRequirementModel.value = value;
                      loanPreferenceController.validateButton();
                    },
                  )
                : errorTextField(index: 0),
          ),*/

          12.sizedBoxH,
        ],
      ),
    );
  }

  ///Minimum Monthly Revenue body
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
            loanPreferenceController.validateButton();
          },
        ),
        12.sizedBoxH,
      ],
    );
  }

/*  ///minimum monthly body
  Widget minimumMonthlyDropDownBody() {
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
                      hint: loanPreferenceController.monthlyRevenueList.isEmpty ? AppStrings.loading : AppStrings.selectMonthlyRevenue,
                      onChanged: (value) {
                        loanPreferenceController.minMonthRevModel.value = value;
                        loanPreferenceController.validateButton();
                      },
                    )
                  : errorTextField(index: 2),
        ),
        12.sizedBoxH,
      ],
    );
  }*/

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
                  hint: loanPreferenceController.minTimeList.isEmpty ? AppStrings.loading : AppStrings.selectTime,
                  onChanged: (value) {
                    loanPreferenceController.minTimeRevModel.value = value;
                    loanPreferenceController.validateButton();
                  },
                )
              : errorTextField(index: 1),
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///restricted industries
  Widget restrictedIndustriesBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.restrictedIndustries, context: context),
        4.sizedBoxH,
        Obx(
          () => loanPreferenceController.strList[2].isEmpty
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

                                                loanPreferenceController.validateButton();
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
                          hint: AppStrings.selectRestrictedIndustries,
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
                              Container(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  loanPreferenceController.getAllIndustryList.isEmpty ? AppStrings.loading : AppStrings.selectRestrictedIndustries,
                                  style: ISOTextStyles.hintTextStyle(),
                                ),
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
              : errorTextField(index: 2),
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///maximum NFSs/month body
  Widget maximumNsfDropDownBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.maximumOfNSFPerMonth, context: context),
        4.sizedBoxH,
        TextFieldComponents(
          context: context,
          hint: AppStrings.maximumOfNSFPerMonth,
          textEditingController: loanPreferenceController.nsfTextController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            loanPreferenceController.validateButton();
          },
          textInputFormatter: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),

        ///Comment code is nsf dropdown
        /*Obx(
          () => loanPreferenceController.strList[3].isEmpty
              ? DropdownComponent.commonDropdown(
                  context: context,
                  items: loanPreferenceController.nsfList,
                  value: loanPreferenceController.minimumNSFListModel.value,
                  hint: loanPreferenceController.nsfList.isEmpty ? AppStrings.loading : AppStrings.selectOfNSFPerMonth,
                  onChanged: (value) {
                    loanPreferenceController.minimumNSFListModel.value = value;
                    loanPreferenceController.validateButton();
                  },
                )
              : errorTextField(index: 3),
        ),*/
        12.sizedBoxH,
      ],
    );
  }

  ///restricted states body
  Widget restrictedStatesBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.restrictedStates, context: context),
        4.sizedBoxH,
        Obx(
          () => loanPreferenceController.strList[4].isEmpty
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

                                                  loanPreferenceController.validateButton();
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
                          hint: AppStrings.selectRestrictedStates,
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
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  loanPreferenceController.getAllStates.isEmpty ? AppStrings.loading : AppStrings.selectRestrictedStates,
                                  style: ISOTextStyles.hintTextStyle(),
                                ),
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
              : errorTextField(index: 4),
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///Preferred  industries body
  Widget preferredIndustriesBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.preferredIndustries, context: context),
        4.sizedBoxH,
        Obx(() => loanPreferenceController.strList[5].isEmpty
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
                                onChanged: (value) => loanPreferenceController.onPrefIndSearch(value),
                              ),
                              Obx(
                                () => Expanded(
                                  child: ListView.builder(
                                    itemCount: loanPreferenceController.searchPrefIndustryList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, int index) {
                                      return ListTile(
                                        contentPadding: EdgeInsets.only(
                                          left: 8.0.w,
                                        ),
                                        title: Text(loanPreferenceController.searchPrefIndustryList[index].industryName ?? ''),
                                        trailing: Obx(
                                          () => Checkbox(
                                            activeColor: AppColors.primaryColor,
                                            value: loanPreferenceController.searchPrefIndustryList[index].isPrefIndustryChecked.value,
                                            onChanged: (value) {
                                              loanPreferenceController.checkBoxPrefIndustry(index, value ?? false);

                                              loanPreferenceController.validateButton();
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
                child: loanPreferenceController.selectedPrefIndustryChipList.isEmpty
                    ? TextFieldComponents(
                        context: context,
                        enable: false,
                        hint: AppStrings.selectPreferredIndustries,
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
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                loanPreferenceController.getAllIndustryList.isEmpty ? AppStrings.loading : AppStrings.selectPreferredIndustries,
                                style: ISOTextStyles.hintTextStyle(),
                              ),
                            ),
                            8.sizedBoxH,
                            Obx(
                              () => Wrap(
                                runSpacing: 10,
                                spacing: 10,
                                children: [
                                  ...List.generate(
                                    loanPreferenceController.selectedPrefIndustryChipList.length,
                                    (index) {
                                      return CommonUtils.customChip(
                                        chipText: loanPreferenceController.selectedPrefIndustryChipList[index].industryName ?? '',
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
            : errorTextField(index: 5)),
        12.sizedBoxH,
      ],
    );
  }

  ///Maximum Funding Amounts body
  /*Widget maximumFundingDropDownBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.maximumFundingAmounts, context: context),
        4.sizedBoxH,
        Obx(
          () => loanPreferenceController.strList[7].isEmpty
              ? DropdownComponent.commonDropdown(
                  context: context,
                  items: loanPreferenceController.maxFundAmountList,
                  value: loanPreferenceController.maxFundingAmountListModel.value,
                  hint: loanPreferenceController.maxFundAmountList.isEmpty ? AppStrings.loading : AppStrings.selectFundingAmounts,
                  onChanged: (value) {
                    loanPreferenceController.maxFundingAmountListModel.value = value;
                    loanPreferenceController.validateButton();
                  },
                )
              : errorTextField(index: 7),
        ),
        12.sizedBoxH,
      ],
    );
  }*/

  ///Maximum Funding Amounts body
  Widget maximumFundingTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.maximumFundingAmounts, context: context),
        4.sizedBoxH,
        TextFieldComponents(
          context: context,
          hint: AppStrings.loanFundingAmount,
          keyboardType: TextInputType.number,
          textInputFormatter: [
            FilteringTextInputFormatter.digitsOnly,
            CurrencyPtBrInputFormatter(maxDigits: 12),
          ],
          onChanged: (value) {
            loanPreferenceController.loanAmount.value = value;
            Logger().i(loanPreferenceController.loanAmount.value);
            loanPreferenceController.validateButton();
          },
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///Maximum Term Length body
  Widget maximumTermDropDownBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.maximumTermLength, context: context),
        4.sizedBoxH,
        Obx(
          () => loanPreferenceController.strList[6].isEmpty
              ? DropdownComponent.commonDropdown(
                  context: context,
                  items: loanPreferenceController.maxTermLengthList,
                  value: loanPreferenceController.maxTermLengthListModel.value,
                  hint: loanPreferenceController.maxTermLengthList.isEmpty ? AppStrings.loading : AppStrings.selectTermLength,
                  onChanged: (value) {
                    loanPreferenceController.maxTermLengthListModel.value = value;
                    loanPreferenceController.validateButton();
                  },
                )
              : errorTextField(index: 6),
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///Starting Buy Rates body
  Widget startByRateDropDownBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.startingBuyRates, context: context),
        4.sizedBoxH,
        TextFieldComponents(
          context: context,
          hint: AppStrings.startingBuyRates,
          textEditingController: loanPreferenceController.buyRateTextController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.next,
          onChanged: (value) {
            loanPreferenceController.validateButton();
          },
          textInputFormatter: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
        ),

        ///Comment code is buy rate dropdown
        /*Obx(
          () => loanPreferenceController.strList[7].isEmpty
              ? DropdownComponent.commonDropdown(
                  context: context,
                  items: loanPreferenceController.buyingRateList,
                  value: loanPreferenceController.startingBuyRatesListModel.value,
                  hint: loanPreferenceController.buyingRateList.isEmpty ? AppStrings.loading : AppStrings.selectStartingBuyRates,
                  onChanged: (value) {
                    loanPreferenceController.startingBuyRatesListModel.value = value;
                    loanPreferenceController.validateButton();
                  },
                )
              : errorTextField(index: 7),
        ),*/
        12.sizedBoxH,
      ],
    );
  }

  ///Max Upsell Points body
  Widget maxUpsellDropDownBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.maxUpsellPoints, context: context),
        4.sizedBoxH,
        TextFieldComponents(
          context: context,
          hint: AppStrings.maxUpsellPoints,
          textEditingController: loanPreferenceController.maxUpSellTextController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onChanged: (value) {
            loanPreferenceController.validateButton();
          },
          textInputFormatter: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        /*Obx(
          () => loanPreferenceController.strList[8].isEmpty
              ? DropdownComponent.commonDropdown(
                  context: context,
                  items: loanPreferenceController.maxUpSellList,
                  value: loanPreferenceController.maxUpSellPointsListModel.value,
                  hint: loanPreferenceController.maxUpSellList.isEmpty ? AppStrings.loading : AppStrings.selectMaxUpsellPoints,
                  onChanged: (value) {
                    loanPreferenceController.maxUpSellPointsListModel.value = value;
                    loanPreferenceController.validateButton();
                  },
                )
              : errorTextField(index: 8),
        ),*/
        12.sizedBoxH,
      ],
    );
  }

  ///Create Company Profile button body
  Widget companyProfileButtonBody() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
        child: ButtonComponents.cupertinoButton(
          width: double.infinity,
          context: context,
          title: AppStrings.completeCompanyProfile,
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
    var validationResult = loanPreferenceController.isValidLoanPref();
    if (!validationResult.item1) {
      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: validationResult.item2);
    } else if (loanPreferenceController.prefIndustryList.where((p0) => loanPreferenceController.resIndustryList.contains(p0)).isNotEmpty) {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: AppStrings.validateResPrefIndustries);
    } else {
      var createCompanyApiResult = await loanPreferenceController.apiCallCreateCompanyFunder(
        companyName: createCompanyController.companyNameChange.value,
        address: createCompanyController.addressTextController.text,
        city: createCompanyController.cityTextController.text,
        state: createCompanyController.stateTextController.text,
        zipcode: createCompanyController.zipCodeTextController.text,
        phoneNumber: createCompanyController.phoneNoForApi.value,
        website: createCompanyController.websiteChange.value,
        description: createCompanyController.descriptionChange.value,
        file: companyImageController.file.isEmpty ? [] : companyImageController.file,
        onErr: (msg) => SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg),
        longitude: '${createCompanyController.longitude}',
        latitude: '${createCompanyController.latitude}',
      );
      if (createCompanyApiResult) {
        DetailInfoController detailInfoController = Get.find<DetailInfoController>();
        await detailInfoController.detailInfoApiCall();
        userSingleton.loadUserData();
        Get.until((route) => route.settings.name == ScreenRoutesConstants.detailScreen);
      }
    }
  }

  Widget errorTextField({required int index}) {
    return TextFieldComponents(
      context: context,
      hint: loanPreferenceController.strList[index],
      enable: false,
      hintColor: AppColors.redColor,
    );
  }

  ///Api init call function
  apiCall() async {
    loanPreferenceController.apiCallFetchCreditRequirementList();
    loanPreferenceController.apiCallFetchMinimumTimeList();
    /*loanPreferenceController.apiCallFetchMonthlyRevenueList();*/
    loanPreferenceController.apiCallFetchIndustryList();
    loanPreferenceController.apiCallFetchMinimumNSFList();
    loanPreferenceController.apiCallFetchStatesList();
    /*loanPreferenceController.apiCallFetchMaxFundingList();*/
    loanPreferenceController.apiCallFetchMaxTermList();
    loanPreferenceController.apiCallFetchStartingBuyRatesList();
    loanPreferenceController.apiCallFetchMaxUpsellList();
    await loanPreferenceController.loadDropdownTempListsForSearch();
  }
}
