import 'package:get/get.dart';
import 'package:iso_net/controllers/authentication/startup_screen_controller.dart';

class StartupScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StartupScreenController());
  }
}
