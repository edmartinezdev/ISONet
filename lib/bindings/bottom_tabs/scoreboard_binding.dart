import 'package:get/get.dart';

import '../../controllers/bottom_tabs/tabs/news_feed/scoreboard_controller.dart';

class ScoreBoardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ScoreBoardController());

  }

}