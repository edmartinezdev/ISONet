import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/chat/one_to_one_chat_controller.dart';

import '../../../controllers/bottom_tabs/tabs/chat/create_new_chat_controller.dart';

class CreateNewMessageBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => NewMessageController());
    Get.lazyPut(() => OneToOneChatController());
  }

}