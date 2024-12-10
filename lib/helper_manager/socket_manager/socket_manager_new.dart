import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/bottom_tabs_controller.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/chat/add_group_name_controller.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/chat/one_to_one_chat_controller.dart';
import 'package:iso_net/helper_manager/network_manager/socket_constants.dart';
import 'package:iso_net/model/bottom_navigation_models/chat_model/one_to_one_chat_model.dart';
import 'package:iso_net/model/bottom_navigation_models/chat_model/recent_chat_model.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/utils/app_map_keys.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../controllers/bottom_tabs/tabs/messenger_tab_controller.dart';
import '../../controllers/bottom_tabs/tabs/recent_chat_list_controller.dart';

enum EventType { connect, sendMessage, chatHistory, chatList, receiveMessage, messageStatus, createGroup, leftGroup, newGroupMessage, updateGroup, pinGroup, unreadStatusOn }

class SocketManagerNew {
  static String getEvent(EventType type) {
    switch (type) {
      case EventType.connect:
        return "client-user-connected";
      case EventType.createGroup:
        return "create_group";
      case EventType.updateGroup:
        return "update_group";
      case EventType.newGroupMessage:
        return "new_group_message";
      case EventType.leftGroup:
        return "left_group";
      case EventType.sendMessage:
        return "send_message";
      case EventType.chatHistory:
        return "get_chat_history";
      case EventType.chatList:
        return "get_chat_conversation";
      case EventType.receiveMessage:
        return "receive_message";
      case EventType.unreadStatusOn:
        return "update_unread_message";
      case EventType.pinGroup:
        return "pin_group";
      case EventType.messageStatus:
        return "client-change-message-status-all";
    }
  }

  /// [isChatDetailsScreenOpened] flag manage to notification of message
  /// when chat screen is open and then message notification action
  /// then not performing screen direction
  bool isChatScreenOpened = false;

  Socket? socket;

  static final String _serverUrl = SocketConstant.baseDomainSocket + SocketConstant.prefixVersionSocket;

  static final _optionBuilder = OptionBuilder().setTransports(["websocket"]).disableAutoConnect().build();

  MessengerController messengerController = Get.find<MessengerController>();
  RecentChatListController recentChatListController = Get.find();
  Rxn<int> deleteIndex = Rxn();

  static final SocketManagerNew _singleton = SocketManagerNew._internal();

  RxBool isSendRecentUpdateList = false.obs;

  factory SocketManagerNew() {
    return _singleton;
  }

  SocketManagerNew._internal();

  Future connectToServer() async {
    if (socket?.connected == true) {
      return;
    }

    try {
      Logger().i("Connecting to $_serverUrl...");
      socket = io(_serverUrl, _optionBuilder).connect();
      registerEvents();
    } catch (e) {
      Logger().e("OnCatch(): Error while connecting to $_serverUrl $e");
    }
  }

  /// Sort using pinned and epoch time to display latest messages and pinned chats
  void sortPinnedAndEpochtime() {
    final List<ChatDataa> pinnedChats = [];
    final List<ChatDataa> unpinnedChats = [];

// Separate pinned and unpinned chats into two lists
    for (var obj in messengerController.chatList) {
      if (obj.isPinned ?? false) {
      pinnedChats.add(obj);
      } else {
      unpinnedChats.add(obj);
      }
    }


// Sort the pinned chats based on the most recent message
   pinnedChats.sort((a, b) => (b.lastMessage.value?.timestamp ?? "").compareTo(a.lastMessage.value?.timestamp ?? ""));


// Sort the unpinned chats based on the most recent message
    unpinnedChats.sort((a, b) => (b.lastMessage.value?.timestamp ?? "").compareTo((a.lastMessage.value?.timestamp ?? "")));

// Concatenate the two lists to create the final sorted chat list
    final List<ChatDataa> sortedChats = [...pinnedChats,...unpinnedChats,];

    messengerController.chatList.value = sortedChats;
  }

  registerEvents() {
    if (socket == null) {
      return;
    }
    socket!.onConnect((data) {
      Logger().i("onConnect(): Connected to $_serverUrl");
      Logger().i("Screen name  ${Get.currentRoute}");

      userConnectEvent();
      if (Get.currentRoute == ScreenRoutesConstants.oneToOneChatScreen) {
        // chatHistoryEventCall.sink.add(true);
      }
    });

    socket!.onError((data) {
      Logger().e("onError(): Socket onError $data");
    });

    socket!.onConnectError((data) {
      Logger().e("onConnectError(): $data");
      socket!.disconnect();
    });

    socket!.onConnectTimeout((_) {
      Logger().e("onConnectTimeout(): Connection timed out! ($_serverUrl)");
    });

    try {
      socket!.on(getEvent(EventType.newGroupMessage), (data) {
        Logger().d("New Group Message Listen : response -> $data");
        ChatDataa dataResponse = ChatDataa.fromJson(data);
        if (messengerController.chatList.isNotEmpty) {
          var matchingRoomIndex = messengerController.chatList.indexWhere((chat) => chat.id == (dataResponse.id ?? -1));
          if (matchingRoomIndex != -1) {
            messengerController.chatList[matchingRoomIndex] = dataResponse;
            sortPinnedAndEpochtime();
          } else {
            var ab = messengerController.chatList.lastIndexWhere((chat) => chat.isChatPinned.value);
            messengerController.chatList.insert(ab + 1, dataResponse);
            sortPinnedAndEpochtime();
          }
        } else {
          messengerController.chatList.insert(0, dataResponse);
          sortPinnedAndEpochtime();
        }
      });
    } catch (e) {
      Logger().e("receiveMessageEvent(): On catch $e");
      return;
    }
    _receiveMessageOn();
    _receiveGroupUpdateOn();
    _leftGroupOn();
    _unreadStatusOn();
  }

  void disconnectFromServer() {
    try {
      socket!
        ..disconnect()
        ..onDisconnect((_) {
          Logger().i("onDisconnect(): Disconnected");
          socket!
            ..destroy()
            ..close()
            ..dispose();
        });
    } on Exception catch (e) {
      Logger().e("OnCatch(): Error wile disconnecting from server $e");
      socket!
        ..destroy()
        ..close()
        ..dispose();
    }
  }

  void userConnectEvent() {
    if (socket!.connected) {
      // Logger().i("userConnectEvent(): socketParams -> $socketParams");
      try {
        // _socket.emit("message", messagePayload);
        socket!.emitWithAck(
          getEvent(EventType.connect),
          {AppMapKeys.user_Id: userSingleton.id},
          ack: (data) {
            Logger().i("userConnectEvent() : Response -> $data");
          },
        );
      } on Exception catch (e) {
        Logger().e("userConnectEvent(): On catch $e");
      }
    } else {
      Logger().e("userConnectEvent():  socket not connect");
      connectToServer();
    }
  }

  /// A function to retrieve the list of recent chats from the server based on a filter.
  ///
  /// Required parameters:
  /// * [filterType]: the type of filter to apply to the list.
  /// * [onChatList]: a callback function that will be called with the response data if the server returns a successful response.
  /// * [onError]: a callback function that will be called with the error message if the server returns an error response.
  ///
  /// Optional parameters:
  /// * [showLoader]: whether or not to display a loader while waiting for the server response.
  /// * [filterIndex]: the index of the filter to apply, if applicable.
  /// * [isSendRecentChat]: whether or not to send the most recent chat data.
  /// * [isPullToRefresh]: whether or not the user has pulled to refresh the chat list.
  /// * [isEventCalling]: whether or not this function is being called as part of an event.
  ///
  /// Returns a [Future<dynamic>] object.
  Future<dynamic> chatListEvent(
      {required String filterType,
      int? limit,
      bool? showLoader,
      int? filterIndex,
      bool isSendRecentChat = false,
      bool isPUllToRefresh = false,
      required onChatList,
      required onError,
      bool isEventCalling = true}) async {
    if (socket!.connected) {
      // Create a map of parameters to send to the server

      Map<String, dynamic> socketParams = <String, dynamic>{};
      socketParams[AppMapKeys.userId] = userSingleton.id ?? -1;
      socketParams[AppMapKeys.skip] = isPUllToRefresh
          ? 0
          : isSendRecentChat
              ? 0
              : messengerController.chatList.length;
      socketParams[AppMapKeys.limit] = limit ?? defaultFetchLimit;
      socketParams[AppMapKeys.filter_by] = filterType;

      Logger().i("chatListEvent(): socketParams -> $socketParams");
      try {
        socket!.emitWithAck(
          getEvent(EventType.chatList),
          socketParams,
          ack: (data) {
            Logger().d("chatListEvent() : response -> $data");
            // Convert the response data to a ResponseModel object
            ResponseModel dataResponse = ResponseModel<ChatListData>.fromJson(data, null);
            if (dataResponse.status == 200) {
              Logger().d("chatListEvent() : response -> $dataResponse");
              onChatList(dataResponse.data);
            } else {
              Logger().d("chatListEvent() : error -> ${dataResponse.message}");
              onError(dataResponse.message);
            }
          },
        );
      } on Exception catch (e) {
        Logger().e("chatListEvent(): On catch $e");
        return null;
      }
    } else {
      Logger().e("chatListEvent(): socket not connect");
      connectToServer();
      return null;
    }
  }

  /// * [onChatList]: a callback function that will be called with the response data if the server returns a successful response.
  /// * [onError]: a callback function that will be called with the error message if the server returns an error response.
  Future<dynamic> sendMessageEvent(Map<String, dynamic> socketParams, {required onSend, required onError, String? querySearch}) async {
    if (socket!.connected) {
      Logger().i("sendMessageEvent(): socketParams -> $socketParams");

      try {
        socket!.emitWithAck(
          getEvent(EventType.sendMessage),
          socketParams,
          ack: (data) {
            Logger().d("sendMessageEvent() : response -> $data");
            ResponseModel dataResponse = ResponseModel<HistoryDetails>.fromJson(data, null);
            if (dataResponse.status == 200) {
              Logger().d("sendMessageEvent() : response -> $dataResponse");
              if (Get.isRegistered<OneToOneChatController>() == true) {
                OneToOneChatController oneToOneChatController = Get.find<OneToOneChatController>();
                oneToOneChatController.file.clear();
                oneToOneChatController.postImageVideoList.clear();
                oneToOneChatController.addImageVideoList.clear();
                oneToOneChatController.temp.clear();
                oneToOneChatController.historyList.insert(0, dataResponse.data);
                for (var message in oneToOneChatController.historyList) {
                  message.highlightedText = CommonUtils.highlightSearchQuery(message.message ?? '', querySearch ?? '');
                }
              }
              if (messengerController.chatList.isNotEmpty) {
                var matchingRoomIndex = messengerController.chatList.indexWhere((chat) => chat.id == (dataResponse.data.roomId ?? -1));
                if (matchingRoomIndex != -1) {
                  messengerController.chatList[matchingRoomIndex].lastMessage.value = dataResponse.data;
                  messengerController.chatList[matchingRoomIndex].isReadByYou.value = true;
                  sortPinnedAndEpochtime();
                } else {
                  // messengerController.chatList.clear();
                  messengerController.updateRecentChatList(Get.context!, isPullToRefresh: true);
                }
              }
              if (isChatScreenOpened) {
                messageStatusEvent(
                    roomId: dataResponse.data.roomId ?? -1,
                    onError: (msg) {
                      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
                    });
              }
              onSend(dataResponse);
            } else {
              Logger().d("sendMessageEvent() : error -> ${dataResponse.message}");
              onError(dataResponse.message);
            }
          },
        );
      } on Exception catch (e) {
        Logger().e("sendMessageEvent(): On catch $e");
        return null;
      }
    } else {
      Logger().e("sendMessageEvent(): socket not connect");
      return null;
    }
  }

  /// * [onChatList]: a callback function that will be called with the response data if the server returns a successful response.
  /// * [onError]: a callback function that will be called with the error message if the server returns an error response.
  Future<dynamic> chatHistoryEvent(Map<String, dynamic> socketParams, {required onChatHistory, required onError}) async {
    if (socket!.connected) {
      Logger().i("chatHistoryEvent(): socketParams -> $socketParams");
      if (isChatScreenOpened) {
        messageStatusEvent(
            roomId: socketParams[AppMapKeys.room_name],
            onError: (msg) {
              SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
            });
      }
      try {
        socket!.emitWithAck(
          getEvent(EventType.chatHistory),
          socketParams,
          ack: (data) {
            Logger().d("chatHistoryEvent() : response -> $data");
            ResponseModel dataResponse = ResponseModel<MessageHistoryData>.fromJson(data, null);
            if (dataResponse.status == 200) {
              Logger().d("chatHistoryEvent() : response -> $dataResponse");
              onChatHistory(dataResponse.data);
            } else {
              Logger().d("chatHistoryEvent() : error -> ${dataResponse.message}");
              onError(dataResponse.message);
            }
          },
        );
      } on Exception catch (e) {
        Logger().e("chatHistoryEvent(): On catch $e");
        return null;
      }
    } else {
      connectToServer();
      Logger().e("chatHistoryEvent(): socket not connect");
      return null;
    }
  }

  /// * [onSend]: a callback function that will be called with the response data if the server returns a successful response.
  /// * [onError]: a callback function that will be called with the error message if the server returns an error response.
  Future<dynamic> updateGroupEvent(Map<String, dynamic> socketParams, {required onSend, required onError}) async {
    if (socket!.connected) {
      Logger().i("updateGroupEvent(): socketParams -> $socketParams");

      try {
        socket!.emitWithAck(
          getEvent(EventType.updateGroup),
          socketParams,
          ack: (data) {
            Logger().d("updateGroupEvent() : response -> $data");
            ResponseModel dataResponse = ResponseModel<ChatDataa>.fromJson(data, null);
            if (dataResponse.status == 200) {
              Logger().d("updateGroupEvent() : response -> $dataResponse");
              AddGroupNameController addGroupNameController = Get.find();
              addGroupNameController.group.value = dataResponse.data.groupName ?? "";

              if (messengerController.chatList.isNotEmpty) {
                var matchingRoomIndex = messengerController.chatList.indexWhere((chat) => chat.id == (dataResponse.data.id ?? -1));
                if (matchingRoomIndex != -1) {
                  messengerController.chatList[matchingRoomIndex] = dataResponse.data;
                  sortPinnedAndEpochtime();
                } else {
                  var ab = messengerController.chatList.lastIndexWhere((chat) => chat.isChatPinned.value);
                  messengerController.chatList.insert(ab + 1, dataResponse.data);
                }
              }

              Get.back();
              onSend(dataResponse.data);
            } else {
              Logger().d("updateGroupEvent() : error -> ${dataResponse.message}");
              onError(dataResponse.message);
            }
          },
        );
      } on Exception catch (e) {
        Logger().e("updateGroupEvent(): On catch $e");
        return null;
      }
    } else {
      Logger().e("updateGroupEvent(): socket not connect");
      return null;
    }
  }

  _unreadStatusOn() {
    try {
      socket!.on(getEvent(EventType.unreadStatusOn), (data) {
        Logger().e("unreadStatusOn(): Unread Message Count = >>>>>>>>>>> $data");
        if (data != null) {
          if (Get.isRegistered<OneToOneChatController>() == true) {
            OneToOneChatController oneToOneChatController = Get.find<OneToOneChatController>();
            int roomName;
            if (oneToOneChatController.roomName is String) {
              roomName = int.parse(oneToOneChatController.roomName);
            } else {
              roomName = oneToOneChatController.roomName;
            }

            if (roomName == data['room_id'] && oneToOneChatController.isChatListCall.value == false) {
              /*oneToOneChatController.isChatListCall.value = true;*/
              return;
            } else {
              countUpdate(data);
              oneToOneChatController.isChatListCall.value = false;
            }
          } else {
            countUpdate(data);
          }
        }
      });
    } catch (e) {
      Logger().e("receiveMessageEvent(): On catch $e");
      return;
    }
  }

  countUpdate(dynamic data) {
    BottomTabsController bottomTabsController = Get.find();
    bottomTabsController.unReadMessageCount.value = data['count'];
  }

  _receiveMessageOn() {
    try {
      socket!.on(getEvent(EventType.receiveMessage), (data) {
        Logger().e("_receiveMessageOn(): Receive Message = >>>>>>>>>>> $data");
        var dataResponse = HistoryDetails.fromJson(data);
        if (isChatScreenOpened) {
          messageStatusEvent(
              roomId: dataResponse.roomId ?? -1,
              onError: (msg) {
                SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
              });
        }
        if (Get.isRegistered<OneToOneChatController>() == true) {
          OneToOneChatController oneToOneChatController = Get.find<OneToOneChatController>();
          int roomName;

          if (oneToOneChatController.roomName is String) {
            roomName = int.parse(oneToOneChatController.roomName);
          } else {
            roomName = oneToOneChatController.roomName;
          }

          if (dataResponse.roomId == roomName) {
            if (oneToOneChatController.isFromSearch) {
              if (oneToOneChatController.maxPage == 0) {
                oneToOneChatController.isReceiveMessage.value = false;
                oneToOneChatController.file.clear();
                oneToOneChatController.postImageVideoList.clear();
                oneToOneChatController.addImageVideoList.clear();
                oneToOneChatController.temp.clear();
                oneToOneChatController.historyList.insert(0, dataResponse);

                for (var message in oneToOneChatController.historyList) {
                  message.highlightedText = CommonUtils.highlightSearchQuery(message.message ?? '', '');
                }
              } else {
                oneToOneChatController.isReceiveMessage.value = true;
              }
            } else {
              oneToOneChatController.file.clear();
              oneToOneChatController.postImageVideoList.clear();
              oneToOneChatController.addImageVideoList.clear();
              oneToOneChatController.temp.clear();
              oneToOneChatController.historyList.insert(0, dataResponse);
              for (var message in oneToOneChatController.historyList) {
                message.highlightedText = CommonUtils.highlightSearchQuery(message.message ?? '', '');
              }
            }
          }
        }

        if (messengerController.chatList.isNotEmpty) {
          var matchingRoomIndex = messengerController.chatList.indexWhere((chat) => chat.id == (dataResponse.roomId ?? -1));
          if (matchingRoomIndex != -1) {
            messengerController.chatList[matchingRoomIndex].lastMessage.value = dataResponse;
            messengerController.chatList[matchingRoomIndex].isReadByYou.value = false;
            sortPinnedAndEpochtime();
          } else {
            messengerController.chatList.insert(0, ChatDataa.fromHistoryObject(dataResponse));
            messengerController.chatList[0].isReadByYou.value = false;
          }
        } else {
          messengerController.chatList.insert(0, ChatDataa.fromHistoryObject(dataResponse));
          messengerController.chatList[0].isReadByYou.value = false;
        }
      });
      /*_unreadStatusOn();*/
    } catch (e) {
      Logger().e("receiveMessageEvent(): On catch $e");
      return;
    }
  }

  _receiveGroupUpdateOn() {
    try {
      socket!.on(getEvent(EventType.updateGroup), (data) {
        Logger().d("Update Group Message Listen : response -> $data");
        ChatDataa dataResponse = ChatDataa.fromJson(data);
        if (Get.isRegistered<AddGroupNameController>() == true) {
          AddGroupNameController addGroupNameController = Get.find();
          addGroupNameController.group.value = dataResponse.groupName ?? "";
        }
        if (messengerController.chatList.isNotEmpty) {
          var matchingRoomIndex = messengerController.chatList.indexWhere((chat) => chat.id == (dataResponse.id ?? -1));
          if (matchingRoomIndex != -1) {
            messengerController.chatList[matchingRoomIndex] = dataResponse;
            messengerController.chatList[matchingRoomIndex].isReadByYou.value = true;
          } else {
            var ab = messengerController.chatList.lastIndexWhere((chat) => chat.isChatPinned.value);
            messengerController.chatList.insert(ab + 1, dataResponse);
          }
        }
      });
    } catch (e) {
      Logger().e("receiveGroupUpdateOn(): On catch $e");
      return;
    }
  }

  _leftGroupOn() {
    try {
      socket!.on(getEvent(EventType.leftGroup), (data) {
        Logger().d("left Group Listen : response -> $data");
        ChatDataa dataResponse = ChatDataa.fromJson(data);
        if (dataResponse.isGroup == true) {
          if (messengerController.chatList.isNotEmpty) {
            var matchingRoomIndex = messengerController.chatList.indexWhere((chat) => chat.id == (dataResponse.id ?? -1));
            if (matchingRoomIndex != -1) {
              messengerController.chatList[matchingRoomIndex] = dataResponse;
            }
          }
        }
      });
    } catch (e) {
      Logger().e("left Group Listen : On catch $e");
      return;
    }
  }

  /// * [onChatList]: a callback function that will be called with the response data if the server returns a successful response.
  /// * [onError]: a callback function that will be called with the error message if the server returns an error response.
  Future<dynamic> createGroupEvent(
      {required String roomType,
      bool isFromSendPost = false,
      bool onlyGroupCreated = false,
      int? feedForumId,
      required List<int> participate,
      String? messageText,
      String? type,
      List<int>? mediaIdList,
      required onSend,
      required onError}) async {
    // Create a map of parameters to send to the server
    Map<String, dynamic> socketParams = <String, dynamic>{};
    socketParams[AppMapKeys.room_type] = roomType;
    socketParams[AppMapKeys.participate] = participate;
    if (messageText != null) {
      socketParams[AppMapKeys.message] = messageText;
    }

    if (type != null) {
      socketParams[AppMapKeys.type] = type;
    }
    socketParams[AppMapKeys.user_Id] = (userSingleton.id ?? -1).toString();
    socketParams[AppMapKeys.media] = mediaIdList;

    if (type == "forum") {
      socketParams[AppMapKeys.forumId] = feedForumId;
    }
    if (type == "feed") {
      socketParams[AppMapKeys.feedId] = feedForumId;
    }

    if (socket!.connected) {
      Logger().i("Create Group: socketParams -> $socketParams");

      try {
        socket!.emitWithAck(
          getEvent(EventType.createGroup),
          socketParams,
          ack: (data) {
            Logger().d("Create Group : response -> $data");
            ResponseModel<ChatDataa> dataResponse = ResponseModel<ChatDataa>.fromJson(data, null);
            if (dataResponse.status == 200) {
              if (dataResponse.data != null) {
                if (messengerController.chatList.isNotEmpty) {
                  var matchingRoomIndex = messengerController.chatList.indexWhere((chat) => chat.id == (dataResponse.data?.id ?? -1));
                  if (matchingRoomIndex != -1) {
                    messengerController.chatList[matchingRoomIndex] = dataResponse.data!;
                    messengerController.chatList[matchingRoomIndex].isReadByYou.value = true;
                    sortPinnedAndEpochtime();
                  } else {
                    var ab = messengerController.chatList.lastIndexWhere((chat) => chat.isChatPinned.value);
                    messengerController.chatList.insert(ab + 1, dataResponse.data ?? ChatDataa());
                    messengerController.chatList[ab + 1].isReadByYou.value = true;
                    sortPinnedAndEpochtime();
                  }
                } else {
                  messengerController.chatList.insert(0, dataResponse.data ?? ChatDataa());
                  messengerController.chatList[0].isReadByYou.value = true;
                  sortPinnedAndEpochtime();
                }

                if (isFromSendPost == false || onlyGroupCreated == true) {
                  Get.toNamed(ScreenRoutesConstants.oneToOneChatScreen, arguments: [(dataResponse.data?.id ?? ""), (dataResponse.data?.groupName ?? ""), (dataResponse.data?.isGroup ?? false)]);
                  return;
                }
              }
              onSend(dataResponse);
            } else {
              Logger().d("Create Group () : error -> ${dataResponse.message}");
              onError(dataResponse.message);
            }
          },
        );
      } on Exception catch (e) {
        Logger().e("Create Group (): On catch $e");
        return null;
      }
    } else {
      Logger().e("Create Group (): socket not connect");
      return null;
    }
  }

  connectSocketIfNotConnected() {
    if (!(socket?.connected ?? false)) {
      connectToServer();
    }
  }

  Future<dynamic> pinGroupEvent(Map<String, dynamic> socketParams, {required onSend, required onError}) async {
    if (socket!.connected) {
      Logger().i("pin_group(): socketParams -> $socketParams");

      try {
        socket!.emitWithAck(
          getEvent(EventType.pinGroup),
          socketParams,
          ack: (data) {
            Logger().d("pin_group() : response -> $data");
            ResponseModel dataResponse = ResponseModel<ChatDataa>.fromJson(data, null);
            if (dataResponse.status == 200) {
              Logger().d("pin_group() : response -> $dataResponse");
              if (messengerController.chatList.isNotEmpty) {
                var matchingRoomIndex = messengerController.chatList.indexWhere((chat) => chat.id == (dataResponse.data.id ?? -1));
                if (matchingRoomIndex != -1) {
                  messengerController.chatList[matchingRoomIndex] = dataResponse.data;
                  sortPinnedAndEpochtime();
                }
              }
              onSend(dataResponse.data);
            } else {
              Logger().d("pin_group() : error -> ${dataResponse.message}");
              onError(dataResponse.message);
            }
          },
        );
      } on Exception catch (e) {
        Logger().e("pin_group(): On catch $e");
        return null;
      }
    } else {
      Logger().e("pin_group(): socket not connect");
      return null;
    }
  }

  /// * [onChatList]: a callback function that will be called with the response data if the server returns a successful response.
  /// * [onError]: a callback function that will be called with the error message if the server returns an error response.
  Future<dynamic> leftGroupEvent({required int roomName, required onSend, required onError}) async {
    Map<String, dynamic> socketParams = <String, dynamic>{};
    socketParams[AppMapKeys.room_name] = roomName;
    socketParams[AppMapKeys.user_Id] = userSingleton.id ?? -1;

    if (socket!.connected) {
      Logger().i("leftGroupEvent(): socketParams -> $socketParams");

      try {
        socket!.emitWithAck(
          getEvent(EventType.leftGroup),
          socketParams,
          ack: (data) {
            Logger().d("leftGroupEvent() : response -> $data");
            ResponseModel dataResponse = ResponseModel<ChatDataa>.fromJson(data, null);
            if (dataResponse.status == 200) {
              Logger().d("leftGroupEvent() : response -> $dataResponse");
              onSend(dataResponse);
            } else {
              Logger().d("leftGroupEvent() : error -> ${dataResponse.message}");
              onError(dataResponse.message);
            }
          },
        );
      } on Exception catch (e) {
        Logger().e("leftGroupEvent(): On catch $e");
        return null;
      }
    } else {
      Logger().e("leftGroupEvent(): socket not connect");
      return null;
    }
  }

  Future<dynamic> messageStatusEvent({required roomId, required onError}) async {
    /// Todo:- Change this as per new socket manager
    Map<String, dynamic> socketParams = <String, dynamic>{};
    socketParams[AppMapKeys.room_name] = roomId ?? -1;
    socketParams[AppMapKeys.userId] = userSingleton.id ?? -1;

    if (socket!.connected) {
      Logger().i("messageStatusEvent(): socketParams -> $socketParams");

      try {
        socket!.emitWithAck(
          getEvent(EventType.messageStatus),
          socketParams,
          ack: (data) {
            Logger().d("messageStatusEvent() : response -> $data");
            final dataResponse = ResponseModel.fromJson(data, null);
            if (dataResponse.status == 200) {
              Logger().d("messageStatusEvent() : response -> $dataResponse");
            } else {
              Logger().d("messageStatusEvent() : error -> ${dataResponse.message}");
              onError(dataResponse.message);
            }
          },
        );
      } on Exception catch (e) {
        Logger().e("messageStatusEvent(): On catch $e");
        return null;
      }
    } else {
      Logger().e("messageStatusEvent(): socket not connect");
      return null;
    }
  }
}
