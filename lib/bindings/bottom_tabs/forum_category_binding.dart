import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/forum/forum_category_controller.dart';

class ForumCategoryBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ForumCategoryController());
  }

}