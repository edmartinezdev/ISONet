import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/my_profile/block_connection_model.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';

import '../../helper_manager/network_manager/api_const.dart';

class BlockConnectionController extends GetxController {
  var isAllDataLoaded = false.obs;
  var blockUserList = <BlockedUserData>[].obs;
  var isLoadMoreRunningForViewAll = false;
  var isApiResponseReceive = false.obs;

  var totalRecord = 0.obs;

  ///***** Api call of get block user list *****///
  apiCallBlockUserList({bool isShowLoader = false}) async {
    Map<String, dynamic> params = {};
    params['start'] = blockUserList.length;
    params['limit'] = defaultFetchLimit;
    ResponseModel<BlockConnectionModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.blockUserList);
    if(isShowLoader){
      ShowLoaderDialog.dismissLoaderDialog();
    }
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      isApiResponseReceive.value = true;
      if (blockUserList.isEmpty) {
        blockUserList.value = responseModel.data?.blockedUserData ?? [];
      } else {
        blockUserList.addAll(responseModel.data?.blockedUserData ?? []);
      }
      isAllDataLoaded.value = (blockUserList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  ///***** Block User Pagination function *****///
  blockUserPagination() {
    apiCallBlockUserList();
  }
}
