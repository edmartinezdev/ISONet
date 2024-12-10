import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/bindings/bottom_tabs/setting_binding/user_setting_binding.dart';
import 'package:iso_net/controllers/my_profile/my_profile_controller.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/feed_post_adapter/feed_post_adaptor.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/settings_screen/user_setting_screen.dart';
import 'package:iso_net/ui/my_profile/edit_myaccount_screen.dart';
import 'package:iso_net/ui/style/ImageWidget.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/send_functionality.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../bindings/bottom_tabs/feed_detail_binding.dart';
import '../../bindings/my_profile/edit_myaccount_binding.dart';
import '../../utils/app_common_stuffs/app_colors.dart';
import '../../utils/app_common_stuffs/app_images.dart';
import '../../utils/app_common_stuffs/app_logger.dart';
import '../../utils/app_common_stuffs/commom_utils.dart';
import '../../utils/app_common_stuffs/common_api_function.dart';
import '../../utils/app_common_stuffs/screen_routes.dart';
import '../../utils/app_common_stuffs/snackbar_util.dart';
import '../bottom_tabs/tabs/news_feed/feed_detail_screen.dart';
import '../common_ui/view_photo_video_screen.dart';
import '../style/appbar_components.dart';
import '../style/image_components.dart';
import '../style/text_style.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  MyProfileController myProfileController = Get.find<MyProfileController>();

  @override
  void initState() {
    myProfileController.isScreenOpen.value = true;
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ShowLoaderDialog.showLoaderDialog(context);
      },
    );
    myProfileController.fetchProfileDataApi(userId: userSingleton.id ?? myProfileController.userId, isShowLoading: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBody(),
      body: buildBody2(),
    );
  }

  ///AppBar Body
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      leadingWidget: GestureDetector(
        onTap: () {
          myProfileController.isScreenOpen.value = false;
          Get.back();
        },
        child: ImageComponent.loadLocalImage(
          imageName: AppImages.arrow,
        ),
      ),
      titleWidget: Text(
        AppStrings.me,
        style: ISOTextStyles.openSenseSemiBold(size: 17),
      ),
      centerTitle: true,
    );
  }

  ///***** Handle on Tap notification icon *****///
  handleOnNotificationIconTap() async {
    var callBack = await Get.toNamed(ScreenRoutesConstants.notificationListingScreen);
    if (callBack) {
      myProfileController.myProfileData.value?.isReadNotification.value = true;
    }
  }

  ///***** Handle routing user setting screen *****///
  routeToUserSettingScreen() {
    Get.to(
        UserSettingScreen(
          isCompanyDeleted: myProfileController.myProfileData.value?.isCompanyDeleted,
          isCompanyOwner: myProfileController.myProfileData.value?.isOwner,
        ),
        binding: UserSettingBinding());
  }

  Widget buildBody2() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () {
          return handleOnRefresh();
        },
        child: Obx(
          () => myProfileController.isAllDataLoaded.value
              ? CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.zero,
                      sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(childCount: 1, (BuildContext context, int index) {
                        return userProfileSection();
                      })),
                    ),
                    Obx(
                      () => myProfileController.currentTabIndex.value == 0
                          ? SliverPadding(
                              padding: EdgeInsets.zero,
                              sliver: Obx(
                                () => (myProfileController.myFeedList.isEmpty)
                                    ? SliverFillRemaining(
                                        hasScrollBody: false,
                                        child: Center(
                                          child: Text(
                                            AppStrings.noPostsYet,
                                            style: ISOTextStyles.openSenseSemiBold(size: 16),
                                          ),
                                        ),
                                      )
                                    : SliverList(
                                        delegate: SliverChildBuilderDelegate(childCount: myProfileController.myFeedList.length, (BuildContext context, int index) {
                                        return myFeedPostSection(index: index);
                                      })),
                              ),
                            )
                          : SliverPadding(
                              padding: EdgeInsets.zero,
                              sliver: Obx(
                                () => (myProfileController.myLoanList.isEmpty)
                                    ? SliverFillRemaining(
                                        hasScrollBody: false,
                                        child: Center(
                                          child: Text(
                                            AppStrings.noLoanText,
                                            style: ISOTextStyles.openSenseSemiBold(size: 16),
                                          ),
                                        ),
                                      )
                                    : SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          childCount: myProfileController.myLoanList.length,
                                          (BuildContext context, int index) {
                                            return myLoanSection(index: index);
                                          },
                                        ),
                                      ),
                              ),
                            ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.zero,
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(childCount: 1, (BuildContext context, int index) {
                          return seeAllButton();
                        }),
                      ),
                    ),
                  ],
                )
              : Container(),
        ),
      ),
    );
  }

  ///Scaffold Body
  Widget buildBody() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () {
          return handleOnRefresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
          child: Obx(
            () => myProfileController.isAllDataLoaded.value
                ? Column(
                    children: [
                      userProfileSection(),
                      //_onTabTapWidgetDisplay(),
                      seeAllButton(),
                    ],
                  )
                : Container(),
          ),
        ),
      ),
    );
  }

  ///my profile section
  Widget userProfileSection() {
    return Obx(
      () => Stack(
        children: [
          ImageWidget(
            url: myProfileController.myProfileData.value?.backgroundImg ?? '',
            placeholder: AppImages.backGroundDefaultImage,
            height: 129.w,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Stack(
            alignment: Alignment.centerRight,
            children: [
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(border: Border.all(color: AppColors.whiteColor, width: 6), borderRadius: BorderRadius.circular(100.w / 2), color: AppColors.whiteColor),
                                    child: IgnorePointer(
                                      child: ImageComponent.circleNetworkImage(imageUrl: myProfileController.myProfileData.value?.profileImg ?? '', height: 94.w, width: 94.w),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10.h,
                                    right: 10.w,
                                    child: InkWell(
                                      onTap: () {
                                        Get.to(
                                            EditMyAccountScreen(
                                              isCompanyDeleted: myProfileController.myProfileData.value?.isCompanyDeleted ?? false,
                                              isCompanyOwner: myProfileController.myProfileData.value?.isOwner,
                                            ),
                                            binding: EditMyAccountBinding());
                                        /*Get.toNamed(ScreenRoutesConstants.editMyAccountScreen);*/
                                      },
                                      child: Container(
                                          decoration:
                                              BoxDecoration(border: Border.all(color: AppColors.whiteColor, width: 2), borderRadius: BorderRadius.circular(100.w / 2), color: AppColors.whiteColor),
                                          child: ImageComponent.loadLocalImage(imageName: AppImages.editFill, height: 20.w, width: 20.w, boxFit: BoxFit.contain)),
                                    ),
                                  ),
                                  Positioned(
                                    top: 5.h,
                                    left: 5.w,
                                    child: ImageComponent.loadLocalImage(
                                        imageName: userSingleton.userType == AppStrings.fu ? AppImages.funderBadge : AppImages.brokerBadge, height: 20.w, width: 20.w, boxFit: BoxFit.contain),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          10.sizedBoxH,
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(top: 60.0.h, left: 12.0.w),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${myProfileController.myProfileData.value?.firstName ?? ''} ${myProfileController.myProfileData.value?.lastName ?? ''}',
                                    style: ISOTextStyles.openSenseSemiBold(size: 18),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 4.h),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: (myProfileController.myProfileData.value?.companyName ?? '').isNotEmpty ? '${myProfileController.myProfileData.value?.companyName ?? ''} • ' : "",
                                                  style: ISOTextStyles.openSenseRegular(size: 12),
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = myProfileController.myProfileData.value?.isCompanyDeleted == false
                                                        ? () async {
                                                            Get.toNamed(ScreenRoutesConstants.companyProfileScreen, arguments: myProfileController.myProfileData.value?.companyId);
                                                          }
                                                        : null,
                                                ),
                                                TextSpan(
                                                  text: '${myProfileController.myProfileData.value?.following ?? 0} Following',
                                                  style: ISOTextStyles.openSenseRegular(size: 12),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only( right: 4.0.w,left: 4.0.w),
                                          child: GestureDetector(
                                              onTap: () {
                                                Get.to(
                                                    EditMyAccountScreen(
                                                      isCompanyDeleted: myProfileController.myProfileData.value?.isCompanyDeleted ?? false,
                                                      isCompanyOwner: myProfileController.myProfileData.value?.isOwner,
                                                    ),
                                                    binding: EditMyAccountBinding());
                                                /*Get.toNamed(ScreenRoutesConstants.editMyAccountScreen);*/
                                              },
                                              child: Container(color: AppColors.transparentColor, child: ImageComponent.loadLocalImage(imageName: AppImages.editFill))),
                                        ),

                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    (myProfileController.myProfileData.value?.bio ?? '').isNotEmpty
                        ? Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: AppColors.greyColor,
                                ),
                                bottom: BorderSide(
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
                                  myProfileController.myProfileData.value?.bio ?? '',
                                  style: ISOTextStyles.openSenseRegular(size: 12),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    tabBody(),
                  ],
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }

  /// Filter Tab
  Widget tabBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Wrap(
                spacing: 20,
                children: [
                  ...List.generate(myProfileController.myProfileTab.length, (index) {
                    return GestureDetector(
                      onTap: () async {
                        myProfileController.currentTabIndex.value = index;
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(vertical: 5.0.h, horizontal: index == 0 ? 40.0.w : 35.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0.r),
                          color: myProfileController.currentTabIndex.value == index ? AppColors.primaryColor : AppColors.greyColor,
                        ),
                        child: Text(
                          myProfileController.myProfileTab[index].tabName ?? '',
                          style: myProfileController.currentTabIndex.value == index
                              ? ISOTextStyles.openSenseSemiBold(size: 16, color: AppColors.headingTitleColor)
                              : ISOTextStyles.openSenseRegular(size: 16, color: AppColors.headingTitleColor),
                        ),
                      ),
                    );
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  ///MyFeed Post Body
  Widget myFeedPostSection({required int index}) {
    return Obx(
      () => Column(
        children: [
          Container(
            height: 1,
            color: AppColors.greyColor,
          ),
          FeedPostAdapter(
            isUserProfileOpen: false,
            feedData: myProfileController.myFeedList[index],
            screenRoutes: () async {
              var callBackData = await Get.to(
                  FeedDetailScreen(
                    feedId: myProfileController.myFeedList[index].feedId ?? 0,
                  ),
                  binding: FeedDetailBinding());
              if (callBackData != null && callBackData != true) {
                myProfileController.myFeedList[index] = callBackData;
                myProfileController.update();
              } else if (callBackData == true) {
                myProfileController.myFeedList.removeAt(index);
                myProfileController.update();
              }
            },
            commentButton: () async {
              var callBackData = await Get.to(
                  FeedDetailScreen(
                    feedId: myProfileController.myFeedList[index].feedId ?? 0,
                  ),
                  binding: FeedDetailBinding());
              if (callBackData != null && callBackData != true) {
                myProfileController.myFeedList[index] = callBackData;
                myProfileController.update();
              } else if (callBackData == true) {
                myProfileController.myFeedList.removeAt(index);
                myProfileController.update();
              }
            },
            pageController: myProfileController.pageController,
            threeDotTap: () {
              CommonUtils.showMyBottomSheet(
                context,
                arrButton: [
                  AppStrings.sendPost,
                  AppStrings.deletePost,
                ],
                callback: (btnIndex) async {
                  if (btnIndex == 0) {
                    SendFunsctionality.sendBottomSheet(feedId: myProfileController.myFeedList[index].feedId, context: context, headingText: AppStrings.sendPost);
                  } else if (btnIndex == 1) {
                    var deleteApi = await CommonApiFunction.feedDeleteApi(
                        onErr: (msg) {
                          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                        },
                        onSuccess: (msg) {
                          SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                        },
                        feedId: myProfileController.myFeedList[index].feedId);
                    if (deleteApi) {
                      myProfileController.myFeedList.removeAt(index);
                      if (myProfileController.myFeedList.isEmpty) {
                        handleOnRefresh();
                      }
                    }
                  }
                },
              );
            },
            onPostImageTap: (value) async {
              var callBack = await Get.to(PhotoVideoScreen(), arguments: [myProfileController.myFeedList[index], value]);
              if (callBack != null && callBack != true) {
                myProfileController.myFeedList[index] = callBack;
              } else if (callBack == true) {
                myProfileController.myFeedList.removeAt(index);
                myProfileController.update();
              }
              Logger().i(value);
            },
          ),
        ],
      ),
      /*FeedPostWidget(
                          userProfilePage: () {},
                          profileImageUrl: myFeed.value.user?.profileImg ?? '',
                          fName: myFeed.value.user?.firstName ?? '',
                          lName: myFeed.value.user?.lastName ?? '',
                          companyName: myFeed.value.user?.companyName ?? '',
                          timeAgo: myFeed.value.getHoursAgo,
                          postContent: myFeed.value.description ?? '',
                          screenRoutes: () async {
                            var callBackData = await Get.to(
                                FeedDetailScreen(
                                  feedId: myFeed.value.feedId ?? 0,
                                ),
                                binding: FeedDetailBinding());
                            if (callBackData != null && callBackData != true) {
                              myFeed.value = callBackData;
                              myProfileController.update();
                            } else if (callBackData == true) {
                              myProfileController.myFeedList.removeAt(index);
                              myProfileController.update();
                            }
                          },
                          onThreeDotTap: () {
                            CommonUtils.showMyBottomSheet(
                              context,
                              arrButton: [AppStrings.deletePost],
                              callback: (btnIndex) async {
                                var deleteApi = await CommonApiFunction.feedDeleteApi(
                                    onErr: (msg) {
                                      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                    },
                                    onSuccess: (msg) {
                                      SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                                    },
                                    feedId: myFeed.value.feedId);
                                if (deleteApi) {
                                  myProfileController.myFeedList.removeAt(index);
                                  if (myProfileController.myFeedList.isEmpty) {
                                    handleOnRefresh();
                                  }
                                }
                              },
                            );
                          },
                          connectText: '',
                          connectIcon: AppImages.plus,
                          onConnectButtonPress: () async {},
                          isExpandText: myFeed.value.showMore,
                          postImages: myFeed.value.feedMedia ?? [],
                          pageController: myProfileController.pageController,
                          onPostImageTap: (value) async {
                            var callBack = await Get.to(PhotoVideoScreen(), arguments: [myFeed.value, value]);
                            if (callBack != null && callBack != true) {
                              myFeed.value = callBack;
                            } else if (callBack == true) {
                              myProfileController.myFeedList.removeAt(index);
                              myProfileController.update();
                            }
                            Logger().i(value);
                          },
                          likeCounts: myFeed.value.likesCounters.value,
                          commentCounts: myFeed.value.comment ?? 0,
                          onLikeButtonPressed: () async {
                            handleLikeButtonTap(index: index);
                          },
                          likedIcon: myFeed.value.isLikeFeed.value == true ? AppImages.dollarFill : AppImages.dollar,
                          onCommentButtonPressed: () async {
                            var callBackData = await Get.to(
                                FeedDetailScreen(
                                  feedId: myFeed.value.feedId ?? 0,
                                ),
                                binding: FeedDetailBinding());
                            if (callBackData != null && callBackData != true) {
                              myFeed.value = callBackData;
                              myProfileController.update();
                            } else if (callBackData == true) {
                              myProfileController.myFeedList.removeAt(index);
                              myProfileController.update();
                            }
                          },
                          onSendButtonPressed: () {
                            SendFunsctionality.sendBottomSheet(feedId: myFeed.value.feedId ?? 0, context: context);
                          },
                          isShareIconVisible: false.obs,
                          isUserMe: CommonUtils.isUserMe(id: myProfileController.myProfileData.value?.userId),
                          isUserConnected: myFeed.value.user?.isConnected ?? AppStrings.notConnected.obs,
                          isUserVerify: myFeed.value.user?.isVerified ?? false),*/
    );
    /*Obx(
      () => myProfileController.myFeedList.isEmpty
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
              itemCount: myProfileController.myFeedList.length,
              itemBuilder: (BuildContext context, int index) {
                */ /*var myFeed = myProfileController.myFeedList[index].obs;*/ /*
                //indexLike.value = index;
                return Obx(
                  () => FeedPostAdapter(
                    isUserProfileOpen: false,
                    feedData: myProfileController.myFeedList[index],
                    screenRoutes: () async {
                      var callBackData = await Get.to(
                          FeedDetailScreen(
                            feedId: myProfileController.myFeedList[index].feedId ?? 0,
                          ),
                          binding: FeedDetailBinding());
                      if (callBackData != null && callBackData != true) {
                        myProfileController.myFeedList[index] = callBackData;
                        myProfileController.update();
                      } else if (callBackData == true) {
                        myProfileController.myFeedList.removeAt(index);
                        myProfileController.update();
                      }
                    },
                    commentButton: () async {
                      var callBackData = await Get.to(
                          FeedDetailScreen(
                            feedId: myProfileController.myFeedList[index].feedId ?? 0,
                          ),
                          binding: FeedDetailBinding());
                      if (callBackData != null && callBackData != true) {
                        myProfileController.myFeedList[index] = callBackData;
                        myProfileController.update();
                      } else if (callBackData == true) {
                        myProfileController.myFeedList.removeAt(index);
                        myProfileController.update();
                      }
                    },
                    pageController: myProfileController.pageController,
                    threeDotTap: () {
                      CommonUtils.showMyBottomSheet(
                        context,
                        arrButton: [AppStrings.deletePost],
                        callback: (btnIndex) async {
                          var deleteApi = await CommonApiFunction.feedDeleteApi(
                              onErr: (msg) {
                                SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                              },
                              onSuccess: (msg) {
                                SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                              },
                              feedId: myProfileController.myFeedList[index].feedId);
                          if (deleteApi) {
                            myProfileController.myFeedList.removeAt(index);
                            if (myProfileController.myFeedList.isEmpty) {
                              handleOnRefresh();
                            }
                          }
                        },
                      );
                    },
                    onPostImageTap: (value) async {
                      var callBack = await Get.to(PhotoVideoScreen(), arguments: [myProfileController.myFeedList[index], value]);
                      if (callBack != null && callBack != true) {
                        myProfileController.myFeedList[index] = callBack;
                      } else if (callBack == true) {
                        myProfileController.myFeedList.removeAt(index);
                        myProfileController.update();
                      }
                      Logger().i(value);
                    },
                  ),
                  */ /*FeedPostWidget(
                          userProfilePage: () {},
                          profileImageUrl: myFeed.value.user?.profileImg ?? '',
                          fName: myFeed.value.user?.firstName ?? '',
                          lName: myFeed.value.user?.lastName ?? '',
                          companyName: myFeed.value.user?.companyName ?? '',
                          timeAgo: myFeed.value.getHoursAgo,
                          postContent: myFeed.value.description ?? '',
                          screenRoutes: () async {
                            var callBackData = await Get.to(
                                FeedDetailScreen(
                                  feedId: myFeed.value.feedId ?? 0,
                                ),
                                binding: FeedDetailBinding());
                            if (callBackData != null && callBackData != true) {
                              myFeed.value = callBackData;
                              myProfileController.update();
                            } else if (callBackData == true) {
                              myProfileController.myFeedList.removeAt(index);
                              myProfileController.update();
                            }
                          },
                          onThreeDotTap: () {
                            CommonUtils.showMyBottomSheet(
                              context,
                              arrButton: [AppStrings.deletePost],
                              callback: (btnIndex) async {
                                var deleteApi = await CommonApiFunction.feedDeleteApi(
                                    onErr: (msg) {
                                      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                    },
                                    onSuccess: (msg) {
                                      SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                                    },
                                    feedId: myFeed.value.feedId);
                                if (deleteApi) {
                                  myProfileController.myFeedList.removeAt(index);
                                  if (myProfileController.myFeedList.isEmpty) {
                                    handleOnRefresh();
                                  }
                                }
                              },
                            );
                          },
                          connectText: '',
                          connectIcon: AppImages.plus,
                          onConnectButtonPress: () async {},
                          isExpandText: myFeed.value.showMore,
                          postImages: myFeed.value.feedMedia ?? [],
                          pageController: myProfileController.pageController,
                          onPostImageTap: (value) async {
                            var callBack = await Get.to(PhotoVideoScreen(), arguments: [myFeed.value, value]);
                            if (callBack != null && callBack != true) {
                              myFeed.value = callBack;
                            } else if (callBack == true) {
                              myProfileController.myFeedList.removeAt(index);
                              myProfileController.update();
                            }
                            Logger().i(value);
                          },
                          likeCounts: myFeed.value.likesCounters.value,
                          commentCounts: myFeed.value.comment ?? 0,
                          onLikeButtonPressed: () async {
                            handleLikeButtonTap(index: index);
                          },
                          likedIcon: myFeed.value.isLikeFeed.value == true ? AppImages.dollarFill : AppImages.dollar,
                          onCommentButtonPressed: () async {
                            var callBackData = await Get.to(
                                FeedDetailScreen(
                                  feedId: myFeed.value.feedId ?? 0,
                                ),
                                binding: FeedDetailBinding());
                            if (callBackData != null && callBackData != true) {
                              myFeed.value = callBackData;
                              myProfileController.update();
                            } else if (callBackData == true) {
                              myProfileController.myFeedList.removeAt(index);
                              myProfileController.update();
                            }
                          },
                          onSendButtonPressed: () {
                            SendFunsctionality.sendBottomSheet(feedId: myFeed.value.feedId ?? 0, context: context);
                          },
                          isShareIconVisible: false.obs,
                          isUserMe: CommonUtils.isUserMe(id: myProfileController.myProfileData.value?.userId),
                          isUserConnected: myFeed.value.user?.isConnected ?? AppStrings.notConnected.obs,
                          isUserVerify: myFeed.value.user?.isVerified ?? false),*/ /*
                );
              },
            ),*/
  }

  ///MyLoan Section
  Widget myLoanSection({required int index}) {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: CommonUtils.amountFormat(number: '${myProfileController.myLoanList[index].loanAmount}'),
                ),
                statusOrTime(index: index),
              ],
            ),
            10.sizedBoxH,
            SizedBox(
              height: 30,
              child: ListView.builder(
                itemCount: myProfileController.myLoanList[index].selectedTags?.length ?? 0,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int subIndex) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                        decoration: BoxDecoration(
                          color: AppColors.greyColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(myProfileController.myLoanList[index].selectedTags?[subIndex] ?? '')),
                  );
                },
              ),
            )
          ],
        ),
      ),
      /*myProfileController.myLoanList.isEmpty
          ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Center(
                child: Text(
                  'You will see your loans here!',
                  style: ISOTextStyles.openSenseSemiBold(size: 16),
                ),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: myProfileController.myLoanList.length,
              itemBuilder: (BuildContext context, int index) {
                var myLoanData = myProfileController.myLoanList[index];
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 16.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CommonUtils.amountFormat(number: '${myLoanData.loanAmount}'),
                          ),
                          statusOrTime(index: index),
                        ],
                      ),
                      10.sizedBoxH,
                      SizedBox(
                        height: 30,
                        child: ListView.builder(
                          itemCount: myLoanData.selectedTags?.length ?? 0,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int subIndex) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.greyColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(myLoanData.selectedTags?[subIndex] ?? '')),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  color: AppColors.dividerColor,
                );
              },
            ),*/
    );
  }

  ///Handle feed & loan list widget according tab selection
  /*Widget _onTabTapWidgetDisplay() {
    if (myProfileController.currentTabIndex.value == 0) {
      return myFeedPostSection();
    } else if (myProfileController.currentTabIndex.value == 1) {
      return myLoanSection();
    } else {
      return Container();
    }
  }*/

  ///see all Feed button
  Widget seeAllButton() {
    return Obx(
      () => myProfileController.currentTabIndex.value == 0
          ? myProfileController.myFeedList.length > 1
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(ScreenRoutesConstants.myAllFeedScreen, arguments: myProfileController.myProfileData.value?.userId ?? 0)?.then((value) {
                        myProfileController.fetchProfileDataApi(userId: userSingleton.id ?? myProfileController.userId, isShowLoading: false);
                      });
                    },
                    child: Row(
                      children: [
                        const Text('See All'),
                        8.sizedBoxW,
                        ImageComponent.loadLocalImage(imageName: AppImages.yellowArrow),
                      ],
                    ),
                  ),
                )
              : Container()
          : myProfileController.myLoanList.length > 5
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(ScreenRoutesConstants.myLoanListScreen, arguments: myProfileController.myProfileData.value?.userId ?? 0);
                    },
                    child: Row(
                      children: [
                        const Text('See All'),
                        8.sizedBoxW,
                        ImageComponent.loadLocalImage(imageName: AppImages.yellowArrow),
                      ],
                    ),
                  ),
                )
              : Container(),
    );
  }

  ///Like button handle function
  handleLikeButtonTap({required int index}) async {
    var myFeed = myProfileController.myFeedList[index];
    if (myFeed.isLikeFeed.value == false) {
      var likeResponse = await CommonApiFunction.likePostApi(
        feedId: myFeed.feedId ?? 0,
        onSuccess: (value) {
          myFeed.likesCounters.value = value;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
        },
      );
      if (likeResponse) {
        myFeed.isLikeFeed.value = true;
      }
    } else {
      var likeResponse = await CommonApiFunction.unlikePostApi(
        feedId: myFeed.feedId ?? 0,
        onSuccess: (value) {
          myFeed.likesCounters.value = value;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
        },
      );
      if (likeResponse) {
        myFeed.isLikeFeed.value = false;
      }
    }
  }

  ///handleOnRefresh Event
  handleOnRefresh() async {
    myProfileController.isAllDataLoaded.value = false;
    ShowLoaderDialog.showLoaderDialog(context);
    myProfileController.myFeedList.clear();
    myProfileController.myLoanList.clear();
    myProfileController.fetchProfileDataApi(userId: userSingleton.id ?? myProfileController.userId, isShowLoading: true);
  }

  Widget statusOrTime({required index}) {
    var myLoanData = myProfileController.myLoanList[index];
    if ((myLoanData.loanStatus ?? '').toLowerCase() == 'pending') {
      return Row(
        children: [
          /*Icon(Icons.cancel_outlined,color: AppColors.redColor,size: 14.sp,),*/
          ImageComponent.loadLocalImage(imageName: AppImages.clock4, height: 14.w, width: 14.w, imageColor: AppColors.primaryColor),
          4.sizedBoxW,
          Text(
            myLoanData.loanStatus ?? '',
            style: ISOTextStyles.openSenseSemiBold(size: 12, color: AppColors.hintTextColor),
          ),
        ],
      );
    } else if ((myLoanData.loanStatus ?? '').toLowerCase() == 'rejected') {
      return Row(
        children: [
          Icon(
            Icons.cancel_outlined,
            color: AppColors.redColor,
            size: 14.sp,
          ),
          4.sizedBoxW,
          Text(
            myLoanData.loanStatus ?? '',
            style: ISOTextStyles.openSenseSemiBold(size: 12, color: AppColors.hintTextColor),
          ),
        ],
      );
    } else {
      return Text(
        myLoanData.getTagTime,
        style: ISOTextStyles.openSenseSemiBold(size: 12, color: AppColors.hintTextColor),
      );
    }
  }
}
