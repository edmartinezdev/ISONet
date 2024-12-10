import 'package:get/get.dart';

import '../../../controllers/bottom_tabs/tabs/chat/add_group_name_controller.dart';

class AddGroupNameBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => AddGroupNameController());
  }

}