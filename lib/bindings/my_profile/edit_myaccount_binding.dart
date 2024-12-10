import 'package:get/get.dart';
import 'package:iso_net/controllers/my_profile/edit_myaccount_controller.dart';
import 'package:iso_net/controllers/my_profile/my_profile_controller.dart';
import 'package:iso_net/controllers/user/user_interest_controller.dart';

class EditMyAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
          () => MyProfileController(),
    );
    Get.lazyPut(
          () => UserInterestController(),
    );
    Get.lazyPut(
      () => EditMyAccountController(),
    );
  }
}
