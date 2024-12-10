// ignore_for_file: must_be_immutable

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/feed_list_model.dart';
import 'package:iso_net/ui/style/ImageWidget.dart';
import 'package:iso_net/ui/style/button_components.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'video_play_screen.dart';

class FeedPostWidget extends StatefulWidget {
  FeedPostWidget({
    Key? key,
    required this.userProfilePage,
    this.profileImageUrl,
    required this.fName,
    required this.lName,
    required this.companyName,
    this.onThreeDotTap,
    this.videoTap,
    this.onConnectButtonPress,
    this.isThreeDotIconVisible,
    required this.timeAgo,
    required this.postContent,
    required this.screenRoutes,
    required this.isExpandText,
    required this.postImages,
    required this.pageController,
    required this.onPostImageTap,
    required this.likeCounts,
    required this.commentCounts,
    required this.onLikeButtonPressed,
    required this.likedIcon,
    required this.onCommentButtonPressed,
    this.onSendButtonPressed,
    required this.isShareIconVisible,
    required this.isUserConnected,
    this.connectText,
    this.connectIcon,
    required this.isUserMe,
    required this.isUserVerify,
    this.feedDetailContent,
    this.userType,
  }) : super(key: key);

  String? profileImageUrl;
  String fName;
  String lName;
  String timeAgo;
  String companyName;
  VoidCallback userProfilePage;
  VoidCallback? onThreeDotTap;
  VoidCallback? onConnectButtonPress;
  bool? isThreeDotIconVisible;
  String postContent;
  VoidCallback screenRoutes;
  RxBool isExpandText;
  List<FeedMedia> postImages;
  PageController pageController;
  Function(int subIndex) onPostImageTap;
  VoidCallback onLikeButtonPressed;
  Function(int subIndex)? videoTap;
  int likeCounts;
  int commentCounts;
  String likedIcon;
  String? connectIcon;
  String? connectText;
  VoidCallback onCommentButtonPressed;
  VoidCallback? onSendButtonPressed;
  RxBool isUserMe = true.obs;
  RxBool isShareIconVisible = false.obs;
  RxString isUserConnected = ''.obs;
  bool isUserVerify;
  bool? feedDetailContent;
  String? userType;

  @override
  State<FeedPostWidget> createState() => _FeedPostWidgetState();
}

class _FeedPostWidgetState extends State<FeedPostWidget> with AutomaticKeepAliveClientMixin<FeedPostWidget> {
  late VideoPlayerController videoPlayerController;

  ChewieController? chewieController;

  RxInt dotIndicatorIndex = 0.obs;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.greyColor,
            width: 8.w,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 1,
            color: AppColors.greyColor,
          ),
          buildTop2Section(),
          //buildTopSection(),
          buildContentSection(),
          widget.postImages.isEmpty ? Container() : buildImageSection(),
          buildLikeCommentCounter(),
        ],
      ),
    );
  }

  ///buildTop 2 section
  Widget buildTop2Section() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          padding: EdgeInsets.only(top: 12.0.h, right: 6.0.w, left: 3.0.w, bottom: 7.0.h),
          child: GestureDetector(
            onTap: widget.userProfilePage,
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IgnorePointer(
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          child: ImageComponent.circleNetworkImage(
                            imageUrl: widget.profileImageUrl ?? '',
                            height: 46.w,
                            width: 46.w,
                          ),
                        ),
                        Visibility(
                          visible: widget.isUserVerify == true,
                          child: Positioned(
                            bottom: 6.h,
                            right: 6.w,
                            child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, height: 12.h, width: 12.w, boxFit: BoxFit.contain),
                          ),
                        ),
                        Visibility(
                          visible: widget.userType != null && (widget.userType ?? '').isNotEmpty,
                          child: Positioned(
                            top: 5.h,
                            left: 5.w,
                            child: ImageComponent.loadLocalImage(imageName: widget.userType == AppStrings.fu ? AppImages.funderBadge : AppImages.brokerBadge, height: 12.h, width: 12.w),
                          ),
                        ),
                      ],
                    ),
                  ),
                  8.sizedBoxW,
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.userProfilePage,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${widget.fName} ${widget.lName}',
                            style: ISOTextStyles.openSenseSemiBold(size: 16),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  widget.companyName.isEmpty
                                      ? Container()
                                      : Text(
                                          widget.companyName,
                                          style: ISOTextStyles.sfProDisplay(size: 10, color: AppColors.hintTextColor),
                                        ),
                                  Text(
                                    widget.timeAgo,
                                    style: ISOTextStyles.sfProDisplay(size: 10, color: AppColors.hintTextColor),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: widget.isUserConnected.value != 'Connected' && widget.isUserMe.value == true,
                                child: GestureDetector(
                                  onTap: widget.onConnectButtonPress,
                                  child: Row(
                                    children: [
                                      Obx(
                                        () => Image.asset(
                                          widget.isUserConnected.value == AppStrings.notConnected ? AppImages.plus : AppImages.check,
                                          height: 10,
                                          width: 10,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      3.sizedBoxW,
                                      Obx(
                                        () => Text(
                                          widget.isUserConnected.value == AppStrings.notConnected ? AppStrings.connect : AppStrings.requested,
                                          style: ISOTextStyles.sfProTextSemiBold(size: 14),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.isThreeDotIconVisible ?? true,
          child: GestureDetector(
              onTap: widget.onThreeDotTap,
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(top: 15, bottom: 0, right: 11.w, left: 3.h),
                child: Image.asset(
                  AppImages.threeDots,
                ),
              )),
        ),
      ],
    );
  }

  /// build content section
  buildContentSection() {
    return GestureDetector(
      onTap: widget.screenRoutes,
      child: Container(
        alignment: Alignment.centerLeft,
        color: Colors.transparent,
        padding: EdgeInsets.only(right: 16.0.w, left: 11.0.w, bottom: 11.5.h),
        child: widget.feedDetailContent == true
            ? Text(
                widget.postContent,
                style: ISOTextStyles.openSenseRegular(size: 14, linespacing: 1.8),
              )
            : CommonUtils.seeMoreText(content: widget.postContent, isExpand: widget.isExpandText, seeMoreTap: widget.screenRoutes),
      ),
    );
  }

  /// build image / videos section
  buildImageSection() {
    return SizedBox(
      height: 218.w,
      width: double.infinity,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          PageView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: widget.postImages.length,
            controller: widget.pageController,
            scrollDirection: Axis.horizontal,
            // onPageChanged: (value) => onPageChanged(value),
            onPageChanged: (value) {
              dotIndicatorIndex.value = value;
              Logger().i('PageChange :- ${dotIndicatorIndex.value}');
            },
            itemBuilder: (BuildContext context, int subIndex) {
              if (widget.postImages[subIndex].mediaType == 'video') {
                videoPlayerController = VideoPlayerController.network(
                  widget.postImages[subIndex].feedMedia ?? '',
                );
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    ImageWidget(
                      url: widget.postImages[subIndex].thumbnail ?? '',
                      fit: BoxFit.cover,
                    ),
                    // ImageComponent.cachedImageNetwork(imageUrl: widget.postImages[subIndex].thumbnail ?? '', onImageTap: () {}),
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
                            video: widget.postImages[subIndex].feedMedia ?? '',
                          ),
                        );
                      },
                    ),
                  ],
                );
              } else {
                return GestureDetector(
                  onTap: () {
                    widget.onPostImageTap(subIndex);
                  },
                  child: ImageWidget(
                    url: widget.postImages[subIndex].feedMedia ?? '',
                    fit: BoxFit.cover,
                    placeholder: AppImages.imagePlaceholder,
                  ),
                );
                // return ImageComponent.cachedImageNetwork(
                //   imageUrl: widget.postImages[subIndex].feedMedia ?? '',
                //   onImageTap: () {
                //     widget.onPostImageTap(subIndex);
                //   });
              }
            },
          ),
          Visibility(
            visible: widget.postImages.length == 1 ? false : true,
            child: Positioned(
              bottom: 12.0.h,
              child: Container(
                padding: EdgeInsets.only(top: 12.0.h),
                child: Obx(
                  () => AnimatedSmoothIndicator(
                    activeIndex: dotIndicatorIndex.value,
                    count: widget.postImages.length,
                    effect: ScrollingDotsEffect(
                      dotHeight: 6.0,
                      dotWidth: 6.0,
                      activeDotColor: AppColors.primaryColor,
                      dotColor: Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// build  likes & comments counter section
  buildLikeCommentCounter() {
    return Container(
      padding: EdgeInsets.only(
        top: 4.0.h,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20.w, right: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonComponents.textIconButton(
                  onTap: widget.onLikeButtonPressed,
                  icon: widget.likedIcon,
                  labelText: NumberFormatter.getShortForm(widget.likeCounts),
                  iconHeight: 17.h,
                  boxFit: BoxFit.contain,
                  textStyle: ISOTextStyles.openSenseSemiBold(size: 14, color: AppColors.hintTextColor),
                ),
                ButtonComponents.textIconButton(
                  onTap: widget.onCommentButtonPressed,
                  icon: AppImages.comment,
                  iconHeight: 16,
                  boxFit: BoxFit.contain,
                  labelText: '${NumberFormatter.getShortForm(widget.commentCounts)} ${widget.commentCounts > 1 ? AppStrings.comments : AppStrings.comment}',
                  textStyle: ISOTextStyles.openSenseRegular(size: 12, color: AppColors.hintTextColor),
                ),
              ],
            ),
          ),
          /*Container(
            margin: EdgeInsets.only(left: 6.0.w, right: 6.0.w),
            height: 0.6,
            width: double.infinity,
            color: AppColors.redColor,
          ),*/
          //buildFooterSection(),
        ],
      ),
    );
  }

  ///build footer section , likes & comments
  buildFooterSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.0.h),
      //color: Colors.yellow,
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: widget.onCommentButtonPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.commentOutline,
                    height: 13.w,
                    width: 13.w,
                    fit: BoxFit.contain,
                  ),
                  6.sizedBoxW,
                  Text(AppStrings.comment, style: ISOTextStyles.sfProTextSemiBold(size: 14, color: AppColors.indicatorColor))
                ],
              ),
            ),
          ),
          /* Expanded(
              child: GestureDetector(
            onTap: widget.onSendButtonPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.sendOutline,
                  height: 13.w,
                  width: 13.w,
                  fit: BoxFit.contain,
                ),
                6.sizedBoxW,
                Text(AppStrings.send, style: ISOTextStyles.sfProTextSemiBold(size: 14, color: AppColors.indicatorColor))
              ],
            ),
          )),*/
          Visibility(
            visible: widget.isShareIconVisible.value,
            child: Expanded(
              child: ButtonComponents.textIconButton(
                onTap: () {},
                icon: AppImages.shareFill,
                labelText: AppStrings.share,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // buildFooterSection() {
  generateThumbnail({String? video}) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: video ?? '',
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.WEBP,
      maxHeight: 64,
      // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
      quality: 75,
    );
    return fileName;
  }
}
