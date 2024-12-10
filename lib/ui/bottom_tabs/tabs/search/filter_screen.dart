import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/search/search_tab_controller.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';

import '../../../../utils/app_common_stuffs/app_images.dart';
import '../../../style/appbar_components.dart';
import '../../../style/image_components.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  SearchController searchController = Get.find<SearchController>();

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
        'Filter By',
        style: ISOTextStyles.openSenseSemiBold(size: 17),
      ),
      centerTitle: true,
    );
  }

  ///Scaffold Body
  Widget buildBody() {
    return Obx(
      () => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: searchController.filterSearchList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () async {
              searchController.searchListController.clear();
              searchController.pageToShow.value = 1;
              searchController.totalRecords.value = 0;
              searchController.isAllDataLoaded.value = false;
              searchController.onFilterSearchSelect(index: index);
              searchController.isFilterEnable.value = true;
              Get.back();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    searchController.filterSearchList[index].search ?? '',
                    style: ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.chatHeadingName),
                  ),
                  searchController.filterSearchList[index].isFilterSelected.value
                      ? ImageComponent.loadLocalImage(imageName: AppImages.doneFill, height: 26.w, width: 26.w, boxFit: BoxFit.contain)
                      : Container(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  handleOnTapFilterEvent() {}
}
