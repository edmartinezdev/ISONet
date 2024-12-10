import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:tuple/tuple.dart';

import '../../helper_manager/network_manager/api_const.dart';
import '../../model/response_model/responese_datamodel.dart';
import '../../ui/style/showloader_component.dart';
import '../../utils/validation/validation.dart';

class OtpController extends GetxController {
  ///********* variables declaration ********///
  var isEnabled = false.obs;
  var otpChange = ''.obs;

  ///*******************************************

  ///******* onClear text function *******
  ///******* onClear icon press all text clear which type in textField *******
  onClearIconTap(TextEditingController otpEditingController) {
    otpEditingController.clear();
    otpChange.value = '';
    isEnabled.value = false;
  }

  ///******* button enable disable validation *******
  validateButton() {
    otpChange.value.isNotEmpty && otpChange.value.length >= 6 ? isEnabled.value = true : isEnabled.value = false;
  }

  ///******* Otp validation *******
  Tuple2<bool, String> isValidFormForOtp() {
    List<Tuple2<ValidationType, String>> arrList = [];
    arrList.add(Tuple2(ValidationType.otp, otpChange.value));
    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);
    return Tuple2(validationResult.item1, validationResult.item2);
  }

  ///***** Otp api call, function ******
  Future<bool> apiCallOtp({required onError}) async {
    ShowLoaderDialog.showLoaderDialog(Get.context!);
    Map<String, dynamic> requestParams = {};
    requestParams['email'] = userSingleton.email;
    requestParams['otp'] = otpChange.value;

    ResponseModel<UserModel> otpResponse = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.otp, params: requestParams);
    ShowLoaderDialog.dismissLoaderDialog();
    if (otpResponse.status == ApiConstant.statusCodeSuccess) {
      ///***** Api Success *****//
      await userSingleton.updateValue(
        otpResponse.data?.toJson() ?? <String, dynamic>{},
      );
      return true;
    } else {
      ///***** Api Error *****//
      onError(otpResponse.message);
      return false;
    }
  }

  ///***** Resend Otp api call, function ******
  Future<bool> apiCallResendOtp({required onSuccess, required onErr}) async {
    ShowLoaderDialog.showLoaderDialog(Get.context!);
    ResponseModel resendOtp = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.resendOtp);
    ShowLoaderDialog.dismissLoaderDialog();
    if (resendOtp.status == ApiConstant.statusCodeSuccess) {
      ///***** Api Success *****//
      onSuccess(AppStrings.otpSentOnEmail);
      return true;
    } else {
      ///***** Api Error *****//
      onErr(resendOtp.message);
      return false;
    }
  }
}
