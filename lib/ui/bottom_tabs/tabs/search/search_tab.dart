import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/bindings/user/loan_preference_binding.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/search/search_tab_controller.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/search/filter_screen.dart';
import 'package:iso_net/ui/style/button_components.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../bindings/bottom_tabs/user_binding/user_profile_binding.dart';
import '../../../../singelton_class/auth_singelton.dart';
import '../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../utils/app_common_stuffs/common_api_function.dart';
import '../../../../utils/app_common_stuffs/screen_routes.dart';
import '../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../style/image_components.dart';
import '../news_feed/user_screens/user_profile_screen.dart';
import 'findfunder_loanform_screen.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> with AutomaticKeepAliveClientMixin<SearchTab> {
  SearchController searchController = Get.find<SearchController>();
  TextEditingController searchTextController = TextEditingController();
  FocusNode focusNode = FocusNode();
  Timer? _debounce;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    searchController.isFilterEnable.value = false;
    Logger().i(searchController.isFilterEnable.value);
    searchController.scrollController.addListener(() {
      focusNode.unfocus();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        if (focusNode.hasPrimaryFocus) {
          focusNode.unfocus();
          searchController.searchFieldEnable.value = false;
        }
      },
      child: Scaffold(
        appBar: appBarBody(),
        body: buildBody(),
        floatingActionButton: findFunderButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  ///AppBar
  PreferredSizeWidget appBarBody() {
    return AppBar(
      centerTitle: false,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => searchController.isFilterEnable.value
                ? GestureDetector(
                    onTap: () {
                      searchController.isFilterEnable.value = false;
                      searchController.userType.value = '';
                      searchTextController.clear();
                      searchController.searchText.value = '';
                      focusNode.unfocus();
                      for (int i = 0; i < searchController.filterSearchList.length; i++) {
                        if (searchController.filterSearchList[i].isFilterSelected.value == true) {
                          searchController.filterSearchList[i].isFilterSelected.value = false;
                        }
                      }
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.only(left: 10.0.w, right: 23.0.w, top: 5.0.h, bottom: 5.0.h),
                      child: ImageComponent.loadLocalImage(imageName: AppImages.leftArrow, height: 14.w, width: 8.w, boxFit: BoxFit.contain),
                    ),
                  )
                : Container(),
          ),
          4.sizedBoxW,
          Expanded(
            child: CupertinoSearchTextField(
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: AppColors.scoreboardNumColor,
                size: 17.sp,
              ),
              controller: searchTextController,
              focusNode: focusNode,
              onChanged: (value) {
                _onSearchChanged(value);
              },
              onSuffixTap: null,
            ),
          ),
        ],
      ),
      actions: [
        Obx(
          () => Padding(
            padding: EdgeInsets.only(right: 12.0.w),
            child: searchController.isFilterEnable.value
                ? ButtonComponents.textButton(
                    context: context,
                    onTap: () {
                      searchController.isFilterEnable.value = false;
                      searchController.userType.value = '';
                      searchTextController.clear();
                      searchController.searchText.value = '';
                      focusNode.unfocus();
                      for (int i = 0; i < searchController.filterSearchList.length; i++) {
                        if (searchController.filterSearchList[i].isFilterSelected.value == true) {
                          searchController.filterSearchList[i].isFilterSelected.value = false;
                        }
                      }
                    },
                    title: AppStrings.cancel,
                    textColor: AppColors.blackColor)
                : GestureDetector(
                    onTap: () {
                      Get.to(const FilterScreen());
                    },
                    child: ImageComponent.loadLocalImage(imageName: AppImages.filterFill, height: 28.w, width: 28.w, boxFit: BoxFit.contain),
                  ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(
          color: AppColors.dropDownColor,
          height: 1.0,
        ),
      ),
    );
  }

  ///Scaffold Body
  Widget buildBody() {
    return SafeArea(
      child: Obx(
        () => searchController.isFilterEnable.value == false
            ? Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageComponent.loadLocalImage(imageName: AppImages.searchYellow, height: 56.w, width: 56.w, boxFit: BoxFit.contain),
                      29.sizedBoxH,
                      Text(
                        AppStrings.searchScreenMessage,
                        style: ISOTextStyles.sfProBold(size: 20, color: AppColors.headingTitleColor),
                      ),
                      12.sizedBoxH,
                      Text(
                        AppStrings.searchSubTitle,
                        style: ISOTextStyles.sfProDisplay(size: 14, color: AppColors.hintTextColor),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            : Obx(
                () => searchController.isDataLoaded.value == false
                    ? Center(
                        child: Text(
                          'No Record Found',
                          style: ISOTextStyles.openSenseSemiBold(size: 16),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: 4.0.h),
                        child: ListView.builder(
                          controller: searchController.scrollController,
                          itemCount: searchController.isAllDataLoaded.value ? searchController.searchListController.length + 1 : searchController.searchListController.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == searchController.searchListController.length) {
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () async {
                                  await _handleLoadMoreList();
                                },
                              );
                              return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
                            }

                            var userData = searchController.searchListController[index];
                            if (searchController.searchListController[index].isCompany == true) {
                              return GestureDetector(
                                onTap: () {
                                  handleCompanyProfileTap(index: index);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 11.0.h),
                                  margin: EdgeInsets.symmetric(horizontal: 7.0.w, vertical: 4.0.h),
                                  decoration: BoxDecoration(border: Border.all(color: AppColors.greyColor), borderRadius: BorderRadius.circular(8.0), color: AppColors.transparentColor),
                                  child: Row(
                                    children: [
                                      IgnorePointer(
                                        child: ImageComponent.circleNetworkImage(imageUrl: userData.companyImage ?? '', height: 94.w, width: 94.w),
                                      ),
                                      16.sizedBoxW,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userData.companyName ?? '',
                                              style: ISOTextStyles.openSenseSemiBold(
                                                size: 16,
                                                color: AppColors.headingTitleColor,
                                              ),
                                            ),
                                            Text(
                                              (userData.totalReviews ?? 0) != 1 ? '${userData.totalReviews ?? 0} ${AppStrings.reviews}' : '${userData.totalReviews ?? 0} ${AppStrings.review}',
                                              style: ISOTextStyles.openSenseSemiBold(size: 11, color: AppColors.hintTextColor),
                                            ),
                                            Text(
                                              userData.address ?? '',
                                              style: ISOTextStyles.openSenseRegular(size: 10, color: AppColors.hintTextColor),
                                            ),
                                            28.sizedBoxH
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  handleUserProfileTap(index: index);
                                },
                                child: Container(
                                  //padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 12.0.h),
                                  margin: EdgeInsets.symmetric(horizontal: 7.0.w, vertical: 4.0.h),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.greyColor,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                      color: AppColors.transparentColor),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(right: 15.0.w, top: 11.0.h, bottom: 11.0.h, left: 15.0.w),
                                        child: IgnorePointer(
                                          child: Stack(
                                            //alignment: Alignment.bottomCenter,
                                            children: [
                                              ImageComponent.circleNetworkImage(imageUrl: userData.profileImg ?? '', height: 94.w, width: 94.w),
                                              Visibility(
                                                visible: userData.isVerified ?? false,
                                                child: Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child: ImageComponent.loadLocalImage(
                                                    imageName: AppImages.verifyLogo,
                                                    height: 24.w,
                                                    width: 24.w,
                                                    boxFit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          top: 19.0.h,
                                          bottom: 19.0.h,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${userData.firstName ?? ''} ${userData.lastName ?? ''}',
                                                  style: ISOTextStyles.openSenseRegular(size: 16, color: AppColors.headingTitleColor),
                                                ),
                                                4.sizedBoxH,
                                                Text(
                                                  userData.companyName ?? '',
                                                  style: ISOTextStyles.openSenseLight(size: 10, color: AppColors.hintTextColor),
                                                ),
                                              ],
                                            ),
                                            10.sizedBoxH,
                                            Obx(
                                              () => userData.isConnected.value == 'Connected'
                                                  ? 20.sizedBoxH
                                                  : GestureDetector(
                                                      onTap: () async {
                                                        var apiResult = await CommonApiFunction.commonConnectApi(
                                                            userId: userData.userId ?? 0,
                                                            onErr: (msg) {
                                                              SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                                            });
                                                        if (apiResult) {
                                                          userData.isConnected.value = 'Requested';
                                                        }
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            userData.isConnected.value == 'NotConnected' ? AppImages.plus : AppImages.check,
                                                            height: userData.isConnected.value == 'NotConnected' ? 12.w : 12.w,
                                                            width: userData.isConnected.value == 'NotConnected' ? 12.w : 12.w,
                                                            fit: BoxFit.contain,
                                                          ),
                                                          3.sizedBoxW,
                                                          Text(
                                                            userData.isConnected.value == 'NotConnected' ? 'Connect' : 'Requested',
                                                            style: ISOTextStyles.openSenseSemiBold(size: 14, color: AppColors.headingTitleColor),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
              ),
      ),
    );
  }

  ///Find a funder button body
  Widget findFunderButton() {
    return Obx(
      () => searchController.isFilterEnable.value || userSingleton.userType == 'FU'
          ? Container()
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
              child: InkWell(
                onTap: () {
                  Get.to(const LoanForumScreen(), binding: LoanPreferenceBinding());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 4,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    color: AppColors.primaryColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppStrings.findFunderB,
                            style: ISOTextStyles.openSenseBold(size: 16),
                          ),
                          5.sizedBoxW,
                          Text(
                            AppStrings.dealPlacement,
                            style: ISOTextStyles.openSenseRegular(size: 14),
                          ),
                        ],
                      ),
                      ImageComponent.loadLocalImage(imageName: AppImages.rightArrow),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  ///Handle on search function
  _onSearchChanged(String query) {
    searchController.isFilterEnable.value = true;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      searchController.searchText.value = query;
      searchController.pageToShow.value = 1;
      searchController.isAllDataLoaded.value = false;
      searchController.isLoadMoreRunningForViewAll = false;
      searchController.totalRecords.value = 0;
      searchController.searchListController.clear();
      await searchController.searchApiCall();
    });
  }

  ///Handle Company profile tap function
  handleCompanyProfileTap({required int index}) {
    CommonUtils.scopeUnFocus(context);
    Get.toNamed(ScreenRoutesConstants.companyProfileScreen, arguments: searchController.searchListController[index].id);
    Logger().i('Hii');
  }

  ///Handle User profile tap function
  handleUserProfileTap({required int index}) async {
    CommonUtils.scopeUnFocus(context);
    if (userSingleton.id == searchController.searchListController[index].userId) {
      null;
    } else {
      Logger().i(searchController.searchListController[index].userId);
      var callBack = await Get.to(
        UserProfileScreen(
          userId: searchController.searchListController[index].userId,
        ),
        binding: UserProfileBinding(),
      );
      if (callBack != null && callBack != true) {
        searchController.searchListController[index].isConnected.value = callBack;
        searchController.update();
      }
    }
  }

  Future _handleLoadMoreList() async {
    if (!searchController.isAllDataLoaded.value) return;
    if (searchController.isLoadMoreRunningForViewAll) return;
    searchController.isLoadMoreRunningForViewAll = true;
    await searchController.searchPagination();
  }
}
