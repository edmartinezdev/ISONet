import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iso_net/ui/style/ImageWidget.dart';

class ImageComponent{
  static Widget loadLocalImage({
    required String imageName,
    double? height,
    double? width,
    Color? imageColor,
    BoxFit? boxFit,
  }) {
    return Image.asset(
      imageName,
      width: width,
      height: height,
      color: imageColor,
      fit: boxFit,
    );
  }

  static circleNetworkImage({required String imageUrl,double? height,double? width,String? placeHolderImage}){
    return ClipRRect(
      borderRadius: BorderRadius.circular((height ?? 0.0)/2),
      child: SizedBox(
          height:height ?? 0.0,
          width:width ?? 0.0,
          child:ImageWidget(url: imageUrl,height: height,width: width,placeholder: placeHolderImage,)
      ),
    );
  }
}