
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/network/viewall_request_controller.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/swipe_back.dart';

import '../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../utils/app_common_stuffs/app_images.dart';
import '../../../style/appbar_components.dart';
import '../../../style/image_components.dart';
import 'viewall_request_adaptor.dart';

class ViewAllRequestScreen extends StatefulWidget {
  const ViewAllRequestScreen({Key? key}) : super(key: key);

  @override
  State<ViewAllRequestScreen> createState() => _ViewAllRequestScreenState();
}

class _ViewAllRequestScreenState extends State<ViewAllRequestScreen> {
  ViewAllRequestController viewAllRequestController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ShowLoaderDialog.showLoaderDialog(context);
      },
    );
    viewAllRequestController.viewAllRequestApiCall(pageToShow: viewAllRequestController.pageToShow.value);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: true);
        return true;
      },
      child: SwipeBackWidget(
        result: true,
        child: Scaffold(
          appBar: appBarBody(),
          body: buildBody(),
        ),
      ),
    );
  }

  ///AppBar Body
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      titleWidget: Text(
        AppStrings.request,
        style: ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.headingTitleColor),
      ),
      leadingWidget: IconButton(
        onPressed: () {
          Get.back(result: true);
        },
        icon: ImageComponent.loadLocalImage(
          imageName: AppImages.arrow,
        ),
      ),
      centerTitle: true,
    );
  }

  Future _handleLoadMoreList() async {
    if (!viewAllRequestController.isAllDataLoaded.value) return;
    if (viewAllRequestController.isLoadMoreRunningForViewAll) return;
    viewAllRequestController.isLoadMoreRunningForViewAll = true;
    await viewAllRequestController.viewAllRequestPagination();
  }

  ///Scaffold Body
  Widget buildBody() {
    return SafeArea(
      child: Obx(
        () => viewAllRequestController.requestList.isEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Text(
                    AppStrings.pendingRequest,
                    style: ISOTextStyles.openSenseSemiBold(size: 16),
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 26.0.h, horizontal: 4.0.w),
                child: ListView.separated(
                  itemCount: viewAllRequestController.isAllDataLoaded.value ? viewAllRequestController.requestList.length + 1 : viewAllRequestController.requestList.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == viewAllRequestController.requestList.length) {
                      Future.delayed(
                        const Duration(milliseconds: 100),
                        () async {
                          await _handleLoadMoreList();
                        },
                      );
                      return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
                    }

                    var requestData = viewAllRequestController.requestList[index];
                    return ViewAllRequestAdaptor(
                      requestData: requestData,
                      acceptRequestCallBack: () async {
                        _handleAcceptRequest(index: index);
                      },
                      cancelRequestCallBack: () async {
                        _handleCancelRequest(index: index);
                      },
                    );
                    /*return Container(
                padding: EdgeInsets.only(top: 6.0.h, right: 12.0.w, left: 12.0.w, bottom: 6.0.h),
                child: GestureDetector(
                  onTap: () {
                    _handleUserProfileTap(userId: requestData.userId ?? 0);
                  },
                  child: Container(
                    color: AppColors.transparentColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IgnorePointer(
                          child: Stack(
                            children: [
                              ImageComponent.circleNetworkImage(
                                imageUrl: requestData.profileImg ?? '',
                                height: 46.w,
                                width: 46.w,
                              ),
                              Visibility(
                                visible: viewAllRequestController.requestList[index].isVerify == true,
                                child: Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, height: 14.w, width: 14.w, boxFit: BoxFit.contain),
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
                                '${requestData.firstName ?? ''} ${requestData.lastName ?? ''}',
                                style: ISOTextStyles.sfProMedium(size: 16, color: AppColors.blackColorDetailsPage),
                              ),
                              Text(
                                requestData.companyName ?? '',
                                style: ISOTextStyles.sfProDisplay(size: 10, color: AppColors.indicatorColor),
                              ),
                              12.sizedBoxH,
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  _handleCancelRequest(index: index);
                                },
                                child: ImageComponent.loadLocalImage(imageName: AppImages.cancelRed, height: 26.w, width: 26.w, boxFit: BoxFit.contain)),
                            18.sizedBoxW,
                            GestureDetector(
                                onTap: () {
                                  _handleAcceptRequest(index: index);
                                },
                                child: ImageComponent.loadLocalImage(imageName: AppImages.greenAccept, height: 26.w, width: 26.w, boxFit: BoxFit.contain)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );*/
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      color: AppColors.dividerColor,
                    );
                  },
                ),
              ),
      ),
    );
  }

  ///Handle Accept Request Function

  _handleAcceptRequest({required int index}) async {
    var acceptApiResult = await viewAllRequestController.acceptRequestApiCall(
      requestUserId: viewAllRequestController.requestList[index].userId ?? 0,
      onErr: (msg) {
        SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
      },
    );
    if (acceptApiResult) {
      SnackBarUtil.showSnackBar(
          context: context,
          type: SnackType.success,
          message: 'You are now connected with ${viewAllRequestController.requestList[index].firstName ?? ''} ${viewAllRequestController.requestList[index].lastName ?? ''}');
      viewAllRequestController.requestList.removeAt(index);
    }
  }

  ///Handle Cancel Request Function
  _handleCancelRequest({required int index}) async {
    var cancelApiResult = await viewAllRequestController.cancelRequestApiCall(
      requestUserId: viewAllRequestController.requestList[index].userId ?? 0,
      onErr: (msg) {
        SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
      },
    );
    if (cancelApiResult) {
      viewAllRequestController.requestList.removeAt(index);
    }
  }
}
