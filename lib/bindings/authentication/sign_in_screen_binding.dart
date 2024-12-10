import 'package:get/get.dart';
import 'package:iso_net/controllers/authentication/sign_in_screen_controller.dart';

class SignInScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInScreenController());
  }
}
