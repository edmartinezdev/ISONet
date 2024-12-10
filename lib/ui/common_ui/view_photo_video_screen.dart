// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/user_screens/user_profile_screen.dart';
import 'package:iso_net/ui/common_ui/fullScreen_photo_video.dart';
import 'package:iso_net/ui/style/ImageWidget.dart';
import 'package:iso_net/ui/style/appbar_components.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/common_api_function.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';
import 'package:iso_net/utils/swipe_back.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

import '../../bindings/bottom_tabs/feed_detail_binding.dart';
import '../../bindings/bottom_tabs/user_binding/user_profile_binding.dart';
import '../../model/bottom_navigation_models/news_feed_models/feed_list_model.dart';
import '../../utils/app_common_stuffs/app_images.dart';
import '../../utils/app_common_stuffs/commom_utils.dart';
import '../../utils/app_common_stuffs/strings_constants.dart';
import '../bottom_tabs/tabs/news_feed/feed_detail_screen.dart';
import '../style/button_components.dart';
import '../style/image_components.dart';
import '../style/text_style.dart';
import 'video_play_screen.dart';

class PhotoVideoScreen extends StatefulWidget {
  bool? isGetBack;

  PhotoVideoScreen({Key? key, this.isGetBack = false}) : super(key: key);

  @override
  State<PhotoVideoScreen> createState() => _PhotoVideoScreenState();
}

class _PhotoVideoScreenState extends State<PhotoVideoScreen> with SingleTickerProviderStateMixin {
  RxBool showMore = false.obs;
  FeedData postDetails = Get.arguments[0];
  int value = Get.arguments[1];
  PageController pageController = PageController(initialPage: Get.arguments[1]);
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  RxInt photoIndexes = 0.obs;

  @override
  void initState() {
    super.initState();
  }

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
        Get.back<FeedData>(result: postDetails);
        return true;
      },
      child: SwipeBackWidget(
        result: postDetails,
        child: Scaffold(
          backgroundColor: AppColors.blackColorDetailsPage,
          appBar: AppBarComponents.appBar(
            backgroundColor: AppColors.blackColorDetailsPage,
            leadingWidget: GestureDetector(
              onTap: () => Get.back<FeedData>(result: postDetails),
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
                    var downloadImageResult = await CommonUtils.imageDownload(imageUrl: postDetails.feedMedia?[photoIndexes.value].feedMedia ?? '', context: context);
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
                buildTop2Section(),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          PageView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: postDetails.feedMedia?.length,
                            controller: pageController,
                            allowImplicitScrolling: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int subIndex) {
                              //photoIndexes.value = subIndex;

                              if (postDetails.feedMedia?[subIndex].mediaType == 'video') {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ImageWidget(
                                      url: postDetails.feedMedia?[subIndex].thumbnail ?? '',
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
                                            video: postDetails.feedMedia?[subIndex].feedMedia ?? '',
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () async {
                                    subIndex = await Get.to(() => const FullScreenPhoto(), arguments: [postDetails, subIndex], transition: Transition.noTransition);
                                    pageController.jumpToPage(subIndex);
                                    Logger().i(subIndex);
                                    //isOnImageTap.value = !isOnImageTap.value;
                                  },
                                  child: PhotoView(
                                    minScale: PhotoViewComputedScale.contained * 1.0,
                                    maxScale: 2.0,
                                    imageProvider: CachedNetworkImageProvider(
                                      postDetails.feedMedia?[subIndex].feedMedia ?? '',
                                    ),
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
                        child: GestureDetector(
                          onTap: () async {
                            await pushToFeedDetailsPage();
                          },
                          child: Container(
                            color: AppColors.blackColorDetailsPage,
                            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
                            child: seeMoreText(postDetails.description ?? ''),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //postDetails.isOnImageTap.value
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() => ButtonComponents.textIconButton(
                                alignment: Alignment.center,
                                onTap: () async {
                                  if (postDetails.isLikeFeed.value == false) {
                                    var likeResponse = await CommonApiFunction.likePostApi(
                                      feedId: postDetails.feedId ?? 0,
                                      onSuccess: (value) {
                                        postDetails.likesCounters.value = value;
                                        // model.likesCounters.toSet();
                                        // Logger().i(model.likesCounters.toList());
                                      },
                                      onErr: (msg) {
                                        SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                      },
                                    );
                                    if (likeResponse) {
                                      postDetails.isLikeFeed.value = true;
                                    }
                                  } else {
                                    var likeResponse = await CommonApiFunction.unlikePostApi(
                                      feedId: postDetails.feedId ?? 0,
                                      onSuccess: (value) {
                                        postDetails.likesCounters.value = value;
                                      },
                                      onErr: (msg) {
                                        SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                      },
                                    );
                                    if (likeResponse) {
                                      postDetails.isLikeFeed.value = false;
                                    }
                                  }
                                },
                                iconHeight: 17.h,
                                icon: postDetails.isLikeFeed.value ? AppImages.dollarFill : AppImages.dollar,
                                labelText: '${NumberFormatter.getShortForm(postDetails.likesCounters.value)}',
                                boxFit: BoxFit.contain,
                                textStyle: ISOTextStyles.openSenseSemiBold(size: 14, color: AppColors.whiteColor),
                              )),
                          ButtonComponents.textIconButton(
                            onTap: () async {
                              if (widget.isGetBack == false) {
                                var callBackData = await Get.to(
                                    FeedDetailScreen(
                                      feedId: postDetails.feedId ?? 0,
                                    ),
                                    binding: FeedDetailBinding());
                                if (callBackData != null && callBackData != true) {
                                  postDetails = callBackData;
                                  Logger().i(postDetails.isLikeFeed.value);
                                  setState(() {});
                                } else if (callBackData == true) {
                                  Get.back(result: true);
                                }
                              } else {
                                Get.back<FeedData>(result: postDetails);
                              }
                            },
                            alignment: Alignment.centerRight,
                            textStyle: ISOTextStyles.openSenseRegular(size: 12, color: AppColors.whiteColor),
                            icon: AppImages.comment,
                            labelText: '${NumberFormatter.getShortForm(postDetails.comment ?? 0)}  ${(postDetails.comment ?? 0) > 1 ? AppStrings.comments : AppStrings.comment}',
                            iconColor: AppColors.transparentColor,
                          ),
                        ],
                      ),
                    ),
                    /* Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      child: const Divider(
                        color: AppColors.indicatorColor,
                        height: 0.5,
                      ),
                    ),
                    buildFooterSection()*/
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFooterSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.0.h),
      //color: Colors.yellow,
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () async {
                if (widget.isGetBack == false) {
                  var callBackData = await Get.to(
                      FeedDetailScreen(
                        feedId: postDetails.feedId ?? 0,
                      ),
                      binding: FeedDetailBinding());
                  if (callBackData != null && callBackData != true) {
                    postDetails = callBackData;
                    Logger().i(postDetails.isLikeFeed.value);
                    setState(() {});
                  } else if (callBackData == true) {
                    Get.back(result: true);
                  }
                } else {
                  Get.back<FeedData>(result: postDetails);
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.commentOutline,
                    height: 13.w,
                    width: 13.w,
                    fit: BoxFit.contain,
                    color: AppColors.whiteColor,
                  ),
                  6.sizedBoxW,
                  Text(AppStrings.comment, style: ISOTextStyles.sfProTextSemiBold(size: 14, color: AppColors.whiteColor))
                ],
              ),
            ),
          ),
          /* Expanded(
              child: GestureDetector(
            onTap: () {
              SendFunsctionality.sendBottomSheet(feedId: postDetails.feedId ?? 0, context: context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.sendOutline,
                  height: 13.w,
                  width: 13.w,
                  fit: BoxFit.contain,
                  color: AppColors.whiteColor,
                ),
                6.sizedBoxW,
                Text(AppStrings.send, style: ISOTextStyles.sfProTextSemiBold(size: 14, color: AppColors.whiteColor))
              ],
            ),
          )),*/
        ],
      ),
    );
  }

  Widget buildTop2Section() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          padding: EdgeInsets.only(top: 10.0.h, right: 6.0.w, left: 3.0.w, bottom: 7.0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  await pushToProfileDetailsPage();
                },
                child: Container(
                  color: Colors.transparent,
                  child: IgnorePointer(
                    child: Stack(
                      children: [
                        Container(
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
                            bottom: 4.h,
                            right: 4.w,
                            child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogoBlack, height: 12.h, width: 12.w, boxFit: BoxFit.contain),
                          ),
                        ),
                        Positioned(
                          top: 4.h,
                          left: 4.w,
                          child: ImageComponent.loadLocalImage(imageName: postDetails.user?.userType == AppStrings.fu ? AppImages.funderBadge : AppImages.brokerBadge, height: 12.h, width: 12.w),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              12.sizedBoxW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await pushToProfileDetailsPage();
                      },
                      child: Text(
                        '${postDetails.user?.firstName ?? ''} ${postDetails.user?.lastName ?? ''}',
                        style: ISOTextStyles.openSenseSemiBold(size: 16, color: AppColors.whiteColor),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await pushToProfileDetailsPage();
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (postDetails.user?.companyName ?? '').isEmpty
                                  ? Container()
                                  : Text(
                                      postDetails.user?.companyName ?? '',
                                      style: ISOTextStyles.sfProDisplay(size: 10, color: AppColors.whiteColor),
                                    ),
                              Text(
                                postDetails.getHoursAgo,
                                style: ISOTextStyles.sfProDisplay(size: 10, color: AppColors.whiteColor),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: postDetails.user?.isConnected.value != 'Connected' && (CommonUtils.isUserMe(id: postDetails.user?.userId ?? "").value == true),
                          child: Obx(
                            () => GestureDetector(
                              onTap: () async {
                                ShowLoaderDialog.showLoaderDialog(context);
                                var apiResult = await CommonApiFunction.commonConnectApi(
                                    userId: postDetails.user?.userId ?? 0,
                                    onErr: (msg) {
                                      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                      return;
                                    });
                                ShowLoaderDialog.dismissLoaderDialog();
                                if (apiResult) {
                                  postDetails.user?.isConnected.value = 'Requested';
                                }
                              },
                              child: Row(
                                children: [
                                  Image.asset((postDetails.user?.isNotConnected ?? true) ? AppImages.plus : AppImages.check, height: 10, width: 10, fit: BoxFit.contain, color: AppColors.whiteColor),
                                  3.sizedBoxW,
                                  Text(
                                    (postDetails.user?.isNotConnected ?? true) ? AppStrings.connect : AppStrings.requested,
                                    style: ISOTextStyles.sfProTextSemiBold(size: 14, color: AppColors.whiteColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> pushToFeedDetailsPage() async {
    var callBackData = await Get.to(
        FeedDetailScreen(
          feedId: postDetails.feedId ?? 0,
        ),
        binding: FeedDetailBinding());
    if (callBackData != null) {
      postDetails = callBackData;
    }
  }

  Future<void> pushToProfileDetailsPage() async {
    if (userSingleton.id == postDetails.user?.userId) {
      Get.toNamed(ScreenRoutesConstants.myProfileScreen, arguments: userSingleton.id);
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
}
