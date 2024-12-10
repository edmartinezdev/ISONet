
// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iso_net/model/bottom_navigation_models/network_model/viewmy_network_model.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../../utils/app_common_stuffs/strings_constants.dart';

class CreateNewMessageAdaptor extends StatefulWidget {
  NetworkData objOfCreateMessage;
  VoidCallback callback;

  CreateNewMessageAdaptor({Key? key, required this.objOfCreateMessage, required this.callback}) : super(key: key);

  @override
  State<CreateNewMessageAdaptor> createState() => _CreateNewMessageAdaptorState();
}

class _CreateNewMessageAdaptorState extends State<CreateNewMessageAdaptor> with AutomaticKeepAliveClientMixin<CreateNewMessageAdaptor> {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        widget.callback();
      },
      child: Container(
        color: AppColors.transparentColor,
        padding: EdgeInsets.symmetric(horizontal: 8.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IgnorePointer(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: ImageComponent.circleNetworkImage(
                      imageUrl: widget.objOfCreateMessage.profileImg ?? '',
                      height: 45.w,
                      width: 45.w,
                    ),
                  ),
                  Visibility(
                    visible: widget.objOfCreateMessage.isVerify == true,
                    child: Positioned(
                      bottom: 5.h,
                      right: 5.w,
                      child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, width: 12.w, height: 12.w, boxFit: BoxFit.contain),
                    ),
                  ),
                  Visibility(
                    visible: widget.objOfCreateMessage.userType != null,
                    child: Positioned(
                      top: 4.h,
                      left: 4.w,
                      child: ImageComponent.loadLocalImage(
                          imageName: widget.objOfCreateMessage.userType == AppStrings.fu ? AppImages.funderBadge : AppImages.brokerBadge, height: 12.w, width: 12.w, boxFit: BoxFit.contain),
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
                    '${widget.objOfCreateMessage.firstName ?? ''} ${widget.objOfCreateMessage.lastName ?? ''}',
                    style: ISOTextStyles.openSenseSemiBold(size: 14, color: AppColors.chatHeadingName),
                  ),
                  Text(
                    widget.objOfCreateMessage.companyName ?? '',
                    style: ISOTextStyles.openSenseRegular(size: 12, color: AppColors.chatMessageSuggestionColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    /*ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 8.0.w),
      onTap: () {
        widget.callback();
      },
      leading: ImageComponent.circleNetworkImage(
        imageUrl: widget.objOfCreateMesage.profileImg ?? '',
        height: 45.w,
        width: 45.w,
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.objOfCreateMesage.firstName ?? ''} ${widget.objOfCreateMesage.lastName ?? ''}'),
          Text(
            widget.objOfCreateMesage.companyName ?? '',
            style: ISOTextStyles.openSenseRegular(size: 12, color: AppColors.chatMessageSuggestionColor),
          ),
        ],
      ),
    );*/
  }
}
