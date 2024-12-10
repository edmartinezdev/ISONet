import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/news_feed_tab_controller.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:tuple/tuple.dart';

import '../../helper_manager/network_manager/api_const.dart';
import '../../helper_manager/network_manager/remote_service.dart';
import '../../model/dropdown_models/get_companies_list_model.dart';
import '../../model/dropdown_models/userdetail_dropdown_model.dart';
import '../../model/my_profile/my_profile_model.dart';
import '../../model/response_model/responese_datamodel.dart';
import '../../utils/app_common_stuffs/app_logger.dart';
import '../../utils/app_common_stuffs/commom_utils.dart';
import '../../utils/validation/validation.dart';

class EditMyAccountController extends GetxController {
  Rxn<XFile> profileImage = Rxn<XFile>();
  Rxn<XFile> backGroundImage = Rxn<XFile>();

  ImagePicker imagePicker = ImagePicker();
  var userInterest = <InterestIn>[].obs;

  var file = <File>[].obs;
  var temp = <File>[].obs;
  var firstNameChange = ''.obs;
  var lastNameChange = ''.obs;
  var emailChange = ''.obs;
  var phoneChange = ''.obs;
  var formattedPhoneNo = ''.obs;
  var selectedStateName = ''.obs;
  var selectedExpName = ''.obs;
  var selectedExpId = 0.obs;

  var isObscure = true.obs;
  var isEnabled = false.obs;
  var isEditEnable = false.obs;
  var phoneNoForApi = ''.obs;
  var cityChange = ''.obs;
  var stateDropDownList = <StatesDropDown>[].obs;
  var stringDob = ''.obs;
  var yyMMddStringDob = ''.obs;
  Rxn<StatesDropDown> stateDropDownModel = Rxn();

  var companyList = <GetCompaniesListModel>[].obs;
  var searchCompanyList = <GetCompaniesListModel>[].obs;
  var selectedCompanyId = 0.obs;
  var isPublic = true.obs;
  Rxn<ExperienceDropDownModel> experienceDropDownModel = Rxn();
  var positionChange = ''.obs;
  var bioChange = ''.obs;
  var experienceList = <ExperienceDropDownModel>[].obs;
  var experienceErr = ''.obs;
  var isCompanyDataLoad = false.obs;

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

  Future<void> convertXFile() async {
    if (profileImage.value?.path != null) {
      var size = CommonUtils.calculateFileSize(File(profileImage.value!.path));
      if (size > 2) {
        final File files = await CommonUtils.compressImage(image: File(profileImage.value!.path));
        file.add(await FlutterExifRotation.rotateImage(
          path: files.path,
        ));
      } else {
        file.add(File(profileImage.value?.path ?? ''));
      }

      /*file.add(File(profileImage.value?.path ?? ''));*/

    }
    if (backGroundImage.value?.path != null) {
      var size = CommonUtils.calculateFileSize(File(backGroundImage.value!.path));
      if (size > 2) {
        final File files = await CommonUtils.compressImage(image: File(backGroundImage.value!.path));
        temp.add(await FlutterExifRotation.rotateImage(
          path: files.path,
        ));
      } else {
        temp.add(File(backGroundImage.value?.path ?? ''));
      }

      /*temp.add(File(backGroundImage.value?.path ?? ''));*/
    }

    Logger().i('UserProfilePath ==== $file');
  }

  ///******* phone no formatting *******
  convertPhoneInputString(TextEditingValue oldValue, TextEditingValue newValue) {
    Logger().i("OldValue: ${oldValue.text}, NewValue: ${newValue.text}");
    formattedPhoneNo.value = newValue.text;
    if (formattedPhoneNo.value.length == 10) {
      RegExp phone = RegExp(r'(\d{3})(\d{3})(\d{4})');
      var matches = phone.allMatches(newValue.text);
      var match = matches.elementAt(0);
      formattedPhoneNo.value = '(${match.group(1)}) ${match.group(2)}-${match.group(3)}';
    }
  }

  ///******* Get Started Form validation *******
  Tuple2<bool, String> isValidFormForGetStarted({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNo,
    required String city,
    required String state,
    required String position,
    required String expName,
    required String bio,
    required String dateOfBirth,
    required String companyName,
  }) {
    List<Tuple2<ValidationType, String>> arrList = [];
    arrList.add(Tuple2(ValidationType.firstName, firstName));
    arrList.add(Tuple2(ValidationType.lastName, lastName));
    arrList.add(Tuple2(ValidationType.email, email));
    arrList.add(Tuple2(ValidationType.phoneNumber, phoneNo));
    /*arrList.add(Tuple2(ValidationType.city, city));*/
    /*arrList.add(Tuple2(ValidationType.state, state));*/
    /*arrList.add(Tuple2(ValidationType.birthdate, dateOfBirth));*/
    /*arrList.add(Tuple2(ValidationType.dropDownCompany, companyName));*/
    /*arrList.add(Tuple2(ValidationType.position, position));*/
    /*arrList.add(Tuple2(ValidationType.experience, expName));*/
    /*arrList.add(Tuple2(ValidationType.bio, bio));*/

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);

    return Tuple2(validationResult.item1, validationResult.item2);
  }

  ///******* Check button validation function *******
  validateButton(
      {required String firstName,
      required String lastName,
      required String email,
      required String phoneNo,
      required String city,
      required String state,
      required String position,
      required String bio,
      required String dateOfBirth,
      required String companyName}) {
    if ((firstName.isNotEmpty && firstName.length > 1) &&
        (lastName.isNotEmpty && lastName.length > 1) &&
        (email.isNotEmpty && email.isEmail) &&
        (phoneNo.isNotEmpty && phoneNo.length == 14)
        /*(city.isNotEmpty && city.length > 1) &&*/
        /*(state).isNotEmpty &&*/
        /*dateOfBirth.isNotEmpty &&*/
        /*(companyName.isNotEmpty && companyName.length > 1) &&*/
        /*(position.isNotEmpty && position.length > 1) &&*/
        //(experienceDropDownModel.value?.expName ?? '').isNotEmpty &&
        /*(bio.isNotEmpty && bio.length > 1)*/) {
      isEnabled.value = true;
    } else {
      isEnabled.value = false;
    }
  }

  ///******* Open Calender for birthdate selection *******
  Future pickDateRange(BuildContext context, TextEditingController textEditingController) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: textEditingController.text.isNotEmpty ? DateFormat('MM/dd/yyyy').parse(textEditingController.text) : DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),

    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('MM/dd/yyyy').format(pickedDate);
      String yyMMddFormattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      yyMMddStringDob.value = yyMMddFormattedDate;
      stringDob.value = formattedDate;
      //textEditingController.text = stringDob.value;
      return stringDob.value;
    }
  }

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

  ///******* toggle Switch on & off Function *******
  toggleSwitch(bool value) {
    isPublic.value = value;
  }

  ///****** Account update API call params
  accountUpdateApiCall({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNo,
    required String city,
    required String state,
    required String position,
    required String bio,
    required String dateOfBirth,
    required bool isUserPublic,
    required List<int> tagId,
    MyProfileModel? myProfileModel,
    required onError,
    onSuccess
  }) async {
    Map<String, dynamic> requestParams = {};
    requestParams['first_name'] = firstName;
    requestParams['last_name'] = lastName;
    userSingleton.email == email ? null : requestParams['email'] = email;
    requestParams['phone_number'] = phoneNo;
    city.isEmpty ? requestParams['city'] = '' : requestParams['city'] = city;
    state.isEmpty ? requestParams['state'] = ''  : requestParams['state'] = state;
    dateOfBirth.isEmpty ? null : requestParams['dob'] = dateOfBirth;
    selectedCompanyId.value == -1 ? null : requestParams['company_id'] = selectedCompanyId.value;
    position.isEmpty ? requestParams['position'] = '' : requestParams['position'] = position;
    selectedExpId.value == -1 ? null : requestParams['experience_id'] = selectedExpId.value;
    tagId.isNotEmpty ? requestParams['interest_in'] = tagId : requestParams['interest_in'] = '';
    bio.isEmpty ? requestParams['bio'] = '' : requestParams['bio'] = bio;
    requestParams['is_public'] = isUserPublic;

    ResponseModel<MyProfileModel> responseModel = await sharedServiceManager.uploadRequest(
      ApiType.accountUpdate,
      params: requestParams,
      arrFile: [
        file.isEmpty ? AppMultiPartFile() : AppMultiPartFile(localFiles: file, key: 'profile_img'),
        temp.isEmpty ? AppMultiPartFile() : AppMultiPartFile(localFiles: temp, key: 'background_img'),
      ],
    );
    ShowLoaderDialog.dismissLoaderDialog();
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      myProfileModel = responseModel.data;
      NewsFeedController newsFeedController = Get.find();
      newsFeedController.profileImage.value = myProfileModel?.profileImg;
      userSingleton.email = responseModel.data?.email ?? '';
      userSingleton.profileImg = responseModel.data?.profileImg;
      userSingleton.saveUserData();
      Logger().i(userSingleton.email);
      onSuccess(responseModel.message);

      return true;
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
      return false;
    }
  }
}
