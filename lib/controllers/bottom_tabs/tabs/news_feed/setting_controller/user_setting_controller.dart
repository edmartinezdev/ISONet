import 'package:get/get.dart';

import '../../../../../helper_manager/network_manager/api_const.dart';
import '../../../../../helper_manager/network_manager/remote_service.dart';
import '../../../../../model/bottom_navigation_models/news_feed_models/cms_list_model.dart';
import '../../../../../model/response_model/responese_datamodel.dart';
import '../../../../../utils/app_common_stuffs/snackbar_util.dart';

class UserSettingController extends GetxController {

  var cmsList = <CMSModelData>[].obs;
  var cmsListModel = <CMSModel>[].obs;
  var cmsKey = 'TC'.obs;

  fetchCMSData({required String cmsKey}) async {

    Map<String, dynamic> params = {};
    params["cms_key"] = cmsKey;

    ResponseModel<CMSModel> response = await sharedServiceManager.createPostRequest(
      typeOfEndPoint: ApiType.termsPrivacyCms, params: params,
    );
    if (response.status == ApiConstant.statusCodeSuccess) {
      if(cmsList.isEmpty){
        cmsList.value = response.data?.data ?? [];
      } else {

      }
      return true;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
      return false;
    }
  }


}