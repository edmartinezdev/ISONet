import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:tuple/tuple.dart';

import '../../helper_manager/network_manager/api_const.dart';
import '../../helper_manager/network_manager/remote_service.dart';
import '../../model/response_model/responese_datamodel.dart';
import '../../ui/style/showloader_component.dart';
import '../../utils/validation/validation.dart';

class GetStartedController extends GetxController {
  ///********* variables declaration ********///
  var firstNameChange = ''.obs;
  var lastNameChange = ''.obs;
  var emailChange = ''.obs;
  var phoneChange = ''.obs;
  var formattedPhoneNo = ''.obs;
  var passwordChange = ''.obs;
  var confirmPwdChange = ''.obs;
  var isPwdObSecure = true.obs;
  var isConPwdObSecure = true.obs;
  var isButtonEnable = false.obs;
  var isCheckTermsCondition = false.obs;
  var phoneNoForApi = ''.obs;

  ///*******************************************

  ///******* phone no formatting *******
  convertPhoneInputString(TextEditingValue oldValue, TextEditingValue newValue) {
    Logger().i("OldValue: ${oldValue.text}, NewValue: ${newValue.text}");
    formattedPhoneNo.value = newValue.text;
    if (formattedPhoneNo.value.length == 10) {
      RegExp phone = RegExp(r'(\d{3})(\d{3})(\d{4})');
      var matches = phone.allMatches(newValue.text);
      var match = matches.elementAt(0);
      formattedPhoneNo.value = '(${match.group(1)}) ${match.group(2)}-${match.group(3)}';
    }
  }

  ///***** show & hide password function *****///
  showHidePassword() {
    isPwdObSecure.value = !isPwdObSecure.value;
  }

  ///***** show & hide confirm password function *****///
  showHideConfirmPassword() {
    isConPwdObSecure.value = !isConPwdObSecure.value;
  }

  ///******* Get Started Form validation *******
  Tuple2<bool, String> isValidFormForGetStarted() {
    List<Tuple2<ValidationType, String>> arrList = [];
    arrList.add(Tuple2(ValidationType.firstName, firstNameChange.value));
    arrList.add(Tuple2(ValidationType.lastName, lastNameChange.value));
    arrList.add(Tuple2(ValidationType.email, emailChange.value));
    arrList.add(Tuple2(ValidationType.phoneNumber, phoneChange.value));
    arrList.add(Tuple2(ValidationType.signUpPassword, passwordChange.value));
    arrList.add(Tuple2(ValidationType.termsAndConditions, isCheckTermsCondition.value.toString()));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);
    if (validationResult.item1) {
      return Validation().validateConfirmPassword(passwordChange.value, confirmPwdChange.value);
    }

    return Tuple2(validationResult.item1, validationResult.item2);
  }

  ///******* Check button validation function *******
  validateButton() {
    if ((firstNameChange.value.isNotEmpty && firstNameChange.value.length > 1) &&
        (lastNameChange.value.isNotEmpty && lastNameChange.value.length > 1) &&
        (emailChange.value.isNotEmpty && emailChange.value.isEmail) &&
        (phoneChange.value.isNotEmpty && phoneChange.value.length == 14) &&
        (passwordChange.value.isNotEmpty && passwordChange.value.length > 5) &&
        (confirmPwdChange.value.isNotEmpty && confirmPwdChange.value.length > 5) &&
        isCheckTermsCondition.value != false) {
      isButtonEnable.value = true;
    } else {
      isButtonEnable.value = false;
    }
  }

  ///****** signup API function *****///

  Future<bool> apiCallSignUp({required onError, required userType}) async {
    Map<String, dynamic> requestParams = {};
    requestParams['email'] = emailChange.value;
    requestParams['password'] = passwordChange.value;
    requestParams['first_name'] = firstNameChange.value;
    requestParams['last_name'] = lastNameChange.value;
    requestParams['phone_number'] = phoneNoForApi.value;
    requestParams['user_type'] = userType;
    //requestParams['is_tc_and_pp_agreed'] = isCheckTermsCondition.value.toString().capitalizeFirst;

    ResponseModel<UserModel> signUpResponse = await sharedServiceManager.createPostRequest(
      typeOfEndPoint: ApiType.signUp,
      params: requestParams,
    );

    ShowLoaderDialog.dismissLoaderDialog();

    if (signUpResponse.status == ApiConstant.statusCodeSuccess) {
      ///***** Api Success *****//
      await userSingleton.updateValue(
        signUpResponse.data?.toJson() ?? <String, dynamic>{},
      );

      return true;
    } else {
      ///***** Api Error *****//
      onError(signUpResponse.message);
      return false;
    }
  }
}
