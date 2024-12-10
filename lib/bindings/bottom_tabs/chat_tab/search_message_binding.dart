import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/chat/search_message_controller.dart';

class SearchMessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchMessageController());
  }
}
