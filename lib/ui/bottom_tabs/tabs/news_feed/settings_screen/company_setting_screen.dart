import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_places_picker/google_places_picker.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/common_api_function.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../../bindings/bottom_tabs/company_binding/employee_profile_binding.dart';
import '../../../../../controllers/bottom_tabs/tabs/news_feed/setting_controller/company_setting_controller.dart';
import '../../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../../utils/app_common_stuffs/commom_utils.dart';
import '../../../../../utils/app_common_stuffs/screen_routes.dart';
import '../../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../../../utils/app_common_stuffs/text_input_formatters.dart';
import '../../../../style/button_components.dart';
import '../../../../style/image_components.dart';
import '../../../../style/text_style.dart';
import '../../../../style/textfield_components.dart';
import '../company_screens/employee_profile_screen.dart';

class CompanySettingScreen extends StatefulWidget {
  const CompanySettingScreen({Key? key}) : super(key: key);

  @override
  State<CompanySettingScreen> createState() => _CompanySettingScreenState();
}

class _CompanySettingScreenState extends State<CompanySettingScreen> {
  CompanySettingController companySettingController = Get.find<CompanySettingController>();

  @override
  void initState() {
    super.initState();
    getCompanyData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  converUsFormatter({required String newText}) {
    // The below code gives a range error if not 10.
    RegExp phone = RegExp(r'(\d{3})(\d{3})(\d{4})');
    var matches = phone.allMatches(newText);
    var match = matches.elementAt(0);
    newText = '(${match.group(1)}) ${match.group(2)}-${match.group(3)}';
    return newText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBody(),
      //body: buildBody(),
      body: buildBody2(),
    );
  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          companySettingController.isProfileEdit.value = false;
          Get.back();
        },
        //onPressed: () => Get.back(),
        child: ImageComponent.loadLocalImage(
          imageName: AppImages.arrow,
        ),
      ),
      title: Obx(
        () => Text(
          companySettingController.isProfileEdit.value ? AppStrings.editCompanyText : AppStrings.companyText,
          style: ISOTextStyles.openSenseSemiBold(size: 17),
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(preferredSize: const Size(double.infinity, 40), child: tabBody()),
      actions: [
        GestureDetector(
          onTap: () {
            companySettingController.isProfileEdit.value = !companySettingController.isProfileEdit.value;
            companySettingController.validateButton();
            if (companySettingController.currentTabIndex.value != 0) {
              companySettingController.currentTabIndex.value = 0;
            }
            // companySettingController.isProfileEdit.value == true ? companySettingController.updateCompanyProfileApiCall() : handleEditAction();
          },
          child: ImageComponent.loadLocalImage(imageName: AppImages.editFillCircle, height: 28.w, width: 28.w, boxFit: BoxFit.contain),
        ),
        Visibility(visible: userSingleton.userType == 'FU', child: 15.sizedBoxW),
        Visibility(
          visible: userSingleton.userType == 'FU',
          child: GestureDetector(
            onTap: () {
              Get.toNamed(ScreenRoutesConstants.settingFilterScreen);
            },
            child: ImageComponent.loadLocalImage(imageName: AppImages.filterFill, height: 28.w, width: 28.w, boxFit: BoxFit.contain),
          ),
        ),
        15.sizedBoxW,
      ],
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      controller: companySettingController.scrollController,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 17.w, vertical: 8.0.h),
            child: Obx(
              () => _onTabTapWidgetDisplay(),
            ),
          ),
        ],
      ),
    );
    // companySettingController.isProfileEdit.value ? saveCompanyDetailsButton() : Container(),
  }

  ///Prac
  Widget buildBody2() {
    return CustomScrollView(
      slivers: [
        Obx(() => _onTabTapWidgetDisplay())
        /*SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 8.0.h),
          sliver: SliverSafeArea(
            bottom: true,
            top: false,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: 1,
                (BuildContext context, int index) {
                  return Obx(
                    () => _onTabTapWidgetDisplay(),
                  );
                },
              ),
            ),
          ),
        ),*/
      ],
    );
  }

  /// Filter Tab
  Widget tabBody() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(vertical: 8.0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Wrap(
              spacing: 20,
              children: [
                ...List.generate(companySettingController.myCompanyTab.length, (index) {
                  return GestureDetector(
                    onTap: () async {
                      companySettingController.currentTabIndex.value = index;
                      if (companySettingController.currentTabIndex.value == 1) {
                        companySettingController.isApiResponseReceive.value = false;
                        ShowLoaderDialog.showLoaderDialog(context);

                        _handleOnReviewTap();
                      } else if (companySettingController.currentTabIndex.value == 2) {
                        companySettingController.isApiResponseReceive.value = false;
                        ShowLoaderDialog.showLoaderDialog(context);
                        _handleOnEmployeeTap();
                      }
                    },
                    child: AnimatedContainer(
                      alignment: Alignment.center,
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 16.0.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0.r),
                        color: companySettingController.currentTabIndex.value == index ? AppColors.primaryColor : AppColors.greyColor,
                      ),
                      child: Text(
                        companySettingController.myCompanyTab[index].tabName ?? '',
                        style: companySettingController.currentTabIndex.value == index
                            ? ISOTextStyles.openSenseSemiBold(size: 16, color: AppColors.headingTitleColor)
                            : ISOTextStyles.openSenseRegular(size: 16, color: AppColors.headingTitleColor),
                      ),
                    ),
                  );
                }),
              ],
            )
          ],
        ),
      ),
    );
  }

  ///Handle Review Tap Event
  _handleOnReviewTap() {
    companySettingController.companyReviewList.clear();
    companySettingController.totalRecord.value = 0;
    companySettingController.pageLimit.value = 1;
    companySettingController.isAllDataLoaded.value = false;
    companySettingController.isReviewTabEnable.value = true;
    companySettingController.companyReviewListApi(isShowLoader: true);
    /*  companySettingController.pagination(companyId: userSingleton.companyId ?? 0);*/
  }

  ///Handle Employee Tap Event
  _handleOnEmployeeTap() {
    companySettingController.companyEmployeeList.clear();
    companySettingController.totalRecord.value = 0;
    companySettingController.pageLimit.value = 1;
    companySettingController.isAllDataLoaded.value = false;
    companySettingController.isReviewTabEnable.value = false;
    companySettingController.companyEmployeeListApi(isShowLoader: true);
  }

  /// Handle Pagination
  Future _handleLoadMoreList() async {
    if (!companySettingController.isAllDataLoaded.value) return;
    if (companySettingController.isLoadMoreRunningForViewAll) return;
    companySettingController.isLoadMoreRunningForViewAll = true;
    await companySettingController.companyReviewEmployeePagination();
  }

  /// Mange Tabs
  Widget _onTabTapWidgetDisplay() {
    if (companySettingController.currentTabIndex.value == 0) {
      /*return myDetailSection();*/
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 8.0.h),
        sliver: SliverList(
            delegate: SliverChildBuilderDelegate(childCount: 1, (BuildContext context, int index) {
          return myDetailSection();
        })),
      );
    } else if (companySettingController.currentTabIndex.value == 1) {
      /*return myReviewSection();*/
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 8.0.h),
        sliver: Obx(
          () => (companySettingController.companyReviewList.isEmpty && companySettingController.isApiResponseReceive.value)
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      AppStrings.noReviews,
                      style: ISOTextStyles.openSenseSemiBold(size: 16),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: companySettingController.isAllDataLoaded.value ? companySettingController.companyReviewList.length + 1 : companySettingController.companyReviewList.length,
                    (BuildContext context, int index) {
                      if (index == companySettingController.companyReviewList.length) {
                        Future.delayed(
                          const Duration(milliseconds: 100),
                          () async {
                            await _handleLoadMoreList();
                          },
                        );
                        return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
                      }
                      return myReviewSection(index: index);
                    },
                  ),
                ),
        ),
      );
      /*return companyReviewSection();*/
    } else if (companySettingController.currentTabIndex.value == 2) {
      /*return myEmployeesSection();*/
      return SliverPadding(
        padding: EdgeInsets.zero,
        sliver: Obx(
          () => (companySettingController.companyEmployeeList.isEmpty && companySettingController.isApiResponseReceive.value)
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      AppStrings.noRecord,
                      style: ISOTextStyles.openSenseSemiBold(size: 16),
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: companySettingController.isAllDataLoaded.value ? companySettingController.companyEmployeeList.length + 1 : companySettingController.companyEmployeeList.length,
                    (BuildContext context, int index) {
                      if (index == companySettingController.companyEmployeeList.length) {
                        Future.delayed(
                          const Duration(milliseconds: 100),
                          () async {
                            await _handleLoadMoreList();
                          },
                        );
                        return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
                      }
                      return myEmployeesSection(index: index);
                    },
                  ),
                ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget myDetailSection() {
    return Obx(
      ()=> Column(
        children: [
          companyNameTextFieldBody(),
          companyAddressTextFieldBody(),
          Row(
            children: [
              cityTextFieldBody(),
              8.sizedBoxW,
              stateTextFieldBody(),
            ],
          ),
          Row(
            children: [
              zipCodeTextFieldBody(),
              8.sizedBoxW,
              blankContainerBody(),
            ],
          ),
          phoneNumberTextFieldBody(),
          websiteTextFieldBody(),
          descriptionTextFieldBody(),
          Obx(
            () => companySettingController.isProfileEdit.value ? saveCompanyDetailsButton() : Container(),
          ),
        ],
      ),
    );
  }

  ///company name text field body
  Widget companyNameTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.companyName, context: context),
        4.sizedBoxH,
        TextFieldComponents(
          enable: companySettingController.isProfileEdit.value,
          textEditingController: companySettingController.companyTextController,
          context: context,
          hint: AppStrings.companyName,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          textInputFormatter: [
            NoLeadingSpaceFormatter(),
          ],
          onChanged: (value) {
            companySettingController.validateButton();
          },
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///company address text field body
  Widget companyAddressTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.address, context: context),
        4.sizedBoxH,
        GestureDetector(
          onTap: () {
            if (companySettingController.isProfileEdit.value == true) {
              pickPlace();
            }
          },
          child: TextFieldComponents(
            enable: false,
            textEditingController: companySettingController.addressTextController,
            context: context,
            hint: AppStrings.address,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            textInputFormatter: [
              NoLeadingSpaceFormatter(),
              LengthLimitingTextInputFormatter(50),
            ],
            onChanged: (value) {
              companySettingController.validateButton();
            },
          ),
        ),
        12.sizedBoxH,
      ],
    );
  }

  Future<void> pickPlace() async {
    //companySettingController.addressTextController.clear();
    Place place = await PluginGooglePlacePicker.showAutocomplete(
      mode: PlaceAutocompleteMode.MODE_OVERLAY,
    );

    if (place.address != null) {
      companySettingController.addressTextController.clear();
      Logger().d("===address========${place.address}");
      Logger().d("===address========${place.latitude} ${place.longitude}");
      companySettingController.addressTextController.text = place.address!;
      List<Placemark> placemark = await placemarkFromCoordinates(place.latitude, place.longitude);

      // companySettingController.latitude = place.latitude;
      // companySettingController.longitude = place.longitude;
      // Logger().d("===address========${companySettingController.latitude} ${companySettingController.longitude}");

      Logger().i(placemark[0].country);

      companySettingController.cityTextController.text = placemark[0].locality!;
      companySettingController.stateTextController.text = placemark[0].administrativeArea!;
      companySettingController.zipCodeTextController.text = placemark[0].postalCode!;
      companySettingController.latitude = place.latitude;
      companySettingController.longitude = place.longitude;
      setState(() {});
    }
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
            enable: companySettingController.isProfileEdit.value,
            textEditingController: companySettingController.cityTextController,
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
              companySettingController.validateButton();
            },
          ),
          12.sizedBoxH,
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
          TextFieldComponents(
            enable: companySettingController.isProfileEdit.value,
            textEditingController: companySettingController.stateTextController,
            context: context,
            hint: AppStrings.state,
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
              companySettingController.validateButton();
            },
          ),
          12.sizedBoxH,
        ],
      ),
    );
  }

  ///zip code text field
  Widget zipCodeTextFieldBody() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldComponents.buildLabelForTextField(text: AppStrings.zipCode, context: context),
          4.sizedBoxH,
          TextFieldComponents(
            enable: companySettingController.isProfileEdit.value,
            textEditingController: companySettingController.zipCodeTextController,
            context: context,
            hint: AppStrings.zipCode,
            keyboardType: TextInputType.text,
            textInputFormatter: [
              NoLeadingSpaceFormatter(),
              // FilteringTextInputFormatter.allow(
              //   RegExp(r"[0-9a-zA-Z]+|\s"),
              // ),
              LengthLimitingTextInputFormatter(5),
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              companySettingController.validateButton();
            },
          ),
          12.sizedBoxH,
        ],
      ),
    );
  }

  ///blank container text field
  Widget blankContainerBody() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          12.sizedBoxH,
        ],
      ),
    );
  }

  ///phone number text field
  Widget phoneNumberTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.phoneNumber, context: context),
        4.sizedBoxH,
        TextFieldComponents(
          enable: companySettingController.isProfileEdit.value,
          textEditingController: companySettingController.phoneNumberTextController,
          context: context,
          hint: AppStrings.phoneNumber,
          keyboardType: TextInputType.phone,
          textInputFormatter: [
            LengthLimitingTextInputFormatter(14),
            FilteringTextInputFormatter.digitsOnly,
            //TextInputFormatter.withFunction((oldValue, newValue) => convert(oldValue, newValue)),
            PhoneNumberTextInputFormatter(),
          ],
          onChanged: (value) {
            companySettingController.validateButton();
          },
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///website text field
  Widget websiteTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.website, context: context),
        4.sizedBoxH,
        TextFieldComponents(
          enable: companySettingController.isProfileEdit.value,
          textEditingController: companySettingController.websiteTextController,
          context: context,
          hint: AppStrings.website,
          keyboardType: TextInputType.url,
          textInputFormatter: [
            NoLeadingSpaceFormatter(),
            FilteringTextInputFormatter.deny(
              RegExp(r'\s'),
            ),
          ],
          onChanged: (value) {
            companySettingController.validateButton();
          },
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///description text Field
  Widget descriptionTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.description, context: context),
        4.sizedBoxH,
        TextFieldComponents(
            enable: companySettingController.isProfileEdit.value,
            textEditingController: companySettingController.descriptionTextController,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            textInputFormatter: [
              NoLeadingSpaceFormatter(),
              LengthLimitingTextInputFormatter(250),
            ],
            maxLines: 6,
            context: context,
            hint: AppStrings.description,
            onChanged: (value) {
              companySettingController.validateButton();
            }),
      ],
    );
  }

  Widget myReviewSection({required int index}) {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: ImageComponent.circleNetworkImage(
                        imageUrl: companySettingController.companyReviewList[index].reviewBy?.profileImg ?? '', height: 34.w, width: 34.w),
                  ),
                  Visibility(
                    visible: companySettingController.companyReviewList[index].reviewBy?.isVerified == true,
                    child: Positioned(
                      bottom: 4.h,
                      right: 4.w,
                      child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, height: 12.h, width: 12.w, boxFit: BoxFit.contain),
                    ),
                  ),
                  Visibility(
                    visible: companySettingController.companyReviewList[index].reviewBy?.userType != null,
                    child: Positioned(
                      top: 4.h,
                      left: 4.w,
                      child: ImageComponent.loadLocalImage(
                          imageName: companySettingController.companyReviewList[index].reviewBy?.userType == AppStrings.fu
                              ? AppImages.funderBadge
                              : AppImages.brokerBadge,
                          height: 12.h,
                          width: 12.w),
                    ),
                  ),

                ],
              ),
              contentPadding: EdgeInsets.zero,
              title: Text(
                '${companySettingController.companyReviewList[index].reviewBy?.firstName ?? ''} ${companySettingController.companyReviewList[index].reviewBy?.lastName ?? ''}',
                style: ISOTextStyles.openSenseSemiBold(size: 16, color: AppColors.headingTitleColor),
              ),
              subtitle: Text(
                '${companySettingController.companyReviewList[index].getHoursAgo} ',
                style: ISOTextStyles.openSenseRegular(size: 10, color: AppColors.showTimeColor),
              ),
            ),
            Text(
              companySettingController.companyReviewList[index].review ?? '',
              style: ISOTextStyles.openSenseRegular(size: 10, color: AppColors.hintTextColor),
            ),
            16.sizedBoxH,
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _handleLikeButtonPress(index: index);
                  },
                  child: Container(
                    color: AppColors.transparentColor,
                    child: ImageComponent.loadLocalImage(
                        imageName: companySettingController.companyReviewList[index].isReviewLikeByMe.value ? AppImages.heartRed : AppImages.heartLike,
                        height: 14.w,
                        width: 16.w,
                        boxFit: BoxFit.contain),
                  ),
                ),
                8.sizedBoxW,
                Text(
                  '${companySettingController.companyReviewList[index].totalReviewLike.value}',
                  style: ISOTextStyles.openSenseRegular(size: 12, color: AppColors.headingTitleColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  }

  Widget myEmployeesSection({required index}) {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(vertical: 8.0.h, ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.5, color: AppColors.greyColor),
          ),

        ),
        child: ListTile(
          onTap: () {
            Get.to(
              EmployeeProfileScreen(
                employeeId: companySettingController.companyEmployeeList[index].userId ?? 0,
              ),
              binding: EmployeeProfileBinding(),
            );
          },
          leading: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(5.0),
                child: ImageComponent.circleNetworkImage(
                  imageUrl: companySettingController.companyEmployeeList[index].profileImg ?? '',
                  height: 36.w,
                  width: 36.w,
                ),
              ),
              Visibility(
                visible: companySettingController.companyEmployeeList[index].isVerified == true,
                child: Positioned(
                  bottom: 4.h,
                  right: 4.w,
                  child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, height: 12.h, width: 12.w, boxFit: BoxFit.contain),
                ),

              ),
              Visibility(
                visible:companySettingController.companyEmployeeList[index].userType != null,
                child: Positioned(
                  top: 4.h,
                  left: 4.w,
                  child: ImageComponent.loadLocalImage(
                      imageName: companySettingController.companyEmployeeList[index].userType== AppStrings.fu
                          ? AppImages.funderBadge
                          : AppImages.brokerBadge,
                      height: 12.h,
                      width: 12.w,boxFit: BoxFit.contain),
                ),
              ),
            ],
          ),
          title: Text(
            '${companySettingController.companyEmployeeList[index].firstName ?? ''} ${companySettingController.companyEmployeeList[index].lastName ?? ''}',
            style: ISOTextStyles.openSenseSemiBold(size: 16, color: AppColors.headingTitleColor),
          ),
        ),
      ), /*ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: companySettingController.isAllDataLoaded.value ? companySettingController.companyEmployeeList.length + 1 : companySettingController.companyEmployeeList.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == companySettingController.companyEmployeeList.length) {
            Future.delayed(
              const Duration(milliseconds: 100),
              () async {
                await _handleLoadMoreList();
              },
            );
            return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
          }
          return Container(
            padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.0.w),
            child: ListTile(
              onTap: () {
                Get.to(
                  EmployeeProfileScreen(
                    employeeId: companySettingController.companyEmployeeList[index].userId ?? 0,
                  ),
                  binding: EmployeeProfileBinding(),
                );
              },
              leading: ImageComponent.circleNetworkImage(imageUrl: companySettingController.companyEmployeeList[index].profileImg ?? '', height: 36.w, width: 36.w),
              title: Text(
                '${companySettingController.companyEmployeeList[index].firstName ?? ''} ${companySettingController.companyEmployeeList[index].lastName ?? ''}',
                style: ISOTextStyles.openSenseSemiBold(size: 16, color: AppColors.headingTitleColor),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),*/
    );
  }

  ///Create Scoreboard Profile button body
  Widget saveCompanyDetailsButton() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 16.0.h),
        child: ButtonComponents.cupertinoButton(
          width: double.infinity,
          context: context,
          title: AppStrings.bSubmit,
          backgroundColor: companySettingController.isEnable.value ? AppColors.primaryColor : AppColors.disableButtonColor,
          textStyle: companySettingController.isEnable.value
              ? ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.blackColor)
              : ISOTextStyles.openSenseRegular(size: 17, color: AppColors.disableTextColor),
          onTap: () async {
            _handleSubmitButtonPress();

            //onButtonPressed();
          },
        ),
      ),
    );
  }

  _handleSubmitButtonPress() async {
    var validationResult = companySettingController.isValidUpdateCompanyFormForDetails();
    if (!validationResult.item1) {
      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: validationResult.item2);
    } else {
      companySettingController.phoneNoForApi.value = CommonUtils.convertToPhoneNumber(updatedStr: companySettingController.phoneNumberTextController.text);
      var updateApiResult = await companySettingController.updateCompanyProfileApiCall();
      if (updateApiResult) {
        companySettingController.isProfileEdit.value = false;
      }
    }
  }

  getCompanyData() {
    companySettingController.companyTextController.text = companySettingController.companyProfileDetail.value?.companyName ?? '';
    companySettingController.addressTextController.text = companySettingController.companyProfileDetail.value?.address ?? '';
    companySettingController.cityTextController.text = companySettingController.companyProfileDetail.value?.city ?? '';
    companySettingController.stateTextController.text = companySettingController.companyProfileDetail.value?.state ?? '';
    companySettingController.zipCodeTextController.text = companySettingController.companyProfileDetail.value?.zipcode ?? '';
    companySettingController.phoneNumberTextController.text = converUsFormatter(newText: (companySettingController.companyProfileDetail.value?.phoneNumber ?? ''));
    companySettingController.websiteTextController.text = companySettingController.companyProfileDetail.value?.website ?? '';
    companySettingController.descriptionTextController.text = companySettingController.companyProfileDetail.value?.description ?? '';
  }

  /// on like button press
  _handleLikeButtonPress({required int index}) async {
    var companyReview = companySettingController.companyReviewList[index];
    if (companyReview.isReviewLikeByMe.value == false) {
      var likeResponse = await CommonApiFunction.likeCompanyReviewApi(
        reviewId: companyReview.id ?? 0,
        onSuccess: (value) {
          companyReview.totalReviewLike.value = value;
          Logger().i(companyReview.totalReviewLike.value);
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
        },
      );
      if (likeResponse) {
        companyReview.isReviewLikeByMe.value = true;
      }
    } else {
      var likeResponse = await CommonApiFunction.unlikeCompanyReviewApi(
        reviewId: companyReview.id ?? 0,
        onSuccess: (value) {
          companyReview.totalReviewLike.value = value;

          Logger().i(companyReview.totalReviewLike.value);
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
        },
      );
      if (likeResponse) {
        companyReview.isReviewLikeByMe.value = false;
      }
    }
  }
}
