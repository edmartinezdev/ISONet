import 'package:get/get.dart';

import '../../controllers/my_profile/my_allloanlist_controller.dart';

class MyAllLoanListBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => MyLoanListController());
  }

}