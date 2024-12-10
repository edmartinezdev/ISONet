// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../bindings/bottom_tabs/user_binding/user_profile_binding.dart';
import '../../../../../model/bottom_navigation_models/news_feed_models/feed_list_model.dart';
import '../../../../../singelton_class/auth_singelton.dart';
import '../../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../../utils/app_common_stuffs/commom_utils.dart';
import '../../../../../utils/app_common_stuffs/common_api_function.dart';
import '../../../../../utils/app_common_stuffs/screen_routes.dart';
import '../../../../../utils/app_common_stuffs/send_functionality.dart';
import '../../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../../common_ui/feed_post_widget.dart';
import '../user_screens/user_profile_screen.dart';

class FeedPostAdapter extends StatefulWidget {
  FeedData feedData;
  VoidCallback screenRoutes;
  VoidCallback commentButton;
  VoidCallback threeDotTap;
  PageController pageController;
  VoidCallback? onConnectButtonPress;
  VoidCallback? userProfileCallBack;
  Function(int subIndex) onPostImageTap;
  bool? isUserProfileOpen;

  FeedPostAdapter(
      {Key? key,
      required this.feedData,
      required this.screenRoutes,
      required this.commentButton,
      required this.pageController,
      required this.threeDotTap,
      required this.onPostImageTap,
      this.onConnectButtonPress,
      this.userProfileCallBack,
      this.isUserProfileOpen})
      : super(key: key);

  @override
  State<FeedPostAdapter> createState() => _FeedPostAdapterState();
}

class _FeedPostAdapterState extends State<FeedPostAdapter> with AutomaticKeepAliveClientMixin<FeedPostAdapter>{
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => FeedPostWidget(
        profileImageUrl: widget.feedData.user?.profileImg ?? '',
        fName: widget.feedData.user?.firstName ?? '',
        lName: widget.feedData.user?.lastName ?? '',
        companyName: widget.feedData.user?.companyName ?? '',
        onThreeDotTap: widget.threeDotTap,
        isUserConnected: widget.feedData.user?.isConnected ?? AppStrings.notConnected.obs,
        onConnectButtonPress: widget.onConnectButtonPress ??
            () async {
              handleOnConnectButtonPress();
            },
        timeAgo: widget.feedData.getHoursAgo,
        userProfilePage: widget.userProfileCallBack != null
            ? widget.userProfileCallBack ?? () {}
            : widget.isUserProfileOpen == false
                ? () {}
                : () async {
                    routeToOtherUserProfileScreen();
                  },
        postContent: widget.feedData.description ?? '',
        screenRoutes: widget.screenRoutes,
        isExpandText: widget.feedData.showMore,
        userType: widget.feedData.user?.userType ?? '',
        pageController: widget.pageController,
        onPostImageTap: widget.onPostImageTap,
        likeCounts: widget.feedData.likesCounters.value,
        commentCounts: widget.feedData.commentCounter.value,
        postImages: widget.feedData.feedMedia ?? [],
        onLikeButtonPressed: () async {
          handleLikeDislikeTap();
        },
        likedIcon: widget.feedData.isLikeFeed.value == true ? AppImages.dollarFill : AppImages.dollar,
        onCommentButtonPressed: widget.commentButton,
        onSendButtonPressed: () {
          SendFunsctionality.sendBottomSheet(feedId: widget.feedData.feedId ?? 0, context: context);
        },
        isShareIconVisible: false.obs,
        isUserMe: CommonUtils.isUserMe(id: widget.feedData.user?.userId ?? 0),
        isUserVerify: widget.feedData.user?.isVerified ?? false,
      ),
    );
  }

  ///Route to my profile screen function
  routeToMyProfileScreen() {
    Get.toNamed(
      ScreenRoutesConstants.myProfileScreen,
      arguments: userSingleton.id,
    );
  }

  ///Route to see other user profile screen while tapping on user profile image tap feed post
  routeToOtherUserProfileScreen() async {
    if (userSingleton.id == widget.feedData.user?.userId) {
      routeToMyProfileScreen();
    } else {
      Logger().i(widget.feedData.user?.userId);
      var callBackData = await Get.to(
        UserProfileScreen(
          userId: widget.feedData.user?.userId,
        ),
        binding: UserProfileBinding(),
      );
      if (callBackData != null) {
        widget.feedData.user?.isConnected.value = callBackData;
      }
      Logger().i(widget.feedData.user);
    }
  }

  ///Handle event of like & dislike post
  handleLikeDislikeTap() async {
    if (widget.feedData.isLikeFeed.value == false) {
      widget.feedData.likesCounters.value = widget.feedData.likesCounters.value + 1;
      widget.feedData.isLikeFeed.value = true;
      await CommonApiFunction.likePostApi(
        feedId: widget.feedData.feedId ?? 0,
        onSuccess: (value) {
          widget.feedData.likesCounters.value = value;
          widget.feedData.isLikeFeed.value = true;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
          widget.feedData.likesCounters.value = widget.feedData.likesCounters.value - 1;
          widget.feedData.isLikeFeed.value = false;
        },
      );
    } else {
      widget.feedData.likesCounters.value = widget.feedData.likesCounters.value - 1;
      widget.feedData.isLikeFeed.value = false;
      await CommonApiFunction.unlikePostApi(
        feedId: widget.feedData.feedId ?? 0,
        onSuccess: (value) {
          widget.feedData.likesCounters.value = value;
          widget.feedData.isLikeFeed.value = false;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
          widget.feedData.likesCounters.value = widget.feedData.likesCounters.value + 1;
          widget.feedData.isLikeFeed.value = true;
        },
      );
    }
  }

  ///Handle event of user friend connect request
  handleOnConnectButtonPress() async {
    var apiResult = await CommonApiFunction.commonConnectApi(
        userId: widget.feedData.user?.userId ?? 0,
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
        });
    if (apiResult) {
      widget.feedData.user?.isConnected.value = AppStrings.requested;
    }
  }
}


