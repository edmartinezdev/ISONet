import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/scoreboard_controller.dart';
import 'package:iso_net/ui/style/showloader_component.dart';

import '../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../style/appbar_components.dart';
import '../../../style/image_components.dart';
import '../../../style/text_style.dart';

class FunderBrokerSorting extends StatefulWidget {
  const FunderBrokerSorting({Key? key}) : super(key: key);

  @override
  State<FunderBrokerSorting> createState() => _FunderBrokerSortingState();
}

class _FunderBrokerSortingState extends State<FunderBrokerSorting> {
  ScoreBoardController scoreBoardController = Get.find<ScoreBoardController>();

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
      leadingWidget: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: ImageComponent.loadLocalImage(imageName: AppImages.arrow),
      ),
      titleWidget: Text(
        AppStrings.sortBy,
        style: ISOTextStyles.openSenseSemiBold(size: 17),
      ),
      centerTitle: true,
    );
  }

  ///Scaffold Body
  Widget buildBody() {
    return Obx(
      () => ListView.builder(
        controller: scoreBoardController.scrollController,
        itemCount: scoreBoardController.filterScoreBoardList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () async {
              scoreBoardController.onFilterScoreBoardSelect(index: index);
              //
              scoreBoardController.isFilterEnable.value = true;

              ShowLoaderDialog.showLoaderDialog(context);
              await scoreBoardController.fetchLoanList(page: 1, userType: scoreBoardController.forumFilter.value);
              Get.back();
              Get.back();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    scoreBoardController.filterScoreBoardList[index].scoreboardSortingData ?? '',
                    style: ISOTextStyles.openSenseSemiBold(size: 17),
                  ),
                  scoreBoardController.filterScoreBoardList[index].isFilterSelected.value ? ImageComponent.loadLocalImage(imageName: AppImages.doneFill) : Container(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
