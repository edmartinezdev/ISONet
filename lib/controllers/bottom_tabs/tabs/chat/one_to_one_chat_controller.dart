// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iso_net/helper_manager/socket_manager/socket_manager_new.dart';
import 'package:iso_net/model/bottom_navigation_models/chat_model/chat_media_model.dart';
import 'package:iso_net/model/bottom_navigation_models/chat_model/one_to_one_chat_model.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/utils/app_map_keys.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/extensions/string_extensions.dart';
import 'package:video_compress/video_compress.dart';

import '../../../../helper_manager/network_manager/api_const.dart';
import '../../../../helper_manager/network_manager/remote_service.dart';
import '../../../../model/response_model/responese_datamodel.dart';
import '../../../../utils/app_common_stuffs/app_logger.dart';
import '../../../../utils/app_common_stuffs/commom_utils.dart';

class OneToOneChatController extends GetxController {
  ///********* variables declaration ********///
  Rxn<MessageHistoryData> messageHistoryData = Rxn();
  var historyList = <HistoryDetails>[].obs;
  var isBlockByMe = false.obs;
  var recieverId = -1.obs;

  TextEditingController textEditingController = TextEditingController();
  var chatMessage = ''.obs;
  var roomName;
  var groupName;
  var isGroup;
  var isFirstTimeSend = false.obs;

  var postImageVideoList = <XFile>[].obs;
  var tempDisplayList = <XFile>[].obs;
  var file = <File>[].obs;
  var temp = <File>[].obs;
  var addImageVideoList = <int>[].obs;
  var thumbnail = ''.obs;
  var isChatListCall = true.obs;

  var isAllDataLoaded = false.obs;
  var isLoadMoreRunningForViewAll = false;

  var totalRecords = 0.obs;
  final ScrollController scrollController = ScrollController();

  var minPage = 0;
  var maxPage = 0;
  RxBool isPaginationActiveFromBottom = false.obs;
  bool isFromSearch = false;
  var isReceiveMessage = false.obs;

  ///*******************************************///

  ///***** Convert Media xFile into file then compressing the image/video while uploading to the api ******///
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

  ///***** Upload Media api function ********///
  ///if user want to send any media in to chat first dev has to upload media file to the api in the api response
  Future<bool> uploadFileAPICall({required onError, bool isCreateGroup = false, List<int>? groupIDs, String? searchQuery}) async {
    Map<String, dynamic> requestParams = {};

    ResponseModel<List<MediaData>> uploadImageAPIResponse = await sharedServiceManager.uploadRequest(
      ApiType.createChatMedia,
      params: requestParams,
      arrFile: [
        AppMultiPartFile(
          localFiles: temp,
          key: 'chat_media',
        ),
      ],
    );
    if (uploadImageAPIResponse.status == ApiConstant.statusCodeSuccess) {
      for (int i = 0; i < (uploadImageAPIResponse.data?.length ?? 0); i++) {
        addImageVideoList.add(
          uploadImageAPIResponse.data?[i].id ?? 0,
        );
      }
      file.clear();
      postImageVideoList.clear();
      tempDisplayList.clear();
      temp.clear();
      textEditingController.clear();
      if (isCreateGroup == false) {
        sendMessageToChat(type: "media", searchQuery: searchQuery ?? '');
      } else {
        createNewGroupChat(groupIDs: groupIDs);
      }
      addImageVideoList.clear();
      return true;
    } else {
      onError(uploadImageAPIResponse.message);
      return false;
    }
  }

  /// ******* Socket event [getChatHistoryEvent] function to fetch the chat room history data ******* ///
  getChatHistoryEvent({String? searchQuery, int? limit, bool isFromSearch = false, int? skip}) {
    Map<String, dynamic> params = <String, dynamic>{};
    params[AppMapKeys.userId] = userSingleton.id ?? "";
    params[AppMapKeys.room_name] = roomName ?? "";
    params[AppMapKeys.skip] = skip == 0
        ? skip
        : isPaginationActiveFromBottom.value
            ? maxPage
            : minPage;
    params[AppMapKeys.limit] = limit ?? defaultFetchLimit;

    SocketManagerNew().chatHistoryEvent(params, onChatHistory: (MessageHistoryData objOfMessageHistory) {
      messageHistoryData.value = objOfMessageHistory;
      totalRecords.value = messageHistoryData.value?.totalRecord ?? 0;
      isBlockByMe.value = messageHistoryData.value?.isBlockedByYou ?? false;

      recieverId = int.parse(messageHistoryData.value?.reciverId ?? '-1');

      if (historyList.isEmpty) {

        historyList.value = messageHistoryData.value?.data ?? [];
        scrollController.animateTo( Platform.isAndroid ? 30.0.h : 10.0.h, duration: const Duration(milliseconds: 500), curve: Curves.ease);
        highlight(searchQuery: searchQuery ?? '');
      } else {
        if (isPaginationActiveFromBottom.value) {
          historyList.insertAll(0, messageHistoryData.value?.data ?? []);

          scrollController.animateTo(
            10.0.h,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
          highlight(searchQuery: searchQuery ?? '');
        } else {
          historyList.addAll(messageHistoryData.value?.data ?? []);
          highlight(searchQuery: searchQuery ?? '');
        }
      }
      isAllDataLoaded.value = ((historyList.length) < (totalRecords.value)) ? true : false;
      isLoadMoreRunningForViewAll = false;
    }, onError: (msg) {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
    });
  }

  ///******* highLight the search message text in chat history list if user  enter room from the search screen *******///
  highlight({required String searchQuery}) {
    for (var message in historyList) {
      message.highlightedText = CommonUtils.highlightSearchQuery(message.message ?? '', searchQuery);
    }
  }

  /// ****** Socket send message event [sendMessageToChat] ***** ///
  sendMessageToChat({required String type, String? messageValue, String? searchQuery}) async {
    /// Todo:- Change this as per new socket manager
    Map<String, dynamic> socketParams = <String, dynamic>{};
    socketParams[AppMapKeys.room_name] = roomName ?? "";
    socketParams[AppMapKeys.user_Id] = userSingleton.id ?? -1;
    socketParams[AppMapKeys.type] = type;
    socketParams[AppMapKeys.message] = type.getMessageOnChatType().isEmpty ? (messageValue ?? textEditingController.text.trim()) : type.getMessageOnChatType();
    socketParams[AppMapKeys.media] = addImageVideoList;

    SocketManagerNew().sendMessageEvent(socketParams, onSend: (ResponseModel<HistoryDetails> objOfHistory) {
      if (isFromSearch) {
        isFromSearch = false;
        scrollController.animateTo(0, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
        historyList.clear();
        getChatHistoryEvent(searchQuery: searchQuery ?? '', skip: 0);
      }
    }, onError: (msg) {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
    }, querySearch: searchQuery ?? '');
  }

  /// Create Group Chat Socket Event ********************************************************************************************************
  createNewGroupChat({
    List<int>? groupIDs,
  }) {
    SocketManagerNew().createGroupEvent(
      roomType: (groupIDs?.length ?? 0) > 1 ? ApiParams.group : ApiParams.oneToOne,
      type: "media",
      messageText: "Media",
      mediaIdList: addImageVideoList,
      participate: groupIDs ?? [],
      onSend: () {},
      onError: (msg) {
        SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
      },
    );
  }
}
