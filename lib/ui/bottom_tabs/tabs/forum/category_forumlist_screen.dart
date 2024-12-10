import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/forum/forum_category_controller.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/forum/forum_adaptor.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/send_functionality.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../bindings/bottom_tabs/create_feed_binding.dart';
import '../../../../bindings/bottom_tabs/forum_detail_binding.dart';
import '../../../../bindings/bottom_tabs/user_binding/user_profile_binding.dart';
import '../../../../singelton_class/auth_singelton.dart';
import '../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../utils/app_common_stuffs/commom_utils.dart';
import '../../../../utils/app_common_stuffs/common_api_function.dart';
import '../../../../utils/app_common_stuffs/screen_routes.dart';
import '../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../common_ui/forum_common_ui/forum_image_video_screen.dart';
import '../../../style/appbar_components.dart';
import '../../../style/image_components.dart';
import '../news_feed/create_feed_screen.dart';
import '../news_feed/user_screens/user_profile_screen.dart';
import 'forum_detail_screen.dart';

class CategoryForumListScreen extends StatefulWidget {
  const CategoryForumListScreen({Key? key}) : super(key: key);

  @override
  State<CategoryForumListScreen> createState() => _CategoryForumListScreenState();
}

class _CategoryForumListScreenState extends State<CategoryForumListScreen> {
  ForumCategoryController forumCategoryController = Get.find<ForumCategoryController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowLoaderDialog.showLoaderDialog(context);
      forumCategoryController.forumApiCall(isShowLoader: true);
    });

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
      leadingWidget: IconButton(
        hoverColor: AppColors.transparentColor,
        splashColor: AppColors.transparentColor,

        onPressed: () {
          Get.back<int>(result: forumCategoryController.totalRecord.value);
        },
        icon: ImageComponent.loadLocalImage(
          imageName: AppImages.arrow,
        ),
      ),
      titleWidget: Text(
        //AppStrings.category,
        forumCategoryController.categoryName,
        style: ISOTextStyles.openSenseSemiBold(size: 17),
      ),
      centerTitle: true,
      actionWidgets: [
        GestureDetector(
          onTap: () async {
            var callBack = await Get.to(
              CreateFeedScreen(
                isCreateForum: false,
                isCreateForumCategory: true,
                isFromFeed: false,
                categoryName: forumCategoryController.categoryName,
                categoryId: forumCategoryController.categoryId,
              ),
              binding: CreateFeedBinding(),
            );
            if (callBack == true) {
              _handleOnRefreshIndicator(isShowLoader: true);
            }
          },
          child: CircleAvatar(
            radius: 14,
            child: ImageComponent.loadLocalImage(imageName: AppImages.plusFill),
          ),
        ),
        10.sizedBoxW,
      ],
    );
  }

  ///Scaffold Body
  Widget buildBody() {
    return Obx(
      () => SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return _handleOnRefreshIndicator();
          },
          child: forumCategoryController.forumList.isEmpty && forumCategoryController.isApiResponseReceive.value
              ? Center(
                  child: Text(
                    AppStrings.noForumsYet,
                    style: ISOTextStyles.openSenseSemiBold(size: 16),
                  ),
                )
              : Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    controller: forumCategoryController.scrollController,
                    itemCount: forumCategoryController.isAllDataLoaded.value ? forumCategoryController.forumList.length + 1 : forumCategoryController.forumList.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == forumCategoryController.forumList.length) {
                        Future.delayed(
                          const Duration(milliseconds: 100),
                          () async {
                            await _handleLoadMoreList();
                          },
                        );
                        return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
                      }
                      var forumData = forumCategoryController.forumList[index].obs;

                      return Obx(
                        () => ForumAdaptor(
                          forumData: forumData.value,
                          userProfileCallBack: () async {
                            var isUserOrAdmin = CommonUtils.isUserMe(id: forumData.value.user?.userId ?? 0, isAdmin: forumData.value.user?.isAdmin ?? false);
                            if (isUserOrAdmin.value) {
                              var callBackData = await Get.to(
                                UserProfileScreen(
                                  userId: forumData.value.user?.userId,
                                ),
                                binding: UserProfileBinding(),
                              );
                              if (callBackData != null && callBackData != true) {
                                forumData.value.user?.isConnected.value = callBackData;
                                forumCategoryController.update();
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
                                      forumCategoryController.forumList.removeAt(index);
                                      forumCategoryController.totalRecord.value--;
                                      Logger().i(forumCategoryController.totalRecord.value);
                                      if (forumCategoryController.forumList.isEmpty) {
                                        forumCategoryController.pageToShow.value = 1;
                                        forumCategoryController.totalRecord.value = 0;
                                        forumCategoryController.isAllDataLoaded.value = false;
                                        forumCategoryController.isLoadMore = forumCategoryController.isAllDataLoaded.value;
                                        forumCategoryController.forumApiCall(isShowLoader: false);
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
                                  buttonText: [AppStrings.sendForum, AppStrings.reportForum, AppStrings.flagForum],
                                  reportTyp: AppStrings.forum);
                            }
                          },
                          screenRoutes: () async {
                            var callBackData = await Get.to(
                                ForumDetailScreen(
                                  forumId: forumData.value.forumId ?? 0,
                                  isFromCategoryPage: true,
                                ),
                                binding: ForumDetailBinding());
                            if (callBackData != null && callBackData != true) {
                              forumData.value = callBackData;
                              forumCategoryController.update();
                            } else if (callBackData == true) {
                              forumCategoryController.forumList.removeAt(index);
                              forumCategoryController.update();
                            }
                          },
                          pageController: forumCategoryController.pageController,
                          onPostImageTap: (value) async {
                            var callBack = await Get.to(ForumPhotoVideoView(), arguments: [forumData.value, value]);
                            if (callBack != null && callBack != true) {
                              forumData.value = callBack;
                              forumCategoryController.update();
                            } else if (callBack == true) {
                              forumCategoryController.forumList.removeAt(index);
                              forumCategoryController.update();
                            }
                          },
                          commentButton: () async {
                            var callBackData = await Get.to(
                                ForumDetailScreen(
                                  isFromCategoryPage: true,
                                  forumId: forumData.value.forumId ?? 0,
                                ),
                                binding: ForumDetailBinding());
                            if (callBackData != null && callBackData != true) {
                              forumData.value = callBackData;
                              forumCategoryController.update();
                            } else if (callBackData == true) {
                              forumCategoryController.forumList.removeAt(index);
                              forumCategoryController.update();
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Future _handleLoadMoreList() async {
    if (!forumCategoryController.isAllDataLoaded.value) return;
    if (forumCategoryController.isLoadMoreRunningForViewAll) return;
    forumCategoryController.isLoadMoreRunningForViewAll = true;
    await forumCategoryController.forumPagination();
  }

  _handleOnRefreshIndicator({bool isShowLoader = false}) async {
    forumCategoryController.isCategoryRefresh.value = true;
    if (isShowLoader) {
      ShowLoaderDialog.showLoaderDialog(context);
    }
    await forumCategoryController.forumApiCall(isShowLoader: isShowLoader);
  }
}
