import 'package:get/get.dart';
import 'package:iso_net/controllers/user/subscribe_controller.dart';

class SubscribeBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SubscribeController());
  }

}