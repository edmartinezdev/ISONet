// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../../utils/app_common_stuffs/commom_utils.dart';
import '../../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../style/appbar_components.dart';
import '../../../../style/image_components.dart';

class ImageFullScreen extends StatefulWidget {
  String image;

  ImageFullScreen({Key? key, required this.image}) : super(key: key);

  @override
  State<ImageFullScreen> createState() => _ImageFullScreenState();
}

class _ImageFullScreenState extends State<ImageFullScreen> {
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
                var downloadImageResult = await CommonUtils.imageDownload(imageUrl: widget.image, context: context);
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
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return InteractiveViewer(
      panEnabled: false, // Set it to false
      boundaryMargin: const EdgeInsets.all(100),
      minScale: 0.5,
      maxScale: 2,
      child: Container(
          //child: ImageComponent.cachedImageNetwork(imageUrl: widget.image, onImageTap: () {}));
          decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(widget.image), fit: BoxFit.contain))),
    );
  }
}
