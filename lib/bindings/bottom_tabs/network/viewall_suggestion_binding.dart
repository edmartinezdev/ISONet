import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/network/viewall_suggestion_controller.dart';


class ViewAllSuggestionBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ViewAllSuggestionController());
  }

}