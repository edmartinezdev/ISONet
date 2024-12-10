import 'package:get/get.dart';
import 'package:tuple/tuple.dart';

import '../../../../helper_manager/network_manager/api_const.dart';
import '../../../../helper_manager/network_manager/remote_service.dart';
import '../../../../model/bottom_navigation_models/search_model/findfunder_model.dart';
import '../../../../model/dropdown_models/loan_preferences_models.dart';
import '../../../../model/response_model/responese_datamodel.dart';
import '../../../../ui/style/showloader_component.dart';
import '../../../../utils/validation/validation.dart';

class FindFunderController extends GetxController{
  Rxn<MinimumMonthRevenueListModel> minMonthRevModel = Rxn();
  Rxn<MinimumTimeListModel> minTimeRevModel = Rxn();
  Rxn<CreditRequirementModel> creditRequirementModel = Rxn();
  Rxn<GetAllIndustryListModel> getAllIndustryListModel = Rxn();
  Rxn<GetStatesListModel> getStatesListModel = Rxn();
  var resIndustryList = <int>[].obs;
  var resStateList = <int>[].obs;
  var selectedStateChipList = <GetStatesListModel>[].obs;
  var selectedResIndustryChipList = <GetAllIndustryListModel>[].obs;
  var getAllIndustryList = <GetAllIndustryListModel>[].obs;
  var getAllStates = <GetStatesListModel>[].obs;
  var searchResIndustryList = <GetAllIndustryListModel>[].obs;
  var searchGetAllStates = <GetStatesListModel>[].obs;
  var monthlyRevenueList = <MinimumMonthRevenueListModel>[].obs;
  var minTimeList = <MinimumTimeListModel>[].obs;
  var creditRequirementList = <CreditRequirementModel>[].obs;
  var isEnabled = false.obs;



  var funderCompanyList = <CompanyList>[].obs;


  ///******* Find Funder Form validation *******
  Tuple2<bool, String> isValidFindFunderForm() {
    List<Tuple2<ValidationType, String>> arrList = [];
    arrList.add(Tuple2(ValidationType.creditRequirement, creditRequirementModel.value?.reqScore ?? ''));
    arrList.add(Tuple2(ValidationType.minTimeInBus, (minTimeRevModel.value?.bussinessTime ?? "").toString()));
    arrList.add(Tuple2(ValidationType.minMonthlyRev, minMonthRevModel.value?.revenue ?? ''));
    arrList.add(Tuple2(ValidationType.findFunderIndustry, (resIndustryList).toString()));
    arrList.add(Tuple2(ValidationType.findFunderState, (resStateList).toString()));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);

    return Tuple2(validationResult.item1, validationResult.item2);
  }

  ///******* button enable disable validation *******

  validateFindFunderButton() {
    if ((creditRequirementModel.value?.reqScore ?? '').isNotEmpty &&
        (" ${minTimeRevModel.value?.bussinessTime ?? 0.0}").isNotEmpty &&
        (minMonthRevModel.value?.revenue ?? '').isNotEmpty &&
        resIndustryList.isNotEmpty &&
        resStateList.isNotEmpty)
      // (" ${resIndustryList.length}").isNotEmpty &&
      //(" ${resStateList.length}").isNotEmpty)
        {
      isEnabled.value = true;
    } else {
      isEnabled.value = false;
    }
  }

  ///Find Funder List Api Call Function

  findFunderApiCall({required onErr})async{
    Map<String,dynamic> params = {};
    params['credit_score'] = creditRequirementModel.value?.id ?? 0;
    params['min_monthly_rev'] = minMonthRevModel.value?.id ?? '';
    params['min_time_business'] = minTimeRevModel.value?.id ?? 0;
    params['industries'] = resIndustryList;
    params['states'] = resStateList;

    ResponseModel<FindFunderModel> responseModel = await sharedServiceManager.uploadRequest(ApiType.findFunder,params: params);
    ShowLoaderDialog.dismissLoaderDialog();
    if(ApiConstant.statusCodeSuccess == ApiConstant.statusCodeSuccess){
      funderCompanyList.value = responseModel.data?.companyList ?? [];
      return true;
    }else{
      onErr(responseModel.message);
      return false;
    }
  }

}