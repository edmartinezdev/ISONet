import 'package:get/get.dart';
import 'package:iso_net/controllers/my_profile/bookmark_controller.dart';

class BookMarkBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() =>  BookMarkController());
  }

}
