import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:tuple/tuple.dart';

import '../../utils/validation/validation.dart';

class ForgotPwdController extends GetxController {
  ///********* variables declaration ********///
  var isButtonEnable = false.obs;
  var emailChange = "".obs;
  ///*******************************************

  ///******* forgot password validation *******
  Tuple2<bool, String> isValidFormForForgotPwd() {
    List<Tuple2<ValidationType, String>> arrList = [];
    arrList.add(Tuple2(ValidationType.email, emailChange.value));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);
    return Tuple2(validationResult.item1, validationResult.item2);
  }

  ///******* button enable disable validation *******
  validateButton() {
    if ((emailChange.value.isNotEmpty && emailChange.value.isEmail)) {
      isButtonEnable.value = true;
    } else {
      isButtonEnable.value = false;
    }
  }

  ///Forgot Password Api Function
  Future<bool>apiCallForgotPwd({required onErr}) async {
    Map<String, dynamic> requestParams = {};
    requestParams['email_id'] = emailChange.value;
    ResponseModel responseModel =
        await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.forgotPassword, params: requestParams);
    ShowLoaderDialog.dismissLoaderDialog();
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      ///***** Api Success *****///
      return true;
    } else {
      ///***** Api Error *****///
      onErr(responseModel.message);
      return false;
    }
  }
}
