import 'package:get/get.dart';

import '../../../controllers/bottom_tabs/tabs/news_feed/user-controller/main_profile_screen_controller.dart';

class MainProfileScreenBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => MainScreenProfileController());
  }

}