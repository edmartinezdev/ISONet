import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/my_profile/my_profile_controller.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/style/button_components.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/ui/style/textfield_components.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';

import '../../utils/app_common_stuffs/app_colors.dart';
import '../../utils/app_common_stuffs/app_images.dart';
import '../../utils/app_common_stuffs/strings_constants.dart';
import '../style/image_components.dart';
import '../style/text_style.dart';

class UserSubscriptionScreen extends StatefulWidget {
  const UserSubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<UserSubscriptionScreen> createState() => _UserSubscriptionScreenState();
}

class _UserSubscriptionScreenState extends State<UserSubscriptionScreen> {
  MyProfileController myProfileController = Get.find();
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await refreshUserApiCall();
    });
    updatePlanType();
    super.initState();

  }

  void updatePlanType() {
    if (myProfileController.myProfileData.value?.currentSubscriptionType == 'MO') {
      textEditingController.text = AppStrings.monthly;
    } else {
      textEditingController.text = AppStrings.yearly;
    }
  }

  Future<void> refreshUserApiCall() async {
    ShowLoaderDialog.showLoaderDialog(context);
    await myProfileController.fetchProfileDataApi(userId: userSingleton.id ?? -1,isShowLoading: true);
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
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: ImageComponent.loadLocalImage(
          imageName: AppImages.arrow,
        ),
      ),
      title: Text(
        AppStrings.subscriptionText,
        style: ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.headingTitleColor),
      ),
      centerTitle: true,
    );
  }

  Widget buildBody() {
    return Container(
      padding: EdgeInsets.only(left: 8.0.w, top: 29.0.h,right: 8.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0.w),
            child: Text(
              AppStrings.currentSub,
              style: ISOTextStyles.openSenseRegular(size: 12, color: AppColors.headingTitleColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 24.0.h),
            child: TextFieldComponents(
              context: context,
              enable: false,
              textEditingController: textEditingController,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 55.0.h),
            child: ButtonComponents.textButton(
                context: context,
                onTap: () async {
                  await Get.toNamed(ScreenRoutesConstants.subscribeScreen, arguments: true);
                  await refreshUserApiCall();
                  updatePlanType();
                },
                title: AppStrings.manage,
                alignment: Alignment.center,
                textStyle: ISOTextStyles.openSenseBold(size: 13, color: AppColors.headingTitleColor)),
          ),
        ],
      ),
    );
  }
}
