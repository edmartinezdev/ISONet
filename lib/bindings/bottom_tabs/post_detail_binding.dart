import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/post_detail_controller.dart';

class PostDetailBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => PostDetailController());
  }

}