import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/network_manager/remote_service.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/extensions/string_extensions.dart';
import 'package:tuple/tuple.dart';
import 'package:video_compress/video_compress.dart';

import '../../../../model/bottom_navigation_models/news_feed_models/feed_category_model.dart';
import '../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../utils/app_common_stuffs/commom_utils.dart';
import '../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../../utils/validation/validation.dart';

class CreateFeedController extends GetxController {
  var postImageVideoList = <XFile>[].obs;
  var tempDisplayList = <XFile>[].obs;
  var file = <File>[].obs;
  var temp = <File>[].obs;

  var description = ''.obs;
  var createSelectionList = <CreateFeedSelection>[].obs;
  var createFeedTypeStringApi = ''.obs;
  var selectedCategoriesName = ''.obs;
  Rxn selectedCategoryId = Rxn();

  Rxn<FeedCategoryModel> feedCategoryModel = Rxn();
  var searchFeedCategoryList = <FeedCategoryList>[].obs;
  var feedCategoryList = <FeedCategoryList>[].obs;
  var thumbnail = ''.obs;

  var isPostButtonEnable = false.obs;
  var percentageIndicatorValue = Rxn();

  ///******* validation function of create post *******
  Tuple2<bool, String> isValidCreatePost({bool isFromFeed = false}) {
    List<Tuple2<ValidationType, String>> arrList = [];
    if (isFromFeed == false) {
      arrList.add(Tuple2(ValidationType.feedCategory, selectedCategoriesName.value));
    }
    arrList.add(Tuple2(ValidationType.feedContent, description.value));

    final validationResult = Validation().checkValidationForTextFieldWithType(list: arrList);
    return Tuple2(validationResult.item1, validationResult.item2);
  }

  ///******* Check post button validation function *******
  validateButton({bool isFromFeed = false}) {
    if (isFromFeed == false) {
      if (description.value.isNotEmpty && selectedCategoriesName.value.isNotEmpty) {
        isPostButtonEnable.value = true;
      }
    } else if (isFromFeed) {
      if (description.value.isNotEmpty) {
        isPostButtonEnable.value = true;
      }
    } else {
      isPostButtonEnable.value = false;
    }
  }

  ///******* Category feed Search Function *******
  onSearch(String search) {
    searchFeedCategoryList.value = feedCategoryList
        .where(
          (e) => e.categoryName!.toLowerCase().contains(
                search.toLowerCase(),
              ),
        )
        .toList();
    if (kDebugMode) {
      print(search);
    }
  }

  loadFeedCategoryList() {
    //isCompanyDataLoad.value = true;
    searchFeedCategoryList.value = feedCategoryList;
  }

  ///fetch feed category
  fetchFeedCategory() async {
    Map<String, dynamic> params = {};
    params['start'] = 0;
    params['limit'] = 1000;
    ResponseModel<FeedCategoryModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.feeCategoryList, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      feedCategoryModel.value = responseModel.data;
      feedCategoryList.value = feedCategoryModel.value?.feedCategoryList ?? [];
      loadFeedCategoryList();
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  Future<void> convertXFile() async {

    for (int i = 0; i < postImageVideoList.length; i++) {
      file.add(
        File(postImageVideoList[i].path),
      );
    }
    for (int i = 0; i < file.length; i++) {
      if (file[i].path.toLowerCase().videoFormat()) {
        var size = CommonUtils.calculateFileSize(File(file[i].path));
        if (size > 2) {
          final info = await VideoCompress.compressVideo(
            file[i].path,
            quality: VideoQuality.MediumQuality,
            deleteOrigin: false,
            includeAudio: true,
          );
          Logger().i(info?.path);
          temp.add(File(info?.path ?? ''));
          CommonUtils.calculateFileSize(File(info?.path ?? ''));
        } else {
          temp.add(file[i]);
        }
      } else {
        var size = CommonUtils.calculateFileSize(File(file[i].path));
        if (size > 2) {
          final File files = await CommonUtils.compressImage(image: file[i]);
          temp.add(await FlutterExifRotation.rotateImage(
            path: files.path,
          ));
        } else {
          temp.add(await FlutterExifRotation.rotateImage(
            path: file[i].path,
          ));
        }
      }
    }

    Logger().i('Path ==== $temp');
    for (var i in temp) {
      Logger().i('After Path -> ${i.path}');

      CommonUtils.calculateFileSize(File(i.path));
    }
  }

  ///Api Calling of create feed
  createFeedApiCalling({
    required onErr,
  }) async {
    Map<String, dynamic> requestParams = {};
    requestParams['description'] = description.value;
    selectedCategoryId.value != null ? requestParams['feed_category_id'] = selectedCategoryId.value : null;
    requestParams['post_to'] = createFeedTypeStringApi.value;

    ResponseModel responseModel = await sharedServiceManager.uploadRequest(ApiType.createFeed,
        arrFile: [
          AppMultiPartFile(
            localFiles: temp,
            key: 'feed_media',
          ),
        ],
        params: requestParams);
    ShowLoaderDialog.dismissLoaderDialog();
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      Logger().i(responseModel.message);
      return true;
    } else {
      file.clear();
      temp.clear();
      postImageVideoList.clear();
      tempDisplayList.clear();
      onErr(responseModel.message);
      return false;
    }
  }

  ///Api Calling of create forum
  createForumApiCalling({required onErr}) async {
    Map<String, dynamic> requestParams = {};
    requestParams['description'] = description.value;
    requestParams['feed_category_id'] = selectedCategoryId.value;

    ResponseModel responseModel = await sharedServiceManager.uploadRequest(ApiType.createForum,
        arrFile: [
          AppMultiPartFile(
            localFiles: temp,
            key: 'forum_media',
          ),
        ],
        params: requestParams);
    ShowLoaderDialog.dismissLoaderDialog();
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      Logger().i(responseModel.message);

      return true;
    } else {
      file.clear();
      temp.clear();
      postImageVideoList.clear();
      tempDisplayList.clear();
      onErr(responseModel.message);
      return false;
    }
  }

  onCreateFeedTypeSelect({required int index}) async {
    createSelectionList.value = createSelectionList.map((e) {
      e.isTypeSelected.value = false;

      return e;
    }).toList();
    createSelectionList[index].isTypeSelected.value = true;
    createFeedTypeStringApi.value = createSelectionList[index].apiParam ?? '';
  }

  @override
  void onInit() {
    createSelectionList.value = [
      CreateFeedSelection(createFeedType: AppStrings.all, apiParam: 'ALL'),
      userSingleton.userType == 'FU' ? CreateFeedSelection(createFeedType: AppStrings.funder, apiParam: 'FU') : CreateFeedSelection(createFeedType: AppStrings.broker, apiParam: 'BR'),
    ];
    if (createSelectionList.isNotEmpty) {
      createSelectionList[0].isTypeSelected.value = true;
      createFeedTypeStringApi.value = createSelectionList[0].apiParam ?? AppStrings.all;
    }
    super.onInit();
  }
}

class CreateFeedSelection {
  String? createFeedType;
  String? apiParam;
  RxBool isTypeSelected = false.obs;

  CreateFeedSelection({this.createFeedType, this.apiParam});
}
