import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:tuple/tuple.dart';

import '../../../../../helper_manager/network_manager/api_const.dart';
import '../../../../../helper_manager/network_manager/remote_service.dart';
import '../../../../../model/bottom_navigation_models/news_feed_models/company_profile_model.dart';
import '../../../../../model/bottom_navigation_models/news_feed_models/feed_list_model.dart';
import '../../../../../model/bottom_navigation_models/news_feed_models/setting_model/company_user_data_model.dart';
import '../../../../../model/response_model/responese_datamodel.dart';
import '../../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../../utils/validation/validation.dart';

class CompanySettingController extends GetxController {
  var isTapped = false.obs;
  var currentTabIndex = 0.obs;
  var phoneNoForApi = ''.obs;
  double latitude = 0.0;
  double longitude = 0.0;
  Rxn<CompanyProfileModel> companyProfileDetail = Rxn();
  var isEnable = false.obs;
  var isLoadMore = false;
  var isApiResponseReceive = false.obs;

  //Rxn<UserDetails> companyUserDetail = Rxn();
  var companyUserDetail = <UserDetails>[].obs;
  var isProfileEdit = false.obs;
  var myCompanyTab = <MyCompanyTabs>[
    MyCompanyTabs(tabName: 'Details'),
    MyCompanyTabs(tabName: 'Reviews'),
    MyCompanyTabs(tabName: 'Employees'),
  ].obs;
  TextEditingController companyTextController = TextEditingController();
  TextEditingController addressTextController = TextEditingController();
  TextEditingController cityTextController = TextEditingController();
  TextEditingController stateTextController = TextEditingController();
  TextEditingController zipCodeTextController = TextEditingController();
  TextEditingController phoneNumberTextController = TextEditingController();
  TextEditingController websiteTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();

  ///Company Review & Employees Variables
  var pageRecordLimit = 5.obs;
  var pageLimit = 1.obs;
  var totalRecord = 0.obs;
  var isReviewTabEnable = false.obs;
  ScrollController scrollController = ScrollController();
  var isAllDataLoaded = false.obs;
  var companyReviewList = <CompanyReviewListData>[].obs;
  var companyEmployeeList = <User>[].obs;
  var isLoadMoreRunningForViewAll = false;

  ///company profile api call
  companyProfileApiCall({bool isShowLoader = false}) async {
    Map<String, dynamic> params = {};
    params['company_id'] = userSingleton.companyId;
    ResponseModel<CompanyProfileModel> response = await sharedServiceManager.createPostRequest<CompanyProfileModel>(typeOfEndPoint: ApiType.companyProfile, params: params);
    //CircularProgressIndicator();
    if(isShowLoader){
      ShowLoaderDialog.dismissLoaderDialog();
    }

    if (response.status == ApiConstant.statusCodeSuccess) {
      companyProfileDetail.value = response.data;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
    }
  }

  ///update Company Profile Api
  updateCompanyProfileApiCall() async {
    Map<String, dynamic> params = {};
    //params['company_id'] = userSingleton.companyId;
    companyProfileDetail.value?.companyName == companyTextController.text ? null : params['company_name'] = companyTextController.text;
    params['address'] = addressTextController.text;
    params['city'] = cityTextController.text;
    params['state'] = stateTextController.text;
    params['zipcode'] = zipCodeTextController.text;
    if (latitude != 0.0 && longitude != 0.0) {
      params['latitude'] = latitude;
      params['longitude'] = longitude;
    }
    params['phone_number'] = phoneNoForApi.value;
    params['website'] = websiteTextController.text;
    params['description'] = descriptionTextController.text;

    ResponseModel<CompanyProfileModel> response = await sharedServiceManager.createPostRequest<CompanyProfileModel>(typeOfEndPoint: ApiType.updateCompanyDetails, params: params);
    //ShowLoaderDialog.dismissLoaderDialog();
    if (response.status == ApiConstant.statusCodeSuccess) {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.success, message: response.message);
      companyProfileApiCall();
      return true;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
      return false;
    }
  }



  ///update Company Profile Api
  /*reviewListApiCall() async {
    Map<String, dynamic> params = {};
    //params['company_id'] = userSingleton.companyId;
    ResponseModel<CompanySettingModel> response = await sharedServiceManager.createPostRequest<CompanySettingModel>(typeOfEndPoint: ApiType.companyReviewData, params: params);
    //ShowLoaderDialog.dismissLoaderDialog();
    if (response.status == ApiConstant.statusCodeSuccess) {
      companyReviewList.value = response.data?.reviewListData ?? [];
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: response.message);
    }
  }*/

  companyReviewListApi({bool isShowLoader = false}) async {
    Map<String, dynamic> params = {};
    params['limit'] = defaultFetchLimit;
    params['start'] = companyReviewList.length;
    params['company_id'] = userSingleton.companyId;
    ResponseModel<CompanyReviewModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.companyListReview, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      totalRecord.value = responseModel.data?.totalRecord ?? 0;
      if(isShowLoader){
        ShowLoaderDialog.dismissLoaderDialog();
      }
      isApiResponseReceive.value = true;
      if (companyReviewList.isEmpty) {
        companyReviewList.value = responseModel.data?.companyReviewListData ?? [];
      } else {
        companyReviewList.addAll(responseModel.data?.companyReviewListData ?? []);
      }
      isAllDataLoaded.value = (companyReviewList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  ///get company employee data api function
  companyEmployeeListApi({bool isShowLoader = false}) async {
    Map<String, dynamic> params = {};
    params['company_id'] = userSingleton.companyId;
    params['start'] = companyEmployeeList.length;
    params['limit'] = defaultFetchLimit;

    //params['search_content'] = searchEmployee.value;

    ResponseModel<CompanyEmployeeModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.companyEmployeeList, params: params);
    if(isShowLoader){
      ShowLoaderDialog.dismissLoaderDialog();
    }
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      totalRecord.value = responseModel.data?.totalRecord ?? 0;
      isApiResponseReceive.value = true;
      if (companyEmployeeList.isEmpty) {
        companyEmployeeList.value = responseModel.data?.companyEmployeeListData ?? [];
      } else {
        companyEmployeeList.addAll(responseModel.data?.companyEmployeeListData ?? []);
      }
      isAllDataLoaded.value = (companyEmployeeList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  ///Review Pagination Function
  pagination({required int companyId}) {
    scrollController.addListener(
      () {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent) {
          if (isReviewTabEnable.value) {
            if (companyReviewList.length != totalRecord.value && !isLoadMore) {
              pageLimit.value++;
              Logger().i(pageLimit.value);
              companyReviewListApi();
            } else {
              isAllDataLoaded.value = true;
              isLoadMore = isAllDataLoaded.value;
              Logger().i('All Data Loaded');
            }
          } else {
            if (companyEmployeeList.length != totalRecord.value && !isLoadMore) {
              pageLimit.value++;
              Logger().i(pageLimit.value);
              //companyUserDataApiCall(companyId: companyId);
            } else {
              isAllDataLoaded.value = true;
              Logger().i('All Data Loaded');
            }
          }
        }
      },
    );
  }

  ///pagination loader
  paginationLoadData() {
    if (isReviewTabEnable.value) {
      if (companyReviewList.length.toString() == totalRecord.value.toString()) {
        isAllDataLoaded.value = true;
        isLoadMore = isAllDataLoaded.value;
        return true;
      } else {
        isAllDataLoaded.value = false;
        isLoadMore = isAllDataLoaded.value;
        return false;
      }
    } else {
      if (companyEmployeeList.length.toString() == totalRecord.value.toString()) {
        isAllDataLoaded.value = true;
        isLoadMore = isAllDataLoaded.value;
        return true;
      } else {
        isAllDataLoaded.value = false;
        isLoadMore = isAllDataLoaded.value;
        return false;
      }
    }
  }

  ///******* Update company Form validation *******
  Tuple2<bool, String> isValidUpdateCompanyFormForDetails() {
    List<Tuple2<ValidationType, String>> arrList = [];
    arrList.add(Tuple2(ValidationType.company, companyTextController.text));
    arrList.add(Tuple2(ValidationType.address, addressTextController.text));
    arrList.add(Tuple2(ValidationType.city, cityTextController.text));
    arrList.add(Tuple2(ValidationType.state, stateTextController.text));
    arrList.add(Tuple2(ValidationType.zipCode, zipCodeTextController.text));
    arrList.add(Tuple2(ValidationType.phoneNumber, phoneNumberTextController.text));
    arrList.add(Tuple2(ValidationType.description, descriptionTextController.text));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);

    return Tuple2(validationResult.item1, validationResult.item2);
  }

  ///******* button enable disable validation *******
  validateButton() {
    if ((companyTextController.text.isNotEmpty && companyTextController.text.length > 1) &&
        addressTextController.text.isNotEmpty &&
        (cityTextController.text.isNotEmpty && cityTextController.text.length > 1) &&
        stateTextController.text.isNotEmpty &&
        zipCodeTextController.text.isNotEmpty &&
        zipCodeTextController.text.length == 5 &&
        (phoneNumberTextController.text.isNotEmpty && phoneNumberTextController.text.length == 14) &&
        (descriptionTextController.text.isNotEmpty && descriptionTextController.text.length > 1)) {
      isEnable.value = true;
    } else {
      isEnable.value = false;
    }
  }

  companyReviewEmployeePagination() {
    pageLimit.value++;
    Logger().i(pageLimit.value);
    if (isReviewTabEnable.value) {
      companyReviewListApi();
    } else {
      companyEmployeeListApi();
    }
  }
}

class MyCompanyTabs {
  String? tabName;
  RxBool isTabSelected = false.obs;

  MyCompanyTabs({this.tabName});
}
