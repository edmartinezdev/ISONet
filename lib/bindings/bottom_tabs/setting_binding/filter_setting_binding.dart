import 'package:get/get.dart';

import '../../../controllers/bottom_tabs/tabs/news_feed/setting_controller/company_setting_controller.dart';
import '../../../controllers/bottom_tabs/tabs/search/company_filter_controller.dart';

class CompanyFilterBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => CompanySettingController());
    Get.lazyPut(() => CompanyFilterController());
  }

}