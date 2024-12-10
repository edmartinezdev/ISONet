import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/bindings/bottom_tabs/feed_detail_binding.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/setting_controller/company_setting_controller.dart';
import 'package:iso_net/controllers/my_profile/notification_listing_controller.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/forum/forum_detail_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/feed_detail_screen.dart';
import 'package:iso_net/ui/style/dialog_components.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../bindings/bottom_tabs/forum_detail_binding.dart';
import '../../controllers/my_profile/my_profile_controller.dart';
import '../../singelton_class/auth_singelton.dart';
import '../../utils/app_common_stuffs/strings_constants.dart';
import '../style/showloader_component.dart';
import '../style/text_style.dart';

class NotificationListingScreen extends StatefulWidget {
  const NotificationListingScreen({Key? key}) : super(key: key);

  @override
  State<NotificationListingScreen> createState() => _NotificationListingScreenState();
}

class _NotificationListingScreenState extends State<NotificationListingScreen> {
  NotificationListingController notificationListingController = Get.find<NotificationListingController>();

  @override
  void initState() {
    /*WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowLoaderDialog.showLoaderDialog(context);
      FlutterAppBadger.removeBadge();
      notificationListingController.notificationListApi();

    });*/

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBody(),
      body: buildBody2(),
    );
  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBar(
      title: Text(
        AppStrings.notifications,
        style: ISOTextStyles.openSenseBold(size: 24),
      ),
      centerTitle: false,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 12.0.w),
          child: Align(
            alignment: Alignment.center,
            child: Obx(
              () => GestureDetector(
                onTap: notificationListingController.totalRecord.value == 0
                    ? null
                    : () {
                        DialogComponent.showAlert(context,
                            title: AppStrings.appName,
                            message: AppStrings.clearNotificationMessage,
                            barrierDismissible: true,
                            arrButton: [AppStrings.cancel, AppStrings.confirm], callback: (btnIndex) {
                          if (btnIndex == 1) {
                            ShowLoaderDialog.showLoaderDialog(context);
                            notificationListingController.apiCallClearAllNotification();
                          }
                        });
                      },
                child: Container(
                  color: AppColors.transparentColor,
                  child: Obx(
                    () => Text(
                      AppStrings.clearAll,
                      style: ISOTextStyles.sfProBold(size: 14, color: notificationListingController.totalRecord.value == 0 ? AppColors.dividerColor : AppColors.blackColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///Scaffold body
  Widget buildBody() {
    return SafeArea(
      child: Obx(
        () => RefreshIndicator(
          onRefresh: () async {
            _handleOnRefreshIndicator();
          },
          child: (notificationListingController.notificationList.isEmpty && notificationListingController.isApiResponseReceive.value)
              ? Center(
                  child: Text(
                    AppStrings.noNotification,
                    style: ISOTextStyles.openSenseSemiBold(size: 16),
                  ),
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: notificationListingController.isAllDataLoaded.value ? notificationListingController.notificationList.length + 1 : notificationListingController.notificationList.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == notificationListingController.notificationList.length) {
                      Future.delayed(
                        const Duration(milliseconds: 100),
                        () async {
                          await _handleLoadMoreList();
                        },
                      );
                      return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
                    }
                    var notificationData = notificationListingController.notificationList[index];
                    return GestureDetector(
                      onTap: () {
                        handleNotificationListTap(index: index);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 16.0.w),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notificationData.title ?? '',
                              style: ISOTextStyles.openSenseSemiBold(size: 14),
                            ),
                            8.sizedBoxH,
                            Text(
                              notificationData.description ?? '',
                              style: ISOTextStyles.openSenseLight(size: 12, color: AppColors.hintTextColor),
                            ),
                            8.sizedBoxH,
                            Visibility(
                              visible: (notificationData.extraData?.link ?? '').isNotEmpty,
                              child: GestureDetector(
                                onTap: () {
                                  CommonUtils.websiteLaunch(notificationData.extraData?.link ?? '');
                                },
                                child: Container(
                                  color: AppColors.transparentColor,
                                  child: Text(
                                    notificationData.extraData?.link ?? '',
                                    style: ISOTextStyles.openSenseLight(size: 12, color: AppColors.blueColor),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
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

  Widget buildBody2() {
    return RefreshIndicator(
      onRefresh: () async {
        _handleOnRefreshIndicator();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 0),
            sliver: SliverSafeArea(
              bottom: true,
              top: false,
              sliver: Obx(
                () => (notificationListingController.notificationList.isEmpty && notificationListingController.isApiResponseReceive.value)
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(
                            AppStrings.noNotification,
                            style: ISOTextStyles.openSenseSemiBold(size: 16),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          addAutomaticKeepAlives: true,
                          childCount:
                              notificationListingController.isAllDataLoaded.value ? notificationListingController.notificationList.length + 1 : notificationListingController.notificationList.length,
                          (BuildContext context, int index) {
                            if (index == notificationListingController.notificationList.length) {
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () async {
                                  await _handleLoadMoreList();
                                },
                              );
                              return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
                            }
                            var notificationData = notificationListingController.notificationList[index];
                            return GestureDetector(
                              onTap: () {
                                handleNotificationListTap(index: index);
                              },
                              child: Container(
                                color: AppColors.transparentColor,
                                padding: EdgeInsets.only(top: 23.0.h, left: 21.0.w,right: 21.0.w),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notificationData.title ?? '',
                                      style: ISOTextStyles.openSenseSemiBold(size: 14),
                                    ),
                                    8.sizedBoxH,
                                    Text(
                                      notificationData.description ?? '',
                                      style: ISOTextStyles.openSenseLight(size: 12, color: AppColors.hintTextColor),
                                    ),
                                    15.sizedBoxH,
                                    Visibility(
                                      visible: (notificationData.extraData?.link ?? '').isNotEmpty,
                                      child: GestureDetector(
                                        onTap: () {
                                          CommonUtils.websiteLaunch(notificationData.extraData?.link ?? '');
                                        },
                                        child: Container(
                                          color: AppColors.transparentColor,
                                          child: Text(
                                            notificationData.extraData?.link ?? '',
                                            style: ISOTextStyles.openSenseLight(size: 12, color: AppColors.blueColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                    (notificationData.extraData?.link ?? '').isNotEmpty ? 15.sizedBoxH : 0.sizedBoxH,
                                    const Divider(
                                      color: AppColors.dividerColor,
                                    )

                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  handleNotificationListTap({required index}) async {
    var notificationData = notificationListingController.notificationList[index];
    if (notificationData.extraData?.notificationType == 3 || notificationData.extraData?.notificationType == 4) {
      Get.to(ForumDetailScreen(forumId: notificationData.extraData?.forumId ?? 0), binding: ForumDetailBinding());
    } else if (notificationData.extraData?.notificationType == 1 || notificationData.extraData?.notificationType == 2) {
      Get.to(FeedDetailScreen(feedId: notificationData.extraData?.feedId ?? 0), binding: FeedDetailBinding());
    } else if (notificationData.extraData?.notificationType == 6) {
      CompanySettingController companySettingController = Get.find();
      await companySettingController.companyProfileApiCall();
      await companySettingController.companyReviewListApi();
      companySettingController.currentTabIndex.value = 1;
      Get.toNamed(ScreenRoutesConstants.settingCompanyScreen);
    } else if (notificationData.extraData?.notificationType == 5) {
      Get.toNamed(ScreenRoutesConstants.viewAllRequestScreen);
    }
    /*else if (notificationData.extraData?.notificationType == 8) {
      Get.toNamed(ScreenRoutesConstants.oneToOneChatScreen,
          arguments: [notificationData.extraData?.roomName ?? '', notificationData.description?.split('sent').first ?? '', notificationData.extraData?.isGroup ?? false]);
      Logger().i('${notificationData.extraData?.roomName ?? ''}${notificationData.extraData?.groupName ?? ''}${notificationData.extraData?.isGroup ?? false}');
    }*/
    else if (notificationData.extraData?.notificationType == 13) {
      Future.delayed(const Duration(milliseconds: 100), () {
        Get.toNamed(
          ScreenRoutesConstants.loanApprovalScreen,
        );
      });
    } else if (notificationData.extraData?.notificationType == 14) {
      MyProfileController myProfileController = Get.find();
      myProfileController.currentTabIndex.value = 1;
      Future.delayed(const Duration(milliseconds: 100), () {
        Get.toNamed(ScreenRoutesConstants.myProfileScreen, arguments: userSingleton.id);
      });
    }
  }

  Future _handleLoadMoreList() async {
    if (!notificationListingController.isAllDataLoaded.value) return;
    if (notificationListingController.isLoadMoreRunningForViewAllCategory) return;
    notificationListingController.isLoadMoreRunningForViewAllCategory = true;
    await notificationListingController.notificationPagination();
  }

  _handleOnRefreshIndicator() async {
    notificationListingController.isNotificationRefresh.value = true;
    await notificationListingController.notificationListApi(isShowLoader: false);
  }
}
