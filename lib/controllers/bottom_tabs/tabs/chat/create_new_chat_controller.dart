// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iso_net/helper_manager/socket_manager/socket_manager_new.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/extensions/string_extensions.dart';
import 'package:video_compress/video_compress.dart';

import '../../../../helper_manager/network_manager/api_const.dart';
import '../../../../helper_manager/network_manager/remote_service.dart';
import '../../../../model/bottom_navigation_models/network_model/viewmy_network_model.dart';
import '../../../../model/response_model/responese_datamodel.dart';
import '../../../../ui/style/showloader_component.dart';
import '../../../../utils/app_common_stuffs/app_logger.dart';

class NewMessageController extends GetxController {
  var pageLimitation = 15.obs;
  var searchText = ''.obs;
  var totalRecord = 0.obs;
  var myNetworkList = <NetworkData>[].obs;
  var sendNetworkList = <NetworkData>[].obs;
  // var addNetworkList = <String>[].obs;
  // var addNetworkId = <int>[].obs;
  var pageToShow = 1.obs;
  var isAllDataLoaded = false.obs;
  var isLoadMoreRunningForViewAll = false;
  var isLoaderShow = true.obs;
  ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();
  TextEditingController sendMessageEditingController = TextEditingController();



  var roomName;
  var groupName;
  var isGroup;
  var isFirstTimeSend = false.obs;
  var imageId = "".obs;
  var postImageVideoList = <XFile>[].obs;
  var tempDisplayList = <XFile>[].obs;
  var file = <File>[].obs;
  var temp = <File>[].obs;
  var addImageVideoList = <int>[].obs;
  var thumbnail = ''.obs;
  var groupMemberNames = <String>[].obs;
  var groupMemberIDs = <int>[].obs;
  var isDataLoaded = false.obs;



  getMyNetworkApi({bool isLoaderShow = true}) async {
    /*myNetworkList.clear();*/

    Map<String, dynamic> params = {};
    params['start'] = myNetworkList.length;
    params['limit'] = defaultFetchLimit;
    params['query'] = searchText.value;
    ResponseModel<ViewMyNetworkModel> responseModel =
        await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.viewMyNetworkApi, params: params);

    if (isLoaderShow) {
      ShowLoaderDialog.dismissLoaderDialog();
    }

    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      totalRecord.value = responseModel.data?.totalRecord ?? 0;
      if (totalRecord.value != 0) {
        isDataLoaded.value = true;
      } else {
        isDataLoaded.value = false;
      }
      if (myNetworkList.isEmpty) {
        myNetworkList.value = responseModel.data?.networkData ?? [];
        for (int x = 0; x < myNetworkList.length; x++) {
          for (int j = 0; j < sendNetworkList.length; j++) {
            if (myNetworkList[x].userId == sendNetworkList[j].userId) {
              myNetworkList[x].isSelected.value = true;
            }
          }
        }
      } else {
        myNetworkList.addAll(responseModel.data?.networkData ?? []);
      }
      isAllDataLoaded.value = (myNetworkList.length < (responseModel.data?.totalRecord ?? 0)) ? true : false;
      isLoadMoreRunningForViewAll = false;
    }
  }

  ///Pagination Load Data
  paginationLoadData() {
    pageToShow.value++;
    Logger().i(pageToShow.value);
    getMyNetworkApi(isLoaderShow: false);
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

    for (var i in temp) {
      CommonUtils.calculateFileSize(File(i.path));
    }
  }

  /// Create Group Chat Socket Event ********************************************************************************************************
  createNewGroupChat({required String text}){
    SocketManagerNew().createGroupEvent(roomType: sendNetworkList.length > 1 ? ApiParams.group : ApiParams.oneToOne,
        type: "text",
        messageText: text.trim(),
        participate: sendNetworkList.map((element) => element.userId ?? 0).toList(), onSend: (){

        }, onError: (msg){
            SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
        });
  }
}
