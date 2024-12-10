import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/company_controller/company_profile_controller.dart';

class CompanyProfileBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => CompanyProfileController());
  }

}