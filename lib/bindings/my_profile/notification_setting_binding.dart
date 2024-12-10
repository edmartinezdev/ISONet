import 'package:get/get.dart';
import 'package:iso_net/controllers/my_profile/notifiation_setting_controller.dart';

class NotificationSettingBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationSettingController());

  }

}