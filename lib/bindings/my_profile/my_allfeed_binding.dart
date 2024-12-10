import 'package:get/get.dart';
import 'package:iso_net/controllers/my_profile/my_allfeed_controller.dart';

class MyAllFeedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => MyAllFeedController(),
    );
  }
}
