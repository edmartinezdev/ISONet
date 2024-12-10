import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:iso_net/helper_manager/socket_manager/socket_manager_new.dart';
import 'package:iso_net/model/bottom_navigation_models/chat_model/recent_chat_model.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';

import '../../../utils/app_common_stuffs/snackbar_util.dart';

class MessengerController extends GetxController {

  ///[filterSelectionList] list initialize the list while we enter the messenger tab
  ///Dev initialize filter value in messenger controller onInit
  ///[filterType] while we tapping the list in[filterSelectionList] we have initialize params to send backend to which type of list user is selected
  ///[isFilterEnable] while tapping on index 4 which is clear all filter dev has to send [filterType] empty to backend and set [isFilterEnable] false
  ///while tapping on other filter [isFilterEnable] set true
  Rxn filterIndex = Rxn();
  var filterSelectionList = <FilterChat>[].obs;
  var filterType = ''.obs;
  var isFilterEnable = false.obs;
  var chatList = <ChatDataa>[].obs;


  /// [isRefreshRecentChatList] is use for when user send any post
  /// when [isRefreshRecentChatList] == true
  /// then [chatList] data refresh and [isRefreshRecentChatList] == false [chatList] not refresh

  RxBool isRefreshRecentChatList = true.obs;
  RxBool isApiResponseReceive = false.obs;
  var isAllDataLoaded = false.obs;
  var isLoadMoreRunningForViewAll = false;
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

  ///********[clearAllValue] function is use in logout api because we have declare messenger controller as initial binding
  ///Dev has to clear all value of messenger controller during logout process
  clearAllValue() {
    chatList.clear();
    totalRecord.value = 0;
    isAllDataLoaded.value = false;
    filterType.value = "";
    isFilterEnable.value = false;
    isLoadMoreRunningForViewAll = false;
  }

  ///********[updateRecentChatList] this function is use get chatList socket event
  ///Dev First check socket connection is on then after calling the [chatListEvent] socket event
  ///Dev has to init this function while entering messenger tab screen
  ///Dev hase to call this function while refreshing the chat list & [isPullToRefresh] set true while refreshing the chat list
  ///Dev has to call this function while tapping on filter

  Future<void> updateRecentChatList(BuildContext context, {bool isPullToRefresh = false}) async {
    if (SocketManagerNew().socket?.connected ?? false) {
      SocketManagerNew().connectToServer();
    }
    SocketManagerNew().chatListEvent(
        filterType: filterType.value,
        isPUllToRefresh: isPullToRefresh,
        isSendRecentChat: false,
        onChatList: (ChatListData objRecentChatList) {
          isApiResponseReceive.value = true;
          if(isPullToRefresh){
            chatList.clear();
          }
          if (SocketManagerNew().isSendRecentUpdateList.value == false) {
            totalRecord.value = objRecentChatList.totalRecord ?? 0;
            if (chatList.isEmpty) {
              chatList.value = objRecentChatList.data ?? [];
            } else {
              chatList.addAll(objRecentChatList.data ?? []);
            }
            isAllDataLoaded.value = ((chatList.length) < (objRecentChatList.totalRecord ?? 0)) ? true : false;
            isLoadMoreRunningForViewAll = false;
          }
        },
        onError: (msg) {
          isApiResponseReceive.value = true;
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
        });
  }
}

///[FilterChat] class is use for filter selection
///In the current flow we have 5 type of filter [Read,Unread,Broker/Funder Messages,My Network Messages,Clear All Filters]
class FilterChat {
  String? chat;
  String? apiChatParam;
  RxBool isFilterSelected = false.obs;

  FilterChat({this.chat, this.apiChatParam});
}
