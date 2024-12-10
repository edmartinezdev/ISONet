import 'dart:io';

import 'package:get/get.dart';
import 'package:iso_net/helper_manager/firebase_notification_manager/firebase_cloud_messaging_manager.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/device_info.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:tuple/tuple.dart';

import '../../utils/app_common_stuffs/screen_routes.dart';
import '../../utils/validation/validation.dart';

class SignInScreenController extends GetxController {
  ///********* variables declaration ********///
  var isObscure = true.obs;
  var isButtonEnable = false.obs;
  var emailChange = "".obs;
  var passwordChange = "".obs;
  var deviceId = ''.obs;

  ///*******************************************

  ///******* check if password is visible or not *******
  showHidePassword() {
    isObscure.value = !isObscure.value;
  }

  ///******* fetch device id *********
  fetchDeviceId() async {
    deviceId.value = await DeviceInfo.getDeviceId() ?? '';
    Logger().i(deviceId.value);
  }

  ///******* login validation *******
  Tuple2<bool, String> isValidFormForLogin() {
    List<Tuple2<ValidationType, String>> arrList = [];
    arrList.add(Tuple2(ValidationType.email, emailChange.value));
    arrList.add(Tuple2(ValidationType.password, passwordChange.value));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);
    return Tuple2(validationResult.item1, validationResult.item2);
  }

  ///******* Check button validation function *******
  validateButton() {
    if ((emailChange.value.isNotEmpty && emailChange.value.isEmail) && (passwordChange.value.isNotEmpty && passwordChange.value.length > 5)) {
      isButtonEnable.value = true;
    } else {
      isButtonEnable.value = false;
    }
  }

  ///*** sign in API
  Future<bool>apiCallSignIn({required onErr}) async {
    ShowLoaderDialog.showLoaderDialog(Get.context!);
    Map<String, dynamic> requestParams = {};
    requestParams['email'] = emailChange.value;
    requestParams['password'] = passwordChange.value;
    requestParams['device_id'] = deviceId.value;
    requestParams['device_type'] = Platform.isAndroid ? AppStrings.android : AppStrings.ios;
    requestParams['device_token'] = FireBaseCloudMessagingWrapper().fcmToken;
    ResponseModel<UserModel> loginApiResponse = await sharedServiceManager.createPostRequest(
      typeOfEndPoint: ApiType.login,
      params: requestParams,
    );

    loginApiResponse.status;

    ShowLoaderDialog.dismissLoaderDialog();
    if (loginApiResponse.status == ApiConstant.statusCodeSuccess) {
      ///***** Api Success Todo *****//
      await userSingleton.updateValue(
        loginApiResponse.data?.toJson() ?? <String, dynamic>{},
      );

      ///Getting response of api we navigate user according to user stage
      if (userSingleton.userStage == 0 || userSingleton.userStage == null) {
        Get.offAllNamed(ScreenRoutesConstants.startupScreen);
      } else if (userSingleton.userStage == 1) {
        Get.offAllNamed(ScreenRoutesConstants.otpScreen);
      } else if (userSingleton.userStage == 2) {
        Get.offAllNamed(ScreenRoutesConstants.detailScreen);
      } else if (userSingleton.userStage == 3) {
        Get.offAllNamed(ScreenRoutesConstants.userProfileImageScreen);
      } else if (userSingleton.userStage == 4) {
        if (userSingleton.isApproved == AppStrings.approved) {
          if (userSingleton.isSubscribed == false) {
            Get.offAllNamed(ScreenRoutesConstants.subscribeScreen, arguments: false);
          } else {
            Get.offAllNamed(ScreenRoutesConstants.bottomTabsScreen);
          }
        } else {
          Get.offAllNamed(ScreenRoutesConstants.userApproveWaitingScreen);
        }
      }
      return true;
    } else {
      ///***** Api Error ****//
      onErr(loginApiResponse.message);
      return false;
    }
  }

  @override
  void onInit() {
    fetchDeviceId();
    FireBaseCloudMessagingWrapper().getFCMToken();
    super.onInit();
  }
}
