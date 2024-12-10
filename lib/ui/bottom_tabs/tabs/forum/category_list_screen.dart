import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/forum/forum_tab_controller.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../style/appbar_components.dart';
import '../../../style/container_components.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({Key? key}) : super(key: key);

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  ForumController forumController = Get.find<ForumController>();

  @override
  void initState() {

    // TODO: implement initState
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
      centerTitle: true,
      leadingWidget: IconButton(
        hoverColor: AppColors.transparentColor,
        splashColor: AppColors.transparentColor,

        onPressed: () {
          Get.back<int>(result: forumController.totalRecord.value);
        },
        icon: ImageComponent.loadLocalImage(
          imageName: AppImages.arrow,
        ),
      ),
      titleWidget: Text(
        AppStrings.categories,
        style: ISOTextStyles.openSenseSemiBold(size: 17),
      ),
    );
  }

  ///Scaffold Body
  Widget buildBody() {
    return SafeArea(
      child: Obx(
        () => GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 30.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: forumController.isAllDataLoadedCategory.value ? forumController.categoryList.length +1 : forumController.categoryList.length,
          itemBuilder: (context, index) {
            if (index == forumController.categoryList.length) {
              Future.delayed(
                const Duration(milliseconds: 100),
                () async {
                  await _handleLoadMoreList();
                },
              );
              return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
            }
            return GestureDetector(
              onTap: () async{
                var getPostCount = await Get.toNamed(ScreenRoutesConstants.categoryForumListScreen, arguments: [forumController.categoryList[index].id ?? 0, forumController.categoryList[index].categoryName ?? 0]);
                if(getPostCount != forumController.categoryList[index].forumPostCount.value){
                  forumController.categoryList[index].forumPostCount.value = getPostCount;
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: 4.0.h,
                ),
                height: 159.0.h,
                child: ContainerComponents.elevatedContainer(
                  borderRadius: 8.0.r,
                  height: 143.0.h,
                  backGroundColor: AppColors.whiteColor,
                  width: 143.0.h,
                  shadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 0),
                    ),
                  ],
                  context: context,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                        child: Text(
                          forumController.categoryList[index].categoryName ?? '',
                          style: ISOTextStyles.openSenseSemiBold(
                            size: 16,
                          ),
                        ),
                      ),
                      7.sizedBoxH,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                        child: Obx(
                          ()=> Text(
                            '${forumController.categoryList[index].forumPostCount.value } ${post(categoryCount: forumController.categoryList[index].forumPostCount.value)}',
                            style: ISOTextStyles.openSenseRegular(
                              size: 12,
                              color: AppColors.hintTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  ///******[_handleLoadMoreList] this function call in pagination while user reach the default limit of category forum list this function will call
  ///And load more category of forums if is available in list *******///
  Future _handleLoadMoreList() async {
    if (!forumController.isAllDataLoadedCategory.value) return;
    if (forumController.isLoadMoreRunningForViewAllCategory) return;
    forumController.isLoadMoreRunningForViewAllCategory = true;
    await forumController.forumCategoryPagination();
  }
  String post({required int categoryCount }){
    if(categoryCount != 1 ){
      return AppStrings.posts;
    }else{
      return AppStrings.post;
    }
  }
}
