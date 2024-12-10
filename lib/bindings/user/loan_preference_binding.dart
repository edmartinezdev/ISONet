import 'package:get/get.dart';
import 'package:iso_net/controllers/user/loan_preference_controller.dart';

class LoanPreferenceBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => LoanPreferenceController());
  }

}