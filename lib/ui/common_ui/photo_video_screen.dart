// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:iso_net/model/bottom_navigation_models/news_feed_models/feed_list_model.dart';
// import 'package:photo_view/photo_view_gallery.dart';
//
// import '../../utils/app_common_stuffs/app_colors.dart';
// import '../../utils/app_common_stuffs/app_images.dart';
// import '../../utils/app_common_stuffs/commom_utils.dart';
// import '../../utils/app_common_stuffs/strings_constants.dart';
// import '../bottom_tabs/tabs/news_feed/post_detail.dart';
// import '../style/button_components.dart';
// import '../style/image_components.dart';
// import '../style/text_style.dart';
//
// class PhotoVideoScreenPrac extends StatefulWidget {
//   List<FeedMedia>? imagesList;
//
//   PhotoVideoScreenPrac({Key? key, required this.imagesList}) : super(key: key);
//
//   @override
//   State<PhotoVideoScreenPrac> createState() => _PhotoVideoScreenPracState();
// }
//
// class _PhotoVideoScreenPracState extends State<PhotoVideoScreenPrac> {
//   // final imagesList = [AppImages.articleImage, AppImages.articleImageLarge, AppImages.broker1];
//
//   FeedData postDetails = Get.arguments;
//   RxBool showMore = false.obs;
//
//   @override
//   void initState() {
//     //imagesList = [];
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.blackColor,
//       body: Obx(
//         () => Column(
//           children: [
//             postDetails.isOnImageTap.value
//                 ? Container()
//                 : Column(
//                     children: [
//                       Container(
//                         margin: EdgeInsets.only(left: 10.w, right: 20.w, top: 15.h),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             IconButton(
//                               onPressed: () => Get.back(),
//                               icon: ImageComponent.loadLocalImage(
//                                 imageName: AppImages.x,
//                                 imageColor: AppColors.whiteColor,
//                               ),
//                             ),
//                             ImageComponent.loadLocalImage(imageName: AppImages.download),
//                           ],
//                         ),
//                       ),
//                       ListTile(
//                         leading: CircleAvatar(
//                           backgroundImage: CachedNetworkImageProvider(
//                             postDetails.user?.profileImg ?? '',
//                           ),
//                         ),
//                         title: Text(
//                           ("${postDetails.user?.firstName ?? ''} ${postDetails.user?.firstName ?? ''}"),
//                           style: ISOTextStyles.openSenseSemiBold(size: 16, color: AppColors.whiteColor),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               postDetails.user?.companyName ?? '',
//                               style: ISOTextStyles.openSenseRegular(size: 10, color: AppColors.whiteColor),
//                             ),
//                             Text(
//                               CommonUtils.checkTimingsAgo(createdAt: postDetails.postedAt ?? ''),
//                               style: ISOTextStyles.openSenseRegular(size: 10, color: AppColors.whiteColor),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//             Expanded(
//               child: Stack(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       postDetails.isOnImageTap.value = !postDetails.isOnImageTap.value;
//                     },
//                     child:
//                         /*PageView.builder(
//                       physics: const BouncingScrollPhysics(),
//                       itemCount: widget.postImages.length,
//                       controller: widget.pageController,
//                       scrollDirection: Axis.horizontal,
//                       onPageChanged: (value) => widget.onPageChanged(value),
//                     )*/
//                         PhotoViewGallery.builder(
//                       itemCount: widget.imagesList?.length,
//                       builder: (BuildContext context, int index) {
//                         final images = widget.imagesList?[index];
//                         return PhotoViewGalleryPageOptions(
//                           imageProvider: NetworkImage(
//                             images?.feedMedia ?? '',
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   postDetails.isOnImageTap.value
//                       ? Container()
//                       : Positioned(
//                           top: 0,
//                           left: 0,
//                           right: 0,
//                           child: Container(
//                             color: AppColors.blackColor,
//                             padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
//                             child: seeMoreText(postDetails.description ?? ''),
//                           ),
//                         ),
//                 ],
//               ),
//             ),
//             postDetails.isOnImageTap.value
//                 ? Container()
//                 : Column(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0.w),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: ButtonComponents.textIconButton(
//                                 alignment: Alignment.centerLeft,
//                                 onTap: () {},
//                                 icon: AppImages.dollar,
//                                 labelText: '${postDetails.likes}',
//                                 textStyle: ISOTextStyles.openSenseSemiBold(size: 14, color: AppColors.whiteColor),
//                               ),
//                             ),
//                             Expanded(
//                               child: ButtonComponents.textIconButton(
//                                 alignment: Alignment.centerRight,
//                                 onTap: () {
//                                   Get.off(const PostDetail(), arguments: postDetails);
//                                   print('hii');
//                                 },
//                                 textStyle: ISOTextStyles.openSenseRegular(size: 12, color: AppColors.whiteColor),
//                                 icon: AppImages.comment,
//                                 labelText: '${postDetails.comment ?? 0} ${AppStrings.comment}',
//                                 iconColor: AppColors.transparentColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const Divider(
//                         color: AppColors.whiteColor,
//                       ),
//                       Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0.w),
//                         //color: Colors.yellow,
//                         alignment: Alignment.center,
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: ButtonComponents.textIconButton(
//                                 onTap: () {},
//                                 icon: AppImages.commentWhite,
//                                 labelText: 'Comment',
//                                 textStyle: ISOTextStyles.sfProSemiBold(size: 14, color: AppColors.whiteColor),
//                               ),
//                             ),
//                             Expanded(
//                               child: ButtonComponents.textIconButton(
//                                 onTap: () {},
//                                 icon: AppImages.sendWhite,
//                                 labelText: 'Send',
//                                 textStyle: ISOTextStyles.sfProSemiBold(size: 14, color: AppColors.whiteColor),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget seeMoreText(String content) {
//     return content.length <= 80
//         ? Text(
//             content,
//             style: ISOTextStyles.openSenseRegular(size: 14, color: AppColors.whiteColor),
//           )
//         : Obx(
//             () {
//               return RichText(
//                 text: TextSpan(
//                   text: showMore.value ? content : '${content.substring(0, 80)} ...    ',
//                   style: ISOTextStyles.openSenseRegular(
//                     size: 14,
//                     color: AppColors.whiteColor,
//                   ),
//                   children: [
//                     TextSpan(
//                       text: showMore.value ? '  ' 'see less' : 'see more',
//                       recognizer: TapGestureRecognizer()..onTap = () => showMore.value = !showMore.value,
//                       style: ISOTextStyles.openSenseBold(
//                         size: 14,
//                         color: AppColors.whiteColor,
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             },
//           );
//   }
// }
