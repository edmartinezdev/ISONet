import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/company_controller/company_profile_controller.dart';
import 'package:iso_net/ui/style/appbar_components.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

class CompanyDealScreen extends StatefulWidget {
  const CompanyDealScreen({Key? key}) : super(key: key);

  @override
  State<CompanyDealScreen> createState() => _CompanyDealScreenState();
}

class _CompanyDealScreenState extends State<CompanyDealScreen> {
  CompanyProfileController companyProfileController = Get.find<CompanyProfileController>();

  @override
  void initState() {
   /* WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowLoaderDialog.showLoaderDialog(context);
      getAllData();
    });*/

    super.initState();
  }

  /*getAllData() async {
    companyProfileController.clearList();
    await companyProfileController.fetchMinimumTimeList();
    await companyProfileController.fetchMaxTermList();
    await companyProfileController.fetchIndustryList();
    await companyProfileController.fetchStatesList();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBody(),
      body: buildBody(),
    );
  }

  ///AppBar Body
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      titleWidget: Text(
        AppStrings.dealPreferences,
        style: ISOTextStyles.openSenseSemiBold(size: 17),
      ),
      centerTitle: true,
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
        child: Column(
          children: [
            nameValueWidget(name: AppStrings.creditRequirement, value: '${companyProfileController.companyProfileDetail.value?.creditScore ?? 0}+'),
            nameValueWidget(
                name: AppStrings.minimumMonthlyRevenue, value: '\$${NumberFormat("#,##0.00", "en_US").format(double.parse(companyProfileController.companyProfileDetail.value?.minMonthlyRev ?? ''))}'),
            Obx(() => nameValueWidget(name: AppStrings.minimumTimeInBusiness, value: companyProfileController.minTime.value.toLowerCase())),

            Obx(() => industryStateWidget(name: AppStrings.restrictedIndustries, value: companyProfileController.resIndustryList)),
            Obx(() => industryStateWidget(name: AppStrings.restrictedStates, value: companyProfileController.resStateList)),
            nameValueWidget(
                name: AppStrings.maximumFundingAmounts, value: '\$${NumberFormat("#,##0.00", "en_US").format(double.parse(companyProfileController.companyProfileDetail.value?.maxFundAmount ?? ''))}'),
            Obx(() => nameValueWidget(name: AppStrings.maximumTermLength, value: companyProfileController.maxTerm.value.toLowerCase())),
          ],
        ),
      ),
    );
  }

  Widget nameValueWidget({required String name, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                name,
                style: ISOTextStyles.openSenseRegular(size: 14, color: AppColors.hintTextColor),
                maxLines: 1,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  value,
                  style: ISOTextStyles.openSenseSemiBold(size: 14, color: AppColors.darkBlackColor),

                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
          child: const Divider(color: AppColors.greyColor,thickness: 1.0,),
        ),
      ],
    );
  }

  Widget industryStateWidget({required String name, required List<String> value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: ISOTextStyles.openSenseRegular(size: 14, color: AppColors.hintTextColor),
        ),
        18.sizedBoxH,
        SizedBox(
          height: 50.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Row(
                children: [
                  ...List.generate(value.length, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.greyColor,
                        ),
                        borderRadius: BorderRadius.circular(4.0.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.0.h),
                      child: Row(
                        children: [
                          Text(value[index],style: ISOTextStyles.openSenseSemiBold(color: AppColors.darkBlackColor,size: 14),),
                          40.sizedBoxW,
                        ],
                      ),
                    );
                  })
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
          child: const Divider(color: AppColors.greyColor,thickness: 1.0,),
        ),
      ],
    );
  }
}
