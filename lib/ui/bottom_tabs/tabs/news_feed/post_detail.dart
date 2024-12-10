// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:chewie/chewie.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:get/get.dart';
// // import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/post_detail_controller.dart';
// // import 'package:iso_net/ui/common_ui/feed_post_widget.dart';
// // import 'package:iso_net/ui/style/image_components.dart';
// // import 'package:iso_net/ui/style/textfield_components.dart';
// // import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
// // import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';
// // import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// // import 'package:video_player/video_player.dart';
// //
// // import '../../../../controllers/bottom_tabs/tabs/news_feed/news_feed_tab_controller.dart';
// // import '../../../../utils/app_common_stuffs/app_colors.dart';
// // import '../../../../utils/app_common_stuffs/app_images.dart';
// // import '../../../../utils/app_common_stuffs/app_logger.dart';
// // import '../../../../utils/app_common_stuffs/commom_utils.dart';
// // import '../../../../utils/app_common_stuffs/screen_routes.dart';
// // import '../../../../utils/app_common_stuffs/strings_constants.dart';
// // import '../../../style/appbar_components.dart';
// // import '../../../style/button_components.dart';
// // import '../../../style/text_style.dart';
// //
// // class PostDetail extends StatefulWidget {
// //   const PostDetail({Key? key}) : super(key: key);
// //
// //   @override
// //   State<PostDetail> createState() => _PostDetailState();
// // }
// //
// // class _PostDetailState extends State<PostDetail> {
// //   PostDetailController postDetailController = Get.find<PostDetailController>();
// //   NewsFeedController newsFeedController = Get.find<NewsFeedController>();
// //   PageController pageController = PageController();
// //   var slidingPageIndicatorIndex = 0.obs;
// //   late VideoPlayerController videoPlayerController;
// //   ChewieController? chewieController;
// //   TextEditingController commentTextController = TextEditingController();
// //   ScrollController scrollController = ScrollController();
// //   FocusNode focusNode = FocusNode();
// //   int index = 0;
// //
// //   @override
// //   void initState() {
// //     postDetailController.fetchPostCommentsApi(page: postDetailController.pageToShow.value);
// //     super.initState();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: () {
// //         FocusScopeNode currentFocus = FocusScope.of(context);
// //         if (!currentFocus.hasPrimaryFocus) {
// //           currentFocus.unfocus();
// //           focusNode.unfocus();
// //         }
// //       },
// //       child: Scaffold(
// //         appBar: appBarBody(),
// //         //body: buildBody(),
// //         body: buildScaffoldBody(index),
// //       ),
// //     );
// //   }
// //
// //   ///Appbar
// //   PreferredSizeWidget appBarBody() {
// //     return AppBarComponents.appBar(
// //       leadingWidget: IconButton(
// //         onPressed: () => Get.until((route) => route.settings.name == ScreenRoutesConstants.bottomTabsScreen),
// //         icon: ImageComponent.loadLocalImage(
// //           imageName: AppImages.arrow,
// //         ),
// //       ),
// //       actionWidgets: [
// //         CircleAvatar(
// //           radius: 14,
// //           child: ImageComponent.loadLocalImage(imageName: AppImages.threeDotFill),
// //         ),
// //         10.sizedBoxW,
// //       ],
// //     );
// //   }
// //
// //   Widget buildScaffoldBody(int index) {
// //     return SafeArea(
// //       child: Column(
// //         children: [
// //           Expanded(
// //             child: SingleChildScrollView(
// //               controller: postDetailController.scrollController,
// //               child: Column(
// //                 children: [
// //                   postCard(index),
// //                   viewCommentBody(),
// //                 ],
// //               ),
// //             ),
// //           ),
// //           addCommentBody(),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget postCard(int index) {
// //     var model = newsFeedController.feedList[index];
// //     return FeedPostWidget(
// //       userProfilePage: () {},
// //       profileImageUrl: postDetailController.postDetail.user?.profileImg ?? '',
// //       fName: postDetailController.postDetail.user?.firstName ?? '',
// //       lName: postDetailController.postDetail.user?.lastName ?? '',
// //       companyName: postDetailController.postDetail.user?.companyName ?? '',
// //       timeAgo: postDetailController.postDetail.postedAt ?? '',
// //       postContent: postDetailController.postDetail.description ?? '',
// //       screenRoutes: () {},
// //       isExpandText: postDetailController.postDetail.showMore,
// //       postImages: postDetailController.postDetail.feedMedia ?? [],
// //       pageController: pageController,
// //       onPageChanged: (value) {
// //         slidingPageIndicatorIndex.value = value;
// //         print(slidingPageIndicatorIndex.value);
// //       },
// //       onPostImageTap: (value) {},
// //       activeIndex: slidingPageIndicatorIndex,
// //       likeCounts: postDetailController.postDetail.likes ?? 0,
// //       commentCounts: postDetailController.postDetail.comment ?? 0,
// //       onLikeButtonPressed: () async {
// //         if (newsFeedController.isLikeFeed[index] == false) {
// //           var likeResponse = await newsFeedController.likePostApi(
// //             feedId: model.feedId ?? '',
// //             onSuccess: (value) {
// //               newsFeedController.likesCounters[index] = value;
// //               newsFeedController.likesCounters.toSet();
// //               Logger().i(newsFeedController.likesCounters.toList());
// //             },
// //           );
// //           if (likeResponse) {
// //             newsFeedController.isLikeFeed[index] = true;
// //           }
// //         } else {
// //           var likeResponse = await newsFeedController.unlikePostApi(
// //             feedId: model.feedId ?? '',
// //             onSuccess: (value) {
// //               newsFeedController.likesCounters[index] = value;
// //               newsFeedController.likesCounters.toSet();
// //               Logger().i(newsFeedController.likesCounters.toList());
// //             },
// //           );
// //           if (likeResponse) {
// //             newsFeedController.isLikeFeed[index] = false;
// //           }
// //         }
// //       },
// //       likedIcon: newsFeedController.isLikeFeed[index] == true ? AppImages.dollarFill : AppImages.dollar,
// //       onCommentButtonPressed: () {
// //         focusNode.requestFocus();
// //         postDetailController.isReplyComment.value = false;
// //         Future.delayed(const Duration(milliseconds: 500), () {
// //           if (scrollController.hasClients) {
// //             final position = scrollController.position.maxScrollExtent;
// //             scrollController.jumpTo(position);
// //           }
// //         });
// //       },
// //       isShareIconVisible: false.obs,
// //     );
// //   }
// //
// //   ///Add Comment Body
// //   Widget addCommentBody() {
// //     return Container(
// //       padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
// //       child: Column(
// //         children: [
// //           addCommentTextField(),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   Widget addCommentTextField() {
// //     return Obx(
// //       () => TextFieldComponents(
// //         textEditingController: commentTextController,
// //         //autoFocus: postDetailController.autoFocus.value,
// //
// //         focusNode: focusNode,
// //         context: context,
// //         hint: 'Add a comment...',
// //         onChanged: (value) {
// //           postDetailController.commentText.value = value;
// //         },
// //         iconSuffix: CommonUtils.visibleOption(postDetailController.commentText.value) == true
// //             ? IconButton(
// //                 onPressed: () async {
// //                   var apiResult = postDetailController.isRCommentReply.value == true ? await postDetailController.addFeedCommentReplyApiCall(
// //                     onErr: (msg) {
// //                       SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
// //                     }, index: postDetailController.replyCommentId.value,
// //                   ) : await postDetailController.addCommentApiCall(
// //                     onErr: (msg) {
// //                       SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
// //                     },
// //                   );
// //                   if (apiResult) {
// //                     commentTextController.clear();
// //                     postDetailController.commentText.value = '';
// //                     Future.delayed(const Duration(milliseconds: 100), () {
// //                       if (scrollController.hasClients) {
// //                         final position = scrollController.position.maxScrollExtent;
// //                         scrollController.jumpTo(position);
// //                       }
// //                     });
// //                   }
// //                 },
// //                 icon: const Icon(
// //                   Icons.send,
// //                   color: AppColors.blackColor,
// //                 ),
// //               )
// //             : null,
// //       ),
// //     );
// //   }
// //
// //   Widget viewCommentBody() {
// //     return Obx(
// //       () => postDetailController.isCommentLoaded.value == false
// //           ? const Center(
// //               child: CircularProgressIndicator(
// //                 color: AppColors.primaryColor,
// //               ),
// //             )
// //           : ListView.separated(
// //               shrinkWrap: true,
// //               physics: const NeverScrollableScrollPhysics(),
// //               itemCount: postDetailController.postCommentsList.length + 1,
// //               itemBuilder: (BuildContext context, int index) {
// //                 if (index < postDetailController.postCommentsList.length) {
// //                   var model = postDetailController.postCommentsList[index];
// //                   return Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       ListTile(
// //                         leading: CircleAvatar(
// //                           radius: 20,
// //                           backgroundImage: CachedNetworkImageProvider(
// //                             model.userId?.profileImg ?? '',
// //                           ),
// //                         ),
// //                         title: Row(
// //                           children: [
// //                             Text(
// //                               '${model.userId?.firstName ?? ''} ${model.userId?.lastName ?? ''}  •  ',
// //                               style: ISOTextStyles.openSenseSemiBold(size: 11),
// //                             ),
// //                             Text(
// //                               CommonUtils.checkTimingsAgo(createdAt: model.createdAt ?? ''),
// //                               style: ISOTextStyles.openSenseRegular(size: 11, color: AppColors.hintTextColor),
// //                             ),
// //                           ],
// //                         ),
// //                         subtitle: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                               model.userId?.companyName ?? '',
// //                               style: ISOTextStyles.openSenseRegular(size: 10, color: AppColors.hintTextColor),
// //                             ),
// //                           ],
// //                         ),
// //                         trailing: Column(
// //                           mainAxisAlignment: MainAxisAlignment.end,
// //                           children: [
// //                             IconButton(
// //                               onPressed: () {},
// //                               icon: ImageComponent.loadLocalImage(imageName: AppImages.threeDots),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       Container(
// //                         padding: EdgeInsets.symmetric(horizontal: 16.0.w),
// //                         child: Text(
// //                           model.comment ?? '',
// //                           style: ISOTextStyles.sfProTextLight(size: 12),
// //                         ),
// //                       ),
// //                       Obx(() => Container(
// //                             padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 4.0.h),
// //                             child: !postDetailController.postCommentsList[index].isReplayShow.value
// //                                 ? Row(
// //                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                     children: [
// //                                       ButtonComponents.textIconButton(
// //                                           onTap: () {
// //                                             postDetailController.postCommentsList[index].isReplayShow.value = !postDetailController.postCommentsList[index].isReplayShow.value;
// //                                           },
// //                                           labelText: 'Replies',
// //                                           icon: postDetailController.postCommentsList[index].isReplayShow.value ? AppImages.downArrow : AppImages.rightArrow,
// //                                           alignment: Alignment.centerLeft),
// //                                       Row(
// //                                         children: [
// //                                           IconButton(
// //                                             onPressed: () {
// //                                               focusNode.requestFocus();
// //                                               Future.delayed(const Duration(milliseconds: 500), () {
// //                                                 if (scrollController.hasClients) {
// //                                                   final position = scrollController.position.maxScrollExtent;
// //                                                   scrollController.jumpTo(position);
// //                                                   postDetailController.replyCommentId.value = postDetailController.postCommentsList[index].mainCommentId ?? 0;
// //                                                 }
// //                                               });
// //                                               postDetailController.isRCommentReply.value = true;
// //                                             },
// //                                             icon: ImageComponent.loadLocalImage(imageName: AppImages.reply),
// //                                           ),
// //                                           ButtonComponents.textIconButton(
// //                                               onTap: () async {
// //                                                 if (postDetailController.isLikeFeed[index] == false) {
// //                                                   var likeResponse = await postDetailController.feedCommentLikeApi(
// //                                                     commentId: model.mainCommentId ?? 0,
// //                                                     onSuccess: (value) {
// //                                                       postDetailController.likesCounters[index] = value;
// //                                                       postDetailController.likesCounters.toSet();
// //                                                       Logger().i(postDetailController.likesCounters.toList());
// //                                                     },
// //                                                   );
// //                                                   if (likeResponse) {
// //                                                     postDetailController.isLikeFeed[index] = true;
// //                                                   }
// //                                                 } else {
// //                                                   var likeResponse = await postDetailController.feedCommentUnlikeApi(
// //                                                     commentId: model.mainCommentId ?? 0,
// //                                                     onSuccess: (value) {
// //                                                       postDetailController.likesCounters[index] = value;
// //                                                       postDetailController.likesCounters.toSet();
// //                                                       Logger().i(postDetailController.likesCounters.toList());
// //                                                     },
// //                                                   );
// //                                                   if (likeResponse) {
// //                                                     postDetailController.isLikeFeed[index] = false;
// //                                                   }
// //                                                 }
// //                                                 // if (model.likedByUser == false) {
// //                                                 //   if (model.isLiked.value == false) {
// //                                                 //     var likeResponse = await postDetailController.feedCommentLikeApi(
// //                                                 //       commentId: model.mainCommentId ?? 0,
// //                                                 //       onSuccess: (value) {
// //                                                 //         postDetailController.likesCounters[index] = value;
// //                                                 //         postDetailController.likesCounters.toSet();
// //                                                 //         print(value);
// //                                                 //         print(postDetailController.likesCounters.toList());
// //                                                 //       },
// //                                                 //     );
// //                                                 //     if (likeResponse) {
// //                                                 //       model.isLiked.value = true;
// //                                                 //     }
// //                                                 //   } else {
// //                                                 //     var response = await postDetailController.feedCommentUnlikeApi(
// //                                                 //       commentId: model.mainCommentId ?? 0,
// //                                                 //       onSuccess: (value) {
// //                                                 //         postDetailController.likesCounters[index] = value;
// //                                                 //         postDetailController.likesCounters.toSet();
// //                                                 //         print(value);
// //                                                 //         print(postDetailController.likesCounters.toList());
// //                                                 //       },
// //                                                 //     );
// //                                                 //     if (response) {
// //                                                 //       model.isLiked.value = false;
// //                                                 //     }
// //                                                 //   }
// //                                                 // } else {
// //                                                 //   var response = await postDetailController.feedCommentUnlikeApi(
// //                                                 //     commentId: model.mainCommentId ?? 0,
// //                                                 //     onSuccess: (value) {
// //                                                 //       postDetailController.likesCounters[index] = value;
// //                                                 //       postDetailController.likesCounters.toSet();
// //                                                 //       print(value);
// //                                                 //       print(postDetailController.likesCounters.toList());
// //                                                 //     },
// //                                                 //   );
// //                                                 //   if (response) {
// //                                                 //     model.isLiked.value = false;
// //                                                 //   }
// //                                                 // }
// //                                               },
// //                                               //labelText: '${model.likes ?? 0}',
// //                                               labelText: '${postDetailController.likesCounters[index]}',
// //                                               icon: postDetailController.isLikeFeed[index] == true ? AppImages.heartRed : AppImages.heartLike,
// //                                           )
// //                                         ],
// //                                       )
// //                                     ],
// //                                   )
// //                                 : Column(
// //                                     children: [
// //                                       Row(
// //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                                         children: [
// //                                           ButtonComponents.textIconButton(
// //                                               onTap: () {
// //                                                 postDetailController.postCommentsList[index].isReplayShow.value = !postDetailController.postCommentsList[index].isReplayShow.value;
// //                                               },
// //                                               labelText: 'Replies',
// //                                               icon: postDetailController.postCommentsList[index].isReplayShow.value ? AppImages.downArrow : AppImages.rightArrow,
// //                                               alignment: Alignment.centerLeft),
// //                                           Row(
// //                                             children: [
// //                                               IconButton(
// //                                                 onPressed: () {
// //                                                   focusNode.requestFocus();
// //                                                   Future.delayed(const Duration(milliseconds: 500), () {
// //                                                     if (scrollController.hasClients) {
// //                                                       final position = scrollController.position.maxScrollExtent;
// //                                                       scrollController.jumpTo(position);
// //                                                     }
// //                                                   });
// //                                                   postDetailController.isReplyComment.value = true;
// //                                                 },
// //                                                 icon: ImageComponent.loadLocalImage(imageName: AppImages.reply),
// //                                               ),
// //                                               ButtonComponents.textIconButton(
// //                                                 onTap: () {},
// //                                                 labelText: '${model.likes ?? 0}',
// //                                                 icon: AppImages.heartLike,
// //                                               )
// //                                             ],
// //                                           )
// //                                         ],
// //                                       ),
// //                                       ListView.builder(
// //                                           shrinkWrap: true,
// //                                           physics: const NeverScrollableScrollPhysics(),
// //                                           //itemCount: postDetailController.postCommentsList[index].commentReplies?.length,
// //                                           itemCount: postDetailController.postCommentsList[index].commentReplies?.length,
// //                                           itemBuilder: (BuildContext context, int i) {
// //                                             return Container(
// //                                               height: 100,
// //                                               color: Colors.blue,
// //                                               child: Text(postDetailController.postCommentsList[index].commentReplies?[i].replies ?? ''),
// //                                             );
// //                                           }),
// //                                       //Container(height: 100, color: Colors.yellow,)
// //                                     ],
// //                                   ),
// //                           ))
// //                     ],
// //                   );
// //                 } else {
// //                   if (postDetailController.paginationLoadData()) {
// //                     return Divider();
// //                   } else {
// //                     return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
// //                   }
// //                 }
// //               },
// //               separatorBuilder: (BuildContext context, int index) {
// //                 return Divider(
// //                   color: AppColors.greyColor,
// //                   thickness: 5.0.h,
// //                 );
// //               },
// //             ),
// //     );
// //   }
// // }
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/post_detail_controller.dart';
// import 'package:iso_net/ui/common_ui/feed_post_widget.dart';
// import 'package:iso_net/ui/style/image_components.dart';
// import 'package:iso_net/ui/style/textfield_components.dart';
// import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
// import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';
//
// import '../../../../utils/app_common_stuffs/app_colors.dart';
// import '../../../../utils/app_common_stuffs/app_images.dart';
// import '../../../../utils/app_common_stuffs/app_logger.dart';
// import '../../../../utils/app_common_stuffs/commom_utils.dart';
// import '../../../../utils/app_common_stuffs/common_api_function.dart';
// import '../../../../utils/app_common_stuffs/screen_routes.dart';
// import '../../../common_ui/view_photo_video_screen.dart';
// import '../../../style/appbar_components.dart';
// import '../../../style/button_components.dart';
// import '../../../style/text_style.dart';
//
// class PostDetail extends StatefulWidget {
//   const PostDetail({Key? key}) : super(key: key);
//
//   @override
//   State<PostDetail> createState() => _PostDetailState();
// }
//
// class _PostDetailState extends State<PostDetail> {
//   PostDetailController postDetailController = Get.find<PostDetailController>();
//   PageController pageController = PageController();
//   TextEditingController commentTextController = TextEditingController();
//   ScrollController scrollController = ScrollController();
//   FocusNode focusNode = FocusNode();
//
//
//   @override
//   void initState() {
//     postDetailController.fetchPostCommentsApi(page: postDetailController.pageToShow.value);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScopeNode currentFocus = FocusScope.of(context);
//         if (!currentFocus.hasPrimaryFocus) {
//           currentFocus.unfocus();
//           focusNode.unfocus();
//           postDetailController.isReplyComment.value = false;
//         }
//       },
//       child: Scaffold(
//         appBar: appBarBody(),
//         //body: buildBody(),
//         body: buildScaffoldBody(),
//       ),
//     );
//   }
//
//   ///Appbar
//   PreferredSizeWidget appBarBody() {
//     return AppBarComponents.appBar(
//       leadingWidget: IconButton(
//         onPressed: () => Get.until((route) => route.settings.name == ScreenRoutesConstants.bottomTabsScreen),
//         icon: ImageComponent.loadLocalImage(
//           imageName: AppImages.arrow,
//         ),
//       ),
//       actionWidgets: [
//         GestureDetector(
//           onTap: () {
//             CommonUtils.reportWidget(feedId: postDetailController.postDetail.feedId ?? 0, context: context);
//           },
//           child: CircleAvatar(
//             radius: 14,
//             child: ImageComponent.loadLocalImage(imageName: AppImages.threeDotFill),
//           ),
//         ),
//         10.sizedBoxW,
//       ],
//     );
//   }
//
//   Widget buildScaffoldBody() {
//     return SafeArea(
//       child: Column(
//         children: [
//           Expanded(
//             child: SingleChildScrollView(
//               physics: const ClampingScrollPhysics(),
//               controller: postDetailController.scrollController,
//               child: Column(
//                 children: [
//                   postCard(),
//                   commentDropDown(),
//                   viewCommentBody(),
//                 ],
//               ),
//             ),
//           ),
//           addCommentBody(),
//         ],
//       ),
//     );
//   }
//
//   Widget postCard() {
//     return Obx(
//       () =>   FeedPostWidget(
//         userProfilePage: () {},
//         profileImageUrl: postDetailController.postDetail.user?.profileImg ?? '',
//         fName: postDetailController.postDetail.user?.firstName ?? '',
//         lName: postDetailController.postDetail.user?.lastName ?? '',
//         companyName: postDetailController.postDetail.user?.companyName ?? '',
//         timeAgo: postDetailController.postDetail.getHoursAgo,
//         isThreeDotIconVisible: false,
//         connectText: postDetailController.postDetail.user?.isConnected.value == 'NotConnected' ? 'Connect' : 'Requested',
//         connectIcon: postDetailController.postDetail.user?.isConnected.value == 'NotConnected' ? AppImages.plus : AppImages.check,
//         onConnectButtonPress: () async {
//           var apiResult = await CommonApiFunction.commonConnectApi(
//               userId: postDetailController.postDetail.user?.userId ?? 0,
//               onErr: (msg) {
//                 SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
//               });
//           if (apiResult) {
//             Logger().i('true api');
//           }
//         },
//         postContent: postDetailController.postDetail.description ?? '',
//         screenRoutes: () {},
//         isExpandText: postDetailController.postDetail.showMore,
//         postImages: postDetailController.postDetail.feedMedia ?? [],
//         pageController: pageController,
//         onPostImageTap: (value) {
//           Get.to(PhotoVideoScreen(), arguments: [postDetailController.postDetail,value]);
//         },
//         likeCounts: postDetailController.postDetail.likesCounters.value,
//         commentCounts: postDetailController.postDetail.comment ?? 0,
//         onLikeButtonPressed: () async {
//           if (postDetailController.postDetail.isLikeFeed.value == false) {
//             var likeResponse = await postDetailController.likePostApi(
//               feedId: postDetailController.postDetail.feedId ?? 0,
//               onSuccess: (value) {
//                 postDetailController.postDetail.likesCounters.value = value;
//               },
//             );
//             if (likeResponse) {
//               postDetailController.postDetail.isLikeFeed.value = true;
//             }
//           } else {
//             var likeResponse = await postDetailController.unlikePostApi(
//               feedId: postDetailController.postDetail.feedId ?? 0,
//               onSuccess: (value) {
//                 postDetailController.postDetail.likesCounters.value = value;
//                 // postDetailController.likesCounters.toSet();
//                 // Logger().i(postDetailController.likesCounters.toList());
//               },
//             );
//             if (likeResponse) {
//               postDetailController.postDetail.isLikeFeed.value = false;
//             }
//           }
//         },
//         likedIcon: postDetailController.postDetail.isLikeFeed.value ? AppImages.dollarFill : AppImages.dollar,
//         onCommentButtonPressed: () {
//           focusNode.requestFocus();
//           postDetailController.isReplyComment.value = false;
//
//           Future.delayed(const Duration(milliseconds: 500), () {
//             if (scrollController.hasClients) {
//               final position = scrollController.position.maxScrollExtent;
//               scrollController.jumpTo(position);
//             }
//           });
//         },
//         isShareIconVisible: false.obs,
//         isUserMe: CommonUtils.isUserMe(id: postDetailController.postDetail.user?.userId ?? 0),
//       ),
//     );
//   }
//
//   ///Add Comment Body
//   Widget addCommentBody() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
//       child: Column(
//         children: [
//           addCommentTextField(),
//         ],
//       ),
//     );
//   }
//
//   Widget addCommentTextField() {
//     return Obx(
//       () => TextFieldComponents(
//         textEditingController: commentTextController,
//         //autoFocus: postDetailController.autoFocus.value,
//
//         focusNode: focusNode,
//         context: context,
//         hint: 'Add a comment...',
//         onChanged: (value) {
//           postDetailController.commentText.value = value;
//         },
//         iconSuffix: CommonUtils.visibleOption(postDetailController.commentText.value) == true
//             ? IconButton(
//                 onPressed: () async {
//                   postDetailController.pageToShow.value = 1;
//                   postDetailController.isAllDataLoaded.value = false;
//                   var apiResult = postDetailController.isReplyComment.value == true
//                       ? await postDetailController.addFeedCommentReplyApiCall(
//                           onErr: (msg) {
//                             SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
//                           },
//                           commentID: postDetailController.replyCommentId.value,
//                         )
//                       : await postDetailController.addCommentApiCall(
//                           onErr: (msg) {
//                             SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
//                           },
//                         );
//                   if (apiResult) {
//                     focusNode.unfocus();
//                     commentTextController.clear();
//                     postDetailController.commentText.value = '';
//                     postDetailController.isReplyComment.value = false;
//                     Future.delayed(const Duration(milliseconds: 100), () {
//                       if (scrollController.hasClients) {
//                         final position = scrollController.position.maxScrollExtent;
//                         scrollController.jumpTo(position);
//                       }
//                     });
//                   }
//                 },
//                 icon: const Icon(
//                   Icons.send,
//                   color: AppColors.blackColor,
//                 ),
//               )
//             : null,
//       ),
//     );
//   }
//
//   Widget viewCommentBody() {
//     return Obx(
//       () => postDetailController.isCommentLoaded.value == false
//           ? const Center(
//               child: CircularProgressIndicator(
//                 color: AppColors.primaryColor,
//               ),
//             )
//           : ListView.separated(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: postDetailController.postCommentsList.length + 1,
//               itemBuilder: (BuildContext context, int index) {
//                 if (index < postDetailController.postCommentsList.length) {
//                   var model = postDetailController.postCommentsList[index];
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ListTile(
//                         leading: CircleAvatar(
//                           radius: 20,
//                           backgroundImage: CachedNetworkImageProvider(
//                             model.user?.profileImg ?? '',
//                           ),
//                         ),
//                         title: Row(
//                           children: [
//                             Text(
//                               '${model.user?.firstName ?? ''} ${model.user?.lastName ?? ''}  •  ',
//                               style: ISOTextStyles.openSenseSemiBold(size: 11),
//                             ),
//                             Text(
//                               CommonUtils.checkTimingsAgo(createdAt: model.createdAt ?? ''),
//                               style: ISOTextStyles.openSenseRegular(size: 11, color: AppColors.hintTextColor),
//                             ),
//                           ],
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               model.user?.companyName ?? '',
//                               style: ISOTextStyles.openSenseRegular(size: 10, color: AppColors.hintTextColor),
//                             ),
//                           ],
//                         ),
//                         trailing: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             IconButton(
//                               onPressed: () {
//                                 CommonUtils.reportFeedCommentWidget(commentId: postDetailController.postCommentsList[index].mainCommentId ?? 0, context: context);
//                               },
//                               icon: ImageComponent.loadLocalImage(imageName: AppImages.threeDots),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0.w),
//                         child: Text(
//                           model.comment ?? '',
//                           style: ISOTextStyles.sfProTextLight(size: 12),
//                         ),
//                       ),
//                       Obx(
//                         () => Container(
//                           padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 4.0.h),
//                           child: !postDetailController.postCommentsList[index].isReplayShow.value
//                               ? Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     ButtonComponents.textIconButton(
//                                         onTap: () {
//                                           postDetailController.postCommentsList[index].isReplayShow.value = !postDetailController.postCommentsList[index].isReplayShow.value;
//                                         },
//                                         labelText: '${postDetailController.postCommentsList[index].commentReplies?.length} Replies',
//                                         icon: postDetailController.postCommentsList[index].isReplayShow.value ? AppImages.upArrow : AppImages.downArrow,
//                                         alignment: Alignment.centerLeft),
//                                     Row(
//                                       children: [
//                                         GestureDetector(
//                                             onTap: () {
//                                               focusNode.requestFocus();
//                                               Future.delayed(const Duration(milliseconds: 500), () {
//                                                 if (scrollController.hasClients) {
//                                                   final position = scrollController.position.maxScrollExtent;
//                                                   scrollController.jumpTo(position);
//                                                 }
//                                               });
//                                               postDetailController.replyCommentId.value = postDetailController.postCommentsList[index].mainCommentId ?? 0;
//                                               print(postDetailController.replyCommentId.value);
//                                               postDetailController.isReplyComment.value = true;
//                                             },
//                                             child: ImageComponent.loadLocalImage(imageName: AppImages.reply)),
//                                         ButtonComponents.textIconButton(
//                                           onTap: () async {
//                                             if (postDetailController.isLikeFeed[index] == false) {
//                                               var likeResponse = await postDetailController.feedCommentLikeApi(
//                                                 commentId: model.mainCommentId ?? 0,
//                                                 onSuccess: (value) {
//                                                   postDetailController.likesCounters[index] = value;
//                                                   postDetailController.likesCounters.toSet();
//                                                   Logger().i(postDetailController.likesCounters.toList());
//                                                 },
//                                               );
//                                               if (likeResponse) {
//                                                 postDetailController.isLikeFeed[index] = true;
//                                               }
//                                             } else {
//                                               var likeResponse = await postDetailController.feedCommentUnlikeApi(
//                                                 commentId: model.mainCommentId ?? 0,
//                                                 onSuccess: (value) {
//                                                   postDetailController.likesCounters[index] = value;
//                                                   postDetailController.likesCounters.toSet();
//                                                   Logger().i(postDetailController.likesCounters.toList());
//                                                 },
//                                               );
//                                               if (likeResponse) {
//                                                 postDetailController.isLikeFeed[index] = false;
//                                               }
//                                             }
//                                           },
//                                           labelText: '${postDetailController.likesCounters[index]}',
//                                           icon: postDetailController.isLikeFeed[index] == true ? AppImages.heartRed : AppImages.heartLike,
//                                         )
//                                       ],
//                                     )
//                                   ],
//                                 )
//                               : Obx(
//                                   () => Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           ButtonComponents.textIconButton(
//                                               onTap: () {
//                                                 postDetailController.postCommentsList[index].isReplayShow.value = !postDetailController.postCommentsList[index].isReplayShow.value;
//                                               },
//                                               labelText: '${postDetailController.postCommentsList[index].commentReplies?.length} Replies',
//                                               icon: postDetailController.postCommentsList[index].isReplayShow.value ? AppImages.downArrow : AppImages.rightArrow,
//                                               alignment: Alignment.centerLeft),
//                                           Row(
//                                             children: [
//                                               GestureDetector(
//                                                   onTap: () {
//                                                     focusNode.requestFocus();
//                                                     Future.delayed(const Duration(milliseconds: 500), () {
//                                                       if (scrollController.hasClients) {
//                                                         final position = scrollController.position.maxScrollExtent;
//                                                         scrollController.jumpTo(position);
//                                                       }
//                                                     });
//                                                     postDetailController.replyCommentId.value = postDetailController.postCommentsList[index].mainCommentId ?? 0;
//                                                     print(postDetailController.replyCommentId.value);
//                                                     postDetailController.isReplyComment.value = true;
//                                                   },
//                                                   child: ImageComponent.loadLocalImage(imageName: AppImages.reply)),
//                                               ButtonComponents.textIconButton(
//                                                 onTap: () async {
//                                                   if (postDetailController.isLikeFeed[index] == false) {
//                                                     var likeResponse = await postDetailController.feedCommentLikeApi(
//                                                       commentId: model.mainCommentId ?? 0,
//                                                       onSuccess: (value) {
//                                                         postDetailController.likesCounters[index] = value;
//                                                         postDetailController.likesCounters.toSet();
//                                                         Logger().i(postDetailController.likesCounters.toList());
//                                                       },
//                                                     );
//                                                     if (likeResponse) {
//                                                       postDetailController.isLikeFeed[index] = true;
//                                                     }
//                                                   } else {
//                                                     var likeResponse = await postDetailController.feedCommentUnlikeApi(
//                                                       commentId: model.mainCommentId ?? 0,
//                                                       onSuccess: (value) {
//                                                         postDetailController.likesCounters[index] = value;
//                                                         postDetailController.likesCounters.toSet();
//                                                         Logger().i(postDetailController.likesCounters.toList());
//                                                       },
//                                                     );
//                                                     if (likeResponse) {
//                                                       postDetailController.isLikeFeed[index] = false;
//                                                     }
//                                                   }
//                                                   // if (model.likedByUser == false) {
//                                                   //   if (model.isLiked.value == false) {
//                                                   //     var likeResponse = await postDetailController.feedCommentLikeApi(
//                                                   //       commentId: model.mainCommentId ?? 0,
//                                                   //       onSuccess: (value) {
//                                                   //         postDetailController.likesCounters[index] = value;
//                                                   //         postDetailController.likesCounters.toSet();
//                                                   //         print(value);
//                                                   //         print(postDetailController.likesCounters.toList());
//                                                   //       },
//                                                   //     );
//                                                   //     if (likeResponse) {
//                                                   //       model.isLiked.value = true;
//                                                   //     }
//                                                   //   } else {
//                                                   //     var response = await postDetailController.feedCommentUnlikeApi(
//                                                   //       commentId: model.mainCommentId ?? 0,
//                                                   //       onSuccess: (value) {
//                                                   //         postDetailController.likesCounters[index] = value;
//                                                   //         postDetailController.likesCounters.toSet();
//                                                   //         print(value);
//                                                   //         print(postDetailController.likesCounters.toList());
//                                                   //       },
//                                                   //     );
//                                                   //     if (response) {
//                                                   //       model.isLiked.value = false;
//                                                   //     }
//                                                   //   }
//                                                   // } else {
//                                                   //   var response = await postDetailController.feedCommentUnlikeApi(
//                                                   //     commentId: model.mainCommentId ?? 0,
//                                                   //     onSuccess: (value) {
//                                                   //       postDetailController.likesCounters[index] = value;
//                                                   //       postDetailController.likesCounters.toSet();
//                                                   //       print(value);
//                                                   //       print(postDetailController.likesCounters.toList());
//                                                   //     },
//                                                   //   );
//                                                   //   if (response) {
//                                                   //     model.isLiked.value = false;
//                                                   //   }
//                                                   // }
//                                                 },
//                                                 labelText: '${postDetailController.likesCounters[index]}',
//                                                 icon: postDetailController.isLikeFeed[index] == true ? AppImages.heartRed : AppImages.heartLike,
//                                               )
//                                             ],
//                                           )
//                                         ],
//                                       ),
//                                       ListView.builder(
//                                         shrinkWrap: true,
//                                         physics: const NeverScrollableScrollPhysics(),
//                                         //itemCount: postDetailController.postCommentsList[index].commentReplies?.length,
//                                         itemCount: postDetailController.postCommentsList[index].commentReplies?.length,
//                                         itemBuilder: (BuildContext context, int i) {
//                                           return Obx(
//                                             () => Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 ListTile(
//                                                   leading: CircleAvatar(
//                                                     radius: 20,
//                                                     backgroundImage: CachedNetworkImageProvider(
//                                                       model.commentReplies?[i].profileImg ?? '',
//                                                     ),
//                                                   ),
//                                                   title: Row(
//                                                     children: [
//                                                       FittedBox(
//                                                         child: Text(
//                                                           '${model.commentReplies?[i].firstName ?? ''} ${model.commentReplies?[i].lastName ?? ''}  •  ',
//                                                           style: ISOTextStyles.openSenseSemiBold(size: 11),
//                                                         ),
//                                                       ),
//                                                       Text(
//                                                         model.commentReplies![i].getReplyCommentTime,
//                                                         style: ISOTextStyles.openSenseRegular(size: 11, color: AppColors.hintTextColor),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                   subtitle: (model.user?.companyName ?? '').isNotEmpty
//                                                       ? Container(
//                                                           child: Text(
//                                                             model.commentReplies?[i].companyName ?? '',
//                                                             style: ISOTextStyles.openSenseRegular(size: 10, color: AppColors.hintTextColor),
//                                                           ),
//                                                         )
//                                                       : Container(),
//                                                   trailing: ImageComponent.loadLocalImage(imageName: AppImages.threeDots),
//                                                 ),
//                                                 Row(
//                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                   children: [
//                                                     Container(
//                                                       margin: EdgeInsets.only(left: 73.w),
//                                                       child: Text(model.commentReplies?[i].replies ?? ''),
//                                                     ),
//                                                     ButtonComponents.textIconButton(
//                                                       onTap: () async {
//                                                         if (model.isLikeReplyFeed[i] == false) {
//                                                           var likeResponse = await postDetailController.feedCommentReplyLikeApi(
//                                                             replyId: model.commentReplies?[i].repliesId ?? 0,
//                                                             onSuccess: (value) {
//                                                               model.likesReplyCounters[i] = value;
//                                                               model.likesReplyCounters.toSet();
//                                                               Logger().i(model.likesReplyCounters.toList());
//                                                             },
//                                                           );
//                                                           if (likeResponse) {
//                                                             model.isLikeReplyFeed[i] = true;
//                                                           }
//                                                         } else {
//                                                           var likeResponse = await postDetailController.feedCommentReplyUnlikeApi(
//                                                             replyId: model.commentReplies?[i].repliesId ?? 0,
//                                                             onSuccess: (value) {
//                                                               model.likesReplyCounters[i] = value;
//                                                               model.likesReplyCounters.toSet();
//                                                               Logger().i(model.likesReplyCounters.toList());
//                                                             },
//                                                           );
//                                                           if (likeResponse) {
//                                                             model.isLikeReplyFeed[i] = false;
//                                                           }
//                                                         }
//                                                       },
//                                                       labelText: '${model.likesReplyCounters[i]}',
//                                                       icon: model.isLikeReplyFeed[i] == true ? AppImages.heartRed : AppImages.heartLike,
//                                                     )
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           );
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                         ),
//                       )
//                     ],
//                   );
//                 } else {
//                   if (postDetailController.paginationLoadData()) {
//                     return const Divider();
//                   } else {
//                     return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
//                   }
//                 }
//               },
//               separatorBuilder: (BuildContext context, int index) {
//                 return Divider(
//                   color: AppColors.greyColor,
//                   thickness: 5.0.h,
//                 );
//               },
//             ),
//     );
//   }
//
//   Widget commentDropDown() {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: Container(
//         padding: EdgeInsets.only(left: 5.w, right: 5.w),
//         margin: EdgeInsets.only(right: 10.w),
//         decoration: const BoxDecoration(
//           color: AppColors.dropDownColor, // Set border width
//           borderRadius: BorderRadius.all(Radius.circular(10.0)), // Set rounded corner radius
//         ),
//         child: Obx(() => DropdownButton<String>(
//               itemHeight: null,
//               underline: SizedBox.shrink(),
//               value: postDetailController.dropdownValue.value,
//               icon: ImageComponent.loadLocalImage(imageName: AppImages.downArrow),
//               style: const TextStyle(color: AppColors.blackColor),
//               onChanged: (String? value) async {
//                 postDetailController.postCommentsList.clear();
//                 // This is called when the user selects an item.
//                 postDetailController.dropdownValue.value = value!;
//                 postDetailController.isCommentLoaded.value = false;
//                 postDetailController.isAllDataLoaded.value = false;
//
//                 postDetailController.pageToShow.value = 1;
//                 await postDetailController.fetchPostCommentsApi(page: postDetailController.pageToShow.value);
//               },
//               items: list.map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text('${value}  '),
//                 );
//               }).toList(),
//             )),
//       ),
//     );
//   }
// }
