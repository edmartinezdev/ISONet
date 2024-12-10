import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/create_scoreboard_controller.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/scoreboard_controller.dart';

class CreateScoreBoardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => CreateScoreBoardController());
    Get.lazyPut(() => ScoreBoardController());
  }

}