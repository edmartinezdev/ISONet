import 'package:get/get.dart';

import '../../../controllers/bottom_tabs/tabs/chat/chat_screen_controller.dart';

class ChatScreenBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ChatScreenController());
  }

}