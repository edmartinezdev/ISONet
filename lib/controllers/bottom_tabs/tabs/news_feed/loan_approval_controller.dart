import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';

import '../../../../model/bottom_navigation_models/news_feed_models/loan_list_model.dart';

class LoanApprovalController extends GetxController {
  var loanApprovalList = <LoanData>[].obs;
  var isAllDataLoaded = false.obs;
  var isLoadMoreRunningForViewAll = false;
  var isApiResponseReceive = false.obs;

  ///***** Loan Approval Pagination *****///
  loanApprovalPagination() {
    Logger().i('Loan Approval length :- ${loanApprovalList.length}');
    apiCallLoanApprovalList();
  }

  /// ***** Loan Approval Api call *******///
  apiCallLoanApprovalList({isShowLoader = false}) async {
    ResponseModel<LoanApprovalModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.loanApprovalListApi);
    if(isShowLoader){
      ShowLoaderDialog.dismissLoaderDialog();
    }
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      isApiResponseReceive.value = true;
      if (loanApprovalList.isEmpty) {
        loanApprovalList.value = responseModel.data?.loanData ?? [];
        Logger().i('Loan Approval length :- ${loanApprovalList.length}');
      } else {
        loanApprovalList.addAll(responseModel.data?.loanData ?? []);
        Logger().i('Loan Approval length :- ${loanApprovalList.length}');
      }
      isAllDataLoaded.value = (loanApprovalList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
      return true;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
      return false;
    }
  }

  ///***** Loan Approve & Decline api call *****///
  apiCallLoanApproveDecline({required loanId,required action,required onErr,required onSuccess})async{
    Map<String,dynamic> params ={};
    params['loan_id'] = loanId;
    params['approval_action'] = action;
    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.loanApproveRejectApi,params: params);
    ShowLoaderDialog.dismissLoaderDialog();
    if(responseModel.status == ApiConstant.statusCodeSuccess){
      onSuccess(responseModel.message);
      return true;
    }else{
      onErr(responseModel.message);
      return false;
    }
  }
}
