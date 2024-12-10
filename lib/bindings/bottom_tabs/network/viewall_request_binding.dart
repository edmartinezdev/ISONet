import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/network/viewall_request_controller.dart';

class ViewAllRequestBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ViewAllRequestController());
  }

}