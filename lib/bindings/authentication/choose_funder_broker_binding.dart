import 'package:get/get.dart';
import 'package:iso_net/controllers/authentication/choose_funder_broker_controller.dart';

class FunderBrokerBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => FunderBrokerController());
  }

}