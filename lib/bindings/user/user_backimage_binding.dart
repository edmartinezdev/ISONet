import 'package:get/get.dart';
import 'package:iso_net/controllers/user/user_backimage_controller.dart';

class UserBackImageBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => UserBackImageController());
  }

}