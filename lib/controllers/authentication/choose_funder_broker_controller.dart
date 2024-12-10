import 'package:get/get.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';

class FunderBrokerController extends GetxController {
  var funderBrokerCardList = <FunderBrokerModel>[].obs;

  @override
  void onInit() {
    ///init funder broker select list
    funderBrokerCardList.value = [
      FunderBrokerModel(name: AppStrings.imBroker, alias: AppStrings.br),
      FunderBrokerModel(name: AppStrings.imFunder, alias: AppStrings.fu),
    ];
    super.onInit();
  }
}

///** alias for FU / BR for backend
///This model use for showing selection of funder broker type
///And alias pass for backend is user register for funder or broker
class FunderBrokerModel {
  String? name;
  String? alias;

  FunderBrokerModel({this.name, this.alias});
}
