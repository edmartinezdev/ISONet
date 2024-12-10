// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/bindings/bottom_tabs/article_detail_binding.dart';
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/feed_list_model.dart';

import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/article_detail_screen.dart';
import 'package:iso_net/ui/style/ImageWidget.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';


class ArticleAdaptor extends StatefulWidget {
  FeedData model;
  ArticleMedia articleMedia;
  bool? isSearchScreenOpen;

   ArticleAdaptor({Key? key,required this.model,required this.articleMedia,this.isSearchScreenOpen}) : super(key: key);

  @override
  State<ArticleAdaptor> createState() => _ArticleAdaptorState();
}

class _ArticleAdaptorState extends State<ArticleAdaptor> with AutomaticKeepAliveClientMixin<ArticleAdaptor>{


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        Get.to(
            ArticleDetail(
              currentPage: widget.model.currentPage ?? 0,
              isScreenOpen: widget.isSearchScreenOpen ?? false,
              articleId: widget.model.articleId ?? -1,
            ),
            binding: ArticleDetailBinding());
      },
      child: Container(

        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: AppColors.greyColor,
              width: 8.w,
            ),
          ),
        ),

        child: Column(
          children: [

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 85.w,
                    width: 85.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(17.r),
                      child: IgnorePointer(
                        child:
                            ImageWidget(url: widget.articleMedia.articleMedia ?? '',fit: BoxFit.cover,),
                      ),
                    ),
                  ),
                  16.sizedBoxW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.model.articleTitle ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: ISOTextStyles.sfProSemiBold(size: 16, lineSpacing: 1.8),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10.h, top: 5.h),
                          child: FittedBox(
                            child: Row(
                              children: [
                                Text(
                                  widget.model.articleAuthorName ?? '',
                                  style: ISOTextStyles.sfProMedium(size: 12, color: AppColors.hintTextColor),
                                ),
                                10.sizedBoxW,
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration:
                                  const BoxDecoration(shape: BoxShape.circle, color: AppColors.showTimeColor),
                                ),
                                11.sizedBoxW,
                                ImageComponent.loadLocalImage(imageName: AppImages.clockOutline),
                                5.sizedBoxW,
                                Text(
                                  widget.model.getHoursAgo,
                                  style: ISOTextStyles.sfProDisplayLight(size: 10, color: AppColors.hintTextColor),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}


