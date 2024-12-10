import 'package:get/get.dart';
import 'package:iso_net/controllers/user/user_interest_controller.dart';

class UserInterestBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => UserInterestController());
  }

}