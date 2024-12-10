import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/user-controller/user_profile_controller.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/feed_post_adapter/feed_post_adaptor.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';

import '../../../../../bindings/bottom_tabs/feed_detail_binding.dart';
import '../../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../../utils/app_common_stuffs/common_api_function.dart';
import '../../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../../common_ui/view_photo_video_screen.dart';
import '../../../../style/appbar_components.dart';
import '../../../../style/image_components.dart';
import '../feed_detail_screen.dart';

class UserFeedScreen extends StatefulWidget {
  const UserFeedScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UserFeedScreen> createState() => _UserFeedScreenState();
}

class _UserFeedScreenState extends State<UserFeedScreen> {
  UserProfileController userProfileController = Get.find();

  @override
  void initState() {
    userProfileController.pageToShow.value = 1;
    userProfileController.isAllDataLoaded.value = false;
    userProfileController.totalFeedRecord.value = 0;
    userProfileController.userFeedApiCall(page: userProfileController.pageToShow.value);
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
      leadingWidget: GestureDetector(
        onTap: () {
          Get.back();
          userProfileController.userAllFeedList.clear();
        },
        child: ImageComponent.loadLocalImage(
          imageName: AppImages.arrow,
        ),
      ),
    );
  }

  ///Scaffold Body
  Widget buildBody() {
    return Obx(
      () => ListView.builder(
        itemCount: userProfileController.isAllDataLoaded.value ? userProfileController.userAllFeedList.length + 1 : userProfileController.userAllFeedList.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == userProfileController.userAllFeedList.length) {
            Future.delayed(
              const Duration(milliseconds: 100),
              () async {
                await _handleLoadMoreList();
              },
            );
            return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
          }
          var userFeed = userProfileController.userAllFeedList[index].obs;

          return  Obx(
            ()=> FeedPostAdapter(
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
                  CommonUtils.reportWidget(feedId: userFeed.value.feedId ?? 0, context: context, buttonText: [AppStrings.sendPost,AppStrings.reportPost,AppStrings.flagPost,],reportTyp: AppStrings.feed,);
                },
                onPostImageTap: (value) async {
                  var callBack = await Get.to(PhotoVideoScreen(), arguments: [userFeed.value, value]);
                  if (callBack != null) {
                    userFeed.value = callBack;
                  }
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
          );
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
                  isUserMe: CommonUtils.isUserMe(id: userProfileController.userProfileData.value?.userId ?? 0),
                  isUserVerify: userFeed.value.user?.isVerified ?? false,
                ),*/

        },
      ),
    );
  }

  Future _handleLoadMoreList() async {
    if (!userProfileController.isAllDataLoaded.value) return;
    if (userProfileController.isLoadMoreRunningForViewAll) return;
    userProfileController.isLoadMoreRunningForViewAll = true;
    await userProfileController.feedPagination();
  }
}
