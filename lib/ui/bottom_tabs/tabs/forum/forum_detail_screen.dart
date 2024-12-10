// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/forum/forum_detail_controller.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/forum/forum_adaptor.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../bindings/bottom_tabs/user_binding/user_profile_binding.dart';
import '../../../../model/bottom_navigation_models/forum_models/forum_list_model.dart';
import '../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../utils/app_common_stuffs/commom_utils.dart';
import '../../../../utils/app_common_stuffs/common_api_function.dart';
import '../../../../utils/app_common_stuffs/screen_routes.dart';
import '../../../../utils/app_common_stuffs/send_functionality.dart';
import '../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../common_ui/forum_common_ui/forum_image_video_screen.dart';
import '../../../style/appbar_components.dart';
import '../../../style/image_components.dart';
import '../../../style/text_style.dart';
import '../../../style/textfield_components.dart';
import '../news_feed/user_screens/user_profile_screen.dart';

class ForumDetailScreen extends StatefulWidget {
  int forumId;
  bool? isFromCategoryPage;


  ForumDetailScreen({Key? key, required this.forumId,this.isFromCategoryPage}) : super(key: key);

  @override
  State<ForumDetailScreen> createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen> with AutomaticKeepAliveClientMixin<ForumDetailScreen> {
  ForumDetailController forumDetailController = Get.find<ForumDetailController>();
  TextEditingController commentTextController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowLoaderDialog.showLoaderDialog(context);
    });
    forumDetailController.forumDetailApiCall(forumId: widget.forumId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        Get.back<ForumData>(result: forumDetailController.forumData.value);
        return true;
      },

      child: GestureDetector(
        onTap: () {
          CommonUtils.scopeUnFocus(context);
          forumDetailController.isReplyComment.value = false;

        },
        onHorizontalDragUpdate: (details) {
          if (details.globalPosition.dx < 50 && Platform.isIOS) {
            Get.back<ForumData>(result: forumDetailController.forumData.value);
          }
        },
        child: Scaffold(
          appBar: appBarBody(),
          body: Obx(() => forumDetailController.isForumDetailLoad.value == false ? Container() : buildScaffoldBody()),
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
          Get.back<ForumData>(result: forumDetailController.forumData.value);
        },
        icon: ImageComponent.loadLocalImage(
          imageName: AppImages.arrow,
        ),
      ),
      actionWidgets: [
        GestureDetector(
          onTap: () {
            if (userSingleton.id == (forumDetailController.forumData.value?.user?.userId ?? 0)) {
              CommonUtils.showMyBottomSheet(
                context,
                arrButton: [
                  AppStrings.sendForum,
                  AppStrings.deleteForum,
                ],
                callback: (btnIndex) async {
                  if (btnIndex == 0) {
                    SendFunsctionality.sendBottomSheet(forumId: forumDetailController.forumData.value?.forumId, context: context, headingText: AppStrings.sendForum);
                  } else if (btnIndex == 1) {
                    var deleteApi = await CommonApiFunction.forumDeleteApi(
                        onErr: (msg) {
                          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                        },
                        onSuccess: (msg) {
                          SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                        },
                        forumId: forumDetailController.forumData.value?.forumId);
                    if (deleteApi) {
                      Get.back(result: true);
                    }
                  }
                },
              );
            } else {
              CommonUtils.reportWidget(
                forumId: forumDetailController.forumData.value?.forumId ?? 0,
                context: context,
                isReportForum: true,
                buttonText: [AppStrings.sendForum, AppStrings.reportForum, AppStrings.flagForum],
                reportTyp: AppStrings.forum,
              );
            }
          },
          child: ImageComponent.loadLocalImage(imageName: AppImages.threeDotFill, height: 30.w, width: 30.w, boxFit: BoxFit.contain),
        ),
        10.sizedBoxW,
      ],
    );
  }

  Future _handleLoadMoreList() async {
    if (!forumDetailController.isAllDataLoaded.value) return;
    if (forumDetailController.isLoadMoreRunningForViewAll) return;
    forumDetailController.isLoadMoreRunningForViewAll = true;
    await forumDetailController.commentPagination();
  }

  ///ScaffoldBuild body
  Widget buildScaffoldBody() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.zero,
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(childCount: 1, (BuildContext context, int index) {
              return forumPostWidget();
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
                    addAutomaticKeepAlives: true,
                    childCount: forumDetailController.isAllDataLoaded.value ? forumDetailController.forumCommentList.length + 1 : forumDetailController.forumCommentList.length,
                    (BuildContext context, int index) {
                      if (index == forumDetailController.forumCommentList.length) {
                        Future.delayed(
                          const Duration(milliseconds: 100),
                          () async {
                            await _handleLoadMoreList();
                          },
                        );
                        return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
                      }
                      var model = forumDetailController.forumCommentList[index];
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
                                          CommonUtils.showMyBottomSheet(
                                            context,
                                            arrButton: [AppStrings.deleteComment],
                                            callback: (btnIndex) async {
                                              if (btnIndex == 0) {
                                                var isCommentDelete = await CommonApiFunction.forumMainCommentDeleteApi(
                                                    onErr: (msg) {
                                                      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                                    },
                                                    onSuccess: (msg) {
                                                      SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                                                      if(forumDetailController.forumCommentList[index].commentReplies != [] || forumDetailController.forumData.value?.commentCounter.value != 0){
                                                        Logger().i('Comment Replies Length :- ${forumDetailController.forumCommentList[index].commentReplies.length}');
                                                        forumDetailController.forumData.value?.commentCounter.value = (forumDetailController.forumData.value?.commentCounter.value ?? 0) - forumDetailController.forumCommentList[index].commentReplies.length;
                                                        forumDetailController.forumData.value?.commentCounter.value--;
                                                      }
                                                    },
                                                    commentId: model.mainCommentId);
                                                if (isCommentDelete) {
                                                  forumDetailController.forumCommentList.removeAt(index);
                                                  //forumDetailController.forumData.value?.commentCounter.value--;
                                                }
                                              }
                                            },
                                          );
                                        } else {
                                          CommonUtils.reportFeedCommentWidget(
                                              commentId: forumDetailController.forumCommentList[index].mainCommentId ?? 0, context: context, isReportForumComment: true);
                                        }
                                      },
                                      child: Container(color: Colors.transparent, padding: EdgeInsets.symmetric(vertical: 5.w), child: ImageComponent.loadLocalImage(imageName: AppImages.threeDots)),
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
                                                  if (forumDetailController.scrollController.hasClients) {
                                                    final position = forumDetailController.scrollController.position.maxScrollExtent;
                                                    forumDetailController.scrollController.jumpTo(position);
                                                  }
                                                });
                                                forumDetailController.replyCommentId.value = model.mainCommentId ?? 0;
                                                Logger().i(forumDetailController.replyCommentId.value);
                                                forumDetailController.isReplyComment.value = true;
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
                                          addAutomaticKeepAlives: true,
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
                                                                  var deleteApi = await CommonApiFunction.forumReplyCommentDeleteApi(
                                                                      onErr: (msg) {
                                                                        SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                                                      },
                                                                      onSuccess: (msg) {
                                                                        SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                                                                      },
                                                                      commentId: model.commentReplies[i].repliesId);
                                                                  if (deleteApi) {
                                                                    model.commentReplies.removeAt(i);
                                                                    forumDetailController.forumData.value?.commentCounter.value--;
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
                                                          onTap: () async {
                                                            if (model.commentReplies[i].isRepliesLike.value == false) {
                                                              var likeResponse = await forumDetailController.forumCommentReplyLikeApi(
                                                                replyId: model.commentReplies[i].repliesId ?? 0,
                                                                onSuccess: (value) {
                                                                  model.commentReplies[i].repliesLikeCount.value = value;
                                                                },
                                                              );
                                                              if (likeResponse) {
                                                                model.commentReplies[i].isRepliesLike.value = true;
                                                              }
                                                            } else {
                                                              var likeResponse = await forumDetailController.forumCommentReplyUnlikeApi(
                                                                replyId: model.commentReplies[i].repliesId ?? 0,
                                                                onSuccess: (value) {
                                                                  model.commentReplies[i].repliesLikeCount.value = value;
                                                                },
                                                              );
                                                              if (likeResponse) {
                                                                model.commentReplies[i].isRepliesLike.value = false;
                                                              }
                                                            }
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

  ///Forum Post Widget Body
  Widget forumPostWidget() {
    return Obx(
      () => ForumAdaptor(
        forumData: forumDetailController.forumData.value ?? ForumData(),
        isFromCategoryPage: widget.isFromCategoryPage ?? false,
        threeDotTap: () {},
        userProfileCallBack: () async {
          var isUserOrAdmin = CommonUtils.isUserMe(id: forumDetailController.forumData.value?.user?.userId ?? 0, isAdmin: forumDetailController.forumData.value?.user?.isAdmin ?? false);
          if (isUserOrAdmin.value) {
            var callBackData = await Get.to(
              UserProfileScreen(
                userId: forumDetailController.forumData.value?.user?.userId,
              ),
              binding: UserProfileBinding(),
            );
            if (callBackData != null && callBackData != true) {
              forumDetailController.forumData.value?.user?.isConnected.value = callBackData;
              forumDetailController.update();
            }
          } else {
            Get.toNamed(ScreenRoutesConstants.myProfileScreen, arguments: userSingleton.id);
          }
        },
        isThreeDotIconVisible: false,
        screenRoutes: () {},
        pageController: forumDetailController.pageController,
        onPostImageTap: (value) {
          Get.to(
              ForumPhotoVideoView(
                isGetBack: true,
              ),
              arguments: [forumDetailController.forumData.value, value]);
        },
        commentButton: () {
          focusNode.requestFocus();
          forumDetailController.isReplyComment.value = false;

          Future.delayed(const Duration(milliseconds: 500), () {
            if (forumDetailController.scrollController.hasClients) {
              final position = forumDetailController.scrollController.position.maxScrollExtent;
              forumDetailController.scrollController.jumpTo(position);
            }
          });
        },
        forumDetailContent: true,
      ),
    );
  }

  ///Add Comment Body
  Widget addCommentBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
      child: Column(
        children: [
          addCommentTextField(),
        ],
      ),
    );
  }

  ///Comment textfield
  Widget addCommentTextField() {
    return Obx(
      () => TextFieldComponents(
        textEditingController: commentTextController,
        //autoFocus: postDetailController.autoFocus.value,

        focusNode: focusNode,
        context: context,
        hint: 'Add a comment...',
        onChanged: (value) {
          forumDetailController.commentText.value = value;
        },
        iconSuffix: CommonUtils.visibleOption(forumDetailController.commentText.value) == true && forumDetailController.isSendButtonEnable.value == true
            ? GestureDetector(
                onTap: () async {
                  ShowLoaderDialog.showLoaderDialog(context);
                  forumDetailController.isAllDataLoaded.value = false;
                  forumDetailController.pageToShow.value = 1;
                  forumDetailController.isSendButtonEnable.value = false;
                  var apiResult = forumDetailController.isReplyComment.value
                      ? await forumDetailController.addForumCommentReplyApiCall(
                          onErr: (msg) {
                            SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                          },
                          commentID: forumDetailController.replyCommentId.value)
                      : await forumDetailController.addCommentApiCall(onErr: (msg) {
                          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                        });
                  commentTextController.clear();
                  forumDetailController.commentText.value = '';
                  if (apiResult) {
                    focusNode.unfocus();
                    commentTextController.clear();
                    forumDetailController.commentText.value = '';
                    forumDetailController.isReplyComment.value = false;
                    forumDetailController.isSendButtonEnable.value = true;
                    Future.delayed(const Duration(milliseconds: 100), () {
                      if (forumDetailController.scrollController.hasClients) {
                        final position = forumDetailController.scrollController.position.maxScrollExtent;
                        forumDetailController.scrollController.jumpTo(position);
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
          borderRadius: BorderRadius.all(Radius.circular(6.0)), // Set rounded corner radius
        ),
        child: Obx(() => ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                isDense: true,
                itemHeight: null,
                underline: Container(),
                value: forumDetailController.dropdownValue.value,
                icon: Padding(
                  padding: EdgeInsets.only(left: 7.w),
                  child: ImageComponent.loadLocalImage(imageName: AppImages.downArrow),
                ),
                style: ISOTextStyles.openSenseSemiBold(size: 12, color: AppColors.headingTitleColor),
                onChanged: (String? value) async {
                  forumDetailController.dropdownValue.value = value!;

                  forumDetailController.forumCommentList.clear();
                  forumDetailController.isCommentLoad.value = false;
                  forumDetailController.isAllDataLoaded.value = false;
                  forumDetailController.pageToShow.value = 1;

                  await forumDetailController.fetchForumCommentApi(page: forumDetailController.pageToShow.value);
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text('$value  '),
                  );
                }).toList(),
              ),
            )),
      ),
    );
  }

  ///******Forum Like Event handle function*****////
  handleUpArrowTap() async {
    if (forumDetailController.forumData.value?.isLikeForum.value == false) {
      await CommonApiFunction.likeForumApi(
        forumId: forumDetailController.forumData.value?.forumId ?? 0,
        onSuccess: (likeCount) {
          forumDetailController.forumData.value?.likeCount.value = likeCount[0];
          forumDetailController.forumData.value?.disLikeCount.value = likeCount[1];
          forumDetailController.forumData.value?.isLikeForum.value = true;
          forumDetailController.forumData.value?.isUnlikeForum.value = false;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
        },
      );
    }
  }

  ///******Forum DisLike Event handle function*****////
  handleDownArrowTap() async {
    if (forumDetailController.forumData.value?.isUnlikeForum.value == false) {
      await CommonApiFunction.unlikeForumApi(
        forumId: forumDetailController.forumData.value?.forumId ?? 0,
        onSuccess: (disLikeCount) {
          forumDetailController.forumData.value?.likeCount.value = disLikeCount[0];
          forumDetailController.forumData.value?.disLikeCount.value = disLikeCount[1];
          forumDetailController.forumData.value?.isLikeForum.value = false;
          forumDetailController.forumData.value?.isUnlikeForum.value = true;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
        },
      );
    }
  }

  ///*****Comment Like Event handle function*****///
  handleCommentLikeUnLike({required int commentIndex}) async {
    var model = forumDetailController.forumCommentList[commentIndex];
    if (model.isLikeComment.value == false) {
      var likeResponse = await forumDetailController.forumCommentLikeApi(
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
      var unLikeResponse = await forumDetailController.forumCommentUnlikeApi(
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

  ///*****Reply Comment Like Event handle function*****///

}
