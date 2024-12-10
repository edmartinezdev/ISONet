import 'package:get/get.dart';

import '../../controllers/bottom_tabs/tabs/forum/forum_detail_controller.dart';

class ForumDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ForumDetailController());
  }
}
