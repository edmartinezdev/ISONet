import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/company_controller/employee_profile_controller.dart';

class EmployeeProfileBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => EmployeeProfileController());
  }

}