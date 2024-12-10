import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/model/bottom_navigation_models/forum_models/forum_list_model.dart';
import 'package:iso_net/ui/style/ImageWidget.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';
import 'package:iso_net/utils/swipe_back.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

import '../video_play_screen.dart';

class FullScreenForumPhotoVideo extends StatefulWidget {
  const FullScreenForumPhotoVideo({Key? key}) : super(key: key);

  @override
  State<FullScreenForumPhotoVideo> createState() => _FullScreenForumPhotoVideoState();
}

class _FullScreenForumPhotoVideoState extends State<FullScreenForumPhotoVideo> with SingleTickerProviderStateMixin {
  ForumData postDetails = Get.arguments[0];

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
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: slidingPageIndicatorIndex.value);
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.blackColor,
        body: PageView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: postDetails.forumMedia?.length,
          controller: pageController,
          scrollDirection: Axis.horizontal,
          onPageChanged: (value) {
            // slidingPageIndicatorIndex.value = value;

          },
          itemBuilder: (BuildContext context, int subIndex) {
            slidingPageIndicatorIndex.value = subIndex;
            if (postDetails.forumMedia?[subIndex].mediaType == 'video') {
              return Stack(
                alignment: Alignment.center,
                children: [
                  ImageWidget(
                    url: postDetails.forumMedia?[subIndex].thumbnail ?? '',
                    fit: BoxFit.cover,
                    width: double.infinity,
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
                onTap: () {
                  Get.back(result: subIndex);
                },
                child: PhotoView(
                  minScale : PhotoViewComputedScale.contained * 1.0,
                  maxScale: 2.0,
                  imageProvider: CachedNetworkImageProvider(postDetails.forumMedia?[subIndex].forumMedia ?? ''),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
