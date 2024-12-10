import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/setting_controller/company_setting_controller.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/search/company_filter_controller.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../../utils/app_common_stuffs/commom_utils.dart';
import '../../../../../utils/app_common_stuffs/dropdown_component.dart';
import '../../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../../style/button_components.dart';
import '../../../../style/image_components.dart';
import '../../../../style/showloader_component.dart';
import '../../../../style/text_style.dart';
import '../../../../style/textfield_components.dart';

class CompanyFilterScreen extends StatefulWidget {
  const CompanyFilterScreen({Key? key}) : super(key: key);

  @override
  State<CompanyFilterScreen> createState() => _CompanyFilterScreenState();
}

class _CompanyFilterScreenState extends State<CompanyFilterScreen> {
  CompanyFilterController companyFilterController = Get.find();
  CompanySettingController companySettingController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowLoaderDialog.showLoaderDialog(context);
    });
    getAllLoanData();

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
    return AppBar(
      leading: GestureDetector(
        onTap: () => Get.back(result: true),
        //onPressed: () => Get.back(),
        child: ImageComponent.loadLocalImage(
          imageName: AppImages.arrow,
        ),
      ),
      title: Obx(
        () => Text(
          companyFilterController.isLoanEdit.value ? AppStrings.editLoanPreferences : AppStrings.loanPreferences,
          style: ISOTextStyles.openSenseSemiBold(size: 17),
        ),
      ),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: () {
            companyFilterController.isLoanEdit.value = !companyFilterController.isLoanEdit.value;
            companyFilterController.validateButton();
          },
          child: ImageComponent.loadLocalImage(imageName: AppImages.editFill, height: 28.w, width: 28.w, boxFit: BoxFit.contain),
        ),
        15.sizedBoxW,
      ],
    );
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
              creditRequireDropDownBody(),

              /*minimumMonthlyDropDownBody(),*/
              minimumMonthlyRevenueTextField(),
              minimumTimeDropDownBody(),
              restrictedIndustriesBody(),
              maximumNsfDropDownBody(),
              restrictedStatesBody(),
              preferredIndustriesBody(),
              //maximumFundingDropDownBody(),
              maximumFundingDropDownBody2(),
              maximumTermDropDownBody(),
              startByRateDropDownBody(),
              maxUpsellDropDownBody(),
            ],
          ),
        ),
        loanUpdateButtonBody(),
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

          ///Comment code is dropdown of credit score
          /*Obx(
            () => companyFilterController.strList[0].isEmpty
                ? DropdownComponent.commonDropdown(
                    context: context,
                    items: companyFilterController.creditRequirementList,
                    value: companyFilterController.creditRequirementModel.value,
                    hint: companyFilterController.creditRequirementList.isEmpty ? 'Loading...' : AppStrings.minCredScore,
                    onChanged: companyFilterController.isLoanEdit.value
                        ? (value) {
                            companyFilterController.creditRequirementModel.value = value;
                            companyFilterController.validateButton();
                          }
                        : null,
                  )
                : errorTextField(index: 0),
          ),*/
          Obx(
            () => TextFieldComponents(
              enable: companyFilterController.isLoanEdit.value,
              context: context,
              hint: AppStrings.creditScore,
              textEditingController: companyFilterController.creditTextController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onChanged: (value) {
                companyFilterController.validateButton();
              },
              textInputFormatter: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
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
          () => companyFilterController.strList[1].isEmpty
              ? DropdownComponent.commonDropdown(
                  context: context,
                  items: companyFilterController.minTimeList,
                  value: companyFilterController.minTimeRevModel.value,
                  hint: companyFilterController.minTimeList.isEmpty ? 'Loading...' : AppStrings.minimumTimeInBusiness,
                  onChanged: companyFilterController.isLoanEdit.value
                      ? (value) {
                          companyFilterController.minTimeRevModel.value = value;
                          companyFilterController.validateButton();
                        }
                      : null,
                )
              : errorTextField(index: 1),
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///Minimum Monthly Revenue body
  Widget minimumMonthlyRevenueTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.minimumMonthlyRevenue, context: context),
        4.sizedBoxH,
        Obx(
          () => TextFieldComponents(
            enable: companyFilterController.isLoanEdit.value,
            textEditingController: companyFilterController.monthlyRevenueController,
            context: context,
            hint: AppStrings.minimumMonthlyRevenue,
            keyboardType: TextInputType.number,
            textInputFormatter: [
              FilteringTextInputFormatter.digitsOnly,
              CurrencyPtBrInputFormatter(maxDigits: 12),
              /*FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),*/
            ],
            onChanged: (value) {
              companyFilterController.monthlyRevenue.value = value;
              Logger().i(companyFilterController.monthlyRevenue.value);
              companyFilterController.validateButton();
            },
          ),
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

              //companyFilterController.errMonthStr.isEmpty ?
              companyFilterController.strList[2].isEmpty
                  ? DropdownComponent.commonDropdown(
                      context: context,
                      items: companyFilterController.monthlyRevenueList,
                      value: companyFilterController.minMonthRevModel.value,
                      hint: companyFilterController.monthlyRevenueList.isEmpty ? 'Loading...' : AppStrings.minimumMonthlyRevenue,
                      onChanged: companyFilterController.isLoanEdit.value
                          ? (value) {
                              companyFilterController.minMonthRevModel.value = value;
                              companyFilterController.validateButton();
                            }
                          : null,
                    )
                  : errorTextField(index: 2),
        ),
        12.sizedBoxH,
      ],
    );
  }*/

  ///restricted industries
  Widget restrictedIndustriesBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.restrictedIndustries, context: context),
        4.sizedBoxH,
        Obx(
          () => companyFilterController.strList[3].isEmpty
              ? InkWell(
                  onTap: companyFilterController.isLoanEdit.value
                      ? () {
                          companyFilterController.loadDropdownTempListsForSearch();
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
                                        onChanged: (value) => companyFilterController.onRestrictedIndSearch(value),
                                      ),
                                      Obx(
                                        () => Expanded(
                                          child: ListView.builder(
                                            itemCount: companyFilterController.searchResIndustryList.length,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context, int index) {
                                              return ListTile(
                                                title: Text(companyFilterController.searchResIndustryList[index].industryName ?? ''),
                                                trailing: Obx(
                                                  () => Checkbox(
                                                    activeColor: AppColors.primaryColor,
                                                    value: companyFilterController.searchResIndustryList[index].isResIndustryChecked.value,
                                                    onChanged: (value) {
                                                      companyFilterController.checkBoxResIndustry(index, value ?? false);

                                                      companyFilterController.validateButton();
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
                        }
                      : null,
                  child: companyFilterController.selectedResIndustryChipList.isEmpty
                      ? TextFieldComponents(
                          context: context,
                          enable: false,
                          hint: AppStrings.selectRestrictedIndustries,
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
                                companyFilterController.getAllIndustryList.isEmpty ? 'Loading...' : AppStrings.restrictedIndustries,
                                style: ISOTextStyles.hintTextStyle(),
                              ),
                              8.sizedBoxH,
                              Obx(
                                () => Wrap(
                                  runSpacing: 10,
                                  spacing: 10,
                                  children: [
                                    ...List.generate(
                                      companyFilterController.selectedResIndustryChipList.length,
                                      (index) {
                                        return CommonUtils.customChip(
                                          chipText: companyFilterController.selectedResIndustryChipList[index].industryName ?? '',
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

  ///maximum NFSs/month body
  Widget maximumNsfDropDownBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.maximumOfNSFPerMonth, context: context),
        4.sizedBoxH,
        Obx(
          () => TextFieldComponents(
            enable: companyFilterController.isLoanEdit.value,
            context: context,
            hint: AppStrings.maximumOfNSFPerMonth,
            textEditingController: companyFilterController.nsfTextController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              companyFilterController.validateButton();
            },
            textInputFormatter: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ),

        ///Comment code is dropdown of maximum nsf
        /*Obx(
          () => companyFilterController.strList[4].isEmpty
              ? DropdownComponent.commonDropdown(
                  context: context,
                  items: companyFilterController.nsfList,
                  value: companyFilterController.minimumNSFListModel.value,
                  hint: companyFilterController.nsfList.isEmpty ? 'Loading...' : AppStrings.maximumOfNSFPerMonth,
                  onChanged: companyFilterController.isLoanEdit.value
                      ? (value) {
                          companyFilterController.minimumNSFListModel.value = value;
                          companyFilterController.validateButton();
                        }
                      : null,
                )
              : errorTextField(index: 4),
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
          () => companyFilterController.strList[5].isEmpty
              ? InkWell(
                  onTap: companyFilterController.isLoanEdit.value
                      ? () {
                          companyFilterController.loadDropdownTempListsForSearch();
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
                                        onChanged: (value) => companyFilterController.onResStatesSearch(value),
                                      ),
                                      Obx(
                                        () => Expanded(
                                          child: ListView.builder(
                                            itemCount: companyFilterController.searchGetAllStates.length,
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context, int index) {
                                              return ListTile(
                                                title: Text(companyFilterController.searchGetAllStates[index].stateName ?? ''),
                                                trailing: Obx(
                                                  () => Checkbox(
                                                      activeColor: AppColors.primaryColor,
                                                      value: companyFilterController.searchGetAllStates[index].isStateChecked.value,
                                                      onChanged: (value) {
                                                        companyFilterController.checkBoxTap(index, value ?? false);

                                                        companyFilterController.validateButton();
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
                        }
                      : null,
                  child: companyFilterController.selectedStateChipList.isEmpty
                      ? TextFieldComponents(
                          context: context,
                          enable: false,
                          hint: AppStrings.selectRestrictedStates,
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
                                companyFilterController.getAllStates.isEmpty ? 'Loading...' : AppStrings.restrictedStates,
                                style: ISOTextStyles.hintTextStyle(),
                              ),
                              8.sizedBoxH,
                              Obx(
                                () => Wrap(
                                  runSpacing: 10,
                                  spacing: 10,
                                  children: [
                                    ...List.generate(
                                      companyFilterController.selectedStateChipList.length,
                                      (index) {
                                        return CommonUtils.customChip(
                                          chipText: companyFilterController.selectedStateChipList[index].stateName ?? '',
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

  ///Preferred  industries body
  Widget preferredIndustriesBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.preferredIndustries, context: context),
        4.sizedBoxH,
        Obx(() => companyFilterController.strList[6].isEmpty
            ? InkWell(
                onTap: companyFilterController.isLoanEdit.value
                    ? () {
                        companyFilterController.loadDropdownTempListsForSearch();
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
                                      onChanged: (value) => companyFilterController.onPrefIndSearch(value),
                                    ),
                                    Obx(
                                      () => Expanded(
                                        child: ListView.builder(
                                          itemCount: companyFilterController.searchPrefIndustryList.length,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context, int index) {
                                            return ListTile(
                                              title: Text(companyFilterController.searchPrefIndustryList[index].industryName ?? ''),
                                              trailing: Obx(
                                                () => Checkbox(
                                                  activeColor: AppColors.primaryColor,
                                                  value: companyFilterController.searchPrefIndustryList[index].isPrefIndustryChecked.value,
                                                  onChanged: (value) {
                                                    companyFilterController.checkBoxPrefIndustry(index, value ?? false);

                                                    companyFilterController.validateButton();
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
                      }
                    : null,
                child: companyFilterController.selectedPrefIndustryChipList.isEmpty
                    ? TextFieldComponents(
                        context: context,
                        enable: false,
                        hint: AppStrings.selectPreferredIndustries,
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
                              companyFilterController.getAllIndustryList.isEmpty ? 'Loading...' : AppStrings.selectPreferredIndustries,
                              style: ISOTextStyles.hintTextStyle(),
                            ),
                            8.sizedBoxH,
                            Obx(
                              () => Wrap(
                                runSpacing: 10,
                                spacing: 10,
                                children: [
                                  ...List.generate(
                                    companyFilterController.selectedPrefIndustryChipList.length,
                                    (index) {
                                      return CommonUtils.customChip(
                                        chipText: companyFilterController.selectedPrefIndustryChipList[index].industryName ?? '',
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
            : errorTextField(index: 6)),
        12.sizedBoxH,
      ],
    );
  }

  ///Maximum Funding Amounts body
  Widget maximumFundingDropDownBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.maximumFundingAmounts, context: context),
        4.sizedBoxH,
        Obx(
          () => companyFilterController.strList[7].isEmpty
              ? DropdownComponent.commonDropdown(
                  context: context,
                  items: companyFilterController.maxFundAmountList,
                  value: companyFilterController.maxFundingAmountListModel.value,
                  hint: companyFilterController.maxFundAmountList.isEmpty ? 'Loading...' : AppStrings.maximumFundingAmounts,
                  onChanged: companyFilterController.isLoanEdit.value
                      ? (value) {
                          companyFilterController.maxFundingAmountListModel.value = value;
                          companyFilterController.validateButton();
                        }
                      : null,
                )
              : errorTextField(index: 7),
        ),
        12.sizedBoxH,
      ],
    );
  }

  Widget maximumFundingDropDownBody2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.maximumFundingAmounts, context: context),
        4.sizedBoxH,
        Obx(
          () => TextFieldComponents(
            enable: companyFilterController.isLoanEdit.value,
            textEditingController: companyFilterController.fundAmountController,
            context: context,
            hint: AppStrings.loanAmount,
            keyboardType: TextInputType.number,
            textInputFormatter: [
              // FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
              FilteringTextInputFormatter.digitsOnly,
              CurrencyPtBrInputFormatter(maxDigits: 12),
            ],
            onChanged: (value) {
              companyFilterController.loanAmount.value = value;
              Logger().i(companyFilterController.loanAmount.value);
              companyFilterController.validateButton();
            },
          ),
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
          () => companyFilterController.strList[8].isEmpty
              ? DropdownComponent.commonDropdown(
                  context: context,
                  items: companyFilterController.maxTermLengthList,
                  value: companyFilterController.maxTermLengthListModel.value,
                  hint: companyFilterController.maxTermLengthList.isEmpty ? 'Loading...' : AppStrings.maximumTermLength,
                  onChanged: companyFilterController.isLoanEdit.value
                      ? (value) {
                          companyFilterController.maxTermLengthListModel.value = value;
                          companyFilterController.validateButton();
                        }
                      : null,
                )
              : errorTextField(index: 8),
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
        Obx(
          () => TextFieldComponents(
            enable: companyFilterController.isLoanEdit.value,
            context: context,
            hint: AppStrings.startingBuyRates,
            textEditingController: companyFilterController.buyRateTextController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              companyFilterController.validateButton();
            },
            textInputFormatter: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
          ),
        ),

        ///Comment code is starting buy rates dropdown
        /*Obx(
          () => companyFilterController.strList[9].isEmpty
              ? DropdownComponent.commonDropdown(
                  context: context,
                  items: companyFilterController.buyingRateList,
                  value: companyFilterController.startingBuyRatesListModel.value,
                  hint: companyFilterController.buyingRateList.isEmpty ? 'Loading...' : AppStrings.startingBuyRates,
                  onChanged: companyFilterController.isLoanEdit.value
                      ? (value) {
                          companyFilterController.startingBuyRatesListModel.value = value;
                          companyFilterController.validateButton();
                        }
                      : null,
                )
              : errorTextField(index: 9),
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
        Obx(
          () => TextFieldComponents(
            enable: companyFilterController.isLoanEdit.value,
            context: context,
            hint: AppStrings.maxUpsellPoints,
            textEditingController: companyFilterController.maxUpSellTextController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              companyFilterController.validateButton();
            },
            textInputFormatter: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ),

        ///Comment code is max upsell points dropdown
        /*Obx(
          () => companyFilterController.strList[10].isEmpty
              ? DropdownComponent.commonDropdown(
                  context: context,
                  items: companyFilterController.maxUpSellList,
                  value: companyFilterController.maxUpSellPointsListModel.value,
                  hint: companyFilterController.maxUpSellList.isEmpty ? 'Loading...' : AppStrings.maxUpsellPoints,
                  onChanged: companyFilterController.isLoanEdit.value
                      ? (value) {
                          companyFilterController.maxUpSellPointsListModel.value = value;
                          companyFilterController.validateButton();
                        }
                      : null,
                )
              : errorTextField(index: 10),
        ),*/
        12.sizedBoxH,
      ],
    );
  }

  ///Create Company Profile button body
  Widget loanUpdateButtonBody() {
    return Obx(
      () => Visibility(
        visible: companyFilterController.isLoanEdit.value,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
          child: ButtonComponents.cupertinoButton(
            width: double.infinity,
            context: context,
            title: AppStrings.updateButton,
            backgroundColor: companyFilterController.isEnabled.value ? AppColors.primaryColor : AppColors.disableButtonColor,
            textStyle: companyFilterController.isEnabled.value
                ? ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.blackColor)
                : ISOTextStyles.openSenseRegular(size: 17, color: AppColors.disableTextColor),
            onTap: () {
              onButtonPressed();
            },
          ),
        ),
      ),
    );
  }

  ///***** on final button pressed
  onButtonPressed() async {
    bool? shouldCallAPI;
    var validationResult = companyFilterController.isValidLoanPref();
    if (!validationResult.item1) {
      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: validationResult.item2);
    } else if (companyFilterController.prefIndustryList.where((p0) => companyFilterController.resIndustryList.contains(p0)).isNotEmpty) {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: AppStrings.validateResPrefIndustries);
    } else {
      ShowLoaderDialog.showLoaderDialog(context);
      var updateLoanApi = await companyFilterController.updateCompanyLOANApiCall(onErr: (msg) {
        SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
      }, onSuccess: (msg) {
        SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
      });
      if (updateLoanApi) {
        companySettingController.companyProfileApiCall();
      }
      Logger().i('Api Call');
    }
  }

  Widget errorTextField({required int index}) {
    return TextFieldComponents(
      context: context,
      hint: companyFilterController.strList[index],
      enable: false,
      hintColor: AppColors.redColor,
    );
  }

  getAllLoanData() async {
    await companyFilterController.fetchCreditRequirementList();
    await companyFilterController.fetchMinimumTimeList();
    /*await companyFilterController.fetchMonthlyRevenueList();*/
    await companyFilterController.fetchIndustryList();
    await companyFilterController.fetchMinimumNSFList();
    await companyFilterController.fetchStatesList();
    /*await companyFilterController.fetchMaxFundingList();*/
    await companyFilterController.fetchMaxTermList();
    await companyFilterController.fetchStartingBuyRatesList();
    await companyFilterController.fetchMaxUpsellList();
    await companyFilterController.loadDropdownTempListsForSearch();
    companyFilterController.creditTextController.text = companySettingController.companyProfileDetail.value!.creditScore.toString();
    companyFilterController.nsfTextController.text = companySettingController.companyProfileDetail.value!.nsfId.toString();
    companyFilterController.buyRateTextController.text = companySettingController.companyProfileDetail.value!.buyingRates.toString();
    companyFilterController.maxUpSellTextController.text = companySettingController.companyProfileDetail.value!.maxUpsellPoints.toString();
    companyFilterController.fundAmountController.text = '\$ ${NumberFormat("#,##0.00", "en_US").format(double.parse(companySettingController.companyProfileDetail.value?.maxFundAmount ?? ''))}';
    companyFilterController.monthlyRevenueController.text = '\$ ${NumberFormat("#,##0.00", "en_US").format(double.parse(companySettingController.companyProfileDetail.value?.minMonthlyRev ?? ''))}';
    companyFilterController.getModelDropDownData(companySettingController.companyProfileDetail.value!);
  }
}
