import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/company_controller/company_reviewlist_controller.dart';

class CompanyReviewBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => CompanyReviewController());
  }

}