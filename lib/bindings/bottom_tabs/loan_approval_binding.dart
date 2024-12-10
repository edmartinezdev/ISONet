import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/loan_approval_controller.dart';

class LoanApprovalBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => LoanApprovalController());
  }

}