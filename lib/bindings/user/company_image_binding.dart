import 'package:get/get.dart';
import 'package:iso_net/controllers/user/company_image_controller.dart';

class CompanyImageBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => CompanyImageController());
  }

}