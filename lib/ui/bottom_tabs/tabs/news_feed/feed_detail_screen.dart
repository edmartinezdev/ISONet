// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/bindings/bottom_tabs/user_binding/user_profile_binding.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/feed_detail_controller.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../model/bottom_navigation_models/news_feed_models/feed_list_model.dart';
import '../../../../singelton_class/auth_singelton.dart';
import '../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../utils/app_common_stuffs/commom_utils.dart';
import '../../../../utils/app_common_stuffs/common_api_function.dart';
import '../../../../utils/app_common_stuffs/send_functionality.dart';
import '../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../common_ui/feed_post_widget.dart';
import '../../../common_ui/view_photo_video_screen.dart';
import '../../../style/appbar_components.dart';
import '../../../style/image_components.dart';
import '../../../style/text_style.dart';
import '../../../style/textfield_components.dart';
import 'user_screens/user_profile_screen.dart';

class FeedDetailScreen extends StatefulWidget {
  int feedId;

  FeedDetailScreen({
    Key? key,
    required this.feedId,
  }) : super(key: key);

  @override
  State<FeedDetailScreen> createState() => _FeedDetailScreenState();
}

class _FeedDetailScreenState extends State<FeedDetailScreen> {
  FeedDetailController feedDetailController = Get.find();
  TextEditingController commentTextController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowLoaderDialog.showLoaderDialog(context);
    });
    feedDetailController.feedDetailApiCall(feedId: widget.feedId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back<FeedData>(result: feedDetailController.feedData.value);
        return true;
      },
      child: GestureDetector(
        onTap: () {
          CommonUtils.scopeUnFocus(context);
          feedDetailController.isReplyComment.value = false;
        },
        onHorizontalDragUpdate: (details) {
          if (details.globalPosition.dx < 50 && Platform.isIOS) {
            Get.back<FeedData>(result: feedDetailController.feedData.value);
          }
        },
        child: Scaffold(
          appBar: appBarBody(),
          body: Obx(() => feedDetailController.feedDetailLoad.value == false ? Container() : buildScaffoldBody()),
        ),
      ),
    );
  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      leadingWidget: IconButton(
        hoverColor: AppColors.transparentColor,
        splashColor: AppColors.transparentColor,
        onPressed: () {
          Get.back<FeedData>(result: feedDetailController.feedData.value);
        },
        icon: ImageComponent.loadLocalImage(
          imageName: AppImages.arrow,
        ),
      ),
      actionWidgets: [
        GestureDetector(
          onTap: () {
            if (userSingleton.id == (feedDetailController.feedData.value?.user?.userId ?? 0)) {
              CommonUtils.showMyBottomSheet(
                context,
                arrButton: [
                  AppStrings.sendPost,
                  AppStrings.deletePost,
                ],
                callback: (btnIndex) async {
                  if (btnIndex == 0) {
                    SendFunsctionality.sendBottomSheet(feedId: feedDetailController.feedData.value?.feedId, context: context, headingText: AppStrings.sendPost);
                  } else if (btnIndex == 1) {
                    var deleteApi = await CommonApiFunction.feedDeleteApi(
                        onErr: (msg) {
                          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                        },
                        onSuccess: (msg) {
                          SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                        },
                        feedId: feedDetailController.feedData.value?.feedId);
                    if (deleteApi) {
                      Get.back(result: true);
                    }
                  }
                },
              );
            } else {
              CommonUtils.reportWidget(
                feedId: feedDetailController.feedData.value?.feedId ?? 0,
                context: context,
                isReportArticle: false,
                isReportForum: false,
                buttonText: [AppStrings.sendPost, AppStrings.reportPost, AppStrings.flagPost],
                reportTyp: AppStrings.feed,
              );
            }
          },
          child: ImageComponent.loadLocalImage(imageName: AppImages.threeDotFill, height: 30.w, width: 30.w, boxFit: BoxFit.contain),
        ),
        7.sizedBoxW,
      ],
      bottomWidget: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(
          color: AppColors.dropDownColor,
          height: 1.0,
        ),
      ),
    );
  }

  Widget buildScaffoldBody() {
    return SafeArea(
      child: CustomScrollView(
        // cacheExtent: 1000,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.zero,
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(childCount: 1, (BuildContext context, int index) {
              return postCard();
            })),
          ),
          SliverPadding(
            padding: EdgeInsets.zero,
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(childCount: 1, (BuildContext context, int index) {
              return addCommentBody();
            })),
          ),
          SliverPadding(
            padding: EdgeInsets.zero,
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(childCount: 1, (BuildContext context, int index) {
              return commentDropDown();
            })),
          ),
          SliverPadding(
            padding: EdgeInsets.zero,
            sliver: SliverSafeArea(
              bottom: true,
              top: false,
              sliver: Obx(
                () => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: feedDetailController.isAllDataLoaded.value ? feedDetailController.feedCommentListData.length + 1 : feedDetailController.feedCommentListData.length,
                    (BuildContext context, int index) {
                      if (index == feedDetailController.feedCommentListData.length) {
                        Future.delayed(
                          const Duration(milliseconds: 100),
                          () async {
                            await _handleLoadMoreList();
                          },
                        );
                        return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
                      }
                      var model = feedDetailController.feedCommentListData[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 24.w, right: 24.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 18.5.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(26.w / 2),
                                          child: ImageComponent.circleNetworkImage(imageUrl: model.user?.profileImg ?? '', height: 26.w, width: 26.w),
                                        ),
                                        3.sizedBoxW,
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${model.user?.firstName ?? ''} ${model.user?.lastName ?? ''}',
                                                  style: ISOTextStyles.openSenseSemiBold(size: 11, color: AppColors.darkBlackColor),
                                                ),
                                                3.sizedBoxW,
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 2.0),
                                                  child: Container(
                                                    height: 3.w,
                                                    width: 3.w,
                                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.grayDotColor),
                                                  ),
                                                ),
                                                7.sizedBoxW,
                                                Text(
                                                  model.getMainCommentTime,
                                                  style: ISOTextStyles.openSenseRegular(size: 11, color: AppColors.darkBlackColor),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              model.user?.companyName ?? '',
                                              style: ISOTextStyles.sfProMedium(size: 8, color: AppColors.indicatorColor),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (userSingleton.id == model.user?.userId) {
                                          CommonUtils.showMyBottomSheet(context, arrButton: [AppStrings.deleteComment], callback: (btnIndex) async {
                                            if (btnIndex == 0) {
                                              var isCommentDelete = await CommonApiFunction.feedMainCommentDeleteApi(
                                                  onErr: (msg) {
                                                    SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                                  },
                                                  onSuccess: (msg) {
                                                    Logger().i('Comment Replies Length :- ${feedDetailController.feedCommentListData[index].commentReplies.length}');
                                                    if(feedDetailController.feedCommentListData[index].commentReplies != [] || feedDetailController.feedData.value?.commentCounter.value != 0){
                                                      Logger().i('Comment Replies Length :- ${feedDetailController.feedCommentListData[index].commentReplies.length}');
                                                      feedDetailController.feedData.value?.commentCounter.value = (feedDetailController.feedData.value?.commentCounter.value ?? 0) - feedDetailController.feedCommentListData[index].commentReplies.length;
                                                      feedDetailController.feedData.value?.commentCounter.value--;
                                                    }

                                                    SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                                                  },
                                                  commentId: model.mainCommentId);
                                              if (isCommentDelete) {
                                                feedDetailController.feedCommentListData.removeAt(index);

                                                // feedDetailController.feedData.value?.commentCounter.value--;
                                              }
                                            }
                                          });
                                        } else {
                                          CommonUtils.reportFeedCommentWidget(
                                            commentId: feedDetailController.feedCommentListData[index].mainCommentId ?? 0,
                                            context: context,
                                          );
                                        }
                                      },
                                      child: Container(
                                          color: Colors.transparent,
                                          padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 5.w),
                                          child: ImageComponent.loadLocalImage(imageName: AppImages.threeDots)),
                                    ),
                                  ],
                                ),
                                10.sizedBoxH,
                                Text(
                                  model.comment ?? '',
                                  style: ISOTextStyles.sfProTextLight(size: 12, color: AppColors.chatHeadingName),
                                ),
                                14.sizedBoxH,

                                /// Comment List View  =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
                                Obx(
                                  () => Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (model.commentReplies.isNotEmpty) {
                                            model.isReplayShow.value = !model.isReplayShow.value;
                                          }
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                model.isReplayShow.value ? AppImages.upArrow : AppImages.downArrow,
                                                height: 5.h,
                                                width: 8.w,
                                                fit: BoxFit.contain,
                                                color: AppColors.darkBlackColor,
                                              ),
                                              11.sizedBoxW,
                                              Text(
                                                model.commentReplies.length > 1
                                                    ? '${NumberFormatter.getShortForm(model.commentReplies.length)} Replies'
                                                    : '${NumberFormatter.getShortForm(model.commentReplies.length)} Reply',
                                                style: ISOTextStyles.sfProMedium(size: 12, color: AppColors.darkBlackColor),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                focusNode.requestFocus();
                                                Future.delayed(const Duration(milliseconds: 500), () {
                                                  if (feedDetailController.scrollController.hasClients) {
                                                    final position = feedDetailController.scrollController.position.maxScrollExtent;
                                                    feedDetailController.scrollController.jumpTo(position);
                                                  }
                                                });
                                                feedDetailController.replyCommentId.value = model.mainCommentId ?? 0;
                                                Logger().i(feedDetailController.replyCommentId.value);
                                                feedDetailController.isReplyComment.value = true;
                                              },
                                              child: ImageComponent.loadLocalImage(imageName: AppImages.reply, height: 14.h, width: 20.w, boxFit: BoxFit.contain, imageColor: AppColors.refferalText)),
                                          24.sizedBoxW,
                                          GestureDetector(
                                            onTap: () {
                                              handleCommentLikeUnLike(commentIndex: index);
                                            },
                                            child: Obx(
                                              () => Container(
                                                color: Colors.transparent,
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                      model.isLikeComment.value == true ? AppImages.heartRed : AppImages.heartLike,
                                                      height: 14.h,
                                                      width: 16.w,
                                                      fit: BoxFit.contain,
                                                    ),
                                                    6.sizedBoxW,
                                                    Text(
                                                      NumberFormatter.getShortForm(model.commentLikes.value),
                                                      style: ISOTextStyles.sfProMedium(size: 12, color: AppColors.darkBlackColor),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),

                                /// Reply List View  =*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*=*
                                Obx(
                                  () => model.isReplayShow.value
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          //itemCount: postDetailController.postCommentsList[index].commentReplies.length,
                                          itemCount: model.commentReplies.length,
                                          itemBuilder: (BuildContext context, int i) {
                                            return Obx(
                                              () => Container(
                                                padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 15.w),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(26.w / 2),
                                                              child: ImageComponent.circleNetworkImage(imageUrl: model.commentReplies[i].profileImg ?? '', height: 26.w, width: 26.w),
                                                            ),
                                                            3.sizedBoxW,
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Row(
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    Text(
                                                                      '${model.commentReplies[i].firstName ?? ''} ${model.commentReplies[i].lastName ?? ''}',
                                                                      style: ISOTextStyles.openSenseSemiBold(size: 11, color: AppColors.darkBlackColor),
                                                                    ),
                                                                    3.sizedBoxW,
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 2.0),
                                                                      child: Container(
                                                                        height: 3,
                                                                        width: 3,
                                                                        decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.grayDotColor),
                                                                      ),
                                                                    ),
                                                                    7.sizedBoxW,
                                                                    Text(
                                                                      model.commentReplies[i].getReplyCommentTime,
                                                                      style: ISOTextStyles.openSenseRegular(size: 11, color: AppColors.darkBlackColor),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  model.commentReplies[i].companyName ?? '',
                                                                  style: ISOTextStyles.sfProMedium(size: 8, color: AppColors.indicatorColor),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Visibility(
                                                          visible: userSingleton.id == model.commentReplies[i].userId,
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              CommonUtils.showMyBottomSheet(context, arrButton: [AppStrings.deleteComment], callback: (btnIndex) async {
                                                                if (btnIndex == 0) {
                                                                  var deleteApi = await CommonApiFunction.feedReplyCommentDeleteApi(
                                                                      onErr: (msg) {
                                                                        SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                                                      },
                                                                      onSuccess: (msg) {
                                                                        SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                                                                      },
                                                                      commentId: model.commentReplies[i].repliesId);
                                                                  if (deleteApi) {
                                                                    model.commentReplies.removeAt(i);
                                                                    feedDetailController.feedData.value?.commentCounter.value--;
                                                                  }
                                                                }
                                                              });
                                                            },
                                                            child: Container(
                                                                color: Colors.transparent,
                                                                padding: EdgeInsets.symmetric(vertical: 5.w),
                                                                child: ImageComponent.loadLocalImage(imageName: AppImages.threeDots)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    10.sizedBoxH,
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          model.commentReplies[i].replies ?? '',
                                                          style: ISOTextStyles.sfProTextLight(size: 12, color: AppColors.chatHeadingName),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            handleCommentReplyLikeUnLike(commentIndex: index, replyCommentIndex: i);
                                                          },
                                                          child: Obx(
                                                            () => Container(
                                                              color: Colors.transparent,
                                                              child: Row(
                                                                children: [
                                                                  Image.asset(
                                                                    model.commentReplies[i].isRepliesLike.value == true ? AppImages.heartRed : AppImages.heartLike,
                                                                    height: 14.h,
                                                                    width: 16.w,
                                                                    fit: BoxFit.contain,
                                                                  ),
                                                                  6.sizedBoxW,
                                                                  Text(
                                                                    NumberFormatter.getShortForm(model.commentReplies[i].repliesLikeCount.value),
                                                                    style: ISOTextStyles.sfProMedium(size: 12, color: AppColors.darkBlackColor),
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
                                            );
                                          },
                                        )
                                      : Container(),
                                ),
                              ],
                            ),
                          ),
                          10.sizedBoxH,
                          Container(
                            height: 4,
                            width: double.infinity,
                            color: AppColors.greyColor,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _handleLoadMoreList() async {
    if (!feedDetailController.isAllDataLoaded.value) return;
    if (feedDetailController.isLoadMoreRunningForViewAll) return;
    feedDetailController.isLoadMoreRunningForViewAll = true;
    await feedDetailController.commentPagination();
  }

  Widget postCard() {
    return Obx(
      () => FeedPostWidget(
        userProfilePage: () async {
          if (userSingleton.id == feedDetailController.feedData.value?.user?.userId) {
            Get.toNamed(ScreenRoutesConstants.myProfileScreen, arguments: userSingleton.id);
          } else {
            Logger().i(feedDetailController.feedData.value?.user?.userId);
            var callBackData = await Get.to(
              UserProfileScreen(
                userId: feedDetailController.feedData.value?.user?.userId,
              ),
              binding: UserProfileBinding(),
            );
            if (callBackData != null) {
              feedDetailController.feedData.value?.user?.isConnected.value = callBackData;
            }
          }
        },
        profileImageUrl: feedDetailController.feedData.value?.user?.profileImg ?? '',
        fName: feedDetailController.feedData.value?.user?.firstName ?? '',
        lName: feedDetailController.feedData.value?.user?.lastName ?? '',
        companyName: feedDetailController.feedData.value?.user?.companyName ?? '',
        timeAgo: feedDetailController.feedData.value?.getHoursAgo ?? '',
        isThreeDotIconVisible: false,
        isUserConnected: feedDetailController.feedData.value?.user?.isConnected ?? AppStrings.notConnected.obs,
        userType: feedDetailController.feedData.value?.user?.userType ?? '',
        onConnectButtonPress: () async {
          var apiResult = await CommonApiFunction.commonConnectApi(
              userId: feedDetailController.feedData.value?.user?.userId ?? 0,
              onErr: (msg) {
                SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
              });
          if (apiResult) {
            feedDetailController.feedData.value?.user?.isConnected.value = 'Requested';
          }
          //updatePreviousList();
        },
        postContent: feedDetailController.feedData.value?.description ?? '',
        screenRoutes: () {},
        isExpandText: feedDetailController.feedData.value?.showMore ?? false.obs,
        postImages: feedDetailController.feedData.value?.feedMedia ?? [],
        pageController: feedDetailController.pageController,
        onPostImageTap: (value) async {
          //Get.to( PhotoVideoScreen(), arguments: [feedDetailController.feedData.value, value]);
          var callBack = await Get.to(
              PhotoVideoScreen(
                isGetBack: true,
              ),
              arguments: [feedDetailController.feedData.value, value]);
          if (callBack != null) {
            feedDetailController.feedData.value = callBack;
          }
          Logger().i(value);
        },
        likeCounts: feedDetailController.feedData.value?.likesCounters.value ?? 0,
        commentCounts: feedDetailController.feedData.value?.commentCounter.value ?? 0,
        onLikeButtonPressed: () async {
          handleLikeButtonTap();
        },
        likedIcon: feedDetailController.feedData.value?.isLikeFeed.value ?? false ? AppImages.dollarFill : AppImages.dollar,
        onCommentButtonPressed: () {
          focusNode.requestFocus();
          feedDetailController.isReplyComment.value = false;

          Future.delayed(const Duration(milliseconds: 500), () {
            if (feedDetailController.scrollController.hasClients) {
              final position = feedDetailController.scrollController.position.maxScrollExtent;
              feedDetailController.scrollController.jumpTo(position);
            }
          });
        },
        onSendButtonPressed: () {
          SendFunsctionality.sendBottomSheet(feedId: feedDetailController.feedData.value?.feedId ?? 0, context: context);
        },
        isShareIconVisible: false.obs,
        isUserMe: CommonUtils.isUserMe(id: feedDetailController.feedData.value?.user?.userId ?? 0),
        isUserVerify: feedDetailController.feedData.value?.user?.isVerified ?? false,
        feedDetailContent: true,
      ),
    );
  }

  handleLikeButtonTap() async {
    if (feedDetailController.feedData.value?.isLikeFeed.value == false) {
      feedDetailController.feedData.value?.isLikeFeed.value = true;
      feedDetailController.feedData.value?.likesCounters.value = (feedDetailController.feedData.value?.likesCounters.value ?? 0) + 1;
      var likeResponse = await CommonApiFunction.likePostApi(
        feedId: feedDetailController.feedData.value?.feedId ?? 0,
        onSuccess: (value) {
          feedDetailController.feedData.value?.likesCounters.value = value;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
          feedDetailController.feedData.value?.isLikeFeed.value = false;
          feedDetailController.feedData.value?.likesCounters.value = (feedDetailController.feedData.value?.likesCounters.value ?? 0) - 1;
        },
      );
      if (likeResponse) {
        feedDetailController.feedData.value?.isLikeFeed.value = true;
        //updatePreviousList();
      }
    } else {
      feedDetailController.feedData.value?.isLikeFeed.value = false;
      feedDetailController.feedData.value?.likesCounters.value = (feedDetailController.feedData.value?.likesCounters.value ?? 0) - 1;
      var likeResponse = await CommonApiFunction.unlikePostApi(
        feedId: feedDetailController.feedData.value?.feedId ?? 0,
        onSuccess: (value) {
          feedDetailController.feedData.value?.likesCounters.value = value;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
          feedDetailController.feedData.value?.isLikeFeed.value = true;
          feedDetailController.feedData.value?.likesCounters.value = (feedDetailController.feedData.value?.likesCounters.value ?? 0) + 1;
        },
      );
      if (likeResponse) {
        feedDetailController.feedData.value?.isLikeFeed.value = false;
        //updatePreviousList();
      }
    }
  }

  ///Add Comment Body
  Widget addCommentBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
      child: addCommentTextField(),
    );
  }

  ///Comment textfield
  Widget addCommentTextField() {
    return Obx(
      () => TextFieldComponents(
        textEditingController: commentTextController,
        //autoFocus: postDetailController.autoFocus.value,
        hintColor: AppColors.chatHeadingName,
        focusNode: focusNode,

        context: context,
        hint: 'Add a comment...',
        onChanged: (value) {
          feedDetailController.commentText.value = value;
        },
        iconSuffix: CommonUtils.visibleOption(feedDetailController.commentText.value) == true && feedDetailController.isSendButtonEnable.value == true
            ? GestureDetector(
                onTap: () async {
                  feedDetailController.pageToShow.value = 1;
                  feedDetailController.isSendButtonEnable.value = false;
                  ShowLoaderDialog.showLoaderDialog(context);

                  var apiResult = feedDetailController.isReplyComment.value
                      ? await feedDetailController.addFeedCommentReplyApiCall(
                          onErr: (msg) {
                            SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                          },
                          commentID: feedDetailController.replyCommentId.value)
                      : await feedDetailController.addCommentApiCall(onErr: (msg) {
                          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                        });
                  commentTextController.clear();
                  feedDetailController.commentText.value = '';

                  if (apiResult) {
                    focusNode.unfocus();
                    commentTextController.clear();
                    feedDetailController.commentText.value = '';
                    feedDetailController.isReplyComment.value = false;
                    feedDetailController.isSendButtonEnable.value = true;
                    Future.delayed(const Duration(milliseconds: 100), () {
                      if (feedDetailController.scrollController.hasClients) {
                        final position = feedDetailController.scrollController.position.maxScrollExtent;
                        feedDetailController.scrollController.jumpTo(position);
                      }
                    });
                  }
                },
                child: Container(
                  color: AppColors.transparentColor,
                  child: const Icon(
                    Icons.send,
                    color: AppColors.blackColor,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget commentDropDown() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(top: 22.h, bottom: 10.h, right: 9.w),
        padding: EdgeInsets.only(right: 9.w, top: 5.h, bottom: 5.h, left: 5.w),
        decoration: const BoxDecoration(
          color: AppColors.dropDownColor, // Set border width
          borderRadius: BorderRadius.all(Radius.circular(6)), // Set rounded corner radius
        ),
        child: Obx(() => ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                isDense: true,
                itemHeight: null,
                underline: Container(),
                value: feedDetailController.dropdownValue.value,
                icon: Padding(
                  padding: EdgeInsets.only(left: 7.w),
                  child: ImageComponent.loadLocalImage(imageName: AppImages.downArrow),
                ),
                style: ISOTextStyles.openSenseSemiBold(size: 12, color: AppColors.headingTitleColor),
                onChanged: (String? value) async {
                  feedDetailController.dropdownValue.value = value!;

                  feedDetailController.feedCommentListData.clear();
                  feedDetailController.isCommentLoad.value = false;
                  feedDetailController.isAllDataLoaded.value = false;
                  feedDetailController.pageToShow.value = 1;

                  await feedDetailController.fetchFeedCommentApi(page: feedDetailController.pageToShow.value);
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: ISOTextStyles.openSenseSemiBold(size: 12, color: AppColors.headingTitleColor),
                    ),
                  );
                }).toList(),
              ),
            )),
      ),
    );
  }

  ///*****Comment Like / Unlike Event handle function*****///
  handleCommentLikeUnLike({required int commentIndex}) async {
    var model = feedDetailController.feedCommentListData[commentIndex];
    if (model.isLikeComment.value == false) {
      var likeResponse = await feedDetailController.feedCommentLikeApi(
        commentId: model.mainCommentId ?? 0,
        onSuccess: (value) {
          model.commentLikes.value = value;
          Logger().i(model.commentLikes.value);
        },
      );
      if (likeResponse) {
        model.isLikeComment.value = true;
      }
    } else {
      var unLikeResponse = await feedDetailController.feedCommentUnlikeApi(
        commentId: model.mainCommentId ?? 0,
        onSuccess: (value) {
          model.commentLikes.value = value;
          Logger().i(model.commentLikes.value);
        },
      );
      if (unLikeResponse) {
        model.isLikeComment.value = false;
      }
    }
  }

  ///***** Reply Comment Like / Unlike Event handle function*****///
  handleCommentReplyLikeUnLike({required int commentIndex, required int replyCommentIndex}) async {
    var model = feedDetailController.feedCommentListData[commentIndex].commentReplies[replyCommentIndex];
    if (model.isRepliesLike.value == false) {
      var likeResponse = await feedDetailController.feedCommentReplyLikeApi(
        replyId: model.repliesId ?? 0,
        onSuccess: (value) {
          model.repliesLikeCount.value = value;
        },
      );
      if (likeResponse) {
        model.isRepliesLike.value = true;
      }
    } else {
      var likeResponse = await feedDetailController.feedCommentReplyUnlikeApi(
        replyId: model.repliesId ?? 0,
        onSuccess: (value) {
          model.repliesLikeCount.value = value;
        },
      );
      if (likeResponse) {
        model.isRepliesLike.value = false;
      }
    }
  }

// updatePreviousList() {
//   widget.feedData = feedDetailController.feedData.value!;
// }
}
