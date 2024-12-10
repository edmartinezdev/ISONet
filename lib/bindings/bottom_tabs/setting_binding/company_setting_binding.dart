import 'package:get/get.dart';

import '../../../controllers/bottom_tabs/tabs/news_feed/setting_controller/company_setting_controller.dart';

class CompanySettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CompanySettingController());
  }
}
