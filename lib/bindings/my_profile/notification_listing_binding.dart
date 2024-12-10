import 'package:get/get.dart';
import 'package:iso_net/controllers/my_profile/notification_listing_controller.dart';

import '../../controllers/bottom_tabs/tabs/news_feed/setting_controller/company_setting_controller.dart';

class NotificationListingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationListingController());
    Get.lazyPut(() => CompanySettingController());
  }
}
