import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/feed_detail_controller.dart';

class FeedDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => FeedDetailController(),
    );
  }
}
