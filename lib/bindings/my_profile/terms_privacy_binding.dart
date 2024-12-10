import 'package:get/get.dart';
import 'package:iso_net/controllers/my_profile/terms_privacy_controller.dart';

class TermsPrivacyBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => TermsPrivacyController());
  }

}