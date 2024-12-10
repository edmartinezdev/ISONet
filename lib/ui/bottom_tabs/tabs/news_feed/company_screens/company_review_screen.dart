
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/company_controller/company_reviewlist_controller.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../../style/appbar_components.dart';
import '../../../../style/showloader_component.dart';

class ListCompanyReview extends StatefulWidget {
  const ListCompanyReview({Key? key}) : super(key: key);

  @override
  State<ListCompanyReview> createState() => _ListCompanyReviewState();
}

class _ListCompanyReviewState extends State<ListCompanyReview> {
  CompanyReviewController companyReviewController = Get.find<CompanyReviewController>();

  //CompanyProfileController companyProfileController = Get.find<CompanyProfileController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) =>

          // ignore: use_build_context_synchronously
          ShowLoaderDialog.showLoaderDialog(context),
    );
    companyReviewController.companyReviewListApi(companyId: companyReviewController.companyId, isShowLoader: true);
    super.initState();
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
    return AppBarComponents.appBar(
      titleWidget: Text(
        AppStrings.reviews,
        style: ISOTextStyles.openSenseSemiBold(size: 17),
      ),
      centerTitle: true,
    );
  }

  ///Widget Scaffold
  Widget buildBody() {
    return SafeArea(
      child: Obx(
        () => RefreshIndicator(
          onRefresh: () async {
            companyReviewController.companyReviewList.clear();
            companyReviewController.pageLimit.value = 1;
            companyReviewController.isAllDataLoaded.value = false;
            companyReviewController.isFullScreenLoader.value = false;
            companyReviewController.companyReviewListApi(companyId: companyReviewController.companyId);
          },
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
            controller: companyReviewController.scrollController,
            physics: const ClampingScrollPhysics(),
            itemCount: companyReviewController.isAllDataLoaded.value ? companyReviewController.companyReviewList.length + 1 : companyReviewController.companyReviewList.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == companyReviewController.companyReviewList.length) {
                Future.delayed(
                  const Duration(milliseconds: 100),
                  () async {
                    await _handleLoadMoreList();
                  },
                );
                return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
              }

              return Obx(
                () => Container(
                  padding: EdgeInsets.only(top: 10.0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(

                        leading: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              child: ImageComponent.circleNetworkImage(
                                  imageUrl: companyReviewController.companyReviewList[index].reviewBy?.profileImg ?? '', height: 36.w, width: 36.w),
                            ),


                            Visibility(
                              visible: companyReviewController.companyReviewList[index].reviewBy?.isVerified == true,
                              child: Positioned(
                                bottom: 4.h,
                                right: 4.w,
                                child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, height: 12.h, width: 12.w, boxFit: BoxFit.contain),
                              ),
                            ),
                            Visibility(
                              visible: companyReviewController.companyReviewList[index].reviewBy?.userType != null,
                              child: Positioned(
                                top: 4.h,
                                left: 4.w,
                                child: ImageComponent.loadLocalImage(
                                    imageName: companyReviewController.companyReviewList[index].reviewBy?.userType == AppStrings.fu
                                        ? AppImages.funderBadge
                                        : AppImages.brokerBadge,
                                    height: 12.h,
                                    width: 12.w),
                              ),
                            ),
                          ],
                        ),
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          '${companyReviewController.companyReviewList[index].reviewBy?.firstName ?? ''} ${companyReviewController.companyReviewList[index].reviewBy?.lastName ?? ''}',
                          style: ISOTextStyles.openSenseSemiBold(size: 16),
                        ),
                        subtitle: Text(
                          '${companyReviewController.companyReviewList[index].getHoursAgo} ',
                          style: ISOTextStyles.openSenseRegular(size: 10, color: AppColors.hintTextColor),
                        ),
                      ),
                      Text(companyReviewController.companyReviewList[index].review ?? ''),
                      16.sizedBoxH,
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _handleLikeButtonPress(index: index);
                            },
                            child: Container(
                              color: AppColors.transparentColor,
                              child: ImageComponent.loadLocalImage(imageName: companyReviewController.companyReviewList[index].isReviewLikeByMe.value ? AppImages.heartRed : AppImages.heartLike),
                            ),
                          ),
                          8.sizedBoxW,
                          Text(
                            '${companyReviewController.companyReviewList[index].totalReviewLike.value}',
                            style: ISOTextStyles.openSenseRegular(size: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future _handleLoadMoreList() async {
    if (!companyReviewController.isAllDataLoaded.value) return;
    if (companyReviewController.isLoadMoreRunningForViewAll) return;
    companyReviewController.isLoadMoreRunningForViewAll = true;
    await companyReviewController.reviewPagination(companyId: companyReviewController.companyId);
  }

  /// on like button press
  _handleLikeButtonPress({required int index}) async {
    if (companyReviewController.companyReviewList[index].isReviewLikeByMe.value == false) {
      var likeResponse = await companyReviewController.likeReviewApi(
        reviewId: companyReviewController.companyReviewList[index].id ?? 0,
        onSuccess: (value) {
          companyReviewController.companyReviewList[index].totalReviewLike.value = value;
          companyReviewController.companyReviewList[index].isReviewLikeByMe.value = true;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
        },
      );
      if (likeResponse) {
        companyReviewController.companyReviewList[index].isReviewLikeByMe.value = true;
      }
    } else {
      var likeResponse = await companyReviewController.unlikeReviewApi(
        reviewId: companyReviewController.companyReviewList[index].id ?? 0,
        onSuccess: (value) {
          companyReviewController.companyReviewList[index].totalReviewLike.value = value;
          companyReviewController.companyReviewList[index].isReviewLikeByMe.value = false;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
        },
      );
      if (likeResponse) {
        companyReviewController.companyReviewList[index].isReviewLikeByMe.value = false;
      }
    }
  }
}
