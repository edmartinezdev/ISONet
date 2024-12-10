import 'dart:io';

import 'package:get/get.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/interest_chips_model.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';

import '../../model/bottom_navigation_models/news_feed_models/feed_category_model.dart';
import '../../utils/app_common_stuffs/snackbar_util.dart';

class UserInterestController extends GetxController {
  ///********* variables declaration ********///
  var temString = ''.obs;

  var interestChipsList = <InterestChipListModel>[].obs;
  Rxn<InterestChipListModel> interestChipModel = Rxn();
  var selectedInterestList = <int>[].obs;
  var selectedInterestNameList = <String>[].obs;
  var temList = [].obs;

  ///********* Category interest select *********//
  var categoryChipList = <FeedCategoryList>[].obs;
  var selectedCategoryList = <int>[].obs;
  var selectedCategoryNameList = <String>[].obs;

  ///*******************************************

  /// *** fetch interest chips
  onInterestTap(int index) {
    interestChipsList[index].isSelected.value = !interestChipsList[index].isSelected.value;
    if (selectedInterestList.contains(interestChipsList[index].pk)) {
      selectedInterestList.remove(interestChipsList[index].pk);
      selectedInterestNameList.remove(interestChipsList[index].tagName);

      Logger().i(selectedInterestList);
    } else {
      selectedInterestList.add(interestChipsList[index].pk ?? 0);
      selectedInterestNameList.add(interestChipsList[index].tagName ?? '');
      Logger().i(selectedInterestList);
    }
  }

  /// *** fetch category chips
  onCategoryTap(int index) {
    categoryChipList[index].isCategorySelect.value = !categoryChipList[index].isCategorySelect.value;
    if (selectedCategoryList.contains(categoryChipList[index].id)) {
      selectedCategoryList.remove(categoryChipList[index].id);
      selectedCategoryNameList.remove(categoryChipList[index].categoryName);

      Logger().i(selectedCategoryList);
    } else {
      selectedCategoryList.add(categoryChipList[index].id ?? 0);
      selectedCategoryNameList.add(categoryChipList[index].categoryName ?? '');
      Logger().i(selectedCategoryList);
    }
  }

  ///fetch feed category
  fetchFeedCategory({List<int>? tag, bool? isEditInterest}) async {
    Map<String, dynamic> params = {};
    params['start'] = 1;
    params['limit'] = 500;
    ResponseModel<FeedCategoryModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.feeCategoryList, params: params);
    if (isEditInterest == false) {
      ShowLoaderDialog.dismissLoaderDialog();
    }
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      // categoryChipList.value = responseModel.data;
      categoryChipList.value = responseModel.data?.feedCategoryList ?? [];
      if (responseModel.status == ApiConstant.statusCodeSuccess) {
        categoryChipList.value = responseModel.data?.feedCategoryList ?? [];
        if (tag?.length != null) {
          for (int i = 0; i < categoryChipList.length; i++) {
            if (tag!.contains(categoryChipList[i].id)) {
              categoryChipList[i].isCategorySelect.value = true;
            }
          }
        }
      }
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  /// *** fetch interest chips
  fetchInterestChips({required onErr, List<int>? tag, bool? isEditInterest}) async {
    ResponseModel<List<InterestChipListModel>> responseModel = await sharedServiceManager.createGetRequest(typeOfEndPoint: ApiType.interestChips);
    if (isEditInterest == false) {
      ShowLoaderDialog.dismissLoaderDialog();
    }

    // if (responseModel.status == ApiConstant.statusCodeSuccess) {
    //   interestChipsList.value = responseModel.data ?? [];
    //   if(tag?.length != null){
    //     for(int i =0 ;i< interestChipsList.length;i++){
    //       if(tag!.contains(interestChipsList[i].pk)){
    //         interestChipsList[i].isSelected.value = true;
    //       }
    //     }
    //   }
    //
    // }
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      interestChipsList.value = responseModel.data ?? [];
      if (tag?.length != null) {
        for (int i = 0; i < interestChipsList.length; i++) {
          if (tag!.contains(interestChipsList[i].pk)) {
            interestChipsList[i].isSelected.value = true;
          }
        }
      }
    } else {
      onErr(responseModel.message);
    }
  }

  /// *** userStage4 MultiPart
  apiCallSignUpStage4({required List<File> profileImage, required List<File> backGroundImage, required onErr, bool? isSkip, bool isSkipBackGroundImage = false}) async {
    ShowLoaderDialog.showLinearProgressIndicatorForFileUpload(context: Get.context!);
    Map<String, dynamic> requestParams = {};
    // 'interest_in': selectedInterestList,
    isSkip == true ? null : requestParams['interest_in'] = selectedCategoryList;

    ResponseModel<UserModel> responseModel = await sharedServiceManager.uploadRequest(
      ApiType.signUpStage4,
      params: requestParams,
      arrFile: isSkipBackGroundImage == true
          ? [
              AppMultiPartFile(localFiles: profileImage, key: 'profile_img'),
            ]
          : [
              AppMultiPartFile(localFiles: profileImage, key: 'profile_img'),
              AppMultiPartFile(localFiles: backGroundImage, key: 'background_img'),
            ],
    );

    ShowLoaderDialog.dismissLoaderDialog();

    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      ///***** Api Success *****///
      userSingleton.updateValue(responseModel.data?.toJson() ?? <String, dynamic>{});
      return true;
    } else {
      ///***** Api Error *****///
      onErr(responseModel.message);
      return false;
    }
  }
}
