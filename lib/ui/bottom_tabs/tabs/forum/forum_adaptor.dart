// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/model/bottom_navigation_models/forum_models/forum_list_model.dart';

import '../../../../utils/app_common_stuffs/commom_utils.dart';
import '../../../../utils/app_common_stuffs/common_api_function.dart';
import '../../../../utils/app_common_stuffs/screen_routes.dart';
import '../../../../utils/app_common_stuffs/send_functionality.dart';
import '../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../common_ui/forum_common_ui/forum_post_widget.dart';

class ForumAdaptor extends StatefulWidget {
  ForumData forumData;
  VoidCallback screenRoutes;
  VoidCallback commentButton;
  VoidCallback threeDotTap;
  PageController pageController;
  VoidCallback? onConnectButtonPress;
  VoidCallback? userProfileCallBack;
  Function(int subIndex) onPostImageTap;
  bool? isUserProfileOpen;
  bool? forumDetailContent;
  bool? isThreeDotIconVisible;
  bool? isFromCategoryPage;

  ForumAdaptor(
      {Key? key,
      required this.forumData,
      required this.screenRoutes,
      required this.commentButton,
      required this.pageController,
      required this.threeDotTap,
      required this.onPostImageTap,
      this.onConnectButtonPress,
      this.userProfileCallBack,
        this.forumDetailContent,
      this.isUserProfileOpen,
        this.isFromCategoryPage,
      this.isThreeDotIconVisible})
      : super(key: key);

  @override
  State<ForumAdaptor> createState() => _ForumAdaptorState();
}

class _ForumAdaptorState extends State<ForumAdaptor> with AutomaticKeepAliveClientMixin<ForumAdaptor>{
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      ()=> ForumPostWidget(
        isAdmin: widget.forumData.user?.isAdmin,
        isThreeDotIconVisible: widget.isThreeDotIconVisible ?? true,
        userProfileImageUrl: widget.forumData.user?.profileImg ?? '',
        userProfileImageTap: widget.userProfileCallBack ?? () {},
        fName: widget.forumData.user?.firstName ?? '',
        lName: widget.forumData.user?.lastName ?? '',
        companyName: widget.forumData.user?.companyName ?? '',
        forumPostTimeAgo: widget.forumData.getHoursAgo,
        onThreeDotTap: widget.threeDotTap,
        isUserConnected: widget.forumData.user?.isConnected.value ?? AppStrings.notConnected,
        onConnectButtonPress: () {
          handleOnConnectButtonPress();
        },
        userType: widget.forumData.user?.userType ?? '',
        isUserMe: CommonUtils.isUserMe(id: widget.forumData.user?.userId ?? 0, isAdmin: widget.forumData.user?.isAdmin ?? false),
        screenRoutes: widget.screenRoutes,
        postContent: widget.forumData.description ?? '',
        isExpandText: widget.forumData.showMore,
        postImages: widget.forumData.forumMedia ?? [],
        pageController: widget.pageController,
        onPostImageTap: widget.onPostImageTap,
        likeCounts: widget.forumData.likeCount.value,
        commentCounts: widget.forumData.commentCounter.value,
        onLikeButtonPressed: () {},
        onUpArrowTap: () {
          handleUpArrowTap();
        },
        onDownArrowTap: () {
          handleDownArrowTap();
        },
        onSendButtonPress: () {
          SendFunsctionality.sendBottomSheet(context: context, forumId: widget.forumData.forumId ?? 0);
        },
        onCommentButtonPressed: widget.commentButton,
        isShareIconVisible: false.obs,
        disLikeCount: widget.forumData.disLikeCount.value,
        forumCategoryName: widget.forumData.forumCategoryName ?? '',
        isUserVerify: widget.forumData.user?.isVerified ?? false,
        isLikeForum: widget.forumData.isLikeForum.value,
        isUnlikeForum: widget.forumData.isUnlikeForum.value,
        forumDetailContent: widget.forumDetailContent ?? false, onTapCategoryName: (){
          if(widget.isFromCategoryPage ?? false){
            Get.back();
          }else{
            _handleOnTapCategoryName();
          }
      },
      ),
    );

  }

  ///Handle event of user friend connect request
  handleOnConnectButtonPress() async {
    var apiResult = await CommonApiFunction.commonConnectApi(
        userId: widget.forumData.user?.userId ?? 0,
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
        });
    if (apiResult) {
      widget.forumData.user?.isConnected.value = AppStrings.requested;
    }
  }

  ///******Forum Like Event handle function*****////
  handleUpArrowTap() async {
    if (widget.forumData.isLikeForum.value == false) {
      widget.forumData.likeCount.value = widget.forumData.likeCount.value + 1;
      widget.forumData.disLikeCount.value = (widget.forumData.disLikeCount.value - 1) > 0 ? widget.forumData.disLikeCount.value - 1 : 0;
      widget.forumData.isLikeForum.value = true;
      widget.forumData.isUnlikeForum.value = false;
      await CommonApiFunction.likeForumApi(
        forumId: widget.forumData.forumId ?? 0,
        onSuccess: (likeCount) {
          widget.forumData.likeCount.value = likeCount[0];
          widget.forumData.disLikeCount.value = likeCount[1];
          widget.forumData.isLikeForum.value = true;
          widget.forumData.isUnlikeForum.value = false;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
          widget.forumData.likeCount.value = (widget.forumData.likeCount.value - 1) > 0 ? widget.forumData.likeCount.value - 1 : 0;
          widget.forumData.isLikeForum.value = false;
        },
      );
    }
  }

  ///******Forum DisLike Event handle function*****////
  handleDownArrowTap() async {
    if (widget.forumData.isUnlikeForum.value == false) {

      widget.forumData.disLikeCount.value = widget.forumData.disLikeCount.value + 1 ;
      widget.forumData.likeCount.value = (widget.forumData.likeCount.value - 1) > 0 ? widget.forumData.likeCount.value - 1 : 0;
      widget.forumData.isLikeForum.value = false;
      widget.forumData.isUnlikeForum.value = true;
      await CommonApiFunction.unlikeForumApi(
        forumId: widget.forumData.forumId ?? 0,
        onSuccess: (disLikeCount) {
          widget.forumData.likeCount.value = disLikeCount[0];
          widget.forumData.disLikeCount.value = disLikeCount[1];
          widget.forumData.isLikeForum.value = false;
          widget.forumData.isUnlikeForum.value = true;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
          widget.forumData.disLikeCount.value = (widget.forumData.disLikeCount.value - 1) > 0 ? widget.forumData.likeCount.value - 1 : 0;
          widget.forumData.isUnlikeForum.value = false;
        },
      );
    }
  }

  ///handle category OnTap Event
  _handleOnTapCategoryName(){
    Get.toNamed(ScreenRoutesConstants.categoryForumListScreen, arguments: [widget.forumData.forumCategoryId ?? 0,widget.forumData.forumCategoryName ?? '']);
  }
}
