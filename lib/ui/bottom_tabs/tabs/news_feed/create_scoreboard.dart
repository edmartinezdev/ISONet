// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';
import 'package:iso_net/utils/swipe_back.dart';

import '../../../../controllers/bottom_tabs/tabs/news_feed/create_scoreboard_controller.dart';
import '../../../../singelton_class/auth_singelton.dart';
import '../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../utils/app_common_stuffs/commom_utils.dart';
import '../../../../utils/app_common_stuffs/dropdown_component.dart';
import '../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../style/appbar_components.dart';
import '../../../style/button_components.dart';
import '../../../style/image_components.dart';
import '../../../style/showloader_component.dart';
import '../../../style/text_style.dart';
import '../../../style/textfield_components.dart';

class CreateScoreBoardScreen extends StatefulWidget {
  const CreateScoreBoardScreen({Key? key}) : super(key: key);

  @override
  State<CreateScoreBoardScreen> createState() => _CreateScoreBoardScreenState();
}

class _CreateScoreBoardScreenState extends State<CreateScoreBoardScreen> with AutomaticKeepAliveClientMixin<CreateScoreBoardScreen> {
  CreateScoreBoardController createScoreBoardController = Get.find<CreateScoreBoardController>();
  TextEditingController searchTextController = TextEditingController();
  TextEditingController funderBrokerController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool showvalue = false;
  Timer? _debounce;

  @override
  void initState() {
    createScoreBoardController.getAllIndustryList.clear();
    createScoreBoardController.loadDropdownTempListsForSearch();
    createScoreBoardController.loanTagList();
    createScoreBoardController.fetchIndustryList();
    createScoreBoardController.brokerFunderListApiCall();
    super.initState();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: false);
        return true;
      },
      child: SwipeBackWidget(
        result: false,
        child: Scaffold(
          appBar: appBarBody(),
          body: buildBody(),
        ),
      ),
    );
  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      leadingWidget: IconButton(
        onPressed: () {
          Get.back(result: false);
        },
        icon: ImageComponent.loadLocalImage(imageName: AppImages.arrow),
      ),
    );
  }

  Widget buildBody() {
    return SafeArea(
      child: CommonUtils.constrainedBody(children: [
        loanData(),
        submitLoanDetailsButton(),
      ]),
    );
  }

  Widget loanData() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.loanDetails,
            style: ISOTextStyles.openSenseBold(
              size: 20,
            ),
          ),
          14.sizedBoxH,
          loanAmount(),
          14.sizedBoxH,
          IndustryDropDownBody(),
          14.sizedBoxH,
          funderBrokerName(),
          14.sizedBoxH,
          tagPopup(),
        ],
      ),
    );
  }

  Widget loanAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.loanAmount,
          style: ISOTextStyles.openSenseSemiBold(
            size: 13,
          ),
        ),
        3.sizedBoxH,
        TextFieldComponents(
          context: context,
          hint: AppStrings.loanAmount,
          keyboardType: TextInputType.number,
          textInputFormatter: [
            // FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
            FilteringTextInputFormatter.digitsOnly,
            CurrencyPtBrInputFormatter(maxDigits: 12),
          ],
          onChanged: (value) {
            createScoreBoardController.loanAmount.value = value;
            Logger().i(createScoreBoardController.loanAmount.value);
            createScoreBoardController.validateButton();
          },
        ),
      ],
    );
  }

  Widget IndustryDropDownBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.loanIndustry, context: context),
        4.sizedBoxH,
        Obx(() => DropdownComponent.commonDropdown(
              context: context,
              items: createScoreBoardController.getAllIndustryList,
              value: createScoreBoardController.getIndustryModel.value,
              hint: createScoreBoardController.getAllIndustryList.isEmpty ? 'Loading...' : AppStrings.loanIndustry,
              onChanged: (value) {
                createScoreBoardController.getIndustryModel.value = value;
                createScoreBoardController.loanIndustryId.value = createScoreBoardController.getIndustryModel.value?.id ?? 0;
                createScoreBoardController.validateButton();
                Logger().i(createScoreBoardController.loanIndustryId.value);
                //createScoreBoardController.validateFindFunderButton();
              },
            )),
      ],
    );
  }

  ///handle categories button press
  handleFunderOrBrokerName() {
    createScoreBoardController.pageToShow.value = 1;
    createScoreBoardController.isAllDataLoaded.value = false;
    createScoreBoardController.totalRecord.value = 0;
    createScoreBoardController.brokerFunderListApiCall();

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0.r),
            topRight: Radius.circular(12.0.r),
          ),
          color: AppColors.whiteColor,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userSingleton.userType == AppStrings.fu ? AppStrings.selectBrokerName : AppStrings.selectFunderName,
              style: ISOTextStyles.openSenseBold(
                size: 22,
              ),
            ),
            14.sizedBoxH,
            CupertinoSearchTextField(
              controller: searchTextController,
              focusNode: focusNode,
              placeholder: userSingleton.userType == AppStrings.fu ? AppStrings.searchBrokerCompany : AppStrings.searchFunderCompany,
              onChanged: (value) {
                _onSearchChanged(value);
              },
            ),
            8.sizedBoxH,
            // CupertinoSearchTextField(
            //   onChanged: (value) => createScoreBoardController.onSearch(value),
            // ),
            Obx(
              () => createScoreBoardController.isSearching.value
                  ? const Expanded(
                    child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        ),
                      ),
                  )
                  : createScoreBoardController.isDataLoaded.value == false
                      ? Expanded(
                        child: Center(
                          child: Text(
                            userSingleton.userType == AppStrings.fu ? AppStrings.noBrokerCompany : AppStrings.noFunderCompany,
                            style: ISOTextStyles.openSenseBold(size: 16),
                          ),
                        ),
                      )
                      : Expanded(
                          child: ListView.separated(
                            controller: createScoreBoardController.scrollController,
                            shrinkWrap: true,
                            addAutomaticKeepAlives: true,
                            itemCount:
                                createScoreBoardController.isAllDataLoaded.value ? createScoreBoardController.searchListController.length + 1 : createScoreBoardController.searchListController.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == createScoreBoardController.searchListController.length) {
                                Future.delayed(
                                  const Duration(milliseconds: 100),
                                  () async {
                                    await _handleLoadMoreList();
                                  },
                                );
                                return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
                              }
                              return Obx(
                                () => InkWell(
                                  onTap: () {
                                    createScoreBoardController.isCompanyLoan.value = createScoreBoardController.searchListController[index].globalSearchData?.isCompany ?? false;
                                    funderBrokerController.text = createScoreBoardController.searchListController[index].globalSearchData?.isCompany == true
                                        ? createScoreBoardController.searchListController[index].globalSearchData?.companyName ?? ''
                                        : '${createScoreBoardController.searchListController[index].globalSearchData?.firstName ?? ''} ${createScoreBoardController.searchListController[index].globalSearchData?.lastName ?? ''}';
                                    createScoreBoardController.selectedFunderBrokerName.value = createScoreBoardController.searchListController[index].globalSearchData?.isCompany == true
                                        ? createScoreBoardController.searchListController[index].globalSearchData?.companyName ?? ''
                                        : '${createScoreBoardController.searchListController[index].globalSearchData?.firstName ?? ''} ${createScoreBoardController.searchListController[index].globalSearchData?.lastName ?? ''}';
                                    createScoreBoardController.selectedFunderBrokerImage.value = createScoreBoardController.searchListController[index].globalSearchData?.isCompany == true
                                        ? createScoreBoardController.searchListController[index].globalSearchData?.companyImage ?? ''
                                        : createScoreBoardController.searchListController[index].globalSearchData?.profileImg ?? '';
                                    createScoreBoardController.funderBrokerId.value = createScoreBoardController.searchListController[index].globalSearchData?.isCompany == true
                                        ? createScoreBoardController.searchListController[index].globalSearchData?.companyId ?? -1
                                        : createScoreBoardController.searchListController[index].globalSearchData?.userId ?? -1;
                                    Logger().i(createScoreBoardController.funderBrokerId.value);
                                    createScoreBoardController.validateButton();
                                    //createScoreBoardController.validateButton();
                                    Get.back();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(right: 16.0.w, top: 8.0.h, left: 16.0.w, bottom: 8.0.h),
                                    child: createScoreBoardController.searchListController[index].globalSearchData?.isCompany == true
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              ImageComponent.circleNetworkImage(
                                                  imageUrl: createScoreBoardController.searchListController[index].globalSearchData?.companyImage ?? '',
                                                  height: 36.w,
                                                  width: 36.w,
                                                  placeHolderImage: AppImages.backGroundDefaultImage),
                                              11.sizedBoxW,
                                              Expanded(
                                                child: Text(
                                                  createScoreBoardController.searchListController[index].globalSearchData?.companyName ?? '',
                                                  style: ISOTextStyles.openSenseSemiBold(size: 14),
                                                ),
                                              ),
                                              Image.asset(
                                                AppImages.companyRoundIcon,
                                                height: 26.w,
                                                width: 26.w,
                                                fit: BoxFit.contain,
                                              ),
                                              const Divider(
                                                thickness: 1.0,
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              ImageComponent.circleNetworkImage(
                                                  imageUrl: createScoreBoardController.searchListController[index].globalSearchData?.profileImg ?? '', height: 36.w, width: 36.w),
                                              11.sizedBoxW,
                                              Text(
                                                '${createScoreBoardController.searchListController[index].globalSearchData?.firstName ?? ''} ${createScoreBoardController.searchListController[index].globalSearchData?.lastName ?? ''}',
                                                style: ISOTextStyles.openSenseSemiBold(size: 14),
                                              ),
                                              const Divider(
                                                thickness: 1.0,
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return const Divider();
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  ///Handle on search function
  _onSearchChanged(String query) {
    createScoreBoardController.isFilterEnable.value = true;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      createScoreBoardController.searchText.value = query;
      createScoreBoardController.pageToShow.value = 1;
      createScoreBoardController.isAllDataLoaded.value = false;
      createScoreBoardController.isSearching.value = true;
      createScoreBoardController.totalRecords.value = 0;
      createScoreBoardController.searchListController.clear();
      await createScoreBoardController.brokerFunderListApiCall();
    });
  }

  Widget funderBrokerName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userSingleton.userType == 'FU' ? AppStrings.brokerName : AppStrings.funderName,
          style: ISOTextStyles.openSenseSemiBold(
            size: 13,
          ),
        ),
        3.sizedBoxH,
        GestureDetector(
          onTap: () {
            handleFunderOrBrokerName();
          },
          child: Container(
              width: double.infinity,

              // margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.only(top: 16, bottom: 16, left: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.greyColor),
                borderRadius: const BorderRadius.all(Radius.circular(8.0) //                 <--- border radius here
                    ),
              ),
              child: Obx(
                () => Row(
                  children: [
                    createScoreBoardController.selectedFunderBrokerName.isEmpty
                        ? Container()
                        : ImageComponent.circleNetworkImage(
                            imageUrl: createScoreBoardController.selectedFunderBrokerImage.value, height: 20.w, width: 20.w, placeHolderImage: AppImages.backGroundDefaultImage),
                    Obx(() => createScoreBoardController.selectedFunderBrokerName.isEmpty ? 0.sizedBoxW : 8.sizedBoxW),
                    Text(
                      createScoreBoardController.selectedFunderBrokerName.isEmpty
                          ? userSingleton.userType == 'FU'
                              ? 'Broker Name'
                              : 'Funder Name'
                          : createScoreBoardController.selectedFunderBrokerName.value,
                      style: createScoreBoardController.selectedFunderBrokerName.isEmpty ? ISOTextStyles.hintTextStyle() : ISOTextStyles.textFieldTextStyle(),
                    ),
                  ],
                ),
              )),
        )
      ],
    );
  }

  /*Widget funderBrokerName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          userSingleton.userType == 'FU' ? AppStrings.brokerName : AppStrings.funderName,
          style: ISOTextStyles.openSenseSemiBold(
            size: 13,
          ),
        ),
        3.sizedBoxH,
        GestureDetector(
          onTap: () {
            handleFunderorBrokerName();
          },
          child: Obx(
            () => TextFieldComponents(
              context: context,
              hint: userSingleton.userType == 'FU' ? AppStrings.brokerName : AppStrings.funderName,
              enable: false,
              textEditingController: funderBrokerController,
              prefixIcon: createScoreBoardController.selectedFunderBrokerImage.value.isEmpty
                  ? null
                  : ImageComponent.circleNetworkImage(imageUrl:createScoreBoardController.selectedFunderBrokerImage.value,height: 24.w,width: 24.w,),
            ),
          ),
        )
      ],
    );
  }*/

  Widget tagPopup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.tags, context: context),
        4.sizedBoxH,
        Obx(() => createScoreBoardController.strList[1].isEmpty
            ? InkWell(
                onTap: () {
                  createScoreBoardController.loadDropdownTempListsForSearch();
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
                                onChanged: (value) => createScoreBoardController.onPrefIndSearch(value),
                              ),
                              Obx(
                                () => Expanded(
                                  child: ListView.builder(
                                    itemCount: createScoreBoardController.searchLoanList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, int index) {
                                      return ListTile(
                                        contentPadding: EdgeInsets.only(
                                          left: 8.0.w,
                                        ),
                                        title: Text(
                                          createScoreBoardController.searchLoanList[index].tagName ?? '',
                                          style: ISOTextStyles.openSenseSemiBold(size: 13, color: AppColors.chatHeadingName),
                                        ),
                                        trailing: Obx(
                                          () => Checkbox(
                                            activeColor: AppColors.primaryColor,
                                            value: createScoreBoardController.searchLoanList[index].isPrefIndustryChecked.value,
                                            onChanged: (value) {
                                              createScoreBoardController.checkBoxPrefLoan(index, value ?? false);

                                              //createScoreBoardController.validateButton();
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const Divider(
                                color: AppColors.dividerColor,
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
                child: createScoreBoardController.selectedPrefLoanChipList.isEmpty
                    ? TextFieldComponents(
                        context: context,
                        enable: false,
                        hint: AppStrings.addTags,
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
                                createScoreBoardController.getAllLoanList.isEmpty ? 'Loading...' : AppStrings.selectTags,
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
                                    createScoreBoardController.selectedPrefLoanChipList.length,
                                    (index) {
                                      return CommonUtils.customChip(
                                        chipText: createScoreBoardController.selectedPrefLoanChipList[index].tagName ?? '',
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

  ///Create Scoreboard Profile button body
  Widget submitLoanDetailsButton() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
        child: ButtonComponents.cupertinoButton(
          width: double.infinity,
          context: context,
          title: AppStrings.bSubmit,
          textColor: createScoreBoardController.isEnableButton.value ? AppColors.blackColor : AppColors.disableTextColor,
          backgroundColor: createScoreBoardController.isEnableButton.value ? AppColors.primaryColor : AppColors.greyColor,
          onTap: () {
            onButtonPressed();
          },
        ),
      ),
    );
  }

  onButtonPressed() async {
    var validationResult = createScoreBoardController.isValidLoanPref();
    if (!validationResult.item1) {
      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: validationResult.item2);
    } else {
      createScoreBoardController.submitLoanDetailsAPICall();
      ShowLoaderDialog.showLoaderDialog(context);
    }
  }

  Widget errorTextField({required int index}) {
    return TextFieldComponents(
      context: context,
      hint: 'heint text',
      enable: false,
      hintColor: AppColors.redColor,
    );
  }

  ///Load more news feed list when record cross the limit value
  Future _handleLoadMoreList() async {
    if (!createScoreBoardController.isAllDataLoaded.value) return;
    if (createScoreBoardController.isLoadMoreRunningForViewAll) return;
    createScoreBoardController.isLoadMoreRunningForViewAll = true;
    await createScoreBoardController.brokerFunderListApiCall();
  }
}
