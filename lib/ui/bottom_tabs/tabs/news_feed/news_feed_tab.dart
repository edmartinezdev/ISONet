import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/bindings/bottom_tabs/create_feed_binding.dart';
import 'package:iso_net/bindings/bottom_tabs/feed_detail_binding.dart';
import 'package:iso_net/controllers/bottom_tabs/bottom_tabs_controller.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/news_feed_tab_controller.dart';
import 'package:iso_net/helper_manager/socket_manager/socket_manager_new.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/article_adaptor/article_adaptor.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/create_feed_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/feed_detail_screen.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/feed_post_adapter/feed_post_adaptor.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/settings_screen/user_setting_screen.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/text_style.dart';

import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/common_api_function.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/app_common_stuffs/send_functionality.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../bindings/bottom_tabs/setting_binding/user_setting_binding.dart';
import '../../../../bindings/bottom_tabs/user_binding/user_profile_binding.dart';
import '../../../../controllers/my_profile/my_profile_controller.dart';
import '../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../common_ui/view_photo_video_screen.dart';
import '../../../style/showloader_component.dart';
import 'user_screens/user_profile_screen.dart';

class NewsFeedTab extends StatefulWidget {
  const NewsFeedTab({Key? key}) : super(key: key);

  @override
  State<NewsFeedTab> createState() => _NewsFeedTabState();
}

class _NewsFeedTabState extends State<NewsFeedTab> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  NewsFeedController newsFeedController = Get.find<NewsFeedController>();
  MyProfileController myProfileController = Get.find();
  BottomTabsController bottomTabsController = Get.find();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    newsFeedController.profileImage.value = userSingleton.profileImg;
    SocketManagerNew().connectToServer();

    /// ***** init apiCall of news feed list ******///
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await bottomTabsController.loadTutorialIndex();
        if(bottomTabsController.tutrorialComplete.value){
          ShowLoaderDialog.showLoaderDialog(Get.context!);
        }

        newsFeedController.apiCallFetchFeedList(page: newsFeedController.pageToShow.value, isShowLoader: bottomTabsController.tutrorialComplete.value);
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appBarBody(),
      body: buildBody()
    );

  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          handleAppBarTitleTap();
        },
        child: Container(
          color: AppColors.transparentColor,
          child: Row(
            children: [
              Obx(
                () => Text(
                  newsFeedController.newsFeedType.value,
                  style: ISOTextStyles.openSenseBold(size: 24, color: AppColors.headingTitleColor),
                ),
              ),
              8.sizedBoxW,
              Container(
                padding: EdgeInsets.only(top: 5.0.h),
                color: AppColors.transparentColor,
                child: ImageComponent.loadLocalImage(imageName: AppImages.downArrow, height: 14.w, width: 14.w, boxFit: BoxFit.contain),
              )
            ],
          ),
        ),
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
            routeToUserSettingScreen();
          },
          child: ImageComponent.loadLocalImage(imageName: AppImages.setting, height: 29.w, width: 29.w, boxFit: BoxFit.contain),
        ),
        16.sizedBoxW,
      ],
      bottom: PreferredSize(preferredSize: const Size.fromHeight(75.0), child: userNewWidget()),
    );
  }

  ///Load more news feed list when record cross the limit value
  Future _handleLoadMoreList() async {
    if (!newsFeedController.isAllDataLoaded.value) return;
    if (newsFeedController.isLoadMoreRunningForViewAll) return;
    newsFeedController.isLoadMoreRunningForViewAll = true;
    await newsFeedController.newsFeedPagination();
  }

  ///***** Handle on Tap notification icon *****///
  handleOnNotificationIconTap() async {
    var callBack = await Get.toNamed(ScreenRoutesConstants.notificationListingScreen);
    if (callBack) {
      myProfileController.myProfileData.value?.isReadNotification.value = true;
    }
  }

  ///build body
  Widget buildBody() {
    return RefreshIndicator(
      onRefresh: () async {
        handleOnRefreshEvent();
      },
      child: CustomScrollView(
        controller: newsFeedController.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          ///********* NewsFeed & Article ListView *********///

          SliverPadding(
            padding: const EdgeInsets.only(top: 0),
            sliver: SliverSafeArea(
              bottom: true,
              top: false,
              sliver: Obx(
                () => (newsFeedController.feedList.isEmpty && newsFeedController.isApiResponseReceive.value)
                    ? SliverFillRemaining(
                        child: Center(
                          child: Text(
                            AppStrings.noPostsYet,
                            style: ISOTextStyles.openSenseSemiBold(size: 16),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          addAutomaticKeepAlives: true,
                          childCount: newsFeedController.isAllDataLoaded.value ? newsFeedController.feedList.length + 1 : newsFeedController.feedList.length,
                          (BuildContext context, int index) {
                            if (index == newsFeedController.feedList.length) {
                              Future.delayed(
                                const Duration(milliseconds: 100),
                                () async {
                                  await _handleLoadMoreList();
                                },
                              );
                              return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
                            }
                            var model = newsFeedController.feedList[index].obs;
                            return newsFeedController.feedList[index].feedType?.toLowerCase() == AppStrings.article
                                ? ListView.builder(
                                    addAutomaticKeepAlives: true,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: newsFeedController.feedList[index].article?.length,
                                    itemBuilder: (BuildContext context, int subIndex) {
                                      return ArticleAdaptor(
                                        model: model.value,
                                        articleMedia: newsFeedController.feedList[index].article![subIndex],
                                      );
                                    },
                                  )
                                : Obx(
                                    () => FeedPostAdapter(
                                      feedData: model.value,
                                      userProfileCallBack: () {
                                        routeToOtherUserProfileScreen(index: index);
                                      },
                                      screenRoutes: () async {
                                        var callBackData = await Get.to(
                                            FeedDetailScreen(
                                              feedId: model.value.feedId ?? 0,
                                            ),
                                            binding: FeedDetailBinding());
                                        if (callBackData != null && callBackData != true) {
                                          model.value = callBackData;
                                          newsFeedController.update();
                                        } else if (callBackData == true) {
                                          newsFeedController.feedList.removeAt(index);
                                          newsFeedController.update();
                                        }
                                        Logger().i(model.value);
                                        Logger().i(callBackData);
                                      },
                                      commentButton: () async {
                                        var callBackData = await Get.to(
                                            FeedDetailScreen(
                                              feedId: model.value.feedId ?? 0,
                                            ),
                                            binding: FeedDetailBinding());
                                        if (callBackData != null && callBackData != true) {
                                          model.value = callBackData;
                                          newsFeedController.update();
                                        } else if (callBackData == true) {
                                          newsFeedController.feedList.removeAt(index);
                                          newsFeedController.update();
                                        }
                                        Logger().i(model.value);
                                        Logger().i(callBackData);
                                      },
                                      pageController: newsFeedController.pageController,
                                      threeDotTap: () {
                                        handleThreeDotTap(index: index);
                                      },
                                      onPostImageTap: (value) async {
                                        var callBack = await Get.to(PhotoVideoScreen(), arguments: [model.value, value]);
                                        if (callBack != null && callBack != true) {
                                          model.value = callBack;
                                        } else if (callBack == true) {
                                          newsFeedController.feedList.removeAt(index);
                                          newsFeedController.update();
                                        }
                                        Logger().i(value);
                                      },
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
    );
  }

  ///******* What's new with you widget ******///
  Widget userNewWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0.h, horizontal: 3.w),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.greyColor)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              routeToMyProfileScreen();
            },
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  child: ImageComponent.circleNetworkImage(
                    imageUrl: newsFeedController.profileImage.value ?? '',
                    height: 35.w,
                    width: 35.w,
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: myProfileController.myProfileData.value?.isVerified == true,
                    child: Positioned(
                      bottom: 4.h,
                      right: 4.w,
                      child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, height: 12.w, width: 12.w, boxFit: BoxFit.contain),
                    ),
                  ),
                ),
                Positioned(
                  top: 4.h,
                  left: 4.w,
                  child: ImageComponent.loadLocalImage(imageName: userSingleton.userType == AppStrings.fu ? AppImages.funderBadge : AppImages.brokerBadge, height: 12.h, width: 12.w),
                ),
              ],
            ),
          ),
          5.sizedBoxW,
          Expanded(
            child: GestureDetector(
              onTap: () => routeToCreateFeedScreen(),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all(color: AppColors.dividerColor), borderRadius: BorderRadius.circular(8.0), color: Colors.transparent),
                child: Text(
                  "What's new with you?",
                  style: ISOTextStyles.hintTextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          16.sizedBoxW,
        ],
      ),
    );
  }

  ///***** Appbar popup design widget *****///
  ///*** Choose FeedType All,Funder,Broker ***///
  Widget popupDialogContainer() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0.w,
      ),
      child: Obx(
        () => Container(
          padding: EdgeInsets.symmetric(vertical: 16.0.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.newsFeed,
                style: ISOTextStyles.openSenseBold(size: 18, color: AppColors.headingTitleColor),
              ),
              14.sizedBoxH,
              ...List.generate(newsFeedController.newFeedTypeList.length, (index) {
                return GestureDetector(
                  onTap: () => newsFeedController.handleOnNewsFeedTypeSelect(index: index),
                  child: Container(
                    color: AppColors.transparentColor,
                    padding: EdgeInsets.symmetric(vertical: 8.0.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          newsFeedController.newFeedTypeList[index].newsFeedType ?? '',
                          style: ISOTextStyles.openSenseSemiBold(size: 16, color: AppColors.chatHeadingName),
                        ),
                        newsFeedController.newFeedTypeList[index].isTypeSelected.value
                            ? ImageComponent.loadLocalImage(imageName: AppImages.doneFill, height: 22.w, width: 22.w, boxFit: BoxFit.contain)
                            : Container(),
                      ],
                    ),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  /// Handle to open dialog while tap on appbar title function
  handleAppBarTitleTap() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 0.2.sh,
          ),
          child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(14.0.r),
                ),
              ),
              alignment: Alignment.topCenter,
              child: popupDialogContainer()),
        );
      },
    );
  }

  ///Route to my profile screen function
  routeToMyProfileScreen() {
    myProfileController.currentTabIndex.value = 0;
    Get.toNamed(
      ScreenRoutesConstants.myProfileScreen,
      arguments: userSingleton.id,
    );
  }

  ///Route to create post screen
  routeToCreateFeedScreen() async {
    var callBack = await Get.to(
      CreateFeedScreen(
        isCreateForum: false,
        isCreateForumCategory: false,
        isFromFeed: true,
      ),
      binding: CreateFeedBinding(),
    );
    if (callBack == true) {
      /*newsFeedController.isApiResponseReceive.value = false;
      newsFeedController.pageToShow.value = 1;
      newsFeedController.isAllDataLoaded.value = false;
      newsFeedController.feedList.clear();*/
      newsFeedController.isNewFeedRefresh.value = true;
      // ignore: use_build_context_synchronously
      ShowLoaderDialog.showLoaderDialog(context);
      await newsFeedController.apiCallFetchFeedList(page: newsFeedController.pageToShow.value, isShowLoader: true);
    }
  }

  ///Handle event of  Report other user post & delete our own feed while tapping on three dot icon
  handleThreeDotTap({required int index}) {
    var model = newsFeedController.feedList[index].obs;
    if (userSingleton.id == model.value.user?.userId) {
      CommonUtils.showMyBottomSheet(
        context,
        arrButton: [
          AppStrings.sendPost,
          AppStrings.deletePost,
        ],
        callback: (btnIndex) async {
          if (btnIndex == 0) {
            SendFunsctionality.sendBottomSheet(feedId: model.value.feedId ?? 0, context: context, headingText: AppStrings.sendPost);
          } else if (btnIndex == 1) {
            var deleteApi = await CommonApiFunction.feedDeleteApi(
                onErr: (msg) {
                  SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                },
                onSuccess: (msg) {
                  SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                },
                feedId: model.value.feedId);
            if (deleteApi) {
              newsFeedController.feedList.removeAt(index);
            }
          }
        },
      );
    } else {
      CommonUtils.reportWidget(feedId: model.value.feedId ?? 0, context: context, buttonText: [AppStrings.sendPost, AppStrings.reportPost, AppStrings.flagPost], reportTyp: AppStrings.feed);
    }
  }

  ///Handle event of refresh indicator while user refresh the news feed page
  handleOnRefreshEvent() async {
    /*newsFeedController.isApiResponseReceive.value = false;
    newsFeedController.feedList.clear();
    newsFeedController.pageToShow.value = 1;
    newsFeedController.isAllDataLoaded.value = false;*/
    newsFeedController.isNewFeedRefresh.value = true;
    await newsFeedController.apiCallFetchFeedList(page: newsFeedController.pageToShow.value);
    /*myProfileApiCall();*/
  }

  ///Route to see other user profile screen while tapping on user profile image tap feed post
  routeToOtherUserProfileScreen({required int index}) async {
    var model = newsFeedController.feedList[index].obs;
    if (userSingleton.id == model.value.user?.userId) {
      routeToMyProfileScreen();
    } else {
      Logger().i(model.value.user?.userId);
      var callBackData = await Get.to(
        UserProfileScreen(
          userId: model.value.user?.userId,
        ),
        binding: UserProfileBinding(),
      );
      if (callBackData != null && callBackData != true) {
        model.value.user?.isConnected.value = callBackData;
        Logger().i('UserProfile CallBack Value :- $callBackData');
      } else if (callBackData == true) {
        handleOnRefreshEvent();
      }
      Logger().i(model.value.user);
    }
  }

  ///***** Handle routing user setting screen *****///
  routeToUserSettingScreen() {
    Get.to(
        UserSettingScreen(
          isCompanyDeleted: myProfileController.myProfileData.value?.isCompanyDeleted,
          isCompanyOwner: myProfileController.myProfileData.value?.isOwner,
        ),
        binding: UserSettingBinding());
  }
}
