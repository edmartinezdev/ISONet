// ignore_for_file: file_names

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';

class ImageWidget extends StatelessWidget {
  final String? url;
  final String? placeholder;
  final String? errorPlaceHolderImage;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final bool isOriginalImage;

  const ImageWidget({Key? key, this.url, this.placeholder, this.fit, this.height, this.width, this.errorPlaceHolderImage, this.isOriginalImage = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if ((url ?? '').isEmpty) {
      if ((placeholder ?? AppImages.imagePlaceholder).isEmpty) return Container();
      return Image.asset(
        placeholder ?? AppImages.imagePlaceholder,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
      );
    }

    if (!(url!.startsWith("http") || url!.startsWith("https"))) {
      return Image.asset(
        errorPlaceHolderImage ?? AppImages.imagePlaceholder,
        height: height,
        width: width,
        fit: fit ?? BoxFit.cover,
      );
    }

    return CachedNetworkImage(
      key:  ValueKey(Random().nextInt(1000).toString()),
        imageUrl: url ?? "",
        height: height,
        width: width,
        // memCacheHeight: isOriginalImage == false ? 400 : null,
        // memCacheWidth: isOriginalImage == false ? 400 : null,
        // cacheManager: LocalCacheManager.instance,
        maxHeightDiskCache: isOriginalImage == false ? 1024 : null,
        maxWidthDiskCache: isOriginalImage == false ? 1024 : null,
        fit: fit ?? BoxFit.cover,
        placeholder: (context, url) {
          // return Image.asset(
          //   placeholder ?? "",
          //   height: height,
          //   width: width,
          //   fit: fit ?? BoxFit.cover,
          // );
          // return Image.asset(
          //   placeholder ?? "",
          //   height: height,
          //   width: width,
          //   fit: fit ?? BoxFit.cover,
          // );
          return const Center(child: CupertinoActivityIndicator());
        },
        errorWidget: (context, url, error) {
          return Image.asset(
            errorPlaceHolderImage ?? AppImages.imagePlaceholder,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
          );
        });
  }
}
