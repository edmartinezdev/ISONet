import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/network/viewmy_network_controller.dart';

class ViewMyNetworkBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ViewMyNetworkController());
  }

}