import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/forum/forum_tab_controller.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/forum/forum_adaptor.dart';
import 'package:iso_net/ui/common_ui/forum_common_ui/forum_image_video_screen.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../bindings/bottom_tabs/create_feed_binding.dart';
import '../../../../bindings/bottom_tabs/forum_detail_binding.dart';
import '../../../../bindings/bottom_tabs/user_binding/user_profile_binding.dart';
import '../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../utils/app_common_stuffs/commom_utils.dart';
import '../../../../utils/app_common_stuffs/common_api_function.dart';
import '../../../../utils/app_common_stuffs/screen_routes.dart';
import '../../../../utils/app_common_stuffs/send_functionality.dart';
import '../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../style/image_components.dart';
import '../../../style/text_style.dart';
import '../news_feed/create_feed_screen.dart';
import '../news_feed/user_screens/user_profile_screen.dart';

import 'category_list_screen.dart';
import 'forum_detail_screen.dart';

class ForumTab extends StatefulWidget {
  const ForumTab({Key? key}) : super(key: key);

  @override
  State<ForumTab> createState() => _ForumTabState();
}

class _ForumTabState extends State<ForumTab> with AutomaticKeepAliveClientMixin<ForumTab> {
  ForumController forumController = Get.find<ForumController>();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowLoaderDialog.showLoaderDialog(Get.context!);
      forumController.fetchFeedCategory();
      forumController.forumApiCall(isShowLoader: true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appBarBody(),
      body: buildBody(),
    );
  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBar(
      title: Text(
        AppStrings.forum,
        style: ISOTextStyles.openSenseBold(size: 24),
      ),
      centerTitle: false,
      actions: [
        GestureDetector(
          onTap: () {
            Get.toNamed(ScreenRoutesConstants.searchScreen);
          },
          child: ImageComponent.loadLocalImage(imageName: AppImages.searchCircle, height: 29.w, width: 29.w, boxFit: BoxFit.contain),
        ),
        10.sizedBoxW,
        GestureDetector(
            onTap: () async {
              ///***** Routing to create new forum screen *****///
              var callBack = await Get.to(
                CreateFeedScreen(
                  isCreateForum: true,
                  isCreateForumCategory: false,
                  isFromFeed: false,
                ),
                binding: CreateFeedBinding(),
              );
              if (callBack == true) {
                ///***** if user create the new forum check on call back result true than refresh the for list to updated new forum ****///
                _handleOnRefreshIndicator(isShowLoader: true);
              }
            },
            child: ImageComponent.loadLocalImage(imageName: AppImages.create, boxFit: BoxFit.contain, height: 29.w, width: 29.w)),
        16.sizedBoxW,
      ],
    );
  }

  ///Scaffold Body
  Widget buildBody() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () {
          return _handleOnRefreshIndicator();
        },
        child: CustomScrollView(
          controller: forumController.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(top: 0),
              sliver: SliverSafeArea(
                bottom: true,
                top: false,
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: 1,
                    (BuildContext context, int index) {
                      return categoryBody();
                    },
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: 10.w),
              sliver: SliverSafeArea(
                bottom: true,
                top: false,
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: 1,
                    (BuildContext context, int index) {
                      return tabBody();
                    },
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 0),
              sliver: SliverSafeArea(
                bottom: true,
                top: false,
                sliver: Obx(
                  () => (forumController.forumList.isEmpty && forumController.isApiResponseReceive.value)
                      ? SliverFillRemaining(
                          child: Center(
                            child: Text(
                              AppStrings.noForumsYet,
                              style: ISOTextStyles.openSenseSemiBold(size: 16),
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            addAutomaticKeepAlives: true,
                            childCount: forumController.isAllDataLoaded.value ? forumController.forumList.length + 1 : forumController.forumList.length,
                            (BuildContext context, int index) {
                              if (index == forumController.forumList.length) {
                                Future.delayed(
                                  const Duration(milliseconds: 100),
                                  () async {
                                    await _handleLoadMoreList();
                                  },
                                );
                                return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
                              }
                              var forumData = forumController.forumList[index].obs;
                              return KeyedSubtree(
                                key: ValueKey(index),
                                child: Obx(
                                  () => ForumAdaptor(
                                    userProfileCallBack: () async {
                                      var isUserOrAdmin = CommonUtils.isUserMe(id: forumData.value.user?.userId ?? 0, isAdmin: forumData.value.user?.isAdmin ?? false);

                                      ///***** First Dev has to check if in forum post user is you or other user or admin
                                      ///**** If forum posted user is admin so no need to open profile of admin
                                      ///**** If user is you than open :-  my profile screen
                                      ///**** If user is not you then open other :- user profile screen
                                      if (isUserOrAdmin.value) {
                                        var callBackData = await Get.to(
                                          UserProfileScreen(
                                            userId: forumData.value.user?.userId,
                                          ),
                                          binding: UserProfileBinding(),
                                        );
                                        if (callBackData != null && callBackData != true) {
                                          forumData.value.user?.isConnected.value = callBackData;
                                          forumController.update();
                                        } else if (callBackData == true) {
                                          _handleOnRefreshIndicator();
                                        }
                                      } else {
                                        Get.toNamed(ScreenRoutesConstants.myProfileScreen, arguments: userSingleton.id);
                                      }
                                    },
                                    threeDotTap: () {
                                      ///On three dot tap event :-
                                      ///First Dev has to check is login user & forum posted user not same
                                      ///If user is same then open show bottom sheet in sheet they have two open delete forum or cancel
                                      if (userSingleton.id == forumData.value.user?.userId) {
                                        CommonUtils.showMyBottomSheet(
                                          context,
                                          arrButton: [AppStrings.sendForum, AppStrings.deleteForum],
                                          callback: (btnIndex) async {
                                            if (btnIndex == 0) {
                                              SendFunsctionality.sendBottomSheet(forumId: forumData.value.forumId, context: context, headingText: AppStrings.sendForum);
                                            } else if (btnIndex == 1) {
                                              var deleteApi = await CommonApiFunction.forumDeleteApi(
                                                  onErr: (msg) {
                                                    SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                                  },
                                                  onSuccess: (msg) {
                                                    SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                                                  },
                                                  forumId: forumData.value.forumId);
                                              if (deleteApi) {
                                                forumController.forumList.removeAt(index);
                                                if (forumController.forumList.isEmpty) {
                                                  forumController.pageToShow.value = 1;
                                                  forumController.totalRecord.value = 0;
                                                  forumController.isAllDataLoaded.value = false;
                                                  forumController.forumApiCall();
                                                }
                                              }
                                            }
                                          },
                                        );
                                      } else {
                                        ///On three dot tap event :-
                                        ///If login user & forum user is not same then open show bottom sheet in sheet they have three option
                                        ///[Send Forum] to send forum in particular chat
                                        ///[Report Forum] if forum is an unusual content & user have to add specific report reason
                                        ///[Flag Forum]
                                        CommonUtils.reportWidget(
                                          context: context,
                                          forumId: forumData.value.forumId ?? 0,
                                          isReportForum: true,
                                          buttonText: [
                                            AppStrings.sendForum,
                                            AppStrings.reportForum,
                                            AppStrings.flagForum,
                                          ],
                                          reportTyp: AppStrings.forum,
                                        );
                                      }
                                    },
                                    screenRoutes: () async {
                                      var callBackData = await Get.to(
                                          ForumDetailScreen(
                                            forumId: forumData.value.forumId ?? 0,
                                          ),
                                          binding: ForumDetailBinding());
                                      if (callBackData != null && callBackData != true) {
                                        forumData.value = callBackData;
                                        forumController.update();
                                      } else if (callBackData == true) {
                                        forumController.forumList.removeAt(index);
                                        forumController.update();
                                      }
                                    },
                                    pageController: forumController.pageController,
                                    onPostImageTap: (value) async {
                                      var callBack = await Get.to(ForumPhotoVideoView(), arguments: [forumData.value, value]);
                                      if (callBack != null && callBack != true) {
                                        forumData.value = callBack;
                                        forumController.update();
                                      } else {
                                        forumController.forumList.removeAt(index);
                                        forumController.update();
                                      }
                                    },
                                    commentButton: () async {
                                      var callBackData = await Get.to(
                                          ForumDetailScreen(
                                            forumId: forumData.value.forumId ?? 0,
                                          ),
                                          binding: ForumDetailBinding());
                                      if (callBackData != null && callBackData != true) {
                                        forumData.value = callBackData;
                                        forumController.update();
                                      } else if (callBackData == true) {
                                        forumController.forumList.removeAt(index);
                                        forumController.update();
                                      }
                                    },
                                    forumData: forumData.value,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///******[_handleLoadMoreList] this function call in pagination while user reach the default limit of forum list this function will call
  ///And load more forums if is available in list *******///
  Future _handleLoadMoreList() async {
    if (!forumController.isAllDataLoaded.value) return;
    if (forumController.isLoadMoreRunningForViewAll) return;
    forumController.isLoadMoreRunningForViewAll = true;
    await forumController.forumPagination();
  }

  ///Category Body
  Widget categoryBody() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 16.0.w, top: 16.0.w),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.category,
                  style: ISOTextStyles.openSenseSemiBold(size: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GestureDetector(
                  onTap: () => Get.to(const CategoryListScreen()),
                  child: Text(
                    AppStrings.seeAll,
                    style: ISOTextStyles.sfProMedium(
                      size: 14,
                      color: AppColors.disableTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        5.sizedBoxH,
        Obx(
          () => SizedBox(
            height: 159.w,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: EdgeInsets.only(right: 16.0.w),
              itemCount: forumController.categoryList.length > 4 ? 4 : forumController.categoryList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                    var getPostCount = await Get.toNamed(ScreenRoutesConstants.categoryForumListScreen,
                        arguments: [forumController.categoryList[index].id ?? 0, forumController.categoryList[index].categoryName ?? 0]);
                    if (getPostCount != forumController.categoryList[index].forumPostCount.value) {
                      forumController.categoryList[index].forumPostCount.value = getPostCount;
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0.w, top: 8.0.h, bottom: 8.0.h),
                    child: Container(
                      height: 159.0.h,
                      width: 163.0.w,
                      /* constraints: BoxConstraints(
                        minWidth: 143.w,
                      ),*/

                      padding: EdgeInsets.only(left: 16.0.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0.r),
                        color: AppColors.whiteColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            forumController.categoryList[index].categoryName ?? '',
                            style: ISOTextStyles.openSenseSemiBold(size: 18, color: AppColors.headingTitleColor),
                          ),
                          9.sizedBoxH,
                          Obx(
                            () => Text(
                              '${forumController.categoryList[index].forumPostCount.value}  ${post(categoryCount: forumController.categoryList[index].forumPostCount.value)}',
                              style: ISOTextStyles.openSenseRegular(
                                size: 12,
                                color: AppColors.disableTextColor,
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
        ),
      ],
    );
  }

  /// Filter Tab
  Widget tabBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Wrap(
                spacing: 10,
                children: [
                  ...List.generate(forumController.tabFilterList.length, (index) {
                    return GestureDetector(
                      onTap: () async {
                        await _handleOnTapTabEvent(index);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(vertical: 4.0.h, horizontal: 22.0.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0.r),
                          color: forumController.currentPageIndex.value == index ? AppColors.primaryColor : AppColors.greyColor,
                        ),
                        child: Text(
                          forumController.tabFilterList[index].tabName ?? '',
                          style: forumController.currentPageIndex.value == index
                              ? ISOTextStyles.openSenseSemiBold(size: 16, color: AppColors.headingTitleColor)
                              : ISOTextStyles.openSenseRegular(size: 16, color: AppColors.headingTitleColor),
                        ),
                      ),
                    );
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  ///****** [_handleOnTapTabEvent] function will use while user tap any of three tab and work it accordingly *****///
  Future<void> _handleOnTapTabEvent(int index) async {
    ShowLoaderDialog.showLoaderDialog(context);
    forumController.forumList.clear();
    forumController.isApiResponseReceive.value = false;
    forumController.pageToShow.value = 1;
    forumController.isAllDataLoaded.value = false;

    forumController.totalRecord.value = 0;
    forumController.currentPageIndex.value = index;
    forumController.forumFilter.value = forumController.tabFilterList[index].apiFilterName ?? '';
    await forumController.forumApiCall(isShowLoader: true);
  }

  ///****** [_handleOnRefreshIndicator] this function is use to refreshing the forum & category list *****///
  _handleOnRefreshIndicator({bool isShowLoader = false}) async {
    forumController.isForumRefresh.value = true;
    if (isShowLoader) {
      ShowLoaderDialog.showLoaderDialog(context);
    }
    await forumController.fetchFeedCategory();
    await forumController.forumApiCall(isShowLoader: isShowLoader);
  }

  String post({required int categoryCount}) {
    if (categoryCount != 1) {
      return AppStrings.posts;
    } else {
      return AppStrings.post;
    }
  }
}
