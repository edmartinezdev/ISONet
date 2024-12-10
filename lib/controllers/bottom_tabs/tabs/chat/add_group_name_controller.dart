import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

import '../../../../utils/validation/validation.dart';

class AddGroupNameController extends GetxController{

  var isEnabled = false.obs;
  var roomName = Get.arguments[0];
  var groupName = Get.arguments[1];

  var group = ''.obs;

  TextEditingController groupNameController = TextEditingController();

  ///******* groupName validation *******
  Tuple2<bool, String> isValidFormForGroupName() {
    List<Tuple2<ValidationType, String>> arrList = [];
    arrList.add(Tuple2(ValidationType.groupName, groupNameController.text));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);
    return Tuple2(validationResult.item1, validationResult.item2);
  }

  validateButton() {
    if ((groupNameController.text.isNotEmpty)) {
      isEnabled.value = true;
    } else {
      isEnabled.value = false;
    }
  }
}