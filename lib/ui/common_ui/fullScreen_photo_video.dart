// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/ui/common_ui/video_play_screen.dart';
import 'package:iso_net/ui/style/ImageWidget.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

import '../../model/bottom_navigation_models/news_feed_models/feed_list_model.dart';

class FullScreenPhoto extends StatefulWidget {
  const FullScreenPhoto({Key? key}) : super(key: key);

  @override
  State<FullScreenPhoto> createState() => _FullScreenPhotoState();
}

class _FullScreenPhotoState extends State<FullScreenPhoto> with SingleTickerProviderStateMixin {
  FeedData postDetails = Get.arguments[0];

  var slidingPageIndicatorIndex = 0.obs;
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  PageController pageController = PageController(initialPage: Get.arguments[1]);

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
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: PageView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: postDetails.feedMedia?.length,
        controller: pageController,
        scrollDirection: Axis.horizontal,
        onPageChanged: (value) {
          /*slidingPageIndicatorIndex.value = value;*/

        },
        itemBuilder: (BuildContext context, int subIndex) {
          slidingPageIndicatorIndex.value = subIndex;
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
                onTap: () {
                  slidingPageIndicatorIndex.value = subIndex;
                  Get.back(result: slidingPageIndicatorIndex.value);
                },
                child: PhotoView(minScale: PhotoViewComputedScale.contained * 1.0, maxScale: 2.0, imageProvider: CachedNetworkImageProvider(postDetails.feedMedia?[subIndex].feedMedia ?? '')));
          }
        },
      ),
    );
  }
}
