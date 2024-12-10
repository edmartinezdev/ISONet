import 'package:get/get.dart';
import 'package:iso_net/controllers/authentication/forgot_password_controller.dart';

class ForgotPwdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForgotPwdController());
  }
}
