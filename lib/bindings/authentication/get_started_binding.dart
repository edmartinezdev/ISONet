import 'package:get/get.dart';
import 'package:iso_net/controllers/authentication/get_started_controller.dart';

class GetStartedBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => GetStartedController());
  }

}