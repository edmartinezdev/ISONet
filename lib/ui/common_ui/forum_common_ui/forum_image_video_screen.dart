import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/bindings/bottom_tabs/forum_detail_binding.dart';
import 'package:iso_net/model/bottom_navigation_models/forum_models/forum_list_model.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/forum/forum_detail_screen.dart';
import 'package:iso_net/ui/style/ImageWidget.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';
import 'package:iso_net/utils/swipe_back.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

import '../../../bindings/bottom_tabs/user_binding/user_profile_binding.dart';
import '../../../singelton_class/auth_singelton.dart';
import '../../../utils/app_common_stuffs/app_colors.dart';
import '../../../utils/app_common_stuffs/app_images.dart';
import '../../../utils/app_common_stuffs/app_logger.dart';
import '../../../utils/app_common_stuffs/commom_utils.dart';
import '../../../utils/app_common_stuffs/common_api_function.dart';
import '../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../utils/app_common_stuffs/strings_constants.dart';
import '../../bottom_tabs/tabs/news_feed/user_screens/user_profile_screen.dart';
import '../../style/appbar_components.dart';
import '../../style/button_components.dart';
import '../../style/image_components.dart';
import '../../style/text_style.dart';
import '../video_play_screen.dart';
import 'fullscreen_forum_photo_video.dart';

// ignore: must_be_immutable
class ForumPhotoVideoView extends StatefulWidget {
  bool? isGetBack;

  ForumPhotoVideoView({Key? key, this.isGetBack = false}) : super(key: key);

  @override
  State<ForumPhotoVideoView> createState() => _ForumPhotoVideoViewState();
}

class _ForumPhotoVideoViewState extends State<ForumPhotoVideoView> {
  RxBool showMore = false.obs;
  ForumData postDetails = Get.arguments[0];
  int value = Get.arguments[1];
  PageController pageController = PageController(initialPage: Get.arguments[1]);
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  RxInt photoIndexes = 0.obs;

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back<ForumData>(result: postDetails);
        return true;
      },
      child: SwipeBackWidget(
        result: postDetails,
        child: Scaffold(
          backgroundColor: AppColors.darkBlackColor,
          appBar: AppBarComponents.appBar(
            backgroundColor: AppColors.darkBlackColor,

            leadingWidget: GestureDetector(
              onTap: () => Get.back<ForumData>(result: postDetails),
              child: Container(
                color: AppColors.transparentColor,
                child: ImageComponent.loadLocalImage(
                  imageName: AppImages.x,
                  imageColor: AppColors.whiteColor,
                ),
              ),
            ),
            actionWidgets: [
              InkWell(
                  onTap: () async {
                    var downloadImageResult = await CommonUtils.imageDownload(imageUrl: postDetails.forumMedia?[photoIndexes.value].forumMedia ?? '', context: context);
                    if (downloadImageResult) {
                      SnackBarUtil.showSnackBar(
                        context: context,
                        type: SnackType.success,
                        message: 'Downloaded',
                      );
                    }
                  },
                  child: ImageComponent.loadLocalImage(imageName: AppImages.download)),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                //postDetails.isOnImageTap.value

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                  child: GestureDetector(
                    onTap: pushToProfileDetailsPage,
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            (postDetails.user?.isAdmin ?? false) == true
                                ? ImageComponent.loadLocalImage(imageName: AppImages.appLogo, boxFit: BoxFit.cover, height: 42.h, width: 42.h)
                                : Container(
                                    padding: const EdgeInsets.all(5.0),
                                    child: ImageComponent.circleNetworkImage(
                                      imageUrl: postDetails.user?.profileImg ?? '',
                                      height: 46.w,
                                      width: 46.w,
                                    ),
                                  ),
                            Visibility(
                              visible: postDetails.user?.isVerified == true,
                              child: Positioned(
                                bottom: 6.h,
                                right: 6.w,
                                child: ImageComponent.loadLocalImage(
                                  imageName: AppImages.verifyLogoBlack,
                                  height: 12.h,
                                  width: 12.w,
                                  boxFit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: postDetails.user?.isAdmin != true,
                              child: Positioned(
                                top: 4.h,
                                left: 4.w,
                                child: ImageComponent.loadLocalImage(imageName: postDetails.user?.userType == AppStrings.fu ? AppImages.funderBadge : AppImages.brokerBadge, height: 12.h, width: 12.w),
                              ),
                            ),
                          ],
                        ),
                        7.sizedBoxW,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              postDetails.user?.isAdmin == true ? 'IsoNet Admin' : ("${postDetails.user?.firstName ?? ''} ${postDetails.user?.lastName ?? ''}"),
                              style: ISOTextStyles.openSenseMedium(size: 15, color: AppColors.whiteColor),
                            ),
                            Visibility(
                              visible: postDetails.user?.isAdmin != true,
                              child: Text(
                                postDetails.user?.companyName ?? '',
                                style: ISOTextStyles.openSenseRegular(size: 10, color: AppColors.whiteColor),
                              ),
                            ),
                            Text(
                              postDetails.getHoursAgo,
                              style: ISOTextStyles.openSenseRegular(size: 10, color: AppColors.whiteColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          PageView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: postDetails.forumMedia?.length,
                            controller: pageController,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int subIndex) {
                              photoIndexes.value = subIndex;

                              if (postDetails.forumMedia?[subIndex].mediaType == 'video') {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ImageWidget(
                                      url: postDetails.forumMedia?[subIndex].thumbnail ?? '',
                                      fit: BoxFit.cover,
                                      placeholder: AppImages.imagePlaceholder,
                                    ),
                                    InkWell(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12.0.r),
                                          color: AppColors.primaryColor,
                                        ),
                                        child: Icon(
                                          Icons.play_arrow_rounded,
                                          color: AppColors.whiteColor,
                                          size: 42.sp,
                                        ),
                                      ),
                                      onTap: () {
                                        Get.to(
                                          VideoPlayScreen(
                                            video: postDetails.forumMedia?[subIndex].forumMedia ?? '',
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () async {
                                    subIndex = await Get.to(() => const FullScreenForumPhotoVideo(), arguments: [postDetails, subIndex], transition: Transition.noTransition);
                                    pageController.jumpToPage(subIndex);
                                    Logger().i(subIndex);
                                  },
                                  child: PhotoView(
                                    minScale: PhotoViewComputedScale.contained * 1.0,
                                    maxScale: 2.0,
                                    imageProvider: CachedNetworkImageProvider(postDetails.forumMedia?[subIndex].forumMedia ?? ''),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: AppColors.darkBlackColor,
                          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
                          child: seeMoreText(postDetails.description ?? ''),
                        ),
                      ),
                    ],
                  ),
                ),
                //postDetails.isOnImageTap.value
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 12.0.h),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => Row(
                              children: [
                                Text(
                                  '${postDetails.likeCount.value}',
                                  style: ISOTextStyles.sfProTextSemiBold(size: 14, color: AppColors.whiteColor),
                                ),
                                10.sizedBoxW,
                                GestureDetector(
                                  onTap: () {
                                    handleUpArrowTap();
                                  },
                                  child: Container(
                                    color: AppColors.transparentColor,
                                    child: ImageComponent.loadLocalImage(
                                        imageName: (postDetails.isLikeForum.value) ? AppImages.upArrowYellow : AppImages.blackFillUpArrow, height: 25.h, width: 25.h, boxFit: BoxFit.contain),
                                  ),
                                ),
                                10.sizedBoxW,
                                GestureDetector(
                                  onTap: () {
                                    handleDownArrowTap();
                                  },
                                  child: Container(
                                    color: AppColors.transparentColor,
                                    child: ImageComponent.loadLocalImage(
                                        imageName: (postDetails.isUnlikeForum.value) ? AppImages.downArrowYellow : AppImages.blackDownArrow, height: 25.h, width: 25.h, boxFit: BoxFit.contain),
                                  ),
                                ),
                                10.sizedBoxW,
                                Text(
                                  '${postDetails.disLikeCount.value}',
                                  style: ISOTextStyles.sfProTextSemiBold(size: 14, color: AppColors.whiteColor),
                                ),
                              ],
                            ),
                          ),
                          ButtonComponents.textIconButton(
                              onTap: () async {
                                if (widget.isGetBack == false) {
                                  var callBackData = await Get.to(ForumDetailScreen(forumId: postDetails.forumId ?? 0), binding: ForumDetailBinding());
                                  if (callBackData != null && callBackData != true) {
                                    postDetails = callBackData;
                                    setState(() {});
                                  } else if (callBackData == true) {
                                    Get.back(result: true);
                                  }
                                } else {
                                  Get.back<ForumData>(result: postDetails);
                                }
                              },
                              icon: AppImages.comment,
                              labelText: '${postDetails.comment} ${(postDetails.comment ?? 0) > 1 ? AppStrings.comments : AppStrings.comment}',
                              textStyle: ISOTextStyles.openSenseRegular(size: 12, color: AppColors.whiteColor),
                              iconColor: AppColors.transparentColor),
                        ],
                      ),
                      /*const Divider(
                        color: AppColors.dividerColor,
                        thickness: 0.5,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                        //color: Colors.yellow,
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Expanded(
                                child: ButtonComponents.textIconButton(
                              onTap: () async {
                                // Get.toNamed(
                                //   ScreenRoutesConstants.forumDetailScreen,
                                //   arguments: postDetails,
                                // );
                                if (widget.isGetBack == false) {
                                  var callBackData = await Get.to(ForumDetailScreen(forumId: postDetails.forumId ?? 0), binding: ForumDetailBinding());
                                  if (callBackData != null && callBackData != true) {
                                    postDetails = callBackData;
                                    setState(() {});
                                  }else if(callBackData == true){
                                    Get.back(result: true);
                                  }
                                } else {
                                  Get.back<ForumData>(result: postDetails);
                                }
                              },
                              icon: AppImages.commentWhite,
                              labelText: 'Comment',
                              textStyle: ISOTextStyles.sfProSemiBold(size: 14, color: AppColors.whiteColor),
                            )),
                            */ /*Expanded(
                              child: ButtonComponents.textIconButton(
                                onTap: () {
                                  SendFunsctionality.sendBottomSheet(forumId: postDetails.forumId ?? 0, context: context);
                                },
                                icon: AppImages.sendWhite,
                                labelText: 'Send',
                                textStyle: ISOTextStyles.sfProSemiBold(size: 14, color: AppColors.whiteColor),
                              ),
                            ),*/ /*
                          ],
                        ),
                      ),*/
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget seeMoreText(String content) {
    return content.length <= 80
        ? Text(
            content,
            style: ISOTextStyles.openSenseRegular(
              color: AppColors.whiteColor,
              size: 14,
            ),
          )
        : Obx(
            () {
              return RichText(
                text: TextSpan(
                  text: showMore.value ? content : '${content.substring(0, 80)} ...    ',
                  style: ISOTextStyles.openSenseRegular(
                    size: 14,
                    color: AppColors.whiteColor,
                  ),
                  children: [
                    TextSpan(
                      text: showMore.value ? '  ' 'see less' : 'see more',
                      recognizer: TapGestureRecognizer()..onTap = () => showMore.value = !showMore.value,
                      style: ISOTextStyles.openSenseBold(
                        size: 14,
                        color: AppColors.whiteColor,
                      ),
                    )
                  ],
                ),
              );
            },
          );
  }

  ///******Forum Like Event handle function*****////
  handleUpArrowTap() async {
    if (postDetails.isLikeForum.value == false) {
      postDetails.likeCount.value = postDetails.likeCount.value + 1;
      postDetails.disLikeCount.value = (postDetails.disLikeCount.value - 1) > 0 ? postDetails.disLikeCount.value - 1 : 0;
      postDetails.isLikeForum.value = true;
      postDetails.isUnlikeForum.value = false;
      await CommonApiFunction.likeForumApi(
        forumId: postDetails.forumId ?? 0,
        onSuccess: (likeCount) {
          postDetails.likeCount.value = likeCount[0];
          postDetails.disLikeCount.value = likeCount[1];
          postDetails.isLikeForum.value = true;
          postDetails.isUnlikeForum.value = false;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
          postDetails.likeCount.value = (postDetails.likeCount.value - 1) > 0 ? postDetails.likeCount.value - 1 : 0;
          postDetails.isLikeForum.value = false;
        },
      );
    }
  }

  ///******Forum DisLike Event handle function*****////
  handleDownArrowTap() async {
    if (postDetails.isUnlikeForum.value == false) {
      postDetails.disLikeCount.value = postDetails.disLikeCount.value + 1 ;
      postDetails.likeCount.value = (postDetails.likeCount.value - 1) > 0 ? postDetails.likeCount.value - 1 : 0;
      postDetails.isLikeForum.value = false;
      postDetails.isUnlikeForum.value = true;
      await CommonApiFunction.unlikeForumApi(
        forumId: postDetails.forumId ?? 0,
        onSuccess: (disLikeCount) {
          postDetails.likeCount.value = disLikeCount[0];
          postDetails.disLikeCount.value = disLikeCount[1];
          postDetails.isLikeForum.value = false;
          postDetails.isUnlikeForum.value = true;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
          postDetails.disLikeCount.value = (postDetails.disLikeCount.value - 1) > 0 ? postDetails.likeCount.value - 1 : 0;
          postDetails.isUnlikeForum.value = false;
        },
      );
    }
  }

  Future<void> pushToProfileDetailsPage() async {
    if (userSingleton.id == postDetails.user?.userId) {
      Get.toNamed(ScreenRoutesConstants.myProfileScreen, arguments: userSingleton.id);
    } else if (postDetails.user?.isAdmin == true) {
      null;
    } else {
      Logger().i(postDetails.user?.userId);
      var callBackData = await Get.to(
        UserProfileScreen(
          userId: postDetails.user?.userId,
        ),
        binding: UserProfileBinding(),
      );
      if (callBackData != null) {
        postDetails.user?.isConnected.value = callBackData;
      }
    }
  }
}
