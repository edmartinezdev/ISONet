// import 'dart:convert';
//
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:iso_net/controllers/bottom_tabs/tabs/chat/add_group_name_controller.dart';
// import 'package:iso_net/controllers/bottom_tabs/tabs/recent_chat_list_controller.dart';
// import 'package:iso_net/helper_manager/network_manager/api_const.dart';
// import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
// import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
// import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
// import 'package:web_socket_channel/io.dart';
//
// import '../../controllers/bottom_tabs/tabs/chat/one_to_one_chat_controller.dart';
// import '../../controllers/bottom_tabs/tabs/messenger_tab_controller.dart';
// import '../../model/bottom_navigation_models/chat model/one_to_one_chat_model.dart';
// import '../../model/bottom_navigation_models/chat model/recent_chat_model.dart';
// import '../../singelton_class/auth_singelton.dart';
// import '../../utils/app_common_stuffs/screen_routes.dart';
// import '../../utils/app_common_stuffs/snackbar_util.dart';
// import '../../utils/network_util.dart';
// import '../network_manager/socket_constants.dart';
//
// RxBool isSendAgainMessageFromNewMessage = false.obs;
//
// class SocketManager {
//   static final String serverUrl = SocketConstant.baseDomainSocket;
//   static Map<String, String> headers = <String, String>{};
//
//   MessengerController messengerController = Get.find();
//   RecentChatListController recentChatListController = Get.find();
//   Rxn<int> deleteIndex = Rxn();
//   IOWebSocketChannel? channel;
//   bool isChatScreenOpened = false;
//   RxBool isLogout = false.obs;
//   RxBool isSendRecentUpdateList = false.obs;
//
//   SocketManager._internal() {
//     setupSocket();
//   }
//
//   setupSocket() {
//     Logger().i('SetupSocket');
//     try {
//       if (channel == null) {
//         channel = IOWebSocketChannel.connect(SocketManager.serverUrl, headers: {'Content-type': 'application/json', 'Accept': 'application/json', 'Authorization': 'Token ${userSingleton.token}'});
//         listenEvents();
//       }
//     } catch (ex) {
//       if (kDebugMode) {
//         print("Socket Error");
//       }
//     }
//   }
//
//   static final SocketManager _socketManager = SocketManager._internal();
//
//   factory SocketManager() {
//     return _socketManager;
//   }
//
//   Future<void> listenEvents() async {
//     channel?.stream.listen((event) {
//       Logger().v("CHAT DATA PRINT");
//
//       messengerController = Get.find();
//       final data = jsonDecode(event as String) as Map<dynamic, dynamic>;
//       Map<String, dynamic> convert = data.cast<String, dynamic>();
//       final chatData = convert['type'] ?? "";
//       switch (chatData) {
//         case "send_message":
//           Logger().i('send_message');
//           sentMessageNewACK(convert);
//           break;
//         case "receive_message":
//           Logger().i("receive_message");
//           receiveNewMessage(convert);
//           break;
//         case "get_chat_history":
//           Logger().i("get_chat_history");
//           messageChatHistory(convert);
//           break;
//         case "get_chat_conversation":
//           Logger().i("get_chat_conversation");
//           getRecentHistoryList(convert);
//           break;
//         case "pin_chat_room":
//           Logger().i("pin_chat_room");
//           if (kDebugMode) {
//             print("Pinned");
//           }
//           pinChatResponse(convert);
//           break;
//         case "unpin_chat_room":
//           Logger().i("UnPinned");
//           pinChatResponse(convert);
//           break;
//         case "create_group":
//           Logger().i("create_group");
//           createGorupResponse(convert);
//           break;
//         case "search":
//           Logger().i("search");
//           updateChatList(convert);
//           break;
//         case "left_group":
//           Logger().i("left_group");
//           updateChatList(convert);
//           break;
//         case "update_group":
//           Logger().i("update_group");
//           updategroupResponse(convert);
//           break;
//       }
//     }, onError: (error) async {
//       if (await NetworkUtil.isNetworkConnected() == false) {
//         SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: AppStrings.noInternetMsg);
//         return;
//       }
//       /*print("Socket Error" + error);*/
//     }, onDone: () async {
//       if (kDebugMode) {
//         print("Socket Disconnect");
//       }
//       if (isLogout.value = false) {
//         if (await NetworkUtil.isNetworkConnected() == false) {
//           SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: AppStrings.noInternetMsg);
//           return;
//         }
//         channel = null;
//         setupSocket();
//       } else {
//         Logger().i('Socket Close');
//       }
//     }, cancelOnError: true);
//   }
//
//   Future<void> pinChatResponse(Map<String, dynamic> convert) async {
//     final chatData = convert['chat_message'];
//     if (chatData != null) {
//       if (messengerController.chatList.isNotEmpty) {
//         var aData = ChatDataa.fromJson(chatData).obs;
//         var matchingRoomIndex = messengerController.chatList.indexWhere((chat) => chat.roomName == aData.value.roomName);
//         if (matchingRoomIndex != -1) {
//           messengerController.chatList[matchingRoomIndex] = aData.value;
//           sortPinnedAndEpochtime();
//           // sort((a, b) => (b.epoch_time ?? 0).compareTo(a.epoch_time ?? 0));
//           messengerController.update();
//         } else {
//           var ab = messengerController.chatList.lastIndexWhere((chat) => chat.isChatPinned.value);
//           messengerController.chatList.insert(0, aData.value);
//         }
//       }
//     }
//   }
//
//   void sentMessageNewACK(Map<String, dynamic> convert) {
//     final chatData = convert['chat_message'];
//     if (chatData != null) {
//       if (Get.isRegistered<OneToOneChatController>() == true) {
//         OneToOneChatController oneToOneChatController = Get.find<OneToOneChatController>();
//
//         oneToOneChatController.file.clear();
//         oneToOneChatController.postImageVideoList.clear();
//         oneToOneChatController.addImageVideoList.clear();
//         oneToOneChatController.temp.clear();
//         var receiveMsgData = HistoryDetails.fromJson(chatData['last_message']);
//         if (oneToOneChatController.historyList.isEmpty) {
//           oneToOneChatController.historyList.insert(0, receiveMsgData);
//         } else if (oneToOneChatController.historyList[0].id != receiveMsgData.id) {
//           oneToOneChatController.historyList.insert(0, receiveMsgData);
//         }
//       }
//     }
//
//     if (messengerController.chatList.isNotEmpty) {
//       var aData = ChatDataa.fromJson(chatData).obs;
//       var matchingRoomIndex = messengerController.chatList.indexWhere((chat) => chat.roomName == aData.value.roomName);
//       if (matchingRoomIndex != -1) {
//         messengerController.chatList[matchingRoomIndex] = aData.value;
//         sortPinnedAndEpochtime();
//         if (isSendAgainMessageFromNewMessage.value) {
//           isSendAgainMessageFromNewMessage.value = false;
//           final roomChatData = chatData['room_name'];
//           final groupName = chatData['group_name'];
//           final isGroup = chatData['is_group'];
//           Get.toNamed(ScreenRoutesConstants.oneToOneChatScreen, arguments: [roomChatData, groupName, isGroup]);
//           return;
//         }
//       } else {
//         var ab = messengerController.chatList.lastIndexWhere((chat) => chat.isChatPinned.value);
//         messengerController.chatList.insert(ab + 1, aData.value);
//       }
//     } else if (isSendRecentUpdateList.value == false) {
//       var aData = ChatDataa.fromJson(chatData).obs;
//       messengerController.chatList.insert(0, aData.value);
//     }
//     messengerController.isRefreshRecentChatList.value = false;
//   }
//
//   void receiveNewMessage(Map<String, dynamic> convert) {
//     final chatData = convert['chat_message'];
//     if (chatData != null) {
//       if (Get.isRegistered<OneToOneChatController>() == true) {
//         OneToOneChatController oneToOneChatController = Get.find<OneToOneChatController>();
//         if ((chatData['room_name'] ?? "") == oneToOneChatController.roomName) {
//           oneToOneChatController.file.clear();
//           oneToOneChatController.postImageVideoList.clear();
//           oneToOneChatController.addImageVideoList.clear();
//           oneToOneChatController.temp.clear();
//           var receiveMsgData = HistoryDetails.fromJson(chatData['last_message']);
//           if (oneToOneChatController.historyList.isEmpty) {
//             oneToOneChatController.historyList.insert(0, receiveMsgData);
//           } else if (oneToOneChatController.historyList[0].id != receiveMsgData.id) {
//             oneToOneChatController.historyList.insert(0, receiveMsgData);
//           }
//           /*oneToOneChatController.historyList.insert(0, receiveMsgData);*/
//         }
//       }
//     }
//
//     if (messengerController.chatList.isNotEmpty) {
//       var aData = ChatDataa.fromJson(chatData).obs;
//       var matchingRoomIndex = messengerController.chatList.indexWhere((chat) => chat.roomName == aData.value.roomName);
//       if (matchingRoomIndex != -1) {
//         /*messengerController.chatList[matchingRoomIndex].isReadByYou.value = false;*/
//         messengerController.chatList[matchingRoomIndex] = aData.value;
//         messengerController.chatList[matchingRoomIndex].isReadByYou.value = false;
//         sortPinnedAndEpochtime();
//         // messengerController.chatList.sort((a, b) => (b.epoch_time ?? 0).compareTo(a.epoch_time ?? 0));
//         //messengerController.update();
//       } else {
//         var ab = messengerController.chatList.lastIndexWhere((chat) => chat.isChatPinned.value);
//         messengerController.chatList.insert(ab + 1, aData.value);
//       }
//     } /*else if (isSendRecentUpdateList.value == false) {
//       var aData = ChatDataa.fromJson(chatData).obs;
//       messengerController.chatList.insert(0, aData.value);
//     }*/
//   }
//
//   /// Sort using pinned and epoch time to display latest messages and pinned chats
//   void sortPinnedAndEpochtime() {
//     messengerController.chatList.sort((a, b) {
//       if (a.isChatPinned.value && !b.isChatPinned.value) {
//         return -1; // a comes before b
//       } else if (!a.isChatPinned.value && b.isChatPinned.value) {
//         return 1; // b comes before a
//       } else if (a.isChatPinned.value && b.isChatPinned.value) {
//         return (b.epoch_time ?? 0).toInt() - (a.epoch_time ?? 0).toInt(); // sort by descending epoch_time
//       } else {
//         return (b.epoch_time ?? 0).toInt() - (a.epoch_time ?? 0).toInt(); // sort by descending epoch_time
//       }
//     });
//   }
//
//   messageChatHistory(Map<String, dynamic> convert) {
//     OneToOneChatController oneToOneChatController = Get.find<OneToOneChatController>();
//     final chatData = convert['message_history'];
//
//     if (kDebugMode) {
//       print(chatData);
//     }
//     if (chatData != null) {
//       if (chatData["is_blocked_by_you"] != null && chatData["connection_user"] != null) {
//         oneToOneChatController.isBlockByMe.value = chatData["is_blocked_by_you"];
//         oneToOneChatController.recieverId = chatData["connection_user"];
//       }
//
//       oneToOneChatController.messageHistoryData.value = MessageHistoryData.fromJson(chatData);
//       oneToOneChatController.totalRecords.value = oneToOneChatController.messageHistoryData.value?.totalRecord ?? 0;
//       if (oneToOneChatController.historyList.isEmpty || oneToOneChatController.pageToShow.value == 1) {
//         oneToOneChatController.historyList.value = oneToOneChatController.messageHistoryData.value?.data ?? [];
//       } else {
//         oneToOneChatController.historyList.addAll(oneToOneChatController.messageHistoryData.value?.data ?? []);
//       }
//     }
//     oneToOneChatController.isAllDataLoaded.value = ((oneToOneChatController.historyList.length) < (oneToOneChatController.totalRecords.value)) ? true : false;
//     oneToOneChatController.isLoadMoreRunningForViewAll = false;
//     return;
//   }
//
//   updategroupResponse(Map<String, dynamic> convert) {
//     final chatData = convert['chat_message'];
//     if (kDebugMode) {
//       print(chatData);
//     }
//     if (chatData != null) {
//       AddGroupNameController addGroupNameController = Get.find();
//       var gorupName = chatData["group_name"] ?? "";
//       addGroupNameController.group.value = gorupName;
//
//       if (messengerController.chatList.isNotEmpty) {
//         var aData = ChatDataa.fromJson(chatData).obs;
//         var matchingRoomIndex = messengerController.chatList.indexWhere((chat) => chat.roomName == aData.value.roomName);
//         if (matchingRoomIndex != -1) {
//           messengerController.chatList[matchingRoomIndex] = aData.value;
//           sortPinnedAndEpochtime();
//           messengerController.update();
//         } else {
//           var ab = messengerController.chatList.lastIndexWhere((chat) => chat.isChatPinned.value);
//           messengerController.chatList.insert(ab + 1, aData.value);
//         }
//       }
//
//       Get.back();
//       /*Get.back();*/
//     }
//   }
//
//   updateChatList(Map<String, dynamic> convert) {
//     final chatData = convert['recent_chat_list'];
//
//     /// below if condition is used for left group call back.
//     if (deleteIndex.value != null) {
//       messengerController.chatList.removeAt(deleteIndex.value ?? -1);
//       deleteIndex.value = null;
//     } else if (chatData != null) {
//       messengerController.recentChatListData.value = RecentChatList.fromJson(chatData);
//
//       messengerController.totalRecord.value = messengerController.recentChatListData.value?.data?.totalRecord ?? 0;
//       if (messengerController.chatList.isEmpty) {
//         messengerController.chatList.value = messengerController.recentChatListData.value?.data?.data ?? [];
//       } else {
//         messengerController.chatList.addAll(messengerController.recentChatListData.value?.data?.data ?? []);
//       }
//       messengerController.isAllDataLoaded.value = ((messengerController.chatList.length) < (messengerController.totalRecord.value)) ? true : false;
//       messengerController.isLoadMoreRunningForViewAll = false;
//       if (kDebugMode) {
//         print('ChatDattaaaa ${messengerController.recentChatListData.value}');
//       }
//       //ShowLoaderDialog.dismissLoaderDialog();
//     }
//
//     if (kDebugMode) {
//       print(chatData);
//     }
//   }
//
//   createGorupResponse(Map<String, dynamic> convert) {
//     final chatData = convert['chat_message'];
//     final roomChatData = convert['room_name'];
//     final groupName = convert['group_name'];
//     final isGroup = convert['is_group'];
//
//     if (messengerController.chatList.isNotEmpty) {
//       var aData = ChatDataa.fromJson(chatData).obs;
//       var matchingRoomIndex = messengerController.chatList.indexWhere((chat) => chat.roomName == aData.value.roomName);
//       if (matchingRoomIndex != -1) {
//         messengerController.chatList[matchingRoomIndex] = aData.value;
//         messengerController.update();
//       } else {
//         var ab = messengerController.chatList.lastIndexWhere((chat) => chat.isChatPinned.value);
//         messengerController.chatList.insert(ab + 1, aData.value);
//       }
//     }
//
//     if (roomChatData != null) {
//       Get.toNamed(ScreenRoutesConstants.oneToOneChatScreen, arguments: [roomChatData, groupName, isGroup]);
//       return;
//     }
//   }
//
//   void getRecentHistoryList(Map<String, dynamic> convert) {
//     final chatData = convert['recent_chat_list'];
//     if (chatData != null) {
//       if (isSendRecentUpdateList.value == false) {
//         Logger().d("CHAT RESPONSE:: ${RecentChatList.fromJson(chatData).toJson()}");
//         messengerController.recentChatListData.value = RecentChatList.fromJson(chatData);
//         messengerController.totalRecord.value = messengerController.recentChatListData.value?.data?.totalRecord ?? 0;
//         if (messengerController.chatList.isEmpty || messengerController.chatList.length == messengerController.totalRecord.value) {
//           messengerController.chatList.value = messengerController.recentChatListData.value?.data?.data ?? [];
//         } else {
//           messengerController.chatList.addAll(messengerController.recentChatListData.value?.data?.data ?? []);
//         }
//         messengerController.isAllDataLoaded.value = ((messengerController.chatList.length) < (messengerController.totalRecord.value)) ? true : false;
//         messengerController.isLoadMoreRunningForViewAll = false;
//         Logger().i("Recent chatList length::${messengerController.chatList.length}");
//         if (kDebugMode) {
//           print('ChatDattaaaa ${messengerController.recentChatListData.value}');
//         }
//       } else {
//         recentChatListController.recentChatListData.value = RecentChatList.fromJson(chatData);
//         recentChatListController.totalRecord.value = recentChatListController.recentChatListData.value?.data?.totalRecord ?? 0;
//         // if (recentChatListController.chatList.isEmpty) {
//         recentChatListController.chatList.value = recentChatListController.recentChatListData.value?.data?.data ?? [];
//         recentChatListController.update();
//         // } else {
//         //   recentChatListController.chatList.addAll(recentChatListController.recentChatListData.value?.data?.data ?? []);
//         // }
//         // recentChatListController.isAllDataLoaded.value = ((recentChatListController.chatList.length) < (recentChatListController.totalRecord.value)) ? true : false;
//         // recentChatListController.isLoadMoreRunningForViewAll = false;
//         Logger().i("Send Recent chatList length::${recentChatListController.chatList.length}");
//         if (kDebugMode) {
//           print('ChatDattaaaa ${recentChatListController.recentChatListData.value}');
//         }
//       }
//     }
//     if (kDebugMode) {
//       print('Dataaa $convert');
//     }
//   }
//
//   Future<void> getRecentChatList({required String filterType, int? limit, bool? showLoader, int? filterIndex, bool isSendRecentChat = false, bool isPUllToRefresh = false}) async {
//     Logger().v({"start": isPUllToRefresh ? 0 : messengerController.chatList.length, "limit": limit ?? defaultFetchLimit, "filter_by": filterType});
//     if (await NetworkUtil.isNetworkConnected()) {
//       //jsonDecode(message)["data"]["data"];
//       if (isSendRecentChat == true) {
//         channel?.sink.add(jsonEncode({
//           "key": "get_chat_conversation",
//           "data": {"start": 0, "limit": limit ?? defaultFetchLimit, "filter_by": filterType}
//         }));
//       } else {
//         channel?.sink.add(jsonEncode({
//           "key": "get_chat_conversation",
//           "data": {"start": isPUllToRefresh ? 0 : messengerController.chatList.length, "limit": limit ?? defaultFetchLimit, "filter_by": filterType}
//         }));
//         isPUllToRefresh ? messengerController.chatList.clear() : messengerController.chatList.length;
//       }
//
//       return;
//     } else {
//       SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: AppStrings.noInternetMsg);
//       return;
//     }
//   }
//
//   pinUnpinChat({required String roomName, required bool isPinned}) {
//     if (isPinned == true) {
//       channel?.sink.add(jsonEncode({
//         "key": "pin_chat_room",
//         "data": {"room_name": roomName}
//       }));
//     } else {
//       channel?.sink.add(jsonEncode({
//         "key": "unpin_chat_room",
//         "data": {"room_name": roomName}
//       }));
//     }
//   }
//
//   Future<void> createGroup({required String roomType, required List<int> participate, String? messageText, String? type, List<int>? mediaIdList}) async {
//     Logger().v("Send message params:${jsonEncode({
//           "key": "create_group",
//           "data": {
//             "room_type": roomType,
//             "participate": participate,
//             "message": messageText ?? "",
//             "type": type ?? "",
//             "media": mediaIdList ?? [],
//           }
//         })}");
//     channel?.sink.add(jsonEncode({
//       "key": "create_group",
//       "data": {
//         "room_type": roomType,
//         "participate": participate,
//         "message": messageText ?? "",
//         "type": type ?? "",
//         "media": mediaIdList ?? [],
//       }
//     }));
//   }
//
//   Future<void> searchListName({required String searchParam}) async {
//     Logger().v("Search Chat params:search_param :$searchParam,start: ${messengerController.chatList.length}, limit: $defaultFetchLimit");
//     channel?.sink.add(jsonEncode({
//       "key": "search",
//       "data": {"search_param": searchParam, "start": messengerController.chatList.length, "limit": defaultFetchLimit}
//     }));
//   }
//
//   Future<void> leftGroup({required String roomName}) async {
//     channel?.sink.add(jsonEncode({
//       "key": "left_group",
//       "data": {"room_name": roomName}
//     }));
//   }
//
//   Future<void> sendMessageText({required String sendMessage, required String roomName}) async {
//     channel?.sink.add(jsonEncode({
//       "key": "send_message",
//       "data": {"room_name": roomName, "type": "text", "message": sendMessage}
//     }));
//   }
//
//   Future<void> sendMessageMedia({required String roomName, required List<int> media}) async {
//     channel?.sink.add(jsonEncode({
//       "key": "send_message",
//       "data": {"room_name": roomName, "message": "Media", "type": "media", "media": media}
//     }));
//   }
//
//   Future<void> createRoomForSend({required int senderId, String? roomName}) async {
//     channel?.sink.add(jsonEncode({
//       "key": "create_group",
//       "data": {
//         "room_type": ApiParams.oneToOne,
//         "participate": [senderId],
//       }
//     }));
//   }
//
//   Future<void> sendMessageFeed({required int feedId, required String roomName, int senderId = -1}) async {
//     channel?.sink.add(jsonEncode({
//       "key": "send_message",
//       "data": {"room_name": roomName, "participate": senderId, "message": "Feed", "type": "feed", "feed_id": feedId}
//     }));
//   }
//
//   Future<void> sendMessageForum({required int forumId, required String roomName, int senderId = -1}) async {
//     channel?.sink.add(jsonEncode({
//       "key": "send_message",
//       "data": {"room_name": roomName, "participate": senderId, "message": "Forum", "type": "forum", "forum_id": forumId}
//     }));
//   }
//
//   Future<void> getChatHistory({
//     required String roomName,
//   }) async {
//     OneToOneChatController oneToOneChatController = Get.find<OneToOneChatController>();
//     channel?.sink.add(jsonEncode({
//       "key": "get_chat_history",
//       "data": {"start": oneToOneChatController.historyList.length, "limit": defaultFetchLimit, "room_name": roomName}
//     }));
//   }
//
//   Future<void> updateGroup({required String roomName, required String groupName}) async {
//     channel?.sink.add(jsonEncode({
//       "key": "update_group",
//       "data": {"room_name": roomName, "group_name": groupName}
//     }));
//   }
//
//   void logout() {
//     channel?.sink.close();
//     channel = null;
//     isLogout.value = true;
//   }
//
//   void logIn() {
//     Logger().i('Socket Connecting......');
//     channel = null;
//     isLogout.value = false;
//     setupSocket();
//   }
// }
