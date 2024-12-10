import 'package:get/get.dart';
import 'package:iso_net/controllers/user/detail_info_controller.dart';

class DetailInfoBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => DetailInfoController());
  }

}