import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iso_net/helper_manager/socket_manager/socket_manager_new.dart';
import 'package:iso_net/model/bottom_navigation_models/chat_model/one_to_one_chat_model.dart';
import 'package:iso_net/model/bottom_navigation_models/chat_model/recent_chat_model.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/utils/app_map_keys.dart';
import 'package:iso_net/utils/extensions/string_extensions.dart';

import '../../../helper_manager/network_manager/api_const.dart';
import '../../../helper_manager/network_manager/remote_service.dart';
import '../../../model/response_model/responese_datamodel.dart';
import '../../../utils/app_common_stuffs/app_logger.dart';
import '../../../utils/app_common_stuffs/snackbar_util.dart';

class RecentChatListController extends GetxController {
  Rxn filterIndex = Rxn();
  ScrollController scrollController = ScrollController();
  var filterSelectionList = <FilterChat>[].obs;
  var chatList = <ChatDataa>[].obs;

  /// [isRefreshRecentChatList] is use for when user send any post
  /// when [isRefreshRecentChatList] == true
  /// then [chatList] data refresh and [isRefreshRecentChatList] == false [chatList] not refresh
  RxBool isRefreshRecentChatList = true.obs;

  Rxn<RecentChatListModell> chatData = Rxn();
  Rxn<RecentChatList> recentChatListData = Rxn();

  //Rxn<ChatDataa> chatData = Rxn();
  var pageToShow = 1.obs;
  var totalRecords = 0.obs;
  var isAllDataLoaded = false.obs;
  var isChatPinned = false.obs;
  var filterType = ''.obs;
  var isFilterEnable = false.obs;
  var pageLimitPagination = 6.obs;
  var isLoadMoreRunningForViewAll = false;
  var groupId = 0.obs;
  Rxn<int> ind = Rxn();

  var searchText = ''.obs;
  var totalRecord = 0.obs;

  @override
  void onInit() {
    filterSelectionList.value = [
      FilterChat(chat: 'Read', apiChatParam: 'read'),
      FilterChat(chat: 'Unread', apiChatParam: 'unread'),
      FilterChat(chat: userSingleton.userType == 'FU' ? 'Broker Messages' : 'Funder Messages', apiChatParam: 'funder_or_broker'),
      FilterChat(chat: 'My Network Messages', apiChatParam: 'my_network'),
      FilterChat(chat: 'Clear All Filters', apiChatParam: ''),
    ];

    super.onInit();
  }

  deleteChatApiCall({required int groupId, required String roomName, required int index}) async {
    Map<String, dynamic> params = {};
    // params['limit'] = pageLimitPagination.value;
    // params['page'] = pageToShow.value;
    params['group_id'] = groupId;
    params['room_name'] = roomName;

    ResponseModel<ResponseModel> responseModel = await sharedServiceManager.createPostRequest(typeOfEndPoint: ApiType.deleteGroup, params: params);
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      //totalRecords.value = responseModel.data?.totalRecord ?? 0;
      if (recentChatListData.value?.data?.data != null) {
        recentChatListData.value?.data?.data?.remove(recentChatListData.value?.data?.data?[index]);
      } else {
        //chatListController.addAll(responseModel.data ?? []);
      }
    } else {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: responseModel.message);
    }
  }

  recentChatListPagination() {
    pageToShow.value++;
    Logger().i(pageToShow.value);
    Logger().i("recent Socket");
    if (searchText.isNotEmpty) {
      /// Todo:- Change this as per new socket manager
      // SocketManager().searchListName(searchParam: searchText.value);
    } else {
      /// Todo:- Change this as per new socket manager
      // SocketManager().getRecentChatList(filterType: filterType.value);
    }
  }

  void updateRecentChatList(BuildContext context) {
    SocketManagerNew().chatListEvent(
        filterType: filterType.value,
        isSendRecentChat:true,
        limit: 25,
        onChatList: (ChatListData objRecentChatList) {
          totalRecord.value = objRecentChatList.totalRecord ?? 0;
          chatList.value = objRecentChatList.data ?? [];
        },
        onError: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
        });
  }

  /// Send Message Chat Socket Event ********************************************************************************************************
  sendMessageToChat({required String type, required int roomId,required feedId}) {
    /// Todo:- Change this as per new socket manager
    Map<String, dynamic> socketParams = <String, dynamic>{};
    socketParams[AppMapKeys.room_name] = roomId;
    socketParams[AppMapKeys.user_Id] = userSingleton.id ?? -1;
    socketParams[AppMapKeys.message] = type.getMessageOnChatType();
    socketParams[AppMapKeys.type] = type;
    if(type == "forum"){
      socketParams[AppMapKeys.forumId] =  feedId;
    }
    if(type == "feed"){
      socketParams[AppMapKeys.feedId] =  feedId;
    }

    SocketManagerNew().sendMessageEvent(socketParams, onSend: (ResponseModel<HistoryDetails> objOfHistory) {}, onError: (msg) {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
    });
  }


  /// Create Group Chat Socket Event ********************************************************************************************************
  createNewGroupChat({required String type,required int userId,required int feedForumId,}){
    SocketManagerNew().createGroupEvent(roomType: ApiParams.oneToOne,
        type: type,
        isFromSendPost: true,
        feedForumId: feedForumId,
        messageText: type.getMessageOnChatType(),
        participate: [userId], onSend: ( ResponseModel<ChatDataa> objOfChatData){

        }, onError: (msg){
          SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
        });
  }



  ///Pagination Load Data
  paginationLoadData() {
    if (chatList.length.toString() == totalRecord.value.toString()) {
      return true;
    } else {
      return false;
    }
  }
}

class FilterChat {
  String? chat;
  String? apiChatParam;
  RxBool isFilterSelected = false.obs;

  FilterChat({this.chat, this.apiChatParam});
}
