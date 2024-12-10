import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/setting_controller/company_setting_controller.dart';

import '../../../controllers/bottom_tabs/tabs/news_feed/setting_controller/user_setting_controller.dart';

class UserSettingBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => UserSettingController());
    Get.lazyPut(() => CompanySettingController());

  }

}