import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/my_profile/bookmark_controller.dart';
import 'package:iso_net/ui/style/ImageWidget.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../utils/app_common_stuffs/app_colors.dart';
import '../../utils/app_common_stuffs/app_images.dart';
import '../../utils/app_common_stuffs/screen_routes.dart';
import '../../utils/app_common_stuffs/strings_constants.dart';
import '../style/appbar_components.dart';
import '../style/image_components.dart';
import '../style/text_style.dart';

class BookMarkScreen extends StatefulWidget {
  const BookMarkScreen({Key? key}) : super(key: key);

  @override
  State<BookMarkScreen> createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen> {
  BookMarkController bookMarkController = Get.find<BookMarkController>();

  @override
  void initState() {
    bookMarkController.getMyBookMarkApi();
    bookMarkController.bookMarkPagination();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBody(),
      body: buildBody(),
    );
  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      titleWidget: Text(
        AppStrings.myBookMarkText,
        style: ISOTextStyles.openSenseSemiBold(size: 17),
      ),
      centerTitle: true,
    );
  }

  ///Scaffold Body
  Widget buildBody() {
    return Obx(
      () => bookMarkController.bookMarkList.isEmpty
          ? const Center(
              child: Text('You will see Bookmarked Articles here'),
            )
          : ListView.builder(
              itemCount: bookMarkController.bookMarkList.length,
              controller: bookMarkController.scrollController,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                if (index < bookMarkController.bookMarkList.length) {
                  //var bookMarkData = bookMarkController.bookMarkList[index].obs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bookMarkController.bookMarkList[index].bookmark?.articleMedia?.length ?? 0,
                    itemBuilder: (BuildContext context, int subIndex) {
                      return GestureDetector(
                        onTap: () async {
                          var callBack = await Get.toNamed(ScreenRoutesConstants.bookmarkDetailScreen, arguments: bookMarkController.bookMarkList[index].currentPage);
                          if (callBack == true) {
                            bookMarkController.page.value = 1;
                            bookMarkController.totalRecord.value = 0;
                            bookMarkController.isAllDataLoaded.value = false;
                            bookMarkController.bookMarkList.clear();
                            bookMarkController.getMyBookMarkApi();
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15.h),
                          child: Column(
                            children: [
                              Container(
                                height: 1,
                                color: AppColors.greyColor,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 85.w,
                                      width: 85.w,
                                      child: IgnorePointer(
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(25),
                                            child: ImageWidget(
                                              url: bookMarkController.bookMarkList[index].bookmark?.articleMedia?[subIndex].articleMedia ?? '',
                                              fit: BoxFit.cover,
                                              placeholder: AppImages.imagePlaceholder,
                                            )),
                                      ),
                                    ),
                                    16.sizedBoxW,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            bookMarkController.bookMarkList[index].bookmark?.title ?? '',
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
                                                    bookMarkController.bookMarkList[index].bookmark?.authorName ?? '',
                                                    style: ISOTextStyles.sfProMedium(size: 12, color: AppColors.hintTextColor),
                                                  ),
                                                  10.sizedBoxW,
                                                  Container(
                                                    width: 5,
                                                    height: 5,
                                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.showTimeColor),
                                                  ),
                                                  11.sizedBoxW,
                                                  ImageComponent.loadLocalImage(imageName: AppImages.clockOutline),
                                                  5.sizedBoxW,
                                                  Text(
                                                    bookMarkController.bookMarkList[index].bookmark?.getHoursAgo ?? '',
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
                              Container(
                                height: 1,
                                color: AppColors.greyColor,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  if (bookMarkController.paginationLoadData()) {
                    return const Divider();
                  } else {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 16.0.h),
                      alignment: Alignment.center,
                      child: const CupertinoActivityIndicator(),
                    );
                  }
                }
              },
            ),
    );
  }
}
