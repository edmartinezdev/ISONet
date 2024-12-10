import 'package:get/get.dart';

import '../../controllers/bottom_tabs/tabs/news_feed/article_detail_controller.dart';

class ArticleDetailBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ArticleDetailController());
  }

}