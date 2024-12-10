import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/my_profile/notification_setting_model.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';

import '../../ui/style/showloader_component.dart';

class NotificationSettingController extends GetxController {
  var notificationTypeList = <NotificationTypesList>[].obs;



  getNotificationTypeListApi({String? notificationOnOffType}) async {
    Map<String, dynamic> params = {};
    notificationOnOffType == null ? null : params['action'] = notificationOnOffType;

    ResponseModel<NotificationSettingModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.notificationSetting, params: params);

    ShowLoaderDialog.dismissLoaderDialog();
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      notificationTypeList.value = responseModel.data?.notificationTypesList ?? [];
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }
}
