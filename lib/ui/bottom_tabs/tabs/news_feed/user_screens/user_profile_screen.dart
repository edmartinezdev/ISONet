// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/bindings/bottom_tabs/feed_detail_binding.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/user-controller/user_profile_controller.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/feed_detail_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/feed_post_adapter/feed_post_adaptor.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/user_screens/user_feedscreen.dart';
import 'package:iso_net/ui/style/ImageWidget.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';
import 'package:iso_net/utils/swipe_back.dart';

import '../../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../../utils/app_common_stuffs/common_api_function.dart';
import '../../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../../common_ui/view_photo_video_screen.dart';
import '../../../../style/appbar_components.dart';
import '../../../../style/showloader_component.dart';

class UserProfileScreen extends StatefulWidget {
  int? userId;

  UserProfileScreen({
    Key? key,
    this.userId,
  }) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UserProfileController userProfileController = Get.find<UserProfileController>();
  RxBool apiCallBack = false.obs;
  Rxn<int> indexLike = Rxn();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowLoaderDialog.showLoaderDialog(context);
      userProfileController.userProfileApiCall(
        userId: widget.userId ?? 0,
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back<String>(
          result: userProfileController.userProfileData.value?.isConnected.value,
        );
        return true;
      },
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.globalPosition.dx < 50 && Platform.isIOS) {
            // Only trigger swipe back from the left edge of the screen

            Get.back<String>(result: userProfileController.userProfileData.value?.isConnected.value);
          }
        },
        child: Scaffold(
          appBar: appBarBody(),
          body: buildBody(),
        ),
      ),
    );
  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      leadingWidget: GestureDetector(
        onTap: () {
          if (userProfileController.userProfileFeedList.isEmpty) {
            Get.back<String>(result: userProfileController.userProfileData.value?.isConnected.value);
          } else {
            Get.back<String>(result: userProfileController.userProfileData.value?.isConnected.value);
          }
        },
        child: ImageComponent.loadLocalImage(
          imageName: AppImages.arrow,
        ),
      ),
      titleWidget: Obx(
        () => Center(
          child: Text(
            '${userProfileController.userProfileData.value?.firstName ?? ''} ${userProfileController.userProfileData.value?.lastName ?? ''}',
            style: ISOTextStyles.openSenseSemiBold(size: 17),
          ),
        ),
      ),
      actionWidgets: [
        GestureDetector(
          onTap: () {
            CommonUtils.reportUserWidget(
              userId: userProfileController.userProfileData.value?.userId ?? 0,
              context: context,
              userName: '${userProfileController.userProfileData.value?.firstName ?? ''} ${userProfileController.userProfileData.value?.lastName ?? ''}',
              buttonText: [AppStrings.reportUser, AppStrings.flagUser, AppStrings.blockUser],
              reportType: AppStrings.user,
              onSuccessBlockAction: (msg) {
                SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                Get.back(result: true);
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
                      () => userProfileController.isUserProfileLoad.value
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
        children: [
          Stack(
            children: [
              ImageWidget(
                url: userProfileController.userProfileData.value?.backgroundImg ?? '',
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
                                      child: ImageComponent.circleNetworkImage(imageUrl: userProfileController.userProfileData.value?.profileImg ?? '', height: 93.w, width: 93.w),
                                    ),
                                  ),
                                  Visibility(
                                    visible: userProfileController.userProfileData.value?.isVerified == true,
                                    child: Positioned(
                                      bottom: 10.h,
                                      right: 10.w,
                                      child: Container(
                                        child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, height: 22.h, width: 22.w, boxFit: BoxFit.contain),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: userProfileController.userProfileData.value?.userType != null,
                                    child: Positioned(
                                      top: 5.h,
                                      left: 5.w,
                                      child: ImageComponent.loadLocalImage(
                                          imageName: userProfileController.userProfileData.value?.userType == AppStrings.fu ? AppImages.funderBadge : AppImages.brokerBadge,
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${userProfileController.userProfileData.value?.firstName ?? ''} ${userProfileController.userProfileData.value?.lastName ?? ''}',
                                    style: ISOTextStyles.openSenseSemiBold(size: 18),
                                  ),
                                  4.sizedBoxH,
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: (userProfileController.userProfileData.value?.companyName ?? '').isNotEmpty ? '${userProfileController.userProfileData.value?.companyName ?? ''} • ' : "",
                                          style: ISOTextStyles.openSenseRegular(size: 12),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = userProfileController.userProfileData.value?.isCompanyDeleted == false
                                                ? () async {
                                              Get.toNamed(ScreenRoutesConstants.companyProfileScreen, arguments: userProfileController.userProfileData.value?.companyId);
                                            }
                                                : null,
                                        ),
                                        TextSpan(
                                          text: '${userProfileController.userProfileData.value?.following ?? 0} Following',
                                          style: ISOTextStyles.openSenseRegular(size: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Flexible(
                                  //       child: InkWell(
                                  //         onTap: userProfileController.userProfileData.value?.isCompanyDeleted == false
                                  //             ? () async {
                                  //                 Get.toNamed(ScreenRoutesConstants.companyProfileScreen, arguments: userProfileController.userProfileData.value?.companyId);
                                  //               }
                                  //             : null,
                                  //         child: Text(
                                  //           userProfileController.userProfileData.value?.companyName ?? '',
                                  //           style: ISOTextStyles.openSenseRegular(size: 12),
                                  //           maxLines: 1,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     (userProfileController.userProfileData.value?.companyName ?? '').isNotEmpty ? 6.sizedBoxW : 0.sizedBoxW,
                                  //     (userProfileController.userProfileData.value?.companyName ?? '').isNotEmpty
                                  //         ? Padding(
                                  //             padding: const EdgeInsets.only(top: 2.0),
                                  //             child: Container(
                                  //               height: 3.w,
                                  //               width: 3.w,
                                  //               decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.blackColor),
                                  //             ),
                                  //           )
                                  //         : Container(),
                                  //     (userProfileController.userProfileData.value?.companyName ?? '').isNotEmpty ? 6.sizedBoxW : 0.sizedBoxW,
                                  //     (userProfileController.userProfileData.value?.companyName ?? '').isNotEmpty ? 8.sizedBoxH : 0.sizedBoxH,
                                  //     Text(
                                  //       '${userProfileController.userProfileData.value?.following ?? 0} Following',
                                  //       style: ISOTextStyles.openSenseRegular(size: 13),
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
                      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 10.0.h),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (userProfileController.userProfileData.value?.isConnected.value == 'NotConnected') {
                                var apiResult = await CommonApiFunction.commonConnectApi(
                                    userId: userProfileController.userProfileData.value?.userId ?? 0,
                                    onErr: (msg) {
                                      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                    });
                                if (apiResult) {
                                  userProfileController.userProfileData.value?.isConnected.value = 'Requested';
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
                                color: userProfileController.userProfileData.value?.isConnected.value == 'NotConnected' ? AppColors.primaryColor : AppColors.greyColor,
                              ),
                              child: Text(
                                userProfileController.userProfileData.value?.isConnected.value == 'NotConnected'
                                    ? 'Connect'
                                    : userProfileController.userProfileData.value?.isConnected.value == 'Connected'
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
                                userId: userProfileController.userProfileData.value?.userId ?? 0,
                                context: context,
                                buttonText: [AppStrings.reportUser, AppStrings.flagUser, AppStrings.blockUser],
                                reportType: AppStrings.user,
                                userName: '${userProfileController.userProfileData.value?.firstName ?? ''} ${userProfileController.userProfileData.value?.lastName ?? ''}',
                                onSuccessBlockAction: (msg) {
                                  SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                                  Get.back(result: true);
                                },
                              );
                            },
                            child: Container(
                              height: 36.0.h,
                              width: 72.0.w,
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
          (userProfileController.userProfileData.value?.bio ?? '').isNotEmpty
              ? Container(
                  decoration: userProfileController.userProfileFeedList.isEmpty
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
                        userProfileController.userProfileData.value?.bio ?? '',
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
      () => userProfileController.userProfileFeedList.isEmpty
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
              itemCount: userProfileController.userProfileFeedList.length > 2 ? 2 : userProfileController.userProfileFeedList.length,
              itemBuilder: (BuildContext context, int index) {
                var userFeed = userProfileController.userProfileFeedList[index].obs;
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
                        userProfileController.update();
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
                        userProfileController.update();
                      }
                    },
                    pageController: userProfileController.pageController,
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
                      Logger().i(value);
                    },
                    onConnectButtonPress: () async {
                      var apiResult = await CommonApiFunction.commonConnectApi(
                          userId: userProfileController.userProfileData.value?.userId ?? 0,
                          onErr: (msg) {
                            SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                          });
                      if (apiResult) {
                        userFeed.value.user?.isConnected.value = AppStrings.requested;
                        userProfileController.userProfileData.value?.isConnected.value = AppStrings.requested;
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
                          userProfileController.update();
                        }
                      },
                      onThreeDotTap: () {
                        CommonUtils.reportWidget(feedId: userFeed.value.feedId ?? 0, context: context, buttonText: AppStrings.reportPost);
                      },
                      isUserConnected: userProfileController.userProfileData.value?.isConnected ?? AppStrings.notConnected.obs,
                      onConnectButtonPress: () async {
                        var apiResult = await CommonApiFunction.commonConnectApi(
                            userId: userProfileController.userProfileData.value?.userId ?? 0,
                            onErr: (msg) {
                              SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                            });
                        if (apiResult) {
                          userProfileController.userProfileData.value?.isConnected.value = 'Requested';
                        }
                      },
                      isExpandText: userFeed.value.showMore,
                      postImages: userFeed.value.feedMedia ?? [],
                      pageController: userProfileController.pageController,
                      onPostImageTap: (value) async {
                        var callBack = await Get.to(PhotoVideoScreen(), arguments: [userFeed.value, value]);
                        if (callBack != null) {
                          userFeed.value = callBack;
                        }
                        Logger().i(value);
                      },
                      likeCounts: userFeed.value.likesCounters.value,
                      commentCounts: userFeed.value.comment ?? 0,
                      onLikeButtonPressed: () async {
                        if (userFeed.value.isLikeFeed.value == false) {
                          var likeResponse = await userProfileController.likePostApi(
                            feedId: '${userFeed.value.feedId ?? 0}',
                            onSuccess: (value) {
                              userFeed.value.likesCounters.value = value;
                            },
                          );
                          if (likeResponse) {
                            userFeed.value.isLikeFeed.value = true;
                          }
                        } else {
                          var likeResponse = await userProfileController.unlikePostApi(
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
                        // Get.toNamed(
                        //   ScreenRoutesConstants.userFeed.valueDetailScreen,
                        //   arguments: userProfileController.userProfileFeedList[index],
                        // );
                        // Get.to(
                        //   FeedDetailScreen(
                        //     feedId: userFeed.value.feedId ?? 0,
                        //   ),
                        //   binding: FeedDetailBinding(),
                        // );
                        var callBackData = await Get.to(
                            FeedDetailScreen(
                              feedId: userFeed.value.feedId ?? 0,
                            ),
                            binding: FeedDetailBinding());
                        if (callBackData != null) {
                          userFeed.value = callBackData;
                          userProfileController.update();
                        }
                      },
                      onSendButtonPressed: () {
                        SendFunsctionality.sendBottomSheet(feedId: userFeed.value.feedId ?? 0, context: context);
                      },
                      isShareIconVisible: false.obs,
                      isUserMe: CommonUtils.isUserMe(id: userProfileController.userProfileData.value?.userId),
                      isUserVerify: userFeed.value.user?.isVerified ?? false),*/
                );
              },
            ),
    );
  }

  ///see all Feed button
  Widget seeAllButton() {
    return Obx(
      () => userProfileController.userProfileFeedList.length > 1
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
              child: GestureDetector(
                onTap: () {
                  userProfileController.userAllFeedList.clear();
                  Get.to(
                    const UserFeedScreen(),
                  );
                },
                child: Row(
                  children: [
                    Text(AppStrings.seeAll,style: ISOTextStyles.openSenseSemiBold(size: 12,color: AppColors.headingTitleColor),),
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
