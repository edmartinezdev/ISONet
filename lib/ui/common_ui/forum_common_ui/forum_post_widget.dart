import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/ui/common_ui/video_play_screen.dart';
import 'package:iso_net/ui/style/ImageWidget.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:video_player/video_player.dart';

import '../../../model/bottom_navigation_models/forum_models/forum_list_model.dart';
import '../../../utils/app_common_stuffs/app_colors.dart';
import '../../../utils/app_common_stuffs/app_images.dart';
import '../../../utils/app_common_stuffs/app_logger.dart';
import '../../../utils/app_common_stuffs/commom_utils.dart';
import '../../../utils/app_common_stuffs/strings_constants.dart';
import '../../style/button_components.dart';
import '../../style/image_components.dart';
import '../../style/text_style.dart';

// ignore: must_be_immutable
class ForumPostWidget extends StatefulWidget {
  ForumPostWidget({
    Key? key,
    this.isAdmin,
    required this.userProfileImageUrl,
    required this.userProfileImageTap,
    required this.fName,
    required this.lName,
    required this.companyName,
    required this.forumPostTimeAgo,
    this.onThreeDotTap,
    this.isThreeDotIconVisible,
    required this.isUserConnected,
    this.onConnectButtonPress,
    required this.isUserMe,
    required this.screenRoutes,
    required this.postContent,
    required this.isExpandText,
    required this.postImages,
    required this.pageController,
    required this.onPostImageTap,
    required this.likeCounts,
    required this.disLikeCount,
    required this.commentCounts,
    required this.onLikeButtonPressed,
    required this.forumCategoryName,
    this.onUpArrowTap,
    this.onDownArrowTap,
    this.onSendButtonPress,
    required this.onCommentButtonPressed,
    required this.isShareIconVisible,
    required this.isUserVerify,
    required this.isLikeForum,
    required this.isUnlikeForum,
    this.forumDetailContent,
    this.userType,
    required this.onTapCategoryName,
  }) : super(key: key);

  String userProfileImageUrl;
  String fName;
  String lName;
  String forumPostTimeAgo;
  String companyName;
  VoidCallback? userProfileImageTap;
  VoidCallback? onThreeDotTap;
  bool? isThreeDotIconVisible;
  VoidCallback? onConnectButtonPress;
  String? userType;
  RxBool isUserMe = true.obs;
  VoidCallback screenRoutes;
  String postContent;
  RxBool isExpandText;
  List<ForumMedia> postImages;
  PageController pageController;
  Function(int subIndex) onPostImageTap;
  VoidCallback onLikeButtonPressed;
  String forumCategoryName;
  VoidCallback? onUpArrowTap;
  VoidCallback? onDownArrowTap;
  VoidCallback? onSendButtonPress;
  VoidCallback onTapCategoryName;
  Function(int subIndex)? videoTap;
  int likeCounts;
  int disLikeCount;
  int commentCounts;
  bool? isAdmin;
  bool? isLikeForum;
  bool? isUnlikeForum;

  VoidCallback onCommentButtonPressed;

  RxBool isShareIconVisible = false.obs;
  String isUserConnected;
  bool isUserVerify;
  bool? forumDetailContent;

  @override
  State<ForumPostWidget> createState() => _ForumPostWidgetState();
}

class _ForumPostWidgetState extends State<ForumPostWidget> with AutomaticKeepAliveClientMixin<ForumPostWidget> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  RxInt dotIndicatorIndex = 0.obs;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

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
          // userTopSection(),
          buildTop2Section(),
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
            onTap: widget.isAdmin == true ? null : widget.userProfileImageTap,
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (widget.isAdmin ?? false) == true
                      ? ImageComponent.loadLocalImage(imageName: AppImages.appLogo, height: 46.w, width: 46.w, boxFit: BoxFit.contain)
                      : IgnorePointer(
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5.0),
                                child: ImageComponent.circleNetworkImage(
                                  imageUrl: widget.userProfileImageUrl,
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
                                  top: 4.h,
                                  left: 4.w,
                                  child: ImageComponent.loadLocalImage(imageName: widget.userType == AppStrings.fu ? AppImages.funderBadge : AppImages.brokerBadge, height: 12.h, width: 12.w),
                                ),
                              ),
                            ],
                          ),
                        ),
                  8.sizedBoxW,
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.isAdmin == true ? null : widget.userProfileImageTap,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            (widget.isAdmin ?? false) == true ? AppStrings.isoNetAdmin : '${widget.fName} ${widget.lName}',
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
                                    widget.forumPostTimeAgo,
                                    style: ISOTextStyles.sfProDisplay(size: 10, color: AppColors.hintTextColor),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: (widget.isAdmin ?? false) == false && widget.isUserConnected != 'Connected' && widget.isUserMe.value == true,
                                child: GestureDetector(
                                  onTap: widget.onConnectButtonPress,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        widget.isUserConnected == AppStrings.notConnected ? AppImages.plus : AppImages.check,
                                        height: 10,
                                        width: 10,
                                        fit: BoxFit.contain,
                                      ),
                                      3.sizedBoxW,
                                      Text(
                                        widget.isUserConnected == AppStrings.notConnected ? AppStrings.connect : AppStrings.requested,
                                        style: ISOTextStyles.sfProTextSemiBold(size: 14),
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
                child: Image.asset(AppImages.threeDots),
              )),
        ),
      ],
    );
  }

  /// build content section
  Widget buildContentSection() {
    return GestureDetector(
      onTap: widget.screenRoutes,
      child: Container(
        alignment: Alignment.centerLeft,
        color: AppColors.transparentColor,
        padding: EdgeInsets.only(right: 16.0.w, left: 16.0.w, top: 4.0.h, bottom: 11.5.h),
        child: widget.forumDetailContent == true
            ? Text(
                widget.postContent,
                style: ISOTextStyles.openSenseRegular(size: 14, linespacing: 1.8),
              )
            : CommonUtils.seeMoreText(
                content: widget.postContent,
                isExpand: widget.isExpandText,
              ),
      ),
    );
  }

  /// build image / videos section
  Widget buildImageSection() {
    return AspectRatio(
      aspectRatio: 6 / 4,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          PageView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: widget.postImages.length,
            controller: widget.pageController,
            scrollDirection: Axis.horizontal,
            onPageChanged: (value) {
              dotIndicatorIndex.value = value;
              Logger().i('PageChange :- ${dotIndicatorIndex.value}');
            },
            itemBuilder: (BuildContext context, int subIndex) {
              videoPlayerController = VideoPlayerController.network(
                widget.postImages[subIndex].forumMedia ?? '',
              );

              if (widget.postImages[subIndex].mediaType == 'video') {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    ImageWidget(
                      url: widget.postImages[subIndex].thumbnail ?? '',
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
                            video: widget.postImages[subIndex].forumMedia ?? '',
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
                      url: widget.postImages[subIndex].forumMedia ?? "",
                      fit: BoxFit.cover,
                      placeholder: AppImages.imagePlaceholder,
                    ));
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
  Widget buildLikeCommentCounter() {
    return Container(
      padding: EdgeInsets.only(top: 8.0.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 10.0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible:widget.forumCategoryName != '' ,
                  child: GestureDetector(
                    onTap: widget.onTapCategoryName,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 5.0.h),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(22.0), color: AppColors.greyColor),
                      child: Text(
                        widget.forumCategoryName,
                        style: ISOTextStyles.openSenseSemiBold(size: 14),
                      ),
                    ),
                  ),
                ),
                14.sizedBoxH,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          NumberFormatter.getShortForm(widget.likeCounts),
                          style: ISOTextStyles.sfProTextSemiBold(size: 14, color: AppColors.indicatorColor),
                        ),
                        10.sizedBoxW,
                        GestureDetector(
                          onTap: widget.onUpArrowTap,
                          child: Container(
                            child: ImageComponent.loadLocalImage(
                              imageName: (widget.isLikeForum ?? false) ? AppImages.upArrowYellow : AppImages.upArrowWhiteFill,
                              height: 26.h,
                              width: 26.h,
                              boxFit: BoxFit.contain,
                            ),
                          ),
                        ),
                        10.sizedBoxW,
                        GestureDetector(
                          onTap: widget.onDownArrowTap,
                          child: Container(
                            child: ImageComponent.loadLocalImage(
                              imageName: (widget.isUnlikeForum ?? false) ? AppImages.downArrowYellow : AppImages.downArrowFillWhite,
                              height: 26.h,
                              width: 26.h,
                              boxFit: BoxFit.contain,
                            ),
                          ),
                        ),
                        10.sizedBoxW,
                        Text(
                          NumberFormatter.getShortForm(widget.disLikeCount),
                          style: ISOTextStyles.sfProTextSemiBold(size: 14, color: AppColors.indicatorColor),
                        ),
                      ],
                    ),
                    ButtonComponents.textIconButton(
                      onTap: widget.onCommentButtonPressed,
                      icon: AppImages.comment,
                      labelText: '${NumberFormatter.getShortForm(widget.commentCounts)} ${widget.commentCounts > 1 ? AppStrings.comments : AppStrings.comment}',
                      textStyle: ISOTextStyles.sfPro(size: 14, color: AppColors.indicatorColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
          /*Container(
            margin: EdgeInsets.only(left: 6.0.w, right: 6.0.w),
            height: 0.6,
            width: double.infinity,
            color: AppColors.dividerColor,
          ),*/
          /*buildFooterSection(),*/
        ],
      ),
    );
  }

  ///build footer section , likes & comments
  Widget buildFooterSection() {
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
                  Text("Comment", style: ISOTextStyles.sfProTextSemiBold(size: 14, color: AppColors.indicatorColor))
                ],
              ),
            ),
            // child: ButtonComponents.textIconButton(
            //   onTap: widget.onCommentButtonPressed,
            //   icon: AppImages.commentOutline,
            //   iconHeight: 13.h,
            //   labelText: AppStrings.comment,
            // ),
          ),
          /* Expanded(
              child: GestureDetector(
            onTap: widget.onSendButtonPress,
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
}
