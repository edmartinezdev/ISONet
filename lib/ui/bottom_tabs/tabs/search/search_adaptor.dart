// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../model/bottom_navigation_models/search_model/global_search_model.dart';
import '../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../utils/app_common_stuffs/common_api_function.dart';
import '../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../style/image_components.dart';
import '../../../style/text_style.dart';

///********* Global search company adaptor *******///
class SearchCompanyAdaptor extends StatefulWidget {
  VoidCallback companyProfileTapEvent;
  GlobalForumFeedArticle searchData;

  SearchCompanyAdaptor({
    Key? key,
    required this.companyProfileTapEvent,
    required this.searchData,
  }) : super(key: key);

  @override
  State<SearchCompanyAdaptor> createState() => _SearchCompanyAdaptorState();
}

class _SearchCompanyAdaptorState extends State<SearchCompanyAdaptor> with AutomaticKeepAliveClientMixin<SearchCompanyAdaptor> {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return /*Obx(*/
        /*()=>*/ GestureDetector(
      onTap: widget.companyProfileTapEvent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 11.0.h),
        margin: EdgeInsets.symmetric(horizontal: 7.0.w, vertical: 4.0.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyColor),
          borderRadius: BorderRadius.circular(8.0),
          color: AppColors.transparentColor,
        ),
        child: Row(
          children: [
            IgnorePointer(
              child: ImageComponent.circleNetworkImage(
                imageUrl: widget.searchData.globalSearchData?.companyImage ?? '',
                height: 94.w,
                width: 94.w,
                placeHolderImage: AppImages.backGroundDefaultImage,
              ),
            ),
            16.sizedBoxW,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.searchData.globalSearchData?.companyName ?? '',
                    style: ISOTextStyles.openSenseSemiBold(
                      size: 16,
                      color: AppColors.headingTitleColor,
                    ),
                  ),
                  Text(
                    (widget.searchData.globalSearchData?.totalReviews ?? 0) != 1
                        ? '${widget.searchData.globalSearchData?.totalReviews ?? 0} ${AppStrings.reviews}'
                        : '${widget.searchData.globalSearchData?.totalReviews ?? 0} ${AppStrings.review}',
                    style: ISOTextStyles.openSenseSemiBold(size: 11, color: AppColors.hintTextColor),
                  ),
                  Text(
                    widget.searchData.globalSearchData?.address ?? '',
                    style: ISOTextStyles.openSenseRegular(size: 10, color: AppColors.hintTextColor),
                  ),
                  28.sizedBoxH
                ],
              ),
            )
          ],
        ),
      ),
    );
    /*);*/
  }
}

///********* Global search funder broker adaptor *******///

class SearchBrokerFunderAdaptor extends StatefulWidget {
  VoidCallback userProfileTapEvent;
  GlobalForumFeedArticle searchData;

  SearchBrokerFunderAdaptor({Key? key, required this.searchData, required this.userProfileTapEvent}) : super(key: key);

  @override
  State<SearchBrokerFunderAdaptor> createState() => _SearchBrokerFunderAdaptorState();
}

class _SearchBrokerFunderAdaptorState extends State<SearchBrokerFunderAdaptor> with AutomaticKeepAliveClientMixin<SearchBrokerFunderAdaptor> {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return /*Obx(*/
        /*() =>*/ GestureDetector(
      onTap: widget.userProfileTapEvent,
      child: Container(
        //padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 12.0.h),
        margin: EdgeInsets.symmetric(horizontal: 7.0.w, vertical: 4.0.h),
        decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.greyColor,
            ),
            borderRadius: BorderRadius.circular(8.0),
            color: AppColors.transparentColor),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(right: 15.0.w, top: 11.0.h, bottom: 11.0.h, left: 15.0.w),
              child: IgnorePointer(
                child: Stack(
                  //alignment: Alignment.bottomCenter,
                  children: [
                    ImageComponent.circleNetworkImage(imageUrl: widget.searchData.globalSearchData?.profileImg ?? '', height: 94.w, width: 94.w),
                    Visibility(
                      visible: widget.searchData.globalSearchData?.isVerified ?? false,
                      child: Positioned(
                        bottom: 4.h,
                        right: 4.w,
                        child: ImageComponent.loadLocalImage(
                          imageName: AppImages.verifyLogo,
                          height: 20.w,
                          width: 20.w,
                          boxFit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.searchData.globalSearchData?.userType != null,
                      child: Positioned(
                        top: 4.h,
                        left: 4.w,
                        child: ImageComponent.loadLocalImage(
                            imageName: widget.searchData.globalSearchData?.userType == AppStrings.fu ? AppImages.funderBadge : AppImages.brokerBadge,
                            height: 20.h,
                            width: 20.w,
                            boxFit: BoxFit.contain),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 19.0.h,
                bottom: 19.0.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.searchData.globalSearchData?.firstName ?? ''} ${widget.searchData.globalSearchData?.lastName ?? ''}',
                        style: ISOTextStyles.openSenseRegular(size: 16, color: AppColors.headingTitleColor),
                      ),
                      4.sizedBoxH,
                      Text(
                        widget.searchData.globalSearchData?.companyName ?? '',
                        style: ISOTextStyles.openSenseLight(size: 10, color: AppColors.hintTextColor),
                      ),
                    ],
                  ),
                  widget.searchData.globalSearchData?.companyName != null ? 10.sizedBoxH : 0.sizedBoxH,
                  Obx(
                    () => widget.searchData.globalSearchData?.isConnected.value == 'Connected'
                        ? 0.sizedBoxH
                        : GestureDetector(
                            onTap: () async {
                              var apiResult = await CommonApiFunction.commonConnectApi(
                                  userId: widget.searchData.globalSearchData?.userId ?? 0,
                                  onErr: (msg) {
                                    SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                  });
                              if (apiResult) {
                                widget.searchData.globalSearchData?.isConnected.value = 'Requested';
                              }
                            },
                            child: Row(
                              children: [
                                Image.asset(
                                  widget.searchData.globalSearchData?.isConnected.value == 'NotConnected' ? AppImages.plus : AppImages.check,
                                  height: widget.searchData.globalSearchData?.isConnected.value == 'NotConnected' ? 12.w : 12.w,
                                  width: widget.searchData.globalSearchData?.isConnected.value == 'NotConnected' ? 12.w : 12.w,
                                  fit: BoxFit.contain,
                                ),
                                3.sizedBoxW,
                                Text(
                                  widget.searchData.globalSearchData?.isConnected.value == 'NotConnected' ? 'Connect' : 'Requested',
                                  style: ISOTextStyles.openSenseSemiBold(size: 14, color: AppColors.headingTitleColor),
                                )
                              ],
                            ),
                          ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
    /*);*/
  }
}
