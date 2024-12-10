import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/user/subscribe_controller.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/style/button_components.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_fonts.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../utils/app_common_stuffs/app_images.dart';
import '../../utils/app_common_stuffs/commom_utils.dart';
import '../../utils/app_common_stuffs/snackbar_util.dart';
import '../../utils/network_util.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  SubscribeController subscribeController = Get.find();
  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // var anc = await FlutterInappPurchase.instance.getPendingTransactionsIOS();
      // anc?.forEach((element) {
      //    FlutterInappPurchase.instance.finishTransactionIOS(element.transactionId ?? "");
      // });
      ShowLoaderDialog.showLoaderDialog(context);
      await subscribeController.subscriptionApiCall();
      subscribeController.introScreenQna.value = [
        'Get Access to the Member-Exclusive Network',
        'Explore the Forum For Opportunities & Updates',
        'Connect with Brokers & Funders and Build Your Network',
      ];
    });

    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Logger().i(userSingleton.token);
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(body: buildBody()
          /*SingleChildScrollView(
          child: Column(
            children: [
              topBarImageBody(),
              //annualSubscriptionBody(),
              annualSubscriptionBody2(),
              subscribeButtonBody(),
              paymentTerm(),
            ],
          ),
        ),*/
          ),
    );
  }

  Widget buildBody() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.zero,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(childCount: 1, (BuildContext context, int index) {
              return Obx(
                () => Column(
                  children: [
                    topBarImageBody(),
                    pageViewBody(),
                    indicatorBody(),
                    annualSubscriptionBody2(),
                    subscribeButtonBody(),
                    paymentTerm(),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  ///PageView with title inFos
  Widget pageViewBody() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: PageView.builder(
        itemCount: subscribeController.introScreenQna.length,
        scrollDirection: Axis.horizontal,
        controller: pageController,
        onPageChanged: (value) {
          subscribeController.currentPage.value = value;
        },
        itemBuilder: (BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 50.0.w),
            child: Text(
              subscribeController.introScreenQna[index],
              style: ISOTextStyles.sfProSemiBold(size: 24, color: AppColors.blackColor),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }

  ///PageView indicator
  Widget indicatorBody() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
            3,
            (index) {
              return GestureDetector(
                onTap: () => subscribeController.onTapIndicator(index: index, pageController: pageController),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0.w),
                  height: 5,
                  width: 35,
                  decoration: BoxDecoration(
                    color: subscribeController.changeIndicatorColor(index),
                    borderRadius: BorderRadius.circular(12.0.r),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  ///Isonet Image widget
  Widget topBarImageBody() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ImageComponent.loadLocalImage(imageName: AppImages.headBackground, boxFit: BoxFit.fill, width: double.infinity, height: MediaQuery.of(context).size.height * 0.30),
          ImageComponent.loadLocalImage(
            imageName: AppImages.blackLogo,
          ),
          Positioned(
              top: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 32.0.h),
                child: IconButton(
                    onPressed: () async {
                      await FlutterInappPurchase.instance.finalize();
                      subscribeController.connectionSubscription?.cancel();
                      subscribeController.purchaseUpdatedSubscription?.cancel();
                      subscribeController.purchaseUpdatedSubscription = null;
                      subscribeController.purchaseErrorSubscription?.cancel();
                      subscribeController.purchaseErrorSubscription = null;
                      subscribeController.isUpgrade == null || userSingleton.isSubscribed == false
                          ? CommonUtils.buildExitAlert(context: context)
                          : subscribeController.isUpgrade == true
                              ? Get.back()
                              : redirectToLoginScreen();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                    )),
              )),
        ],
      ),
    );
  }

  ///Month & year subscription price widget
  Widget annualSubscriptionBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      height: MediaQuery.of(context).size.height * 0.30,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: subscribeController.subscriptionBoxList.length,
        itemBuilder: (BuildContext context, int index) {
          return Obx(
            () => priceContainerWidget(
              priceText: subscribeController.subscriptionBoxList[index].priceText ?? '',
              monthYearText: subscribeController.subscriptionBoxList[index].monthYearText ?? '',
              freeTrialText: subscribeController.subscriptionBoxList[index].freeTrialText ?? '',
              onTap: () {
                //subscribeController.onSubscribeButtonPressed(index: index);
                subscribeController.onSubscribeButtonPressed2(index: index);
                subscribeController.priceSelectIndex.value = index;
                subscribeController.isEnable.value = subscribeController.subscriptionBoxList[index].isCardSelected.value;
              },
              borderColor: subscribeController.subscriptionBoxList[index].isCardSelected.value == true ? AppColors.primaryColor : null,
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return 16.sizedBoxH;
        },
      ),
    );
  }

  ///Practice
  Widget annualSubscriptionBody2() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 20.0.h),
      child: Obx(
        () => ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: subscribeController.subscriptionList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return Obx(
              () => priceContainerWidget(
                priceText: '\$${subscribeController.subscriptionList[index].price ?? ''}',
                monthYearText: ('/${subscribeController.subscriptionList[index].type ?? ''}').toLowerCase(),
                freeTrialText: '30 Day Free Trial',
                onTap: () {
                  //subscribeController.onSubscribeButtonPressed(index: index);
                  subscribeController.onSubscribeButtonPressed2(index: index);
                  subscribeController.priceSelectIndex.value = index;
                  subscribeController.isEnable.value = subscribeController.subscriptionList[index].isCardSelected.value;
                },
                borderColor: subscribeController.subscriptionList[index].isCardSelected.value == true ? AppColors.primaryColor : null,
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return 16.sizedBoxH;
          },
        ),
      ),
    );
  }

  ///Extract widget of annual subscription body
  Widget priceContainerWidget({
    required String priceText,
    required String monthYearText,
    required String freeTrialText,
    required VoidCallback onTap,
    Color? borderColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0.r),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          height: MediaQuery.of(context).size.height * 0.10,
          decoration: BoxDecoration(
            //color: backgroundColor,
            borderRadius: BorderRadius.circular(8.0.r),
            border: Border.all(
              width: 1.5.r,
              color: borderColor ?? AppColors.greyColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: priceText,
                  style: ISOTextStyles.sfProBold(
                    size: 30,
                  ),
                  children: [
                    TextSpan(
                      text: ' $monthYearText',
                      style: ISOTextStyles.sfProMedium(
                        size: 14,
                        color: AppColors.blueGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 4.0.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0.r),
                  color: Colors.red,
                ),
                child: Text(
                  freeTrialText,
                  style: ISOTextStyles.sfProMedium(
                    size: 12,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///Subscribe Button Body
  Widget subscribeButtonBody() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.0.w,
        ),
        height: MediaQuery.of(context).size.height * 0.10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonComponents.cupertinoButton(
                context: context,
                title: AppStrings.subscribe,
                onTap: subscribeController.isEnable.value ? () => subscribeButtonPressed() : null,
                backgroundColor: subscribeController.isEnable.value ? AppColors.blackColor : AppColors.greyColor,
                width: double.infinity,
                textColor: subscribeController.isEnable.value ? AppColors.whiteColor : AppColors.disableTextColor,
                textSize: 17),
          ],
        ),
      ),
    );
  }

  subscribeButtonPressed() async {
    //if (Platform.isIOS) {
    if (await NetworkUtil.isNetworkConnected() == false) {
      SnackBarUtil.showSnackBar(context: context, type: SnackType.warning, message: 'No Internet connection');
      return;
    }
    subscribeController.requestPurchase(
      planId: subscribeController.subscriptionList[subscribeController.priceSelectIndex.value].plan ?? '',
    );
  }

  ///Payment term text widget
  Widget paymentTerm() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 20.0.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Platform.isIOS
              ? ButtonComponents.textButton(
                  context: context,
                  onTap: () {
                    subscribeController.getPurchases2();
                  },
                  title: AppStrings.restorePurchase,
                  textColor: AppColors.hintTextColor,
                  textStyle: TextStyle(
                    decoration: TextDecoration.underline,
                    fontFamily: AppFont.sfProTextMedium,
                    fontSize: 12.sp,
                  ),
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonComponents.textButton(
                context: context,
                onTap: () {
                  Get.toNamed(ScreenRoutesConstants.termsConditionScreen, arguments: 'TC');
                },
                title: AppStrings.termsOfUse,
                textColor: AppColors.blackColor,
                textStyle: TextStyle(
                  decoration: TextDecoration.underline,
                  fontFamily: AppFont.sfProTextMedium,
                  fontSize: 12.sp,
                ),
              ),
              ButtonComponents.textButton(
                context: context,
                onTap: () {
                  Get.toNamed(ScreenRoutesConstants.privacyPolicyScreen, arguments: 'PP');
                },
                title: AppStrings.privacyPolicy,
                textColor: AppColors.blackColor,
                textStyle: TextStyle(
                  decoration: TextDecoration.underline,
                  fontFamily: AppFont.sfProTextMedium,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
            child: Platform.isIOS
                ? Text(
                    AppStrings.paymentTerm,
                    textAlign: TextAlign.center,
                    style: ISOTextStyles.sfProTextLight(color: AppColors.disableTextColor, size: 10),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  redirectToLoginScreen() {
    Get.offAllNamed(ScreenRoutesConstants.signInScreen);
  }
}
