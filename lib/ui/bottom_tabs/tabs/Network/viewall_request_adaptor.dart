import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../bindings/bottom_tabs/user_binding/user_profile_binding.dart';
import '../../../../model/bottom_navigation_models/network_model/network_tab_model.dart';
import '../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../utils/app_common_stuffs/app_images.dart';
import '../../../style/image_components.dart';
import '../../../style/text_style.dart';
import '../news_feed/user_screens/user_profile_screen.dart';

// ignore: must_be_immutable
class ViewAllRequestAdaptor extends StatefulWidget {
  VoidCallback acceptRequestCallBack;
  VoidCallback cancelRequestCallBack;
  PendingRequest requestData;

  ViewAllRequestAdaptor({Key? key, required this.requestData, required this.acceptRequestCallBack, required this.cancelRequestCallBack}) : super(key: key);

  @override
  State<ViewAllRequestAdaptor> createState() => _ViewAllRequestAdaptorState();
}

class _ViewAllRequestAdaptorState extends State<ViewAllRequestAdaptor> with AutomaticKeepAliveClientMixin<ViewAllRequestAdaptor>{
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.only(top: 1.0.h, right: 7.0.w, left: 7.0.w, bottom: 1.0.h),
      child: GestureDetector(
        onTap: () {
          handleUserProfileTap(
            userId: widget.requestData.userId ?? 0,
          );
        },
        child: Container(
          color: AppColors.transparentColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IgnorePointer(
                child: Stack(
                  children: [
                    Container(
                      padding:const EdgeInsets.all(5.0),
                      child: ImageComponent.circleNetworkImage(
                        imageUrl: widget.requestData.profileImg ?? '',
                        height: 46.w,
                        width: 46.w,
                      ),
                    ),
                    Visibility(
                      visible: widget.requestData.isVerify == true,
                      child: Positioned(
                        bottom: 4.h,
                        right: 4.w,
                        child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, height: 13.h, width: 13.w, boxFit: BoxFit.contain),
                      ),
                    ),
                    Visibility(
                      visible: widget.requestData.userType != null,
                      child: Positioned(
                        top: 4.h,
                        left: 4.w,
                        child: ImageComponent.loadLocalImage(imageName: widget.requestData.userType == AppStrings.fu ? AppImages.funderBadge : AppImages.brokerBadge, height: 13.h, width: 13.w, boxFit: BoxFit.contain),
                      ),
                    ),
                  ],
                ),
              ),
              12.sizedBoxW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.requestData.firstName ?? ''} ${widget.requestData.lastName ?? ''}',
                      style: ISOTextStyles.sfProMedium(size: 16, color: AppColors.blackColorDetailsPage),
                    ),
                    Text(
                      widget.requestData.companyName ?? '',
                      style: ISOTextStyles.sfProDisplay(size: 10, color: AppColors.indicatorColor),
                    ),
                    12.sizedBoxH,
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(onTap: widget.cancelRequestCallBack, child: ImageComponent.loadLocalImage(imageName: AppImages.cancelRed, height: 26.w, width: 26.w, boxFit: BoxFit.contain)),
                  18.sizedBoxW,
                  GestureDetector(onTap: widget.acceptRequestCallBack, child: ImageComponent.loadLocalImage(imageName: AppImages.greenAccept, height: 26.w, width: 26.w, boxFit: BoxFit.contain)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///Handle UserProfile Navigation Function
  Future<String> handleUserProfileTap({
    required int userId,
  }) async {
    String callBack = await Get.to(
      UserProfileScreen(
        userId: userId,
      ),
      binding: UserProfileBinding(),
    );
    return callBack;
  }
}
