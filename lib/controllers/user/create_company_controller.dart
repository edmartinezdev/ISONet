import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/utils/validation/validation.dart';
import 'package:tuple/tuple.dart';

import '../../model/dropdown_models/userdetail_dropdown_model.dart';

class CreateCompanyController extends GetxController {
  ///********* variables declaration ********///
  var isButtonEnable = false.obs;

  var companyNameChange = ''.obs;
  var addressChange = ''.obs;
  var cityChange = ''.obs;
  var stateChange = ''.obs;
  var zipCodeChange = ''.obs;
  var phoneNumberChange = ''.obs;
  var websiteChange = ''.obs;
  var descriptionChange = ''.obs;
  var phoneNoForApi = ''.obs;
  double latitude = 0.0;
  double longitude = 0.0;

  var stateDropDownList2 = <StatesDropDown>[].obs;
  Rxn<StatesDropDown> stateDropDownModel2 = Rxn();

  TextEditingController addressTextController = TextEditingController();
  TextEditingController cityTextController = TextEditingController();
  TextEditingController stateTextController = TextEditingController();
  TextEditingController zipCodeTextController = TextEditingController();

  ///*******************************************

  ///******* create company Form validation *******
  Tuple2<bool, String> isValidCreateCompanyFormForDetails({required String address, required String city, required String state, required String zipCode}) {
    List<Tuple2<ValidationType, String>> arrList = [];
    arrList.add(Tuple2(ValidationType.company, companyNameChange.value));
    arrList.add(Tuple2(ValidationType.address, address));
    arrList.add(Tuple2(ValidationType.city, city));
    arrList.add(Tuple2(ValidationType.state, state));
    arrList.add(Tuple2(ValidationType.zipCode, zipCode));
    arrList.add(Tuple2(ValidationType.phoneNumber, phoneNumberChange.value));
    // arrList.add(Tuple2(ValidationType.description, descriptionChange.value));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);

    return Tuple2(validationResult.item1, validationResult.item2);
  }

  ///******* button enable disable validation *******
  validateButton({required String address, required String city, required String state, required String zipCode}) {
    if ((companyNameChange.value.isNotEmpty && companyNameChange.value.length > 1) &&
        address.isNotEmpty &&
        (city.isNotEmpty && city.length > 1) &&
        state.isNotEmpty &&
        (zipCode.isNotEmpty && zipCode.length > 4) &&
        phoneNumberChange.value.isNotEmpty && phoneNumberChange.value.length == 14)
        /*(descriptionChange.value.isNotEmpty && descriptionChange.value.length > 1))*/ {
      isButtonEnable.value = true;
    } else {
      isButtonEnable.value = false;
    }
  }
}
