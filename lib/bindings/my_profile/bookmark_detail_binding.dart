import 'package:get/get.dart';
import 'package:iso_net/controllers/my_profile/bookmark_detail_controller.dart';

class BookMarkDetailBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => BookMarkDetailController());
  }

}