import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/bindings/bottom_tabs/company_binding/company_profile_binding.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/company_controller/company_profile_controller.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/company_screens/deal_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/company_screens/employee_profile_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/company_screens/leave_review_screen.dart';
import 'package:iso_net/ui/style/ImageWidget.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';
import 'package:iso_net/utils/swipe_back.dart';

import '../../../../../bindings/bottom_tabs/company_binding/employee_profile_binding.dart';
import '../../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../style/appbar_components.dart';
import '../../../../style/image_components.dart';
import '../../../../style/showloader_component.dart';
import '../../../../style/text_style.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({Key? key}) : super(key: key);

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  CompanyProfileController companyProfileController = Get.find<CompanyProfileController>();

  TextEditingController reviewController = TextEditingController();

  converUsFormatter({required String newText}) {
    // The below code gives a range error if not 10.
    RegExp phone = RegExp(r'(\d{3})(\d{3})(\d{4})');
    var matches = phone.allMatches(newText);
    var match = matches.elementAt(0);
    newText = '(${match.group(1)}) ${match.group(2)}-${match.group(3)}';
    return newText;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ShowLoaderDialog.showLoaderDialog(context),
    );
    getAllData();

    super.initState();
  }

  getAllData() async {
    companyProfileController.clearList();
    await companyProfileController.companyProfileApiCall();
    Logger().i(companyProfileController.companyProfileDetail.value?.creditScore);
    if(companyProfileController.companyProfileDetail.value?.creditScore != null){
      await companyProfileController.fetchMinimumTimeList();
      await companyProfileController.fetchMaxTermList();
      await companyProfileController.fetchIndustryList();
      await companyProfileController.fetchStatesList();
    }

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: true);
        return true;
      },
      child: SwipeBackWidget(
        result: true,
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
      leadingWidget: GestureDetector(
        onTap: () => Get.back(result: true),
        //onPressed: () => Get.back(),
        child: ImageComponent.loadLocalImage(
          imageName: AppImages.arrow,
        ),
      ),
    );
  }

  ///Scaffold body
  Widget buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Obx(
          () => companyProfileController.isAllCompanyDataLoaded.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageWidget(
                      url: companyProfileController.companyProfileDetail.value?.companyImage ?? '',
                      fit: BoxFit.cover,
                      height: 200.0,
                      width: double.infinity,
                      placeholder: AppImages.backGroundDefaultImage,
                    ),
                    companyDetailBody(),
                    addCompanyReviewBody(),
                    companyContactDetailWidget(),
                    companyReviewBody(),
                    companyEmployeeListBody(),
                  ],
                )
              : Container(),
        ),
      ),
    );
  }

  ///Company details body
  Widget companyDetailBody() {
    return Container(
      padding: EdgeInsets.only(right: 16.0.w, top: 23.0.h, left: 16.0.w, bottom: 23.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            companyProfileController.companyProfileDetail.value?.companyName ?? '',
            style: ISOTextStyles.openSenseSemiBold(size: 18, color: AppColors.headingTitleColor),
          ),
          Row(
            children: [
              Text(
                '${companyProfileController.companyProfileDetail.value?.totalReviews} ${(companyProfileController.companyProfileDetail.value?.totalReviews ?? 0) != 1 ? AppStrings.reviews : AppStrings.review}',
                style: ISOTextStyles.openSenseSemiBold(size: 14, color: AppColors.disableTextColor),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 32.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                commonNavigationWidget(
                    imageName: AppImages.navigate,
                    name: AppStrings.navigate,
                    onTap: () {
                      //openMap();
                      CommonUtils.mapCompanyDirection(
                          latitude: companyProfileController.companyProfileDetail.value?.latitude ?? '', longitude: companyProfileController.companyProfileDetail.value?.longitude ?? '');
                    }),
                commonNavigationWidget(
                    imageName: AppImages.call,
                    name: AppStrings.call,
                    onTap: () {
                      CommonUtils.telePhoneUrl(companyProfileController.companyProfileDetail.value?.phoneNumber ?? '');
                    }),
                Visibility(
                  visible: (companyProfileController.companyProfileDetail.value?.website ?? '').isNotEmpty,
                  child: commonNavigationWidget(
                      imageName: AppImages.website,
                      name: AppStrings.website,
                      onTap: () async {
                        CommonUtils.websiteLaunch(companyProfileController.companyProfileDetail.value?.website ?? '');
                      }),
                ),
                Visibility(
                  visible: companyProfileController.companyProfileDetail.value?.creditScore != null && companyProfileController.companyProfileDetail.value?.creditScore != 0,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(const CompanyDealScreen(), binding: CompanyProfileBinding());
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0.w,
                      ),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 52.w,
                            width: 52.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(52.w / 2),
                              color: AppColors.greyColor,
                            ),
                            child: ImageComponent.loadLocalImage(
                              imageName: AppImages.filterIcon2,
                              height: 26.w,
                              width: 26.w,
                            ),
                          ),
                          4.sizedBoxH,
                          Text(
                            AppStrings.deals,
                            style: ISOTextStyles.sfProMedium(size: 12, color: AppColors.darkBlackColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: AppColors.dropDownColor,
            thickness: 1.0,
          ),
        ],
      ),
    );
  }

  ///Navigation,call,website common widget
  Widget commonNavigationWidget({required String imageName, required String name, required VoidCallback onTap}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0.w,
      ),
      child: Column(
        children: [
          GestureDetector(
              onTap: onTap, child: Container(color: AppColors.transparentColor, child: ImageComponent.loadLocalImage(imageName: imageName, height: 52.w, width: 52.w, boxFit: BoxFit.contain))),
          4.sizedBoxH,
          Text(
            name,
            style: ISOTextStyles.sfProMedium(size: 12, color: AppColors.darkBlackColor),
          ),
        ],
      ),
    );
  }

  ///add review textfield
  Widget addCompanyReviewBody() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0.h, horizontal: 16.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            companyProfileController.companyProfileDetail.value?.description ?? '',
            style: ISOTextStyles.sfProDisplay(size: 14),
          ),
          24.sizedBoxH,
          GestureDetector(
            onTap: () async {
              Get.to(const LeaveReviewScreen());
            },
            child: Container(
              alignment: Alignment.center,
              height: 40.0,
              margin: EdgeInsets.symmetric(horizontal: 50.0.w),
              // padding: EdgeInsets.symmetric(horizontal: 30.0.w,vertical: 8.0.h),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40 / 2), border: Border.all(color: AppColors.blueGrey)),
              child: Text(
                AppStrings.leaveAReview,
                style: ISOTextStyles.sfProBold(size: 15, color: AppColors.darkBlackColor),
              ),
            ),
          ),
          32.sizedBoxH,
          const Divider(
            color: AppColors.dropDownColor,
            thickness: 1.0,
          ),
        ],
      ),
    );
  }

  ///Company contact details
  Widget companyContactDetailWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0.w,
      ),
      child: Column(
        children: [
          companyContactCommonWidget(
            imageName: AppImages.location,
            text: companyProfileController.companyProfileDetail.value?.address ?? '',
            onTap: () {
              CommonUtils.mapCompanyDirection(
                  latitude: companyProfileController.companyProfileDetail.value?.latitude ?? '', longitude: companyProfileController.companyProfileDetail.value?.longitude ?? '');
            },
          ),
          companyContactCommonWidget(
            imageName: AppImages.callGrey,
            text: (companyProfileController.companyProfileDetail.value?.phoneNumber ?? '').isEmpty
                ? ''
                : converUsFormatter(newText: (companyProfileController.companyProfileDetail.value?.phoneNumber ?? '')),
            onTap: () {
              CommonUtils.telePhoneUrl(companyProfileController.companyProfileDetail.value?.phoneNumber ?? '');
            },
          ),
          companyContactCommonWidget(
            imageName: AppImages.webGrey,
            text: companyProfileController.companyProfileDetail.value?.website ?? '',
            onTap: () {
              CommonUtils.websiteLaunch(companyProfileController.companyProfileDetail.value?.website ?? '');
            },
          ),
        ],
      ),
    );
  }

  ///Company contact details
  Widget companyContactCommonWidget({required String imageName, required String text, required VoidCallback onTap}) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 4.0.h),
      child: Visibility(
        visible: text.isNotEmpty ? true : false,
        child: Column(
          children: [
            InkWell(
              onTap: onTap,
              child: Row(
                children: [
                  ImageComponent.loadLocalImage(imageName: imageName),
                  8.sizedBoxW,
                  Flexible(
                    child: Text(
                      text,
                      style: ISOTextStyles.sfProTextMedium(size: 14, color: AppColors.blackColorDetailsPage),
                    ),
                  ),
                ],
              ),
            ),
            8.sizedBoxH,
            const Divider(color: AppColors.dropDownColor, thickness: 1.0),
          ],
        ),
      ),
    );
  }

  ///Widget company Reviews
  Widget companyReviewBody() {
    return companyProfileController.companyProfileDetail.value?.reviews == null
        ? Container()
        : Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  //(companyProfileController.companyProfileDetail.value?.totalReviews ?? 0) != 1 ? AppStrings.reviews : AppStrings.review,
                   AppStrings.reviews ,
                  style: ISOTextStyles.openSenseSemiBold(size: 18),
                ),
                Obx(
                  () => companyProfileController.companyProfileDetail.value?.totalReviews == 0
                      ? Container(
                    alignment: Alignment.center,

                          child: Text(
                            'No Reviews Added!',
                            style: ISOTextStyles.openSenseSemiBold(size: 14),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: companyProfileController.companyProfileDetail.value?.reviews?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              padding: EdgeInsets.only(top: 15.0.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(

                                    leading: Stack(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          child: ImageComponent.circleNetworkImage(
                                              imageUrl: companyProfileController.companyProfileDetail.value?.reviews?[index].reviewBy?.profileImg ?? '', height: 36.w, width: 36.w),
                                        ),
                                        Visibility(
                                          visible: companyProfileController.companyProfileDetail.value?.reviews?[index].reviewBy?.isVerified == true,
                                          child: Positioned(
                                            bottom: 4.h,
                                            right: 4.w,
                                            child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, height: 12.h, width: 12.w, boxFit: BoxFit.contain),
                                          ),
                                        ),
                                        Visibility(
                                          visible: companyProfileController.companyProfileDetail.value?.reviews?[index].reviewBy?.userType != null,
                                          child: Positioned(
                                            top: 4.h,
                                            left: 4.w,
                                            child: ImageComponent.loadLocalImage(
                                                imageName: companyProfileController.companyProfileDetail.value?.reviews?[index].reviewBy?.userType == AppStrings.fu
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
                                      '${companyProfileController.companyProfileDetail.value?.reviews?[index].reviewBy?.firstName ?? ''} ${companyProfileController.companyProfileDetail.value?.reviews?[index].reviewBy?.lastName ?? ''}',
                                      style: ISOTextStyles.openSenseSemiBold(size: 16),
                                    ),
                                    subtitle: Text(
                                      '${companyProfileController.companyProfileDetail.value?.reviews?[index].getHoursAgo} ',
                                      style: ISOTextStyles.openSenseRegular(size: 10, color: AppColors.hintTextColor),
                                    ),
                                  ),
                                  companyProfileController.companyProfileDetail.value?.reviews == null
                                      ? Container()
                                      : Text(companyProfileController.companyProfileDetail.value?.reviews?[index].review ?? ''),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                8.sizedBoxH,
                (companyProfileController.companyProfileDetail.value?.reviews?.length ?? 0) > 2
                    ? GestureDetector(
                        onTap: () {
                          Get.toNamed(ScreenRoutesConstants.companyReviewScreen, arguments: companyProfileController.companyProfileDetail.value?.id ?? 0);
                        },
                        child: Row(
                          children: [
                            Text(AppStrings.seeAll,style: ISOTextStyles.openSenseSemiBold(size: 12,color: AppColors.headingTitleColor),),
                            8.sizedBoxW,
                            ImageComponent.loadLocalImage(imageName: AppImages.yellowArrow),
                          ],
                        ),
                      )
                    : Container(),
                8.sizedBoxH,
                const Divider(
                  thickness: 1.0,
                  color: AppColors.dropDownColor,
                ),
              ],
            ),
          );
  }

  ///Widget company employee list
  Widget companyEmployeeListBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.employees,
                style: ISOTextStyles.openSenseSemiBold(size: 18),
              ),
              Text('${companyProfileController.companyProfileDetail.value?.totalEmployeesCount}'),
            ],
          ),
          23.sizedBoxH,
          Obx(
            () => companyProfileController.companyProfileDetail.value?.employees?.length == null
                ? Container()
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: companyProfileController.companyProfileDetail.value?.employees?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 5.0.h),
                        child: userSingleton.id == companyProfileController.companyProfileDetail.value?.employees?[index].userId
                            ? Container()
                            : Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Get.to(
                                        EmployeeProfileScreen(
                                          employeeId: companyProfileController.companyProfileDetail.value?.employees?[index].userId ?? 0,
                                          isFromSeeAllEmployeeScreen: false,
                                        ),
                                        binding: EmployeeProfileBinding(),
                                      );
                                    },
                                    contentPadding: EdgeInsets.zero,
                                    leading: Stack(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(5.0),
                                          child: ImageComponent.circleNetworkImage(
                                            imageUrl: companyProfileController.companyProfileDetail.value?.employees?[index].profileImg ?? '',
                                            height: 36.w,
                                            width: 36.w,
                                          ),
                                        ),
                                        Visibility(
                                          visible: companyProfileController.companyProfileDetail.value?.employees?[index].isVerified == true,
                                          child: Positioned(
                                            bottom: 4.h,
                                            right: 4.w,
                                            child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, height: 12.w, width: 12.w, boxFit: BoxFit.contain),
                                          ),
                                        ),
                                        Visibility(
                                          visible: companyProfileController.companyProfileDetail.value?.employees?[index].userType != null,
                                          child: Positioned(
                                            top: 4.h,
                                            left: 4.w,
                                            child: ImageComponent.loadLocalImage(
                                                imageName:
                                                    companyProfileController.companyProfileDetail.value?.employees?[index].userType == AppStrings.fu ? AppImages.funderBadge : AppImages.brokerBadge,
                                                height: 12.h,
                                                width: 12.w),
                                          ),
                                        ),
                                      ],
                                    ),
                                    title: Text(
                                      '${companyProfileController.companyProfileDetail.value?.employees?[index].firstName ?? ''} ${companyProfileController.companyProfileDetail.value?.employees?[index].lastName ?? ''}',
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
                        height: 1,
                        color: AppColors.dropDownColor,
                      );
                    },
                  ),
          ),
          (companyProfileController.companyProfileDetail.value?.employees?.length ?? 0) > 3
              ? GestureDetector(
                  onTap: () {
                    Get.toNamed(ScreenRoutesConstants.companyEmployeeListScreen, arguments: companyProfileController.companyProfileDetail.value?.id ?? 0);
                  },
                  child: Row(
                    children: [
                      Text(AppStrings.seeAll,style: ISOTextStyles.openSenseSemiBold(size: 12,color: AppColors.headingTitleColor),),
                      8.sizedBoxW,
                      ImageComponent.loadLocalImage(imageName: AppImages.yellowArrow),
                    ],
                  ),
                )
              : Container(),
          const Divider(
            color: AppColors.dropDownColor,
            thickness: 1.0,
          )
        ],
      ),
    );
  }
}
