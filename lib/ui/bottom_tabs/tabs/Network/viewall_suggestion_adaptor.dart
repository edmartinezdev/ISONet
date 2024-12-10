// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../model/bottom_navigation_models/network_model/network_tab_model.dart';
import '../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../style/container_components.dart';
import '../../../style/image_components.dart';
import '../../../style/text_style.dart';

class ViewAllSuggestionAdaptor extends StatefulWidget {
  VoidCallback userProfileOnTap;
  VoidCallback connectButtonTap;
  ConnectionSuggestion suggestionData;

  ViewAllSuggestionAdaptor({Key? key, required this.suggestionData, required this.userProfileOnTap, required this.connectButtonTap}) : super(key: key);

  @override
  State<ViewAllSuggestionAdaptor> createState() => _ViewAllSuggestionAdaptorState();
}

class _ViewAllSuggestionAdaptorState extends State<ViewAllSuggestionAdaptor> with AutomaticKeepAliveClientMixin<ViewAllSuggestionAdaptor>{
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: widget.userProfileOnTap,
      child: ContainerComponents.elevatedContainer(
        borderRadius: 8.0.r,
        height: 225.0.h,
        backGroundColor: AppColors.whiteColor,
        width: 225.0.h,
        context: context,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(padding: EdgeInsets.only(top: 10.h)),
            IgnorePointer(
              child: Stack(
                children: [
                  Container(
                    padding:const EdgeInsets.all(5.0),
                    child: ImageComponent.circleNetworkImage(
                      imageUrl: widget.suggestionData.profileImg ?? '',
                      height: 72.w,
                      width: 72.w,
                    ),
                  ),

                  Visibility(
                    visible: widget.suggestionData.isVerify == true,
                    child: Positioned(
                      bottom: 5.h,
                      right: 5.w,
                      child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, height: 18.w, width: 18.w, boxFit: BoxFit.contain),
                    ),
                  ),
                  Visibility(
                    visible: widget.suggestionData.userType != null,
                    child: Positioned(
                      top: 5.h,
                      left: 5.w,
                      child: ImageComponent.loadLocalImage(imageName: widget.suggestionData.userType == AppStrings.fu ? AppImages.funderBadge : AppImages.brokerBadge, height: 18.w, width: 18.w, boxFit: BoxFit.contain),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.suggestionData.firstName ?? ''} ${widget.suggestionData.lastName ?? ''}',
                    style: ISOTextStyles.openSenseSemiBold(size: 14, color: AppColors.blackColorDetailsPage),
                    textAlign: TextAlign.center,
                  ),
                  5.sizedBoxH,
                  Text(
                    widget.suggestionData.companyName ?? '',
                    style: ISOTextStyles.openSenseRegular(size: 12, color: AppColors.chatMessageSuggestionColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: widget.connectButtonTap,
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: EdgeInsets.only(left: 8.0.w, top: 4.0.h, right: 8.0.w, bottom: 5.0.h),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.0.r), border: Border.all(color: AppColors.connectContainerColor, width: 2.0)),
                child: Obx(() => Text(
                      widget.suggestionData.connectStatus.value == 'NotConnected' ? AppStrings.connect : 'Requested',
                      style: ISOTextStyles.openSenseSemiBold(size: 14, color: AppColors.headingTitleColor),
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.h),
            ),
          ],
        ),
      ),
    );
  }
}
