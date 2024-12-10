import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/create_scoreboard_controller.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../controllers/bottom_tabs/tabs/news_feed/scoreboard_controller.dart';
import '../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../utils/app_common_stuffs/commom_utils.dart';
import '../../../../utils/app_common_stuffs/screen_routes.dart';
import '../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../style/appbar_components.dart';
import '../../../style/button_components.dart';
import '../../../style/image_components.dart';
import '../../../style/showloader_component.dart';
import '../../../style/text_style.dart';
import '../../../style/textfield_components.dart';

class CreateFilterScoreboard extends StatefulWidget {
  const CreateFilterScoreboard({Key? key}) : super(key: key);

  @override
  State<CreateFilterScoreboard> createState() => _CreateFilterScoreboardState();
}

class _CreateFilterScoreboardState extends State<CreateFilterScoreboard> {
  CreateScoreBoardController scoreBoardController = Get.find<CreateScoreBoardController>();
  ScoreBoardController scoreController = Get.find();

  @override
  void initState() {
    scoreBoardController.loadDropdownTempListsForSearch();
    scoreBoardController.loanTagList();
    scoreBoardController.fetchIndustryList();
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
    return AppBarComponents.appBar(
      leadingWidget: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: ImageComponent.loadLocalImage(imageName: AppImages.arrow),
      ),
      centerTitle: true,
      titleWidget: Text(
        AppStrings.filterBy,
        style: ISOTextStyles.openSenseSemiBold(
          size: 17,
        ),
      ),
    );
  }

  Widget buildBody() {
    return SafeArea(
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20),
          child: CommonUtils.constrainedBody(children: [
            Column(
              children: [industriesBody(), 14.sizedBoxH, tagPopup()],
            ),
            submitLoanDetailsButton()
          ])),
    );
  }

  Widget tagPopup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.tags, context: context),
        4.sizedBoxH,
        Obx(() => scoreBoardController.strList[1].isEmpty
            ? GestureDetector(
                onTap: () {
                  scoreBoardController.loadDropdownTempListsForSearch();
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
                                  AppStrings.loanSearch,
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0.sp),
                                ),
                              ),
                              CupertinoSearchTextField(
                                onChanged: (value) => scoreBoardController.onPrefIndSearch(value),
                              ),
                              Obx(
                                () => Expanded(
                                  child: ListView.builder(
                                    itemCount: scoreBoardController.searchLoanList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, int index) {
                                      return ListTile(
                                        contentPadding: EdgeInsets.only(left: 8.0.w,),
                                        title: Text(scoreBoardController.searchLoanList[index].tagName ?? ''),
                                        trailing: Obx(
                                          () => Checkbox(
                                            activeColor: AppColors.primaryColor,
                                            value: scoreBoardController.searchLoanList[index].isPrefIndustryChecked.value,
                                            onChanged: (value) {
                                              scoreBoardController.checkBoxPrefLoan(index, value ?? false);

                                              //scoreBoardController.validateFilterButton();
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
                child: scoreBoardController.selectedPrefLoanChipList.isEmpty
                    ? TextFieldComponents(
                        context: context,
                        enable: false,
                        hint: AppStrings.selectTags,
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
                                scoreBoardController.getAllLoanList.isEmpty ? 'Loading...' : AppStrings.selectTags,
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
                                    scoreBoardController.selectedPrefLoanChipList.length,
                                    (index) {
                                      return CommonUtils.customChip(
                                        chipText: scoreBoardController.selectedPrefLoanChipList[index].tagName ?? '',
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

  ///industries
  Widget industriesBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.industry, context: context),
        4.sizedBoxH,
        Obx(
          () => scoreBoardController.strList[1].isEmpty
              ? GestureDetector(
                  onTap: () {
                    scoreBoardController.loadDropdownTempListsForSearch();
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
                                  onChanged: (value) => scoreBoardController.onRestrictedIndSearch(value),
                                ),
                                Obx(
                                  () => Expanded(
                                    child: ListView.builder(
                                      itemCount: scoreBoardController.searchResIndustryList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (BuildContext context, int index) {
                                        return ListTile(
                                          contentPadding: EdgeInsets.only(left: 8.0.w,),
                                          title: Text(scoreBoardController.searchResIndustryList[index].industryName ?? ''),
                                          trailing: Obx(
                                            () => Checkbox(
                                              activeColor: AppColors.primaryColor,
                                              value: scoreBoardController.searchResIndustryList[index].isResIndustryChecked.value,
                                              onChanged: (value) {
                                                scoreBoardController.checkBoxResIndustry(index, value ?? false);

                                                //scoreBoardController.validateFilterButton();
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
                  child: scoreBoardController.selectedResIndustryChipList.isEmpty
                      ? TextFieldComponents(
                          context: context,
                          enable: false,
                          hint: AppStrings.selectedIndustry,
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
                                  scoreBoardController.getAllIndustryList.isEmpty ? 'Loading...' : AppStrings.selectedIndustry,
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
                                      scoreBoardController.selectedResIndustryChipList.length,
                                      (index) {
                                        return CommonUtils.customChip(
                                          chipText: scoreBoardController.selectedResIndustryChipList[index].industryName ?? '',
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

  Widget errorTextField({required int index}) {
    return TextFieldComponents(
      context: context,
      hint: 'hint text',
      enable: false,
      hintColor: AppColors.redColor,
    );
  }

  Widget submitLoanDetailsButton() {
    return Obx(() => ButtonComponents.cupertinoButton(
          width: double.infinity,
          context: context,
          title: AppStrings.save,
          backgroundColor: scoreBoardController.isFilterEnable.value ? AppColors.primaryColor : AppColors.disableButtonColor,
          textStyle: scoreBoardController.isFilterEnable.value
              ? ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.blackColor)
              : ISOTextStyles.openSenseRegular(size: 17, color: AppColors.disableTextColor),
          onTap: () {
            onButtonPressed();
          },
        ));
  }

  onButtonPressed() async {
    var validationResult = scoreBoardController.isValidLoanFilter();
    if (!validationResult.item1) {
      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: validationResult.item2);
    } else {
      ShowLoaderDialog.showLoaderDialog(context);
      scoreController.loanList.clear();
      scoreController.pageToShow.value = 1;
      scoreController.totalRecords.value = 0;
      scoreController.isAllDataLoaded.value = false;
      var createFilterApiResult = await scoreController.fetchLoanList(
          page: 1, userType: scoreController.forumFilter.value, selectedIndustryList: scoreBoardController.resIndustryList, selectedLoanList: scoreBoardController.prefLoanList);
      if (createFilterApiResult) {
        //DetailInfoController detailInfoController = Get.find<DetailInfoController>();

        Get.until((route) => route.settings.name == ScreenRoutesConstants.scoreBoardScreen);
      }
    }
  }
}
