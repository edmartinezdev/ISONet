import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/search/search_tab_controller.dart';


class SearchBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SearchController());
  }

}