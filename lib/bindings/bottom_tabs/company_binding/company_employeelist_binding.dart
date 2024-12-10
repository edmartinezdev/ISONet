import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/company_controller/company_employelist_controller.dart';


class CompanyEmployeeListBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => CompanyEmployeeListController());
  }

}