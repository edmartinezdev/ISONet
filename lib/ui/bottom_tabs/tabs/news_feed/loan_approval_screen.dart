import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/loan_approval_controller.dart';
import 'package:iso_net/ui/style/appbar_components.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../style/image_components.dart';
import '../../../style/text_style.dart';

class LoanApprovalScreen extends StatefulWidget {
  const LoanApprovalScreen({Key? key}) : super(key: key);

  @override
  State<LoanApprovalScreen> createState() => _LoanApprovalScreenState();
}

class _LoanApprovalScreenState extends State<LoanApprovalScreen> {
  LoanApprovalController loanApprovalController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowLoaderDialog.showLoaderDialog(context);
      loanApprovalController.apiCallLoanApprovalList(isShowLoader: true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBody(),
      body: buildBody(),
    );
  }

  ///Appbar body
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      centerTitle: true,
      titleWidget: Text(
        AppStrings.approvals,
        style: ISOTextStyles.openSenseSemiBold(
          size: 17,
          color: AppColors.headingTitleColor,
        ),
      ),
    );
  }

  ///Scaffold buildBody
  Widget buildBody() {
    return Obx(
      () => (loanApprovalController.loanApprovalList.isEmpty && loanApprovalController.isApiResponseReceive.value)
          ? Center(
              child: Text(
                AppStrings.noLoansYet,
                style: ISOTextStyles.openSenseSemiBold(size: 16),
              ),
            )
          : ListView.builder(
              itemCount: loanApprovalController.isAllDataLoaded.value ? loanApprovalController.loanApprovalList.length + 1 : loanApprovalController.loanApprovalList.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == loanApprovalController.loanApprovalList.length) {
                  Future.delayed(
                    const Duration(milliseconds: 100),
                    () async {
                      await _handleLoadMoreList();
                    },
                  );
                  return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
                }
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 16.0.w),
                  color: AppColors.whiteColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7.0.w),
                        child: CommonUtils.amountFormat(number: '${loanApprovalController.loanApprovalList[index].loanAmount ?? 0}'),
                      ),
                      SizedBox(
                        height: 40.0.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: loanApprovalController.loanApprovalList[index].selectedTags?.length,
                          itemBuilder: (BuildContext context, int subIndex) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 7.0),
                              child: Row(
                                children: [
                                  Container(
                                      height: 22.h,
                                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: AppColors.greyColor, // Set border width
                                        borderRadius: BorderRadius.all(Radius.circular(4.0)), // Set rounded corner radius
                                      ),
                                      child: Text(
                                        loanApprovalController.loanApprovalList[index].selectedTags?[subIndex] ?? '',
                                        style: ISOTextStyles.openSenseRegular(
                                          size: 12,
                                        ),
                                      )),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      loanApprovalController.loanApprovalList[index].createByCompanyOwner == true ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7.0.w),
                        child: Row(
                          children: [
                            ImageComponent.circleNetworkImage(
                              imageUrl: loanApprovalController.loanApprovalList[index].createdByUser?.companyImage ?? '',
                              placeHolderImage: AppImages.backGroundDefaultImage,
                              height: 19.w,
                              width: 19.w,
                            ),
                            8.sizedBoxW,
                            Text(
                              loanApprovalController.loanApprovalList[index].createdByUser?.companyName ?? '',
                              style: ISOTextStyles.openSenseRegular(
                                size: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ): Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7.0.w),
                        child: Row(
                          children: [
                            Container(
                              height: 28.0,
                              color: AppColors.transparentColor,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Obx(
                                    () => IgnorePointer(
                                      child: ImageComponent.circleNetworkImage(
                                        imageUrl: loanApprovalController.loanApprovalList[index].createdByUser?.profileImg ?? '',
                                        height: 19.w,
                                        width: 19.w,
                                      ),
                                    ),
                                  ),
                                  Obx(
                                    () => Visibility(
                                      visible: loanApprovalController.loanApprovalList[index].createdByUser?.isVerified == true,
                                      child: Positioned(
                                        bottom: 2.0,
                                        right: 0.0,
                                        child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, height: 10.w, width: 10.w),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            8.sizedBoxW,
                            Text(
                              '${loanApprovalController.loanApprovalList[index].createdByUser?.firstName ?? ''} ${loanApprovalController.loanApprovalList[index].createdByUser?.lastName ?? ''}',
                              style: ISOTextStyles.openSenseRegular(
                                size: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 26.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            containerButton(
                              buttonColor: AppColors.disableButtonColor,
                              buttonText: AppStrings.decline,
                              index: index,
                              approveAction: AppStrings.rejected,
                            ),
                            containerButton(
                              buttonColor: AppColors.primaryColor,
                              buttonText: AppStrings.approve,
                              index: index,
                              approveAction: AppStrings.approvedf,
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: AppColors.dividerColor,
                        height: 2,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Future _handleLoadMoreList() async {
    if (!loanApprovalController.isAllDataLoaded.value) return;
    if (loanApprovalController.isLoadMoreRunningForViewAll) return;
    loanApprovalController.isLoadMoreRunningForViewAll = true;
    await loanApprovalController.loanApprovalPagination();
  }

  Widget containerButton({required Color buttonColor, required String buttonText, required String approveAction, required index}) {
    return GestureDetector(
      onTap: () {
        ShowLoaderDialog.showLoaderDialog(context);
        loanApprovalController.apiCallLoanApproveDecline(
            loanId: loanApprovalController.loanApprovalList[index].id ?? -1,
            action: approveAction,
            onErr: (msg) {
              SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
            },
            onSuccess: (msg) {
              SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
              loanApprovalController.loanApprovalList.removeAt(index);
            });
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 4.0.h, horizontal: 50.0.w),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: buttonColor),
        child: Text(
          buttonText,
          style: ISOTextStyles.openSenseSemiBold(size: 16, color: AppColors.headingTitleColor),
        ),
      ),
    );
  }
}
