import 'package:get/get.dart';

import '../../../controllers/bottom_tabs/tabs/news_feed/user-controller/user_edit_screen_controller.dart';

class UserEditScreenBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => UserEditScreenController());
  }

}