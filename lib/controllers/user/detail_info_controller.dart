import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/dropdown_models/get_companies_list_model.dart';
import 'package:iso_net/model/dropdown_models/userdetail_dropdown_model.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:tuple/tuple.dart';

import '../../utils/validation/validation.dart';

class DetailInfoController extends GetxController {
  ///********* variables declaration ********///
  var cityChange = ''.obs;
  var stateChange = ''.obs;
  var positionChange = ''.obs;
  var bioChange = ''.obs;
  var experienceChange = ''.obs;
  var stringDob = ''.obs;
  var yyMMddStringDob = ''.obs;
  var companyName = ''.obs;

  var isPublic = true.obs;
  var isButtonEnable = false.obs;

  var companyList = <GetCompaniesListModel>[].obs;
  var searchCompanyList = <GetCompaniesListModel>[].obs;
  var selectedCompanyId = ''.obs;
  var isCompanyDataLoad = false.obs;

  Rxn<StatesDropDown> stateDropDownModel = Rxn();
  var stateDropDownList = <StatesDropDown>[].obs;

  Rxn<ExperienceDropDownModel> experienceDropDownModel = Rxn();
  TextEditingController companyNameEditingController = TextEditingController();
  var experienceList = <ExperienceDropDownModel>[].obs;
  var experienceErr = ''.obs;

  var now = DateTime.now().obs;
  Rx<DateTime> chooseDate = DateTime.now().obs;

  ///*******************************************

  ///******* Get API for companies list
  Future fetchCompaniesList() async {
    ResponseModel<List<GetCompaniesListModel>> companiesList = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.getCompaniesList,
    );

    if (companiesList.status == ApiConstant.statusCodeSuccess) {
      companyList.value = companiesList.data ?? [];
    }
    loadCompanyListData();
  }

  Future fetchExperienceList() async {
    ResponseModel<List<ExperienceDropDownModel>> responseModel = await sharedServiceManager.createGetRequest(
      typeOfEndPoint: ApiType.getExperienceList,
    );
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      experienceList.value = responseModel.data ?? [];
    } else {
      experienceErr.value = responseModel.message;
    }
  }

  ///******* Company Search Function *******
  onSearch(String search) {
    searchCompanyList.value = companyList
        .where(
          (e) => e.companyName!.toLowerCase().contains(
                search.toLowerCase(),
              ),
        )
        .toList();
  }

  ///******* Load company list while user tap on company name field *******
  loadCompanyListData() {
    isCompanyDataLoad.value = true;
    searchCompanyList.value = companyList;
  }

  ///******* Open Calender for birthdate selection *******
  Future pickDateRange(BuildContext context, TextEditingController textEditingController) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),

    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('MM/dd/yyyy').format(pickedDate);
      String yyMMddFormattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      yyMMddStringDob.value = yyMMddFormattedDate;
      stringDob.value = formattedDate;
      textEditingController.text = stringDob.value;
    }
  }


  ///***** Open calender for ios birthdate selection ******///

  ///******* toggle Switch on & off Function *******
  toggleSwitch(bool value) {
    isPublic.value = value;
  }

  ///******* Get Started Form validation *******
  Tuple2<bool, String> isValidFormForDetails({required String dateOfBirth, required String companyName}) {
    List<Tuple2<ValidationType, String>> arrList = [];
    arrList.add(Tuple2(ValidationType.city, cityChange.value));
    arrList.add(Tuple2(ValidationType.state, stateDropDownModel.value?.stateName ?? ''));
    arrList.add(Tuple2(ValidationType.birthdate, dateOfBirth));
    arrList.add(Tuple2(ValidationType.dropDownCompany, companyName));
    arrList.add(Tuple2(ValidationType.position, positionChange.value));
    /*arrList.add(Tuple2(ValidationType.experience, (experienceDropDownModel.value?.expValue ?? '').toString()));*/
    arrList.add(Tuple2(ValidationType.bio, bioChange.value));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);

    return Tuple2(validationResult.item1, validationResult.item2);
  }

  ///******* button enable disable validation *******
  validateButton({required String dateOfBirth, required String companyName}) {
    if ((cityChange.value.isNotEmpty && cityChange.value.length > 1) &&
        (stateDropDownModel.value?.stateName ?? '').isNotEmpty &&
        dateOfBirth.isNotEmpty &&
        (companyName.isNotEmpty && companyName.length > 1) &&
        (positionChange.value.isNotEmpty && positionChange.value.length > 1) &&
        /*(experienceDropDownModel.value?.expValue ?? '').toString().isNotEmpty &&*/
        (bioChange.value.isNotEmpty && bioChange.value.length > 1)) {
      isButtonEnable.value = true;
    } else {
      isButtonEnable.value = false;
    }
  }

  detailInfoApiCall()async{
    ///Fetching company & experience dropdown list
    await fetchCompaniesList();
    await fetchExperienceList();
    if(companyList.length != 0 && userSingleton.companyId != null){

      for (int i = 0; i < companyList.length; i++) {
        if (companyList[i].id == userSingleton.companyId) {
          companyNameEditingController.text = companyList[i].companyName ?? '';
        }
      }

    }
  }

  ///****** sign up stage 3 API call params
  Future<bool> apiCallSignUpStage3({required onError, bool isSkip =false}) async {
    ShowLoaderDialog.showLoaderDialog(Get.context!);
    Map<String, dynamic> requestParams = {};
    if(isSkip){
       requestParams = {};
    }else{
      requestParams['city'] = cityChange.value;
      requestParams['state'] = stateDropDownModel.value?.stateName ?? '';
      requestParams['dob'] = yyMMddStringDob.value;
      userSingleton.companyId != null ? null : requestParams['company_id'] =   selectedCompanyId.value;
      requestParams['position'] = positionChange.value;
      experienceDropDownModel.value?.id == null ? null : requestParams['experience_id'] = experienceDropDownModel.value?.id;
      requestParams['bio'] = bioChange.value;
      requestParams['is_public'] = isPublic.value;
    }


    ResponseModel<UserModel> signUpResponse = await sharedServiceManager.createPostRequest(
      typeOfEndPoint: ApiType.signUpStage3,
      params: requestParams,
    );
    ShowLoaderDialog.dismissLoaderDialog();
    if (signUpResponse.status == ApiConstant.statusCodeSuccess) {
      ///***** Api Success *****//
      await userSingleton.updateValue(
        signUpResponse.data?.toJson() ?? <String, dynamic>{},
      );
      return true;
    } else {
      ///***** Api Error *****//
      onError(signUpResponse.message);
      return false;
    }
  }

  @override
  void onInit() {
    stateDropDownList.value = [
      StatesDropDown(stateId: 0, stateName: 'Alabama', stateAlias: 'AL'),
      StatesDropDown(stateId: 1, stateName: 'Alaska', stateAlias: 'AK'),
      StatesDropDown(stateId: 2, stateName: 'Arizona', stateAlias: 'AZ'),
      StatesDropDown(stateId: 3, stateName: 'Arkansas', stateAlias: 'AR'),
      StatesDropDown(stateId: 4, stateName: 'California', stateAlias: 'CA'),
      StatesDropDown(stateId: 5, stateName: 'Colorado', stateAlias: 'CO'),
      StatesDropDown(stateId: 6, stateName: 'Connecticut', stateAlias: 'CT'),
      StatesDropDown(stateId: 7, stateName: 'Delaware', stateAlias: 'DE'),
      StatesDropDown(stateId: 8, stateName: 'District of Columbia', stateAlias: 'DC'),
      StatesDropDown(stateId: 9, stateName: 'Florida', stateAlias: 'FL'),
      StatesDropDown(stateId: 10, stateName: 'Georgia', stateAlias: 'GA'),
      StatesDropDown(stateId: 11, stateName: 'Hawaii', stateAlias: 'HI'),
      StatesDropDown(stateId: 12, stateName: 'Idaho', stateAlias: 'ID'),
      StatesDropDown(stateId: 13, stateName: 'Illinois', stateAlias: 'IL'),
      StatesDropDown(stateId: 14, stateName: 'Indiana', stateAlias: 'IN'),
      StatesDropDown(stateId: 15, stateName: 'Iowa', stateAlias: 'IA'),
      StatesDropDown(stateId: 16, stateName: 'Kansas', stateAlias: 'KS'),
      StatesDropDown(stateId: 17, stateName: 'Kentucky', stateAlias: 'KY'),
      StatesDropDown(stateId: 18, stateName: 'Louisiana', stateAlias: 'LA'),
      StatesDropDown(stateId: 19, stateName: 'Maine', stateAlias: 'ME'),
      StatesDropDown(stateId: 20, stateName: 'Maryland', stateAlias: 'MD'),
      StatesDropDown(stateId: 21, stateName: 'Massachusetts', stateAlias: 'MA'),
      StatesDropDown(stateId: 22, stateName: 'Michigan', stateAlias: 'MI'),
      StatesDropDown(stateId: 23, stateName: 'Minnesota', stateAlias: 'MN'),
      StatesDropDown(stateId: 24, stateName: 'Mississippi', stateAlias: 'MS'),
      StatesDropDown(stateId: 25, stateName: 'Missouri', stateAlias: 'MO'),
      StatesDropDown(stateId: 26, stateName: 'Montana', stateAlias: 'MT'),
      StatesDropDown(stateId: 27, stateName: 'Nebraska', stateAlias: 'NE'),
      StatesDropDown(stateId: 28, stateName: 'Nevada', stateAlias: 'NV'),
      StatesDropDown(stateId: 29, stateName: 'New Hampshire', stateAlias: 'NH'),
      StatesDropDown(stateId: 30, stateName: 'New Jersey', stateAlias: 'NJ'),
      StatesDropDown(stateId: 31, stateName: 'New Mexico', stateAlias: 'NM'),
      StatesDropDown(stateId: 32, stateName: 'New York', stateAlias: 'NY'),
      StatesDropDown(stateId: 33, stateName: 'North Carolina', stateAlias: 'NC'),
      StatesDropDown(stateId: 34, stateName: 'North Dakota', stateAlias: 'ND'),
      StatesDropDown(stateId: 35, stateName: 'Ohio', stateAlias: 'OH'),
      StatesDropDown(stateId: 36, stateName: 'Oklahoma', stateAlias: 'OK'),
      StatesDropDown(stateId: 37, stateName: 'Oregon', stateAlias: 'OR'),
      StatesDropDown(stateId: 38, stateName: 'Pennsylvania', stateAlias: 'PA'),
      StatesDropDown(stateId: 39, stateName: 'Rhode Island', stateAlias: 'RI'),
      StatesDropDown(stateId: 40, stateName: 'South Carolina', stateAlias: 'SC'),
      StatesDropDown(stateId: 41, stateName: 'South Dakota', stateAlias: 'SD'),
      StatesDropDown(stateId: 42, stateName: 'Tennessee', stateAlias: 'TN'),
      StatesDropDown(stateId: 43, stateName: 'Texas', stateAlias: 'TX'),
      StatesDropDown(stateId: 44, stateName: 'Utah', stateAlias: 'UT'),
      StatesDropDown(stateId: 45, stateName: 'Vermont', stateAlias: 'VT'),
      StatesDropDown(stateId: 46, stateName: 'Virginia', stateAlias: 'VA'),
      StatesDropDown(stateId: 47, stateName: 'Washington', stateAlias: 'WA'),
      StatesDropDown(stateId: 48, stateName: 'West Virginia', stateAlias: 'WV'),
      StatesDropDown(stateId: 49, stateName: 'Wisconsin', stateAlias: 'WI'),
      StatesDropDown(stateId: 50, stateName: 'Wyoming', stateAlias: 'WY'),
      StatesDropDown(stateId: 51, stateName: 'American Samoa', stateAlias: 'AS'),
      StatesDropDown(stateId: 52, stateName: 'Guam', stateAlias: 'GA'),
      StatesDropDown(stateId: 53, stateName: 'Northern Marian Islands', stateAlias: 'NP'),
      StatesDropDown(stateId: 54, stateName: 'Puerto Rico', stateAlias: 'PR'),
      StatesDropDown(stateId: 55, stateName: 'U.S. Virgin Islands', stateAlias: 'VI'),
    ];
    super.onInit();
  }
}
