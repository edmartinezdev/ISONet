import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/authentication/startup_screen_controller.dart';
import 'package:iso_net/ui/style/button_components.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({Key? key}) : super(key: key);

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  StartupScreenController startupScreenController = Get.find<StartupScreenController>();
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
      child: Scaffold(
        body: buildBody(),
      ),
    );
  }

  ///Scaffold body
  Widget buildBody() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          topBody(),
          bottomBody(),
        ],
      ),
    );
  }

  ///Top body header & app icon
  Widget topBody() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      color: AppColors.brownColor,
      child: ImageComponent.loadLocalImage(
        boxFit: BoxFit.cover,
        imageName: AppImages.maskGroup2,
      ),
    );
  }

  ///Bottom body
  Widget bottomBody() {
    return Obx(
      () => SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          children: [
            pageViewBody(),
            indicatorBody(),
            getStartedBody(),
            signInButtonBody(),
          ],
        ),
      ),
    );
  }

  ///PageView with title inFos
  Widget pageViewBody() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.20,
      child: PageView.builder(
        itemCount: startupScreenController.introScreenQna.length,
        scrollDirection: Axis.horizontal,
        controller: pageController,
        onPageChanged: (value) {
          startupScreenController.currentPage.value = value;
        },
        itemBuilder: (BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 64.0.w),
            child: Text(
              startupScreenController.introScreenQna[index],
              style: ISOTextStyles.sfProSemiBold(size: 24, color: AppColors.blackColor),
              textAlign: TextAlign.center,
              maxLines: 3,
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
                onTap: () => startupScreenController.onTapIndicator(index: index, pageController: pageController),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0.w),
                  height: 5,
                  width: 35,
                  decoration: BoxDecoration(
                    color: startupScreenController.changeIndicatorColor(index),
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

  ///Button - get started
  Widget getStartedBody() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonComponents.cupertinoButton(
            context: context,
            title: AppStrings.getStarted,
            backgroundColor: AppColors.primaryColor,
            onTap: () => Get.toNamed(ScreenRoutesConstants.funderBrokerScreen),
          ),
        ],
      ),
    );
  }

  ///Button - sign in
  Widget signInButtonBody() {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height * 0.10,
      child: Column(
        children: [
          ButtonComponents.textButton(
            context: context,
            onTap: () => Get.toNamed(ScreenRoutesConstants.signInScreen),
            title: AppStrings.bSignIn,
            textColor: AppColors.blackColor,
            textStyle: ISOTextStyles.sfProMedium(
              size: 17,
              color: AppColors.disableTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
