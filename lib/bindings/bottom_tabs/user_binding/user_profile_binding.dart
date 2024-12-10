import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/user-controller/user_profile_controller.dart';

class UserProfileBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => UserProfileController());
  }

}