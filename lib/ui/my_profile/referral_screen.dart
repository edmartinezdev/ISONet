import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/my_profile/my_profile_controller.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/app_common_stuffs/app_colors.dart';
import '../../utils/app_common_stuffs/app_images.dart';
import '../style/appbar_components.dart';
import '../style/text_style.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  MyProfileController myProfileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: appBarBody(),
      body: buildBody(),
    );
  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      backgroundColor: AppColors.refferalBackgroundColor,
    );
  }

  ///Scaffold body
  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          0.sizedBoxH,
          ImageComponent.loadLocalImage(imageName: AppImages.referFriendLowHeight, boxFit: BoxFit.fitWidth, width: double.infinity),
          16.sizedBoxH,
          Text(
            AppStrings.referFrnd,
            style: ISOTextStyles.sfProSemiBold(size: 24, color: AppColors.darkBlackColor),
          ),
          16.sizedBoxH,
          Text(
            AppStrings.referQuotes,
            style: ISOTextStyles.sfProDisplayLight(size: 14, color: AppColors.refferalText),
            textAlign: TextAlign.center,
          ),
          24.sizedBoxH,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 28.0.w, vertical: 8.0.h),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: AppColors.greyColor),
                child: Text(
                  myProfileController.myProfileData.value?.referralCode ?? '',
                  style: ISOTextStyles.sfProDisplayLight(size: 16, color: AppColors.darkBlackColor),
                ),
              ),
              8.sizedBoxW,
              GestureDetector(
                onTap: () {
                  shareLink(referralCode: myProfileController.myProfileData.value?.referralCode ?? '');
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 14.0.w, vertical: 10.0.h),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: AppColors.primaryColor),
                  child: ImageComponent.loadLocalImage(imageName: AppImages.blackShare),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  shareLink({required String referralCode}) {
    final box = context.findRenderObject() as RenderBox?;
    return Share.share(
        "Ready to expand your network and connect with fellow brokers and funders? \n\n"
        'Open the door to new funding opportunities, unique insights, and resources. \n\n'
        'Embrace the power of networking with The ISO Net using this referral link : \nhttps://onelink.to/xtepdx \n\n'
        'Your Referral code is : $referralCode',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }
}
