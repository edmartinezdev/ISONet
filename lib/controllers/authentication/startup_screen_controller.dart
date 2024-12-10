import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';

class StartupScreenController extends GetxController {

  ///********* variables declaration ********///
  var currentPage = 0.obs;
  var introScreenQna = <String>[].obs;
  ///*******************************************

  ///******* It will change the indicator color while pageView changed *******
  Color changeIndicatorColor(int index) {
    return index == currentPage.value ? AppColors.indicatorColor : AppColors.greyColor;
  }

  ///******* OnTap indicator to navigate the page *******
  onTapIndicator({required PageController pageController, required int index}) {
    pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  void onInit() {
    ///Slider List
    introScreenQna.value = [
      AppStrings.startupSlider1String,
      AppStrings.startupSlider2String,
      AppStrings.startupSlider3String,
    ];

    super.onInit();
  }
}
