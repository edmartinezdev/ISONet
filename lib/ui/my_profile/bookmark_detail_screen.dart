import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/my_profile/bookmark_detail_controller.dart';
import 'package:iso_net/ui/style/ImageWidget.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../singelton_class/auth_singelton.dart';
import '../../utils/app_common_stuffs/app_colors.dart';
import '../../utils/app_common_stuffs/app_images.dart';
import '../../utils/app_common_stuffs/app_logger.dart';
import '../../utils/app_common_stuffs/commom_utils.dart';
import '../../utils/app_common_stuffs/common_api_function.dart';
import '../../utils/app_common_stuffs/snackbar_util.dart';
import '../../utils/app_common_stuffs/strings_constants.dart';
import '../style/appbar_components.dart';
import '../style/image_components.dart';
import '../style/text_style.dart';
import '../style/textfield_components.dart';

class BookMarkDetailScreen extends StatefulWidget {
  const BookMarkDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<BookMarkDetailScreen> createState() => _BookMarkDetailScreenState();
}

class _BookMarkDetailScreenState extends State<BookMarkDetailScreen> {
  BookMarkDetailController bookMarkDetailController = Get.find<BookMarkDetailController>();
  TextEditingController commentTextController = TextEditingController();

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      bookMarkDetailController.nextArticleApi(currentPage: bookMarkDetailController.bookMarkCurrentPage);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: true);
        return true;
      },
      child: GestureDetector(
        onTap: (){
          CommonUtils.scopeUnFocus(context);
          bookMarkDetailController.isReplyComment.value = false;
        },
          onHorizontalDragUpdate: (details) {
            if (details.globalPosition.dx < 50 && Platform.isIOS) {
              Get.back(result: true);
            }
          },
        child: Scaffold(
          appBar: appBarBody(),
          body: Obx(() => bookMarkDetailController.bookmarkDataLoad.value == false ? Container() : buildBody()),
          bottomNavigationBar: Obx(() => Container(
            padding: EdgeInsets.only(bottom: 20.0.h),
            child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        handleArticleLikeUnLike();
                      },
                      child: Container(
                        decoration: const BoxDecoration(color: AppColors.articleLikeColor, borderRadius: BorderRadius.all(Radius.circular(7))),
                        margin: EdgeInsets.symmetric(horizontal: 14.0.w, vertical: 14.0.h),
                        padding: EdgeInsets.symmetric(horizontal: 9.0.w, vertical: 9.0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ImageComponent.loadLocalImage(
                                imageName: bookMarkDetailController.bookMarkDetail.value?.isLikeArticle.value == true ? AppImages.heartRed : AppImages.heartLike,
                                height: 13.w,
                                width: 15.w,
                                boxFit: BoxFit.contain),
                            4.sizedBoxW,
                            Text(
                              '${bookMarkDetailController.bookMarkDetail.value?.likeCount ?? 0}',
                              style: ISOTextStyles.openSenseSemiBold(size: 16, color: AppColors.darkBlackColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 14.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // if(articleDetailController.leftEnabled.value)

                          IconButton(
                            hoverColor: AppColors.transparentColor,
                            splashColor: AppColors.transparentColor,
                            onPressed: () {
                              bookMarkDetailController.getAction.value = 'PREV';
                              if (bookMarkDetailController.apiCurrentPage.value != 1) {
                                //articleDetailController.currentPages.value--;
                                bookMarkDetailController.isCommentLoad.value = false;
                                bookMarkDetailController.articleCommentList.clear();
                                bookMarkDetailController.pageToShow.value = 1;
                                bookMarkDetailController.totalCommentRecord.value = 0;
                                bookMarkDetailController.isAllDataLoaded.value = false;
                                bookMarkDetailController.bookmarkDataLoad.value = false;
                                bookMarkDetailController.nextArticleApi(
                                  currentPage: bookMarkDetailController.apiCurrentPage.value,
                                );
                              }
                            },
                            icon:
                                ImageComponent.loadLocalImage(imageName: AppImages.leftArrow, imageColor: bookMarkDetailController.apiCurrentPage.value == 1 ? AppColors.greyColor : AppColors.blackColor),
                            highlightColor: AppColors.transparentColor,
                          ),
                          36.sizedBoxW,
                          IconButton(
                              hoverColor: AppColors.transparentColor,
                              splashColor: AppColors.transparentColor,
                              onPressed: () {
                                bookMarkDetailController.getAction.value = 'NEXT';

                                if (bookMarkDetailController.apiCurrentPage.value != bookMarkDetailController.apiTotalRecords.value) {
                                  bookMarkDetailController.isCommentLoad.value = false;
                                  bookMarkDetailController.articleCommentList.clear();
                                  bookMarkDetailController.pageToShow.value = 1;
                                  bookMarkDetailController.totalCommentRecord.value = 0;
                                  bookMarkDetailController.isAllDataLoaded.value = false;
                                  bookMarkDetailController.bookmarkDataLoad.value = false;
                                  bookMarkDetailController.nextArticleApi(currentPage: bookMarkDetailController.apiCurrentPage.value);
                                }

                              },
                              icon: ImageComponent.loadLocalImage(
                                  imageName: AppImages.rightArrow,
                                  imageColor: bookMarkDetailController.apiCurrentPage.value == bookMarkDetailController.apiTotalRecords.value ? AppColors.greyColor : AppColors.blackColor)),
                        ],
                      ),
                    )
                  ],
                ),
          )),
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
        onPressed: () => Get.back(result: true),
        //onPressed: () => Get.back<List<int>>(result:  bookMarkDetailController.bookMarkRemoveId),
        icon: ImageComponent.loadLocalImage(
          imageName: AppImages.arrow,
        ),
      ),
      actionWidgets: [
        Row(
          children: [
            Obx(
              () => GestureDetector(
                onTap: () async {
                  _handleBookmarkTap();
                },
                child: ImageComponent.loadLocalImage(
                    imageName: (bookMarkDetailController.bookMarkDetail.value?.isBookmarkByMe.value ?? false) == true ? AppImages.savePostFill : AppImages.savePost,
                    height: 30.w,
                    width: 30.w,
                    boxFit: BoxFit.contain),
              ),
            ),
            8.sizedBoxW,
            GestureDetector(
              onTap: () async {
                // reportArticleWidget(articleId: articleDetailController.articleDetailList.value?.id ?? 0, context: context);
                CommonUtils.reportWidget(context: context, isReportArticle: true, articleId: bookMarkDetailController.bookMarkDetail.value?.id ?? 0, buttonText: [AppStrings.reportArticle],reportTyp: '');
              },
              child: ImageComponent.loadLocalImage(imageName: AppImages.threeDotFill, height: 30.w, width: 30.w, boxFit: BoxFit.contain),
            ),
          ],
        ),
        10.sizedBoxW,
      ],
    );
  }

  ///Handle bookmark tap
  _handleBookmarkTap() async {
    var apiResult = await bookMarkDetailController.articleBookMarkApi(
      articleId: bookMarkDetailController.bookMarkDetail.value?.id ?? 0,
      onError: (msg) {
        SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
      },
    );
    if (apiResult) {
      //bookMarkDetailController.isBookMarkRemove.value = true;

      if (bookMarkDetailController.bookMarkDetail.value?.isBookmarkByMe.value == true) {
        bookMarkDetailController.bookMarkDetail.value?.isBookmarkByMe.value = false;
        if (bookMarkDetailController.apiTotalRecords.value == 1) {
          Get.back(result: true);
        } else {
          if (bookMarkDetailController.apiTotalRecords == bookMarkDetailController.apiCurrentPage) {
            bookMarkDetailController.getAction.value = 'PREV';
            bookMarkDetailController.bookmarkDataLoad.value = false;
            bookMarkDetailController.nextArticleApi(currentPage: bookMarkDetailController.apiCurrentPage.value);
          } else {
            bookMarkDetailController.getAction.value = '';
            bookMarkDetailController.bookmarkDataLoad.value = false;
            bookMarkDetailController.nextArticleApi(currentPage: bookMarkDetailController.apiCurrentPage.value);
          }
        }
      } else {
        bookMarkDetailController.bookMarkDetail.value?.isBookmarkByMe.value = true;
      }
    }
  }

  Future _handleLoadMoreList() async {
    if (!bookMarkDetailController.isAllDataLoaded.value) return;
    if (bookMarkDetailController.isLoadMoreRunningForViewAll) return;
    bookMarkDetailController.isLoadMoreRunningForViewAll = true;
    await bookMarkDetailController.commentPagination();
  }

  Widget articleWidget() {
    return Obx(() => Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              //itemCount: articleDetailController.articleDetailList.articleMedia?.length,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 223.h,
                        child: ImageWidget(
                          url: bookMarkDetailController.bookMarkDetail.value?.articleMedia?[index].articleMedia ?? '',
                          width: double.infinity,
                          height: 223.h,
                          fit: BoxFit.cover,
                          placeholder: AppImages.imagePlaceholder,
                        )),
                  ],
                );
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 17.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    bookMarkDetailController.bookMarkDetail.value?.title ?? '',
                    style: ISOTextStyles.sfProSemiBold(size: 17, color: AppColors.darkBlackColor),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10.h, top: 6.h),
                    child: Row(
                      children: [
                        Text(
                          bookMarkDetailController.bookMarkDetail.value?.authorName ?? '',
                          style: ISOTextStyles.sfProMedium(size: 12, color: AppColors.hintTextColor),
                        ),
                        11.sizedBoxW,
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.showTimeColor),
                        ),
                        11.sizedBoxW,
                        ImageComponent.loadLocalImage(imageName: AppImages.clockOutline),
                        4.sizedBoxW,
                        Text(
                          bookMarkDetailController.bookMarkDetail.value?.getHoursAgo ?? '',
                          style: ISOTextStyles.sfProDisplayLight(size: 10, color: AppColors.hintTextColor),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    bookMarkDetailController.bookMarkDetail.value?.description ?? '',
                    style: ISOTextStyles.openSenseRegular(size: 14, color: AppColors.chatHeadingName),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 3,
              color: AppColors.dividerColor,
            ),
          ],
        ));
  }

  Widget buildBody() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.zero,
            sliver: SliverList(
                delegate: SliverChildBuilderDelegate(childCount: 1, (BuildContext context, int index) {
              return articleWidget();
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
                    childCount: bookMarkDetailController.isAllDataLoaded.value ? bookMarkDetailController.articleCommentList.length + 1 : bookMarkDetailController.articleCommentList.length,
                    (BuildContext context, int index) {
                      if (index == bookMarkDetailController.articleCommentList.length) {
                        Future.delayed(
                          const Duration(milliseconds: 100),
                          () async {
                            await _handleLoadMoreList();
                          },
                        );
                        return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
                      }
                      var model = bookMarkDetailController.articleCommentList[index];
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
                                                var isCommentDelete = await CommonApiFunction.articleMainCommentDeleteApi(
                                                    onErr: (msg) {
                                                      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                                    },
                                                    onSuccess: (msg) {
                                                      SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                                                    },
                                                    commentId: model.mainCommentId);
                                                if (isCommentDelete) {
                                                  bookMarkDetailController.articleCommentList.removeAt(index);
                                                  bookMarkDetailController.totalCommentRecord.value--;
                                                }
                                              }
                                            },
                                          );
                                        } else {
                                          CommonUtils.reportFeedCommentWidget(
                                              commentId: bookMarkDetailController.articleCommentList[index].mainCommentId ?? 0, context: context, isReportArticle: true);
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
                                                  if (bookMarkDetailController.scrollController.hasClients) {
                                                    final position = bookMarkDetailController.scrollController.position.maxScrollExtent;
                                                    bookMarkDetailController.scrollController.jumpTo(position);
                                                  }
                                                });
                                                bookMarkDetailController.replyCommentId.value = model.mainCommentId ?? 0;
                                                Logger().i(bookMarkDetailController.replyCommentId.value);
                                                bookMarkDetailController.isReplyComment.value = true;
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
                                                                  var deleteApi = await CommonApiFunction.articleReplyCommentDeleteApi(
                                                                      onErr: (msg) {
                                                                        SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                                                      },
                                                                      onSuccess: (msg) {
                                                                        SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                                                                      },
                                                                      commentId: model.commentReplies[i].repliesId);
                                                                  if (deleteApi) {
                                                                    model.commentReplies.removeAt(i);
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
                                                              var likeResponse = await bookMarkDetailController.articleCommentReplyLikeApi(
                                                                replyId: model.commentReplies[i].repliesId ?? 0,
                                                                onSuccess: (value) {
                                                                  model.commentReplies[i].repliesLikeCount.value = value;
                                                                },
                                                              );
                                                              if (likeResponse) {
                                                                model.commentReplies[i].isRepliesLike.value = true;
                                                              }
                                                            } else {
                                                              var likeResponse = await bookMarkDetailController.articleCommentReplyUnlikeApi(
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
          bookMarkDetailController.commentText.value = value;
        },
        iconSuffix: CommonUtils.visibleOption(bookMarkDetailController.commentText.value) == true && bookMarkDetailController.isSendButtonEnable.value == true
            ? GestureDetector(
                onTap: () async {
                  bookMarkDetailController.pageToShow.value = 1;
                  bookMarkDetailController.isAllDataLoaded.value = false;
                  bookMarkDetailController.isSendButtonEnable.value = false;
                  ShowLoaderDialog.showLoaderDialog(context);
                  var apiResult = bookMarkDetailController.isReplyComment.value
                      ? await bookMarkDetailController.addArticleCommentReplyApiCall(
                          onErr: (msg) {
                            SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                          },
                          commentID: bookMarkDetailController.replyCommentId.value)
                      : await bookMarkDetailController.addCommentApiCall(onErr: (msg) {
                          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                        });
                  commentTextController.clear();
                  bookMarkDetailController.commentText.value = '';
                  if (apiResult) {
                    focusNode.unfocus();
                    commentTextController.clear();
                    bookMarkDetailController.commentText.value = '';
                    bookMarkDetailController.isReplyComment.value = false;
                    bookMarkDetailController.isSendButtonEnable.value = true;
                    Future.delayed(const Duration(milliseconds: 100), () {
                      if (bookMarkDetailController.scrollController.hasClients) {
                        final position = bookMarkDetailController.scrollController.position.maxScrollExtent;
                        bookMarkDetailController.scrollController.jumpTo(position);
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

  /// Comment DropDown
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
                value: bookMarkDetailController.dropdownValue.value,
                icon: Padding(
                  padding: EdgeInsets.only(left: 7.w),
                  child: ImageComponent.loadLocalImage(imageName: AppImages.downArrow),
                ),
                style: const TextStyle(color: AppColors.blackColor),
                onChanged: (String? value) async {
                  bookMarkDetailController.dropdownValue.value = value!;

                  bookMarkDetailController.articleCommentList.clear();
                  bookMarkDetailController.isCommentLoad.value = false;
                  bookMarkDetailController.isAllDataLoaded.value = false;
                  bookMarkDetailController.pageToShow.value = 1;

                  await bookMarkDetailController.fetchArticleCommentApi(page: bookMarkDetailController.pageToShow.value);
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

  ///Comment Like Event handle function
  handleCommentLikeUnLike({required int commentIndex}) async {
    var model = bookMarkDetailController.articleCommentList[commentIndex];
    if (model.isLikeComment.value == false) {
      var likeResponse = await bookMarkDetailController.articleCommentLikeApi(
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
      var unLikeResponse = await bookMarkDetailController.articleCommentUnlikeApi(
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

  /// Article Like And Unlike
  handleArticleLikeUnLike() async {
    var model = bookMarkDetailController.bookMarkDetail.value;
    if (model?.isLikeArticle.value == false) {
      var likeResponse = await bookMarkDetailController.articleLikeApi(
        articleId: model?.id ?? 0,
        onSuccess: (value) {
          model?.likeCount = value;
          Logger().i(model?.likeCount);
        },
      );
      if (likeResponse) {
        model?.isLikeArticle.value = true;
      }
    } else {
      var unLikeResponse = await bookMarkDetailController.articleUnlikeApi(
        articleId: model?.id ?? 0,
        onSuccess: (value) {
          model?.likeCount = value;
          Logger().i(model?.likeCount);
        },
      );
      if (unLikeResponse) {
        model?.isLikeArticle.value = false;
      }
    }
  }
}
