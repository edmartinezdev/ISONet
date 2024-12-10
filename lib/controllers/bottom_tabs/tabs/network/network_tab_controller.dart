import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';

import '../../../../model/bottom_navigation_models/network_model/network_tab_model.dart';
import '../../../../model/bottom_navigation_models/news_feed_models/loan_list_model.dart';
import '../../../../singelton_class/auth_singelton.dart';
import '../../../../ui/style/showloader_component.dart';

class NetworkController extends GetxController {
  ///*********Network Tab Screen variables & Function*********///
  Rxn<NetworkTabModel> networkTabData = Rxn();
  var requestList = <PendingRequest>[].obs;
  var suggestionList = <ConnectionSuggestion>[].obs;
  var isNetworkDataLoaded = false.obs;
  var loanList = <LoanData>[].obs;

  networkTabApiCall({bool isShowLoader = false}) async {
    ResponseModel<NetworkTabModel> responseModel = await sharedServiceManager.createGetRequest(typeOfEndPoint: ApiType.networkTabApi);
    if (isShowLoader) {
      ShowLoaderDialog.dismissLoaderDialog();
    }
    if(isNetworkDataLoaded.value == true){
      requestList.clear();
      suggestionList.clear();
      loanList.clear();
      isNetworkDataLoaded.value = false;
    }

    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      networkTabData.value = responseModel.data;
      requestList.value = responseModel.data?.pendingRequest ?? [];
      suggestionList.value = responseModel.data?.connectionSuggestion ?? [];
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }


  ///**** api call function of scoreboard list ******///
  apiCallFetchScoreboardLoanList() async {
    Map<String, dynamic> params = {};
    params["user_type"] = userSingleton.userType == 'FU' ? 'BR' : 'FU';

    ResponseModel<LoanListModel> response = await sharedServiceManager.uploadRequest(ApiType.loanList, params: params);
    if(isNetworkDataLoaded.value == true){
      loanList.clear();
      isNetworkDataLoaded.value = false;
    }


    if (response.status == ApiConstant.statusCodeSuccess) {
      ///***** Api Success *****///
      loanList.value = response.data?.loanData ?? [];
      return true;
    } else {
      ///***** Api Error *****///
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
      return false;
    }
  }

  ///Accept request api
  acceptRequestApiCall({required int requestUserId, required onErr}) async {
    isNetworkDataLoaded.value = true;
    Map<String, dynamic> params = {};
    params['requested_user'] = requestUserId;
    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.acceptRequest, params: params);

    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      return true;
    } else {
      onErr(responseModel.message);
      return false;
    }
  }

  ///Cancel request api
  cancelRequestApiCall({required int requestUserId, required onErr}) async {
    isNetworkDataLoaded.value = true;
    Map<String, dynamic> params = {};
    params['requested_user'] = requestUserId;
    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.cancelRequest, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      return true;
    } else {
      onErr(responseModel.message);
      return false;
    }
  }


}
