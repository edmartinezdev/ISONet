import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/model/tutorial_model.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';
import 'package:iso_net/utils/app_common_stuffs/preferences_key.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomTabsController extends GetxController {
  var currentIndex = 0.obs;
  var isTapChangeVariable = 0.obs;
  var unReadMessageCount = 0.obs;

  var tutorialIndex = 0.obs;
  var tutrorialComplete = false.obs;
  var heightTutorial = 0.0.obs;

  PageController pageController = PageController();
  var tutorialStringList = <TutorialModel>[
    TutorialModel(
        tutorialText: "Discover updates &\n"
            "news in your feed!",
        tutorialImage: AppImages.newsFeedTutorial,
        tutorialArrowImage: AppImages.newsFeedTutorialArrow),
    TutorialModel(
        tutorialText: 'Stay informed,\n'
            'and collaborate\n'
            'with experts!',
        tutorialImage: AppImages.forumTutorial,
    tutorialArrowImage: AppImages.forumTutorialArrow),
    TutorialModel(
        tutorialText: 'Expand your\n'
            ' network, track deals:\n'
            'and boost success!',
        tutorialImage: AppImages.networkTutorial,
        tutorialArrowImage: AppImages.networkTutorialArrow),
    TutorialModel(
        tutorialText: 'Stay in the loop,\n'
            'don’t miss a thing!',
        tutorialImage: AppImages.notificationTutorial,
        tutorialArrowImage: AppImages.notificationTutorialArrow),
    TutorialModel(
        tutorialText: 'Boost productivity &\n'
            'connection with\n'
            'messenger chats.',
        tutorialImage: AppImages.messengerTutorial,
        tutorialArrowImage: AppImages.messengerTutorialArrow),
  ].obs;
  PersistentTabController tabController = PersistentTabController();
  var screensList = <Widget>[].obs;

  Future<void> saveUserData({required bool isTutorialComplete}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(PreferenceKeys.tutorialCount, isTutorialComplete);
  }

  Future<void> loadTutorialIndex() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    tutrorialComplete.value = preferences.getBool(PreferenceKeys.tutorialCount) ?? false;
    if(tutrorialComplete.value == false){
      tutorialIndex.value = 0;
    }
  }

//@override
/*void onInit() {
    screensList.value = const [
      NewsFeedTab(),
      ForumTab(),
      SearchTab(),
      NetworkTab(),
      MessengerTab(),
    ];
    super.onInit();
  }*/
}
