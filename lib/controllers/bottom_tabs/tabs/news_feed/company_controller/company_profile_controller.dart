import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/dropdown_models/loan_preferences_models.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';

import '../../../../../model/bottom_navigation_models/news_feed_models/company_profile_model.dart';

class CompanyProfileController extends GetxController {
  Rxn<CompanyProfileModel> companyProfileDetail = Rxn();

  ///Company Profile Screen variable declaration ***//
  var companyId = Get.arguments;
  var companyReview = ''.obs;
  var isEnable = false.obs;
  var isAllCompanyDataLoaded = false.obs;
  var isCompanyDataLoaded = false.obs;
  var minTime = ''.obs;
  var maxTerm = ''.obs;
  var minTimeList = <MinimumTimeListModel>[].obs;
  var maxTermLengthList = <MaxTermLengthListModel>[].obs;
  var getAllIndustryList = <GetAllIndustryListModel>[].obs;
  var getAllStates = <GetStatesListModel>[].obs;
  var resIndustryList = <String>[].obs;
  var resStateList = <String>[].obs;


  ///Company Employees Screen variable declaration ***//

  ///company profile api call
  companyProfileApiCall() async {
    Map<String, dynamic> params = {};
    params['company_id'] = companyId;
    ResponseModel<CompanyProfileModel> response = await sharedServiceManager.createPostRequest<CompanyProfileModel>(typeOfEndPoint: ApiType.companyProfile, params: params);
    if (isAllCompanyDataLoaded.value == false) {
      ShowLoaderDialog.dismissLoaderDialog();
    }

    if (response.status == ApiConstant.statusCodeSuccess) {
      isAllCompanyDataLoaded.value = true;
      companyProfileDetail.value = response.data;
    } else {
      isAllCompanyDataLoaded.value = true;
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
    }
  }

  ///add company review api call
  addCompanyReviewApi({required onErr}) async {
    Map<String, dynamic> params = {};
    params['company_id'] = companyId;
    params['review'] = companyReview.value;
    ResponseModel responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.createCompanyReview, params: params);
    ShowLoaderDialog.dismissLoaderDialog();
    if (responseModel.status == ApiConstant.statusCodeSuccess || responseModel.status == ApiConstant.statusCodeCreated) {
      return true;
    } else {
      onErr(responseModel.message);
      return false;
    }
  }

  Future fetchMinimumTimeList() async {
    ResponseModel<List<MinimumTimeListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.timeInBusinessList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      minTimeList.value = responseModel.data ?? [];
      for (int i = 0; i < minTimeList.length; i++) {
        if (minTimeList[i].id == companyProfileDetail.value?.minTimeBusiness) {
          minTime.value = minTimeList[i].bussinessTime ?? '';
        }
      }
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  Future fetchMaxTermList() async {
    ResponseModel<List<MaxTermLengthListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.maxTermLengthList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      maxTermLengthList.value = responseModel.data ?? [];
      /*final maxLength = maxTermLengthList.firstWhere((term) => term.id == (companyProfileDetail.value?.maxTermLength ?? -1), orElse: () => MaxTermLengthListModel());
      if (maxLength != 0) {
        final term = maxLength.type == 'MO' ? 'Month' : 'Year';
        final termLength = maxLength.maxTerm ?? -1;
        maxTerm.value = termLength > 1 ? '$termLength ${term}s' : '$termLength $term';
      }*/

      for (int i = 0; i < maxTermLengthList.length; i++) {
        if (maxTermLengthList[i].id == (companyProfileDetail.value?.maxTermLength ?? -1)) {
          maxTerm.value = maxTermLengthList[i].type == 'MO'
              ? (maxTermLengthList[i].maxTerm ?? -1) > 1
                  ? '${maxTermLengthList[i].maxTerm ?? -1} Months'
                  : '${maxTermLengthList[i].maxTerm ?? -1} Month'
              : (maxTermLengthList[i].maxTerm ?? -1) > 1
                  ? '${maxTermLengthList[i].maxTerm ?? -1} Years'
                  : '${maxTermLengthList[i].maxTerm ?? -1} Year';
        }
      }
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  Future fetchIndustryList() async {
    ResponseModel<List<GetAllIndustryListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.industriesList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      getAllIndustryList.value = responseModel.data ?? [];
      for (var industry in getAllIndustryList) {
        if (companyProfileDetail.value?.restrIndusties?.contains(industry.id) == true) {
          resIndustryList.add(industry.industryName ?? '');
        }
      }
     /* for (int a = 0; a < getAllIndustryList.length; a++) {
        for (int i = 0; i < (companyProfileDetail.value?.restrIndusties?.length ?? 0); i++) {
          if (companyProfileDetail.value?.restrIndusties?[i] == getAllIndustryList[a].id) {
            resIndustryList.add(getAllIndustryList[a].industryName ?? '');
            continue;
          }
        }
      }*/

      Logger().i(resIndustryList);
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  Future fetchStatesList() async {
    ResponseModel<List<GetStatesListModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.stateList,
    );
    /*ShowLoaderDialog.dismissLoaderDialog();*/
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      getAllStates.value = responseModel.data ?? [];
      for (var state in getAllStates) {
        if (companyProfileDetail.value?.restrState?.contains(state.id) == true) {
          resStateList.add(state.stateName ?? '');
        }
      }

      /*for (int a = 0; a < getAllStates.length; a++) {
        for (int i = 0; i < (companyProfileDetail.value?.restrState?.length ?? 0); i++) {
          if (companyProfileDetail.value?.restrState?[i] == getAllStates[a].id) {
            resStateList.add(getAllStates[a].stateName ?? '');
            continue;
          }
        }
      }*/

      Logger().i(resStateList);
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  clearList() {
    getAllIndustryList.clear();
    getAllStates.clear();
    resIndustryList.clear();
    resStateList.clear();
    maxTermLengthList.clear();
    minTimeList.clear();
    minTime.value = '';
    maxTerm.value = '';
  }
}
