import 'package:get/get.dart';
import 'package:iso_net/controllers/authentication/otp_controller.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OtpController());
  }
}
