import 'package:get/get.dart';

import '../../../controllers/bottom_tabs/tabs/chat/add_group_name_controller.dart';
import '../../../controllers/bottom_tabs/tabs/chat/one_to_one_chat_controller.dart';

class OneToOneChatBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => OneToOneChatController());
    Get.lazyPut(() => AddGroupNameController());
  }

}