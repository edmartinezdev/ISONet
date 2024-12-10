import 'package:get/get.dart';
import 'package:iso_net/controllers/my_profile/block_connection_controller.dart';

class BlockConnectionBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => BlockConnectionController());
  }

}