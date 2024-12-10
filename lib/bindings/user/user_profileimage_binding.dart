import 'package:get/get.dart';
import 'package:iso_net/controllers/user/user_profileimage_controller.dart';

class UserProfileImageBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => UserProfileImageController());
  }

}