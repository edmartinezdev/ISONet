import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/my_profile/notification_list_model.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';

import '../../utils/app_common_stuffs/app_logger.dart';
import '../../utils/app_common_stuffs/commom_utils.dart';

class NotificationListingController extends GetxController {
  var page = 1.obs;
  var totalRecord = 0.obs;
  var isAllDataLoaded = false.obs;
  var notificationList = <NotificationListData>[].obs;
  var isLoadMoreRunningForViewAllCategory = false;
  var isApiResponseReceive = false.obs;
  var isNotificationRefresh = false.obs;

  ///Get Notification list
  notificationListApi({bool isShowLoader = true}) async {
    Map<String, dynamic> params = {};
    params['start'] = isNotificationRefresh.value ? 0 : notificationList.length;
    params['limit'] = defaultFetchLimit;
    ResponseModel<NotificationListModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.notificationList, params: params);
    if (isShowLoader) {
      ShowLoaderDialog.dismissLoaderDialog();
    }
    if (isNotificationRefresh.value) {
      notificationList.clear();
      isApiResponseReceive.value = false;
      isAllDataLoaded.value = false;
      totalRecord.value = 0;
      isNotificationRefresh.value = false;
    }
    isApiResponseReceive.value = true;

    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      totalRecord.value = responseModel.data?.totalRecord ?? 0;
      isApiResponseReceive.value = true;
      if (notificationList.isEmpty) {
        notificationList.value = responseModel.data?.data ?? [];
      } else {
        notificationList.addAll(responseModel.data?.data ?? []);
        /*if (responseModel.data?.data != null) {
          notificationList.insert(0, responseModel.data!.data!.first);
        }*/
      }
      isAllDataLoaded.value = (notificationList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAllCategory = false;
    }
  }

  /// Clear all notification api
  apiCallClearAllNotification() async {
    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.notificationClear);
    ShowLoaderDialog.dismissLoaderDialog();
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      notificationList.clear();
      totalRecord.value = 0;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.success, message: responseModel.message);
    }
  }

  ///pagination loader
  paginationLoadData() {
    if (notificationList.length.toString() == totalRecord.value.toString()) {
      return true;
    } else {
      return false;
    }
  }

  notificationPagination() {
    page.value++;
    Logger().i(page.value);
    notificationListApi(isShowLoader: false);
  }
}
