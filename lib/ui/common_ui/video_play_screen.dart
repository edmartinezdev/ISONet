// ignore_for_file: must_be_immutable

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../utils/app_common_stuffs/app_colors.dart';
import '../../utils/app_common_stuffs/app_images.dart';
import '../../utils/app_common_stuffs/commom_utils.dart';
import '../../utils/app_common_stuffs/snackbar_util.dart';
import '../style/appbar_components.dart';
import '../style/image_components.dart';

class VideoPlayScreen extends StatefulWidget {
  String? video;

  VideoPlayScreen({Key? key, this.video}) : super(key: key);

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  late Future<void> _future;

  Future<void> initVideoPlayer() async {
    await _videoPlayerController.initialize();

    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoPlay: true,
        looping: false,
      );
    });
  }

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(widget.video ?? "");

    _future = initVideoPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBarComponents.appBar(
        backgroundColor: AppColors.blackColor,
        leadingWidget: IconButton(
          onPressed: () => Get.back(),
          icon: ImageComponent.loadLocalImage(
            imageName: AppImages.x,
            imageColor: AppColors.whiteColor,
          ),
        ),
        actionWidgets: [
          InkWell(
              onTap: () async {
                var downloadImageResult = await CommonUtils.imageDownload(imageUrl: widget.video ?? '', context: context);
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
        child: Center(
            child: FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  return Center(
                    child: _videoPlayerController.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _videoPlayerController.value.aspectRatio,
                            child: Chewie(
                              controller: _chewieController,
                            ),
                          )
                        : const CircularProgressIndicator(),
                  );
                })),
      ),
    );
  }
}
