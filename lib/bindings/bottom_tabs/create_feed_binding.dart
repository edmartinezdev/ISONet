import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/create_feed_controller.dart';

class CreateFeedBinding  extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => CreateFeedController());
    // Get.lazyPut(() => ForumCategoryController());
  }

}