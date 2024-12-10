// ignore_for_file: avoid_types_as_parameter_names

import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/bottom_tabs_controller.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/news_feed_tab_controller.dart';
import 'package:iso_net/controllers/my_profile/notification_listing_controller.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/Network/network_tab.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/forum/forum_tab.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/chat_tab/messenger_tab.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/news_feed_tab.dart';
import 'package:iso_net/ui/my_profile/notification_listing_screen.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../controllers/bottom_tabs/tabs/forum/forum_tab_controller.dart';
import '../../controllers/my_profile/my_profile_controller.dart';
import '../../singelton_class/auth_singelton.dart';
import '../../utils/app_common_stuffs/strings_constants.dart';
import '../style/image_components.dart';
import 'custom_navbar.dart';

class DashboardTabBar extends StatefulWidget {
  const DashboardTabBar({Key? key}) : super(key: key);

  @override
  State<DashboardTabBar> createState() => _DashboardTabBarState();
}

class _DashboardTabBarState extends State<DashboardTabBar> with AutomaticKeepAliveClientMixin, WidgetsBindingObserver,AfterLayoutMixin {
  final BottomTabsController _controller = Get.find<BottomTabsController>();
  MyProfileController myProfileController = Get.find();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    ///My Profile apiCall for profile pic update
    myProfileApiCall();


    Get.arguments != null ? _controller.currentIndex.value = Get.arguments : null;
    _controller.tabController = PersistentTabController(
      initialIndex: _controller.currentIndex.value,
    );

    super.initState();
  }
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    /// Get Chat Conversations
    precacheImage(const AssetImage(AppImages.newsFeedTutorial),context);
    precacheImage(const AssetImage(AppImages.forumTutorial),context);
    precacheImage(const AssetImage(AppImages.networkTutorial),context);
    precacheImage(const AssetImage(AppImages.notificationTutorial),context);
    precacheImage(const AssetImage(AppImages.messengerTutorial),context);
    precacheImage(const AssetImage(AppImages.newsFeedTutorialArrow),context);
    precacheImage(const AssetImage(AppImages.forumTutorialArrow),context);
    precacheImage(const AssetImage(AppImages.networkTutorialArrow),context);
    precacheImage(const AssetImage(AppImages.notificationTutorialArrow),context);
    precacheImage(const AssetImage(AppImages.messengerTutorialArrow),context);
    precacheImage(const AssetImage(AppImages.img),context);

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (myProfileController.isScreenOpen.value == false) {
        myProfileApiCall();
      }
    }
  }

  @override


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  myProfileApiCall() async {
    await _controller.loadTutorialIndex();
    await myProfileController.fetchProfileDataApi(userId: userSingleton.id!, isShowLoading: false);
    _controller.unReadMessageCount.value = myProfileController.myProfileData.value?.unreadCount.value ?? 0;
  }

  /// All Screens List
  List<Widget> _buildScreens() {
    return [
      const NewsFeedTab(),
      const ForumTab(),
      const NetworkTab(),
      const NotificationListingScreen(),
      const MessengerTab(),
    ];
  }

  // "assets/images/home_fill_1.png"
  /// Bottom Navigation Icons
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      _setNavigator(AppImages.homeFill, AppImages.home, AppStrings.newsFeed, 0),
      _setNavigator(AppImages.forumFill, AppImages.forum, AppStrings.forum, 1),
      _setNavigator(AppImages.networkFill, AppImages.networkOutline, AppStrings.network, 2),
      _setNavigator(AppImages.notificationBottom, AppImages.notificationBottom, AppStrings.notifications, 3),
      _setNavigator(AppImages.messenger, AppImages.messengerOutline, AppStrings.messenger, 4),
    ];
  }

  _setNavigator(String activeIcon, String inActiveIcon, String title, int index) {
    return PersistentBottomNavBarItem(
      icon: Container(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Image(
              fit: BoxFit.cover,
              image: AssetImage(AppImages.shape),
              height: 40,
              width: 40,
            ),
            Obx(
              () => ((myProfileController.myProfileData.value?.isReadNotification.value ?? true) == false && index == 3) || (_controller.unReadMessageCount.value > 0 && index == 4)
                  ? Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Image(
                          fit: BoxFit.contain,
                          image: AssetImage(activeIcon),
                          color: AppColors.primaryColor,
                        ),
                        Positioned(
                          top: index == 3 ? 4.h : 3.h,
                          right: index == 3 ? 2.5.w : -1.w,
                          child: Container(
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primaryShadowColor, width: 1.0)),
                            child: ImageComponent.loadLocalImage(imageName: AppImages.redDot, boxFit: BoxFit.contain),
                          ),
                        ),
                      ],
                    )
                  : Image(
                      fit: BoxFit.contain,
                      image: AssetImage(activeIcon),
                      color: AppColors.primaryColor,
                    ),
            ),
          ],
        ),
      ),
      inactiveIcon: Container(
        color: Colors.transparent,
        child: Center(
          child: Obx(
            () => ((myProfileController.myProfileData.value?.isReadNotification.value ?? true) == false && index == 3) || (_controller.unReadMessageCount.value > 0 && index == 4)
                ? Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Image(
                        fit: BoxFit.contain,
                        image: AssetImage(activeIcon),
                        color: AppColors.showTimeColor,
                      ),
                      Positioned(
                        top: index == 3 ? 4.h : 3.h,
                        right: index == 3 ? 2.5.w : -1.w,
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.whiteColor,
                                  width: 1.0,
                                )),
                            child: ImageComponent.loadLocalImage(imageName: AppImages.redDot, boxFit: BoxFit.contain)),
                      ),
                    ],
                  )
                : Image(
                    fit: BoxFit.contain,
                    image: AssetImage(activeIcon),
                    color: AppColors.showTimeColor,
                    /* height: 21.w,
                width: 21.w,*/
                  ),
          ),
        ),
      ),
      title: title,
      activeColorPrimary: AppColors.blackColor,
      inactiveColorPrimary: AppColors.showTimeColor,
      textStyle:
          (index == _controller.currentIndex.value) ? ISOTextStyles.openSenseBold(color: AppColors.blackColor, size: 10) : ISOTextStyles.openSenseSemiBold(color: AppColors.showTimeColor, size: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: PersistentTabView.custom(
              context,
              stateManagement: false,
              screens: _buildScreens(),
              confineInSafeArea: true,
              handleAndroidBackButtonPress: true,
              controller: _controller.tabController,
              itemCount: _navBarsItems().length,

              // ignore: non_constant_identifier_names
              customWidget: (NavBarEssentials) => CustomNavBarWidget(
                selectedIndex: _controller.tabController.index,
                items: _navBarsItems(),
                onItemSelected: (int value) {
                  if (_controller.currentIndex.value == value) {
                    //Scroll up the first scroll controller
                    if (_controller.currentIndex.value == 0) {
                      NewsFeedController newsFeedController = Get.find();
                      newsFeedController.scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    } else if (_controller.currentIndex.value == 1) {
                      ForumController forumController = Get.find();
                      forumController.scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    }
                  } else {
                    if (value == 3) {
                      myProfileController.myProfileData.value?.isReadNotification.value = true;
                      NotificationListingController notificationListingController = Get.find();
                      notificationListingController.notificationList.clear();
                      ShowLoaderDialog.showLoaderDialog(Get.context!);
                      notificationListingController.notificationListApi(isShowLoader: true);
                      FlutterAppBadger.removeBadge();
                    }
                  }

                  _controller.currentIndex.value = value;
                  _controller.tabController.index = value;
                },
              ),
            ),
          ),
        ),
        Obx(
          () => _controller.tutrorialComplete.value == false
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      bottom: 0,
                      child: ImageComponent.loadLocalImage(
                        imageName: AppImages.img,
                        boxFit: BoxFit.fitWidth,
                        width: Get.width,
                      ),
                    ),
                    Container(
                    color: AppColors.tutorialBackColor,
                    child: Column(
                      children: [
                        const Spacer(flex: 3,),
                        Material(
                          color: Colors.transparent,
                          child: Text(
                            _controller.tutorialStringList[_controller.tutorialIndex.value].tutorialText ?? '',
                            style: ISOTextStyles.openSenseSemiBold(color: AppColors.whiteColor, size: 28),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const Spacer(flex: 1,),
                        Container(

                          width: double.infinity,
                          child: Stack(

                            children: [
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    if (_controller.tutorialIndex.value != 4) {
                                      // _controller.pageController
                                      //     .animateToPage(_controller.tutorialIndex.value = _controller.tutorialIndex.value + 1, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                                      //_controller.pageController.jumpToPage(_controller.tutorialIndex.value = _controller.tutorialIndex.value + 1);
                                      _controller.tutorialIndex.value = _controller.tutorialIndex.value + 1;
                                    } else {
                                      _controller.tutrorialComplete.value = true;
                                      _controller.saveUserData(isTutorialComplete: _controller.tutrorialComplete.value);
                                    }
                                  },
                                  child: Container(
                                    child: ImageComponent.loadLocalImage(imageName: AppImages.btnImage, height: 80.h, width: 80.h),
                                  ),
                                ),
                              ),
/*                              Obx(
                                ()=>*/ Visibility(
                                  visible: _controller.tutorialIndex.value != 4,
                                  child: Positioned(
                                    right: 50.w,
                                    bottom: 25.h,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          _controller.tutrorialComplete.value = true;
                                          _controller.saveUserData(isTutorialComplete: _controller.tutrorialComplete.value);
                                        },
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Text(
                                            AppStrings.skip,
                                            style: ISOTextStyles.openSenseSemiBold(color: AppColors.whiteColor, size: 18),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                             // ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h,),

                        ImageComponent.loadLocalImage(imageName: _controller.tutorialStringList[_controller.tutorialIndex.value].tutorialArrowImage ?? ''),
                        SizedBox(height: 20.h,),
                        Container(
                          margin: EdgeInsets.only(bottom: 22.h),
                          width: double.infinity,
                          child: ImageComponent.loadLocalImage(
                            imageName: _controller.tutorialStringList[_controller.tutorialIndex.value].tutorialImage ?? '',
                            boxFit: BoxFit.fitWidth,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ],
                )
              : Container(),
        ),
      ],
    );
  }

  Widget tutorialWidget() {
    return Container();
  }
}
