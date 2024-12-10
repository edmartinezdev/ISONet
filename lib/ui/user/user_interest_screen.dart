import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/user/user_backimage_controller.dart';
import 'package:iso_net/controllers/user/user_interest_controller.dart';
import 'package:iso_net/controllers/user/user_profileimage_controller.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';

import '../../utils/app_common_stuffs/screen_routes.dart';
import '../../utils/app_common_stuffs/strings_constants.dart';
import '../style/appbar_components.dart';
import '../style/button_components.dart';
import '../style/text_style.dart';

// ignore: must_be_immutable
class UserInterestScreen extends StatefulWidget {
  ///******isEdit use for when user want to update his interest through his profile *****///
  bool? isEditInterest;
  bool? isSkipBackGroundImage;
  List<int>? tagId;

  UserInterestScreen({Key? key, this.isEditInterest, this.tagId,this.isSkipBackGroundImage}) : super(key: key);

  @override
  State<UserInterestScreen> createState() => _UserInterestScreenState();
}

class _UserInterestScreenState extends State<UserInterestScreen> {
  final UserInterestController userInterestController = Get.find<UserInterestController>();

  @override
  void initState() {
    // if(widget.isEditInterest == false){
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) { ShowLoaderDialog.showLoaderDialog(context,);});
    //   userInterestController.fetchInterestChips(onErr: (msg){
    //     SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
    //   },tag: widget.tagId,isEditInterest: widget.isEditInterest ?? false);
    // }
    if (widget.isEditInterest == false) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ShowLoaderDialog.showLoaderDialog(
          context,
        );
      });
      userInterestController.fetchFeedCategory(tag: widget.tagId, isEditInterest: widget.isEditInterest ?? false);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBody(),
      body: buildBody(),
    );
  }

  ///Appbar Body
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar();
  }

  ///Scaffold Body
  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        headingBody(),
        categoryChipsBuilder(),
        widget.isEditInterest ?? false ? Container() : nextButtonBody(),
      ],
    );
  }

  ///title-heading body
  Widget headingBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              AppStrings.interests,
              style: ISOTextStyles.openSenseBold(size: 20),
            ),
          ),
          Visibility(
            visible: widget.isEditInterest == false,
            child: InkWell(
              onTap: () {
                handleNextButtonPress(isSkip: true);
              },
              child: Text(
                AppStrings.skip,
                style: ISOTextStyles.openSenseRegular(size: 17, color: AppColors.disableTextColor),
              ),
            ),
          )
        ],
      ),
    );
  }

  ///Dev :- As of now we use category list for user interest select
  /// Widget :- categoryChipsBuilder
  ///Interest chip builder
  Widget interestChipsBuilder() {
    return Obx(
      () => Expanded(
        child: SingleChildScrollView(
          child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
              child: Wrap(
                runSpacing: 10.0,
                spacing: 10.0,
                children: [
                  ...List.generate(userInterestController.interestChipsList.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        userInterestController.onInterestTap(index);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 16.0.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0.r),
                          color: userInterestController.interestChipsList[index].isSelected.value ? AppColors.primaryColor : AppColors.lightGreyColor,
                        ),
                        child: Text(
                          userInterestController.interestChipsList[index].tagName ?? '',
                          style: ISOTextStyles.openSenseSemiBold(size: 14),
                        ),
                      ),
                    );
                  })
                ],
              )),
        ),
      ),
    );
  }

  ///Category Interest chip builder
  Widget categoryChipsBuilder() {
    return Obx(
      () => Expanded(
        child: SingleChildScrollView(
          child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
              child: Wrap(
                runSpacing: 10.0,
                spacing: 10.0,
                children: [
                  ...List.generate(userInterestController.categoryChipList.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        userInterestController.onCategoryTap(index);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 16.0.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0.r),
                          color: userInterestController.categoryChipList[index].isCategorySelect.value ? AppColors.primaryColor : AppColors.lightGreyColor,
                        ),
                        child: Text(
                          userInterestController.categoryChipList[index].categoryName ?? '',
                          style: ISOTextStyles.openSenseSemiBold(size: 14),
                        ),
                      ),
                    );
                  })
                ],
              )),
        ),
      ),
    );
  }

  /// next button body
  Widget nextButtonBody() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 32.0.h),
        child: ButtonComponents.cupertinoButton(
          width: double.infinity,
          context: context,
          title: AppStrings.bNext,
          backgroundColor: userInterestController.selectedCategoryList.isEmpty ? AppColors.disableButtonColor : AppColors.primaryColor,
          textStyle: userInterestController.selectedCategoryList.isEmpty
              ? ISOTextStyles.openSenseRegular(size: 17, color: AppColors.disableTextColor)
              : ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.blackColor),
          onTap: userInterestController.selectedCategoryList.isEmpty
              ? null
              : () {
                  handleNextButtonPress(isSkip: false);
                },
        ),
      ),
    );
  }

  /// Function on next button will go here
  handleNextButtonPress({bool? isSkip}) async {
    UserProfileImageController userProfileImageController = Get.find<UserProfileImageController>();
    UserBackImageController userBackImageController = Get.find<UserBackImageController>();
    var signUpStage4Result = await userInterestController.apiCallSignUpStage4(
      isSkip: isSkip,
      profileImage: userProfileImageController.file,
      backGroundImage: widget.isSkipBackGroundImage == true ? [] : userBackImageController.file,
      onErr: (msg) => SnackBarUtil.showSnackBar(
        context: context,
        type: SnackType.error,
        message: msg,
      ),
    );

    if (signUpStage4Result) {
      Get.offAllNamed(ScreenRoutesConstants.signUpCompletedScreen);
    }
  }
}
