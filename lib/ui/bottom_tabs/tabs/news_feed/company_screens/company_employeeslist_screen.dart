import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/company_controller/company_employelist_controller.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../../bindings/bottom_tabs/company_binding/employee_profile_binding.dart';
import '../../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../style/appbar_components.dart';
import '../../../../style/showloader_component.dart';
import 'employee_profile_screen.dart';

class CompanyEmployeeScreen extends StatefulWidget {
  const CompanyEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<CompanyEmployeeScreen> createState() => _CompanyEmployeeScreenState();
}

class _CompanyEmployeeScreenState extends State<CompanyEmployeeScreen> {
  CompanyEmployeeListController companyEmployeeListController = Get.find<CompanyEmployeeListController>();
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) =>

          // ignore: use_build_context_synchronously
          ShowLoaderDialog.showLoaderDialog(context),
    );
    companyEmployeeListController.companyEmployeeListApi(isShowLoader: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBody(),
      body: buildBody(),
    );
  }

  ///AppBar Widget
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      // titleWidget: Text(
      //   AppStrings.employees,
      //   style: ISOTextStyles.openSenseSemiBold(size: 17),
      // ),
      titleWidget: Obx(
        () => companyEmployeeListController.searchFieldEnable.value
            ? CupertinoTheme(
                data: const CupertinoThemeData(
                  primaryColor: AppColors.blackColor,
                ),
                child: CupertinoSearchTextField(
                  placeholder: AppStrings.searchEmployees,
                  focusNode: searchFocus,
                  onChanged: (value) async {
                    _handleOnSearchEvent(value);
                  },
                  onSuffixTap: () async {
                    companyEmployeeListController.companyEmployeeList.clear();
                    companyEmployeeListController.searchFieldEnable.value = false;
                    companyEmployeeListController.searchEmployee = '';
                    Logger().i(companyEmployeeListController.companyEmployeeList.length);
                    companyEmployeeListController.pageToShow.value = 1;
                    companyEmployeeListController.isFullScreenLoader.value = false;
                    companyEmployeeListController.isAllDataLoaded.value = false;
                    ShowLoaderDialog.showLoaderDialog(context);
                    companyEmployeeListController.companyEmployeeListApi(isShowLoader: true);
                    //companyEmployeeListController.searchCompanyEmployeeList.clear();
                  },
                ),
              )
            : Text(
                AppStrings.employees,
                style: ISOTextStyles.openSenseSemiBold(size: 17),
              ),
      ),
      centerTitle: true,
      actionWidgets: [
        Obx(
          () => Visibility(
            visible: companyEmployeeListController.searchFieldEnable.value == false,
            child: IconButton(
              onPressed: () {
                companyEmployeeListController.searchFieldEnable.value = true;
                searchFocus.requestFocus();
              },
              icon: ImageComponent.loadLocalImage(imageName: AppImages.search),
            ),
          ),
        ),
      ],
    );
  }

  ///Scaffold body
  Widget buildBody() {
    return SafeArea(
      child: Obx(
        () => companyEmployeeListController.isDataLoaded.value == false
            ? Center(
                child: Text(
                  AppStrings.noRecordFound,
                  style: ISOTextStyles.openSenseSemiBold(size: 16),
                ),
              )
            : ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: 21.0.w,
                ),
                itemCount:
                    companyEmployeeListController.isAllDataLoaded.value ? companyEmployeeListController.companyEmployeeList.length + 1 : companyEmployeeListController.companyEmployeeList.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == companyEmployeeListController.companyEmployeeList.length) {
                    Future.delayed(
                      const Duration(milliseconds: 100),
                      () async {
                        await _handleLoadMoreList();
                      },
                    );
                    return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
                  }
                  return Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 5.0.h,
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Get.to(
                              EmployeeProfileScreen(
                                employeeId: companyEmployeeListController.companyEmployeeList[index].userId ?? 0,
                                isFromSeeAllEmployeeScreen: true,
                              ),
                              binding: EmployeeProfileBinding(),
                            );
                          },
                          contentPadding: EdgeInsets.zero,
                          leading: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: ImageComponent.circleNetworkImage(imageUrl: companyEmployeeListController.companyEmployeeList[index].profileImg ?? '', height: 36.w, width: 36.w),
                              ),
                              Visibility(
                                visible: companyEmployeeListController.companyEmployeeList[index].isVerified == true,
                                child: Positioned(
                                  bottom: 4.h,
                                  right: 4.w,
                                  child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, height: 12.h, width: 12.w, boxFit: BoxFit.contain),
                                ),
                              ),
                              Visibility(
                                visible: companyEmployeeListController.companyEmployeeList[index].userType != null,
                                child: Positioned(
                                  top: 4.h,
                                  left: 4.w,
                                  child: ImageComponent.loadLocalImage(
                                      imageName: companyEmployeeListController.companyEmployeeList[index].userType == AppStrings.fu ? AppImages.funderBadge : AppImages.brokerBadge,
                                      height: 12.h,
                                      width: 12.w),
                                ),
                              ),
                            ],
                          ),
                          title: Text(
                            '${companyEmployeeListController.companyEmployeeList[index].firstName ?? ''} ${companyEmployeeListController.companyEmployeeList[index].lastName ?? ''}',
                            style: ISOTextStyles.openSenseSemiBold(size: 16),
                          ),
                        ),
                        5.sizedBoxH,
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 0.5,
                    color: AppColors.dropDownColor,
                  );
                },
              ),
      ),
    );
  }

  ///Handle onSearch event
  _handleOnSearchEvent(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      companyEmployeeListController.companyEmployeeList.clear();
      companyEmployeeListController.isFullScreenLoader.value = false;
      Logger().i(companyEmployeeListController.companyEmployeeList.length);
      companyEmployeeListController.pageToShow.value = 1;
      companyEmployeeListController.isAllDataLoaded.value = false;
      companyEmployeeListController.searchEmployee = query;
      ShowLoaderDialog.showLoaderDialog(context);
      companyEmployeeListController.companyEmployeeListApi(isShowLoader: true);
      searchFocus.requestFocus();
    });
  }

  Future _handleLoadMoreList() async {
    if (!companyEmployeeListController.isAllDataLoaded.value) return;
    if (companyEmployeeListController.isLoadMoreRunningForViewAll) return;
    companyEmployeeListController.isLoadMoreRunningForViewAll = true;
    await companyEmployeeListController.paginationFunction();
  }
}
