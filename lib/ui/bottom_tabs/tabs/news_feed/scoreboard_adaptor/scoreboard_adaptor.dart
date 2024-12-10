// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/loan_list_model.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../../utils/app_common_stuffs/commom_utils.dart';
import '../../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../../style/image_components.dart';
import '../../../../style/text_style.dart';

class ScoreBoardAdaptor extends StatelessWidget {
  int index;
  LoanData loanData;

  ScoreBoardAdaptor({Key? key, required this.index, required this.loanData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 143.w,
      /*constraints: BoxConstraints(
        minWidth: 143.w,
      ),*/
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        horizontal: 10.0.w,
      ),
      margin: EdgeInsets.only(right: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 4,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  '${index + 1}',
                  style: ISOTextStyles.openSenseRegular(
                    color: AppColors.hintTextColor,
                    size: 16,
                  ),
                ),
                13.sizedBoxW,
                CommonUtils.amountFormat(number: '${loanData.loanAmount ?? 0}'),
              ],
            ),
            12.sizedBoxH,
            loanData.createByCompanyOwner == true
                ? Row(
                    children: [
                      ImageComponent.circleNetworkImage(
                        imageUrl: loanData.createdByUser?.companyImage ?? '',
                        placeHolderImage: AppImages.backGroundDefaultImage,
                        height: 19.w,
                        width: 19.w,
                      ),
                      8.sizedBoxW,
                      Expanded(
                        child: Text(
                          ' ${loanData.createdByUser?.companyName ?? ''}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5.0),
                            child: ImageComponent.circleNetworkImage(
                              imageUrl: loanData.createdByUser?.profileImg ?? '',
                              height: 19.38.w,
                              width: 19.38.w,
                            ),
                          ),
                          Visibility(
                            visible: loanData.createdByUser?.isVerified ?? false,
                            child: Positioned(
                              bottom: 4.h,
                              right: 4.w,
                              child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, height: 7.h, width: 7.w, boxFit: BoxFit.contain),
                            ),
                          ),
                          Visibility(
                            visible: loanData.createdByUser?.userType != null,
                            child: Positioned(
                              top: 3.h,
                              left: 3.w,
                              child: ImageComponent.loadLocalImage(
                                  imageName: loanData.createdByUser?.userType == AppStrings.fu ? AppImages.funderBadge : AppImages.brokerBadge, height: 8.h, width: 8.w, boxFit: BoxFit.contain),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Text(
                          ' ${loanData.createdByUser?.firstName}'
                          ' ${loanData.createdByUser?.lastName}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      /*Container(
                  constraints: BoxConstraints(maxWidth: 80.w),
                  child: CommonUtils.buildMarquee(
                    text: ' ${loanData.createdByUser?.firstName}'
                        ' ${loanData.createdByUser?.lastName}',
                  ),
                ),*/
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
