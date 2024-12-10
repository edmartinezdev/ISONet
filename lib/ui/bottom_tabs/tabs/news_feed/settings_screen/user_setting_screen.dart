// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/bindings/my_profile/my_profile_binding.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/setting_controller/company_setting_controller.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/setting_controller/user_setting_controller.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/my_profile/referral_screen.dart';
import 'package:iso_net/ui/style/dialog_components.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/ui/user/user_subscription_screen.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/common_api_function.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';

import '../../../../../bindings/my_profile/edit_myaccount_binding.dart';
import '../../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../../utils/app_common_stuffs/screen_routes.dart';
import '../../../../my_profile/edit_myaccount_screen.dart';
import '../../../../style/image_components.dart';
import '../../../../style/text_style.dart';

class UserSettingScreen extends StatefulWidget {
  bool? isCompanyOwner;
  bool? isCompanyDeleted;

  UserSettingScreen({Key? key, this.isCompanyDeleted, this.isCompanyOwner}) : super(key: key);

  @override
  State<UserSettingScreen> createState() => _UserSettingScreenState();
}

class _UserSettingScreenState extends State<UserSettingScreen> {
  UserSettingController userSettingController = Get.find<UserSettingController>();
  CompanySettingController companySettingController = Get.find<CompanySettingController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.isCompanyOwner == true && widget.isCompanyDeleted == false) {
        ShowLoaderDialog.showLoaderDialog(context);
        companySettingController.companyProfileApiCall(isShowLoader: true);
      }
    });

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
        onTap: () => Get.back(),
        child: ImageComponent.loadLocalImage(
          imageName: AppImages.arrow,
        ),
      ),
      title: Text(
        AppStrings.settingText,
        style: ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.headingTitleColor),
      ),
      centerTitle: true,
    );
  }

  Widget buildBody() {
    return CommonUtils.constrainedBody(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
              child: Text(
                AppStrings.appText,
                style: ISOTextStyles.openSenseSemiBold(size: 16, color: AppColors.darkBlackColor),
              ),
            ),
            //10.sizedBoxH,
            appSettingOptionWidget(),
            Container(
              padding: EdgeInsets.only(right: 16.0.w, top: 36.0.h, left: 16.0.w),
              child: Text(
                AppStrings.aboutText,
                style: ISOTextStyles.openSenseSemiBold(size: 16, color: AppColors.darkBlackColor),
              ),
            ),
            aboutSettingOptionWidget(),
          ],
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 16.0.h),
          child: GestureDetector(
            onTap: () {
              CommonUtils.buildSignOutAlert(context: context);
            },
            child: Container(
              height: 40.h,
              width: 100.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: AppColors.greyColor,
              ),
              child: Center(
                child: Text(
                  AppStrings.bSignOut,
                  style: ISOTextStyles.sfProSemiBold(size: 14, color: AppColors.scoreboardNumColor),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///User setting option widget
  Widget appSettingOptionWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0.r),
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.greyColor,
              blurRadius: 4.0.r,
              spreadRadius: 2.0.r,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.h),
          child: Column(
            children: [
              userOptionFieldWidget(
                settingScreenText: AppStrings.accountText,
                voidCallback: () {
                  Get.to(
                      EditMyAccountScreen(
                        isCompanyDeleted: widget.isCompanyDeleted ?? false,
                        isCompanyOwner: widget.isCompanyOwner ?? false,
                      ),
                      binding: EditMyAccountBinding());
                  /*Get.toNamed(ScreenRoutesConstants.editMyAccountScreen);*/
                },
              ),
              const Divider(
                thickness: 1.0,
                color: AppColors.greyColor,
              ),
              Obx(
                ()=> Visibility(
                  visible: userSingleton.isOwner.value == true && widget.isCompanyDeleted == false,
                  child: userOptionFieldWidget(
                    settingScreenText: AppStrings.companyText,
                    voidCallback: () {
                      Get.toNamed(ScreenRoutesConstants.settingCompanyScreen);
                    },
                  ),
                ),
              ),
              Obx(
                ()=> Visibility(
                    visible: userSingleton.isOwner.value == true && widget.isCompanyDeleted == false,
                    child: const Divider(
                      thickness: 1.0,
                      color: AppColors.greyColor,
                    )),
              ),
              userOptionFieldWidget(
                settingScreenText: AppStrings.subscriptionText,
                voidCallback: () {
                  Get.to(const UserSubscriptionScreen(), binding: MyProfileBinding());
                },
              ),
              const Divider(
                thickness: 1.0,
                color: AppColors.greyColor,
              ),
              userOptionFieldWidget(
                settingScreenText: AppStrings.referralsText,
                voidCallback: () {
                  Get.to(const ReferralScreen(), binding: MyProfileBinding());
                  //Get.toNamed(ScreenRoutesConstants.editMyAccountScreen);
                },
              ),
              const Divider(
                thickness: 1.0,
                color: AppColors.greyColor,
              ),
              userOptionFieldWidget(
                settingScreenText: AppStrings.myBookMarkText,
                voidCallback: () {
                  Get.toNamed(ScreenRoutesConstants.bookMarkScreen);
                },
              ),
              const Divider(
                thickness: 1.0,
                color: AppColors.greyColor,
              ),
              userOptionFieldWidget(
                settingScreenText: AppStrings.notificationsText,
                voidCallback: () {
                  Get.toNamed(ScreenRoutesConstants.notificationSettingScreen);
                },
              ),
              const Divider(
                thickness: 1.0,
                color: AppColors.greyColor,
              ),
              userOptionFieldWidget(
                settingScreenText: AppStrings.blockConnection,
                voidCallback: () {
                  Get.toNamed(ScreenRoutesConstants.blockedConnectionScreen);
                },
              ),
              const Divider(
                thickness: 1.0,
                color: AppColors.greyColor,
              ),
              userOptionFieldWidget(
                settingScreenText: AppStrings.deleteAccount,
                voidCallback: () {
                  DialogComponent.showAlert(
                    context,
                    message: AppStrings.deleteAccountMessage,
                    title: AppStrings.appName,
                    arrButton: [AppStrings.cancel, AppStrings.confirm],
                    barrierDismissible: true,
                    callback: (btnIndex) async {
                      if (btnIndex == 1) {
                        CommonApiFunction.deleteUserAccountApi(
                            onErr: (msg) {
                              SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                            },
                            context: context);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///User options filed widget
  Widget userOptionFieldWidget({required settingScreenText, required VoidCallback voidCallback}) {
    return InkWell(
      onTap: voidCallback,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 8.0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              settingScreenText,
              style: ISOTextStyles.openSenseSemiBold(size: 14, color: AppColors.darkBlackColor),
            ),
            ImageComponent.loadLocalImage(imageName: AppImages.rightArrow, height: 10.w, width: 6.w, boxFit: BoxFit.contain),
          ],
        ),
      ),
    );
  }

  ///About Setting widget
  Widget aboutSettingOptionWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0.r),
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.greyColor,
              blurRadius: 4.0.r,
              spreadRadius: 2.0.r,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.h),
          child: Column(
            children: [
              userOptionFieldWidget(
                settingScreenText: AppStrings.privacyPolicyText,
                voidCallback: () {
                  Get.toNamed(ScreenRoutesConstants.privacyPolicyScreen, arguments: 'PP');
                },
              ),
              const Divider(
                thickness: 1.0,
                color: AppColors.greyColor,
              ),
              userOptionFieldWidget(
                settingScreenText: AppStrings.termsOfUseText,
                voidCallback: () {
                  Get.toNamed(ScreenRoutesConstants.termsConditionScreen, arguments: 'TC');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

/*redirectToTermsScreen(int index) {
    Get.to(
      WebViewPage(
        htmlText: userSettingController.cmsList[index].cmsText ?? '',
        url: '',
        titleText: AppStrings.termsOfUseText,
      ),
    );
  }*/
}
