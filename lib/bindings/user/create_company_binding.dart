import 'package:get/get.dart';
import 'package:iso_net/controllers/user/create_company_controller.dart';

class CreateCompanyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateCompanyController());
  }
}
