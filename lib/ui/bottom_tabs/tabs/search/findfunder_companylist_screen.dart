import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/user/loan_preference_controller.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../utils/app_common_stuffs/screen_routes.dart';
import '../../../style/appbar_components.dart';
import '../../../style/image_components.dart';
import '../../../style/text_style.dart';

// ignore: must_be_immutable
class FindFunderCompanyListScreen extends StatefulWidget {
  const FindFunderCompanyListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FindFunderCompanyListScreen> createState() => _FindFunderCompanyListScreenState();
}

class _FindFunderCompanyListScreenState extends State<FindFunderCompanyListScreen> {
  LoanPreferenceController loanPreferenceController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBody(),
      body: buildBody(),
      bottomNavigationBar: editPreferenceButton(),
    );
  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      titleWidget: Text(
        AppStrings.findFunder,
        style: ISOTextStyles.openSenseSemiBold(size: 16),
      ),
      centerTitle: true,
      bottomWidget: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(
          color: AppColors.dropDownColor,
          height: 1.0,
        ),
      ),
    );
  }

  Widget buildBody() {
    return SafeArea(
      child: loanPreferenceController.funderCompanyList.isEmpty ?  Center(
        child: Text('No Record Found.',style: ISOTextStyles.openSenseSemiBold(size: 16),),
      )
          : Padding(
        padding: EdgeInsets.only(top: 14.0.h),
        child: ListView.builder(
          itemCount: loanPreferenceController.isAllDataLoaded.value ? loanPreferenceController.funderCompanyList.length + 1 : loanPreferenceController.funderCompanyList.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == loanPreferenceController.funderCompanyList.length) {
              Future.delayed(
                const Duration(milliseconds: 100),
                () async {
                  await _handleLoadMoreList();
                },
              );
              return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
            }
            var companyData = loanPreferenceController.funderCompanyList[index];
            return GestureDetector(
              onTap: () {
                handleCompanyProfileTap(index: index);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 11.0.h),
                margin: EdgeInsets.symmetric(horizontal: 7.0.w, vertical: 4.0.h),
                decoration: BoxDecoration(
                    border: Border.all(color: companyData.isPreferred == true ? AppColors.primaryColor : AppColors.greyColor),
                    borderRadius: BorderRadius.circular(8.0),
                    color: AppColors.transparentColor),
                child: Row(
                  children: [
                    ImageComponent.circleNetworkImage(imageUrl: companyData.companyImage ?? '', height: 94.w, width: 94.w,placeHolderImage: AppImages.backGroundDefaultImage),
                    16.sizedBoxW,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            companyData.companyName ?? '',
                            style: ISOTextStyles.openSenseSemiBold(
                              size: 16,
                              color: AppColors.headingTitleColor,
                            ),
                          ),
                          Text(
                            '${companyData.totalReviews ?? 0} ${AppStrings.reviews}',
                            style: ISOTextStyles.openSenseSemiBold(size: 11, color: AppColors.hintTextColor),
                          ),
                          Text(
                            companyData.address ?? '',
                            style: ISOTextStyles.openSenseRegular(size: 10, color: AppColors.hintTextColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Visibility(
                            visible: companyData.isPreferred == true,
                            child: Text(
                              AppStrings.preferred,
                              style: ISOTextStyles.openSenseSemiBold(size: 14),
                            ),
                          ),
                          18.sizedBoxH
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  ///Edit Preference button body
  Widget editPreferenceButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 32.0.h),
      child: InkWell(
        onTap: () {
          Get.back();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0.r),
            color: AppColors.primaryColor,
          ),
          child: Text(
            AppStrings.editPreference,
            style: ISOTextStyles.openSenseBold(size: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  ///Handle Company profile tap function
  handleCompanyProfileTap({required int index}) {
    Get.toNamed(ScreenRoutesConstants.companyProfileScreen, arguments: loanPreferenceController.funderCompanyList[index].companyId);
  }

  Future _handleLoadMoreList() async {
    if (!loanPreferenceController.isAllDataLoaded.value) return;
    if (loanPreferenceController.isLoadMoreRunningForViewAll) return;
    loanPreferenceController.isLoadMoreRunningForViewAll = true;
    await loanPreferenceController.funderPagination();
  }
}
