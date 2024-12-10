// ignore_for_file: must_be_immutable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/company_controller/employee_profile_controller.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/company_screens/employee_profile_feed_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/feed_post_adapter/feed_post_adaptor.dart';
import 'package:iso_net/ui/style/ImageWidget.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../../bindings/bottom_tabs/feed_detail_binding.dart';
import '../../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../../utils/app_common_stuffs/common_api_function.dart';
import '../../../../../utils/app_common_stuffs/screen_routes.dart';
import '../../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../../common_ui/view_photo_video_screen.dart';
import '../../../../style/appbar_components.dart';
import '../feed_detail_screen.dart';

class EmployeeProfileScreen extends StatefulWidget {
  int? employeeId;
  bool? isFromSeeAllEmployeeScreen;

  EmployeeProfileScreen({
    Key? key,
    this.employeeId,
    this.isFromSeeAllEmployeeScreen,
  }) : super(key: key);

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen> {
  EmployeeProfileController employeeProfileController = Get.find<EmployeeProfileController>();
  RxBool apiCallBack = false.obs;
  Rxn<int> indexLike = Rxn();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowLoaderDialog.showLoaderDialog(context);
    });
    employeeProfileController.employeeProfileApiCall(
      employeeId: widget.employeeId ?? 0,
    );
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
      titleWidget: Obx(
        () => Center(
          child: Text(
            '${employeeProfileController.employeeProfileData.value?.firstName ?? ''} ${employeeProfileController.employeeProfileData.value?.lastName ?? ''}',
            style: ISOTextStyles.openSenseSemiBold(size: 17),
          ),
        ),
      ),
      actionWidgets: [
        GestureDetector(
          onTap: () {
            CommonUtils.reportUserWidget(
              userId: employeeProfileController.employeeProfileData.value?.userId ?? 0,
              context: context,
              buttonText: [AppStrings.reportUser, AppStrings.flagUser, AppStrings.blockUser],
              reportType: AppStrings.user,
              onSuccessBlockAction: (msg) {
                SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                Get.back();
              },
            );
          },
          child: ImageComponent.loadLocalImage(imageName: AppImages.threeDotFill),
        ),
      ],
    );
  }

  ///Scaffold Body
  Widget buildBody() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(top: 0),
            sliver: SliverSafeArea(
              bottom: true,
              top: false,
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (BuildContext context, int index) {
                    return Obx(
                      () => employeeProfileController.isEmployeeProfileLoad.value
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                userProfileSection(),
                                userPostSection(),
                                seeAllButton(),
                              ],
                            )
                          : Container(),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///user profile section
  Widget userProfileSection() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ImageWidget(
                url: employeeProfileController.employeeProfileData.value?.backgroundImg ?? '',
                fit: BoxFit.cover,
                height: 129.w,
                width: double.infinity,
                placeholder: AppImages.backGroundDefaultImage,
              ),
              Container(
                margin: EdgeInsets.only(top: 129.w / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(border: Border.all(color: AppColors.whiteColor, width: 6), borderRadius: BorderRadius.circular(100.w / 2), color: AppColors.whiteColor),
                                    child: IgnorePointer(
                                      child: ImageComponent.circleNetworkImage(imageUrl: employeeProfileController.employeeProfileData.value?.profileImg ?? '', height: 93.w, width: 93.w),
                                    ),
                                  ),
                                  Visibility(
                                    visible: employeeProfileController.employeeProfileData.value?.isVerified == true,
                                    child: Positioned(
                                      bottom: 10.h,
                                      right: 10.w,
                                      child: Container(
                                        child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, height: 22.h, width: 22.w, boxFit: BoxFit.contain),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: employeeProfileController.employeeProfileData.value?.userType != null,
                                    child: Positioned(
                                      top: 5.h,
                                      left: 5.w,
                                      child: ImageComponent.loadLocalImage(
                                          imageName: employeeProfileController.employeeProfileData.value?.userType == AppStrings.fu ? AppImages.funderBadge : AppImages.brokerBadge,
                                          height: 22.h,
                                          width: 22.w,
                                          boxFit: BoxFit.contain),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          10.sizedBoxH,
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(top: 60.0.h, left: 12.0.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${employeeProfileController.employeeProfileData.value?.firstName ?? ''} ${employeeProfileController.employeeProfileData.value?.lastName ?? ''}',
                                    style: ISOTextStyles.openSenseSemiBold(size: 18),
                                  ),
                                  4.sizedBoxH,
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: (employeeProfileController.employeeProfileData.value?.companyName ?? '').isNotEmpty ? '${employeeProfileController.employeeProfileData.value?.companyName ?? ''} • ' : "",
                                          style: ISOTextStyles.openSenseRegular(size: 12),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap =  employeeProfileController.employeeProfileData.value?.isCompanyDeleted == false
                                                      ? () async {
                                                          if (widget.isFromSeeAllEmployeeScreen ?? false) {
                                                            Get.until((route) => route.settings.name == ScreenRoutesConstants.companyProfileScreen);
                                                          } else {
                                                            Get.back();
                                                          }
                                                        }
                                                      : null,
                                        ),
                                        TextSpan(
                                          text: '${employeeProfileController.employeeProfileData.value?.following ?? 0} Following',
                                          style: ISOTextStyles.openSenseRegular(size: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Flexible(
                                  //       child: InkWell(
                                  //         onTap: employeeProfileController.employeeProfileData.value?.isCompanyDeleted == false
                                  //             ? () async {
                                  //                 if (widget.isFromSeeAllEmployeeScreen ?? false) {
                                  //                   Get.until((route) => route.settings.name == ScreenRoutesConstants.companyProfileScreen);
                                  //                 } else {
                                  //                   Get.back();
                                  //                 }
                                  //               }
                                  //             : null,
                                  //         child: Text(
                                  //           employeeProfileController.employeeProfileData.value?.companyName ?? '',
                                  //           style: ISOTextStyles.openSenseRegular(size: 12),
                                  //           maxLines: 1,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     8.sizedBoxH,
                                  //     (employeeProfileController.employeeProfileData.value?.companyName ?? '').isNotEmpty
                                  //         ? Padding(
                                  //             padding: const EdgeInsets.only(top: 2.0, right: 6.0, left: 6.0),
                                  //             child: Container(
                                  //               height: 3.w,
                                  //               width: 3.w,
                                  //               decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.blackColor),
                                  //             ),
                                  //           )
                                  //         : Container(),
                                  //     (employeeProfileController.employeeProfileData.value?.companyName ?? '').isNotEmpty ? 8.sizedBoxH : 0.sizedBoxH,
                                  //     Text(
                                  //       '${employeeProfileController.employeeProfileData.value?.following ?? 0} Following',
                                  //       style: ISOTextStyles.openSenseRegular(size: 13),
                                  //       maxLines: 1,
                                  //       overflow: TextOverflow.ellipsis,
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (employeeProfileController.employeeProfileData.value?.isConnected.value == 'NotConnected') {
                                var apiResult = await CommonApiFunction.commonConnectApi(
                                    userId: employeeProfileController.employeeProfileData.value?.userId ?? 0,
                                    onErr: (msg) {
                                      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                    });
                                if (apiResult) {
                                  employeeProfileController.employeeProfileData.value?.isConnected.value = 'Requested';
                                }
                              }
                            },
                            child: Container(
                              height: 36.0.h,
                              width: 215.w,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(34.0.r),
                                color: employeeProfileController.employeeProfileData.value?.isConnected.value == 'NotConnected' ? AppColors.primaryColor : AppColors.greyColor,
                              ),
                              child: Text(
                                employeeProfileController.employeeProfileData.value?.isConnected.value == 'NotConnected'
                                    ? 'Connect'
                                    : employeeProfileController.employeeProfileData.value?.isConnected.value == 'Connected'
                                        ? 'Connected'
                                        : 'Requested',
                                style: ISOTextStyles.openSenseSemiBold(size: 18),
                              ),
                            ),
                          ),
                          16.sizedBoxW,
                          //ImageComponent.loadLocalImage(imageName: AppImages.threeDotFill)
                          GestureDetector(
                            onTap: () {
                              CommonUtils.reportUserWidget(
                                userId: employeeProfileController.employeeProfileData.value?.userId ?? 0,
                                context: context,
                                buttonText: [AppStrings.reportUser, AppStrings.flagUser, AppStrings.blockUser],
                                reportType: AppStrings.user,
                                onSuccessBlockAction: (msg) {
                                  SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                                  Get.back();
                                },
                              );
                            },
                            child: Container(
                              height: 36.0.h,
                              width: 72.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28.0.r),
                                color: AppColors.greyColor,
                              ),
                              alignment: Alignment.center,
                              //padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              child: Image.asset(AppImages.threeDots),
                            ),
                          ),
                          Expanded(child: Container())
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          (employeeProfileController.employeeProfileData.value?.bio ?? '').isNotEmpty
              ? Container(
                  decoration: employeeProfileController.employeeProfileFeedList.isEmpty
                      ? const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: AppColors.greyColor,
                            ),
                            bottom: BorderSide(
                              color: AppColors.greyColor,
                            ),
                          ),
                        )
                      : const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: AppColors.greyColor,
                            ),
                          ),
                        ),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ImageComponent.loadLocalImage(imageName: AppImages.bioBook, height: 16.w, width: 16.w, boxFit: BoxFit.contain, imageColor: AppColors.dividerColor),
                          8.sizedBoxW,
                          Text(
                            AppStrings.bio.toUpperCase(),
                            style: ISOTextStyles.openSenseBold(
                              size: 12,
                            ),
                          ),
                        ],
                      ),
                      8.sizedBoxH,
                      Text(
                        employeeProfileController.employeeProfileData.value?.bio ?? '',
                        style: ISOTextStyles.openSenseRegular(size: 12),
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  ///user post section
  Widget userPostSection() {
    return Obx(
      () => employeeProfileController.employeeProfileFeedList.isEmpty
          ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Center(
                child: Text(
                  'No Posts Yet!',
                  style: ISOTextStyles.openSenseSemiBold(size: 16),
                ),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: employeeProfileController.employeeProfileFeedList.length,
              itemBuilder: (BuildContext context, int index) {
                var userFeed = employeeProfileController.employeeProfileFeedList[index].obs;
                indexLike.value = index;
                return Obx(
                  () => FeedPostAdapter(
                    isUserProfileOpen: false,
                    feedData: userFeed.value,
                    screenRoutes: () async {
                      var callBackData = await Get.to(
                          FeedDetailScreen(
                            feedId: userFeed.value.feedId ?? 0,
                          ),
                          binding: FeedDetailBinding());
                      if (callBackData != null) {
                        userFeed.value = callBackData;
                        employeeProfileController.update();
                      }
                    },
                    commentButton: () async {
                      var callBackData = await Get.to(
                          FeedDetailScreen(
                            feedId: userFeed.value.feedId ?? 0,
                          ),
                          binding: FeedDetailBinding());
                      if (callBackData != null) {
                        userFeed.value = callBackData;
                        employeeProfileController.update();
                      }
                    },
                    pageController: employeeProfileController.pageController,
                    threeDotTap: () {
                      CommonUtils.reportWidget(
                        feedId: userFeed.value.feedId ?? 0,
                        context: context,
                        buttonText: [AppStrings.sendPost, AppStrings.reportPost, AppStrings.flagPost],
                        reportTyp: AppStrings.feed,
                      );
                    },
                    onPostImageTap: (value) async {
                      var callBack = await Get.to(PhotoVideoScreen(), arguments: [userFeed.value, value]);
                      if (callBack != null) {
                        userFeed.value = callBack;
                      }
                    },
                    onConnectButtonPress: () async {
                      var apiResult = await CommonApiFunction.commonConnectApi(
                          userId: employeeProfileController.employeeProfileData.value?.userId ?? 0,
                          onErr: (msg) {
                            SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                          });
                      if (apiResult) {
                        userFeed.value.user?.isConnected.value = AppStrings.requested;
                        employeeProfileController.employeeProfileData.value?.isConnected.value = AppStrings.requested;
                      }
                    },
                  ),
                  /*FeedPostWidget(
                          userProfilePage: () {},
                          profileImageUrl: userFeed.value.user?.profileImg ?? '',
                          fName: userFeed.value.user?.firstName ?? '',
                          lName: userFeed.value.user?.lastName ?? '',
                          companyName: userFeed.value.user?.companyName ?? '',
                          timeAgo: userFeed.value.getHoursAgo,
                          postContent: userFeed.value.description ?? '',
                          screenRoutes: () async {
                            var callBackData = await Get.to(
                                FeedDetailScreen(
                                  feedId: userFeed.value.feedId ?? 0,
                                ),
                                binding: FeedDetailBinding());
                            if (callBackData != null) {
                              userFeed.value = callBackData;
                              employeeProfileController.update();
                            }
                          },
                          onThreeDotTap: () {
                            CommonUtils.reportWidget(feedId: userFeed.value.feedId ?? 0, context: context, buttonText: AppStrings.reportPost);
                          },
                          isUserConnected: employeeProfileController.employeeProfileData.value?.isConnected ?? AppStrings.notConnected.obs,
                          onConnectButtonPress: () async {
                            var apiResult = await CommonApiFunction.commonConnectApi(
                                userId: employeeProfileController.employeeProfileData.value?.userId ?? 0,
                                onErr: (msg) {
                                  SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                });
                            if (apiResult) {
                              employeeProfileController.employeeProfileData.value?.isConnected.value = 'Requested';
                            }
                          },
                          isExpandText: userFeed.value.showMore,
                          postImages: userFeed.value.feedMedia ?? [],
                          pageController: employeeProfileController.pageController,
                          onPostImageTap: (value) async {
                            var callBack = await Get.to(PhotoVideoScreen(), arguments: [userFeed.value, value]);
                            if (callBack != null) {
                              userFeed.value = callBack;
                            }
                            // Get.to(const PhotoVideoScreen(), arguments: [userFeed.value, value]);
                          },
                          //activeIndex: userProfileController.slidingPageIndicatorIndex,
                          likeCounts: userFeed.value.likesCounters.value,
                          commentCounts: userFeed.value.comment ?? 0,
                          onLikeButtonPressed: () async {
                            if (userFeed.value.isLikeFeed.value == false) {
                              var likeResponse = await employeeProfileController.likePostApi(
                                feedId: '${userFeed.value.feedId ?? 0}',
                                onSuccess: (value) {
                                  userFeed.value.likesCounters.value = value;
                                },
                              );
                              if (likeResponse) {
                                userFeed.value.isLikeFeed.value = true;
                              }
                            } else {
                              var likeResponse = await employeeProfileController.unlikePostApi(
                                feedId: '${userFeed.value.feedId ?? 0}',
                                onSuccess: (value) {
                                  userFeed.value.likesCounters.value = value;
                                },
                              );
                              if (likeResponse) {
                                userFeed.value.isLikeFeed.value = false;
                              }
                            }
                          },
                          likedIcon: userFeed.value.isLikeFeed.value == true ? AppImages.dollarFill : AppImages.dollar,
                          onCommentButtonPressed: () async {
                            // Get.to(
                            //     FeedDetailScreen(
                            //       feedId: userFeed.value.feedId ?? 0,
                            //     ),
                            //     binding: FeedDetailBinding());
                            var callBackData = await Get.to(
                                FeedDetailScreen(
                                  feedId: userFeed.value.feedId ?? 0,
                                ),
                                binding: FeedDetailBinding());
                            if (callBackData != null) {
                              userFeed.value = callBackData;
                              employeeProfileController.update();
                            }
                          },
                          onSendButtonPressed: () {
                            SendFunsctionality.sendBottomSheet(feedId: userFeed.value.feedId ?? 0, context: context);
                          },
                          isShareIconVisible: false.obs,
                          isUserMe: CommonUtils.isUserMe(id: employeeProfileController.employeeProfileData.value?.userId),
                          isUserVerify: userFeed.value.user?.isVerified ?? false),*/
                );
              },
            ),
    );
  }

  ///see all Feed button
  Widget seeAllButton() {
    return Obx(
      () => employeeProfileController.employeeProfileFeedList.length > 2
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
              child: GestureDetector(
                onTap: () {
                  employeeProfileController.employeeAllFeedList.clear();
                  Get.to(
                    const EmployeeFeedScreen(),
                  );
                },
                child: Row(
                  children: [
                    const Text(AppStrings.seeAll),
                    8.sizedBoxW,
                    ImageComponent.loadLocalImage(imageName: AppImages.yellowArrow),
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}
