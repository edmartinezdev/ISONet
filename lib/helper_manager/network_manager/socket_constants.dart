import 'package:iso_net/main.dart';
import 'package:iso_net/utils/enums_all/enums.dart';

enum EventType { connect, userList, userTyping, startTyping, stopTyping, sendMessage, chatHistory, chatList, messageStatus, serverMessageStatus, receiveMessage, disConnected }

class SocketConstant {
  //change when live url
  static bool get isLiveURl => true;

  static const int statusCodeSuccess = 200;
  static const int statusCodeCreated = 201;
  static const int statusCodeNotFound = 404;
  static const int statusCodeServiceNotAvailable = 503;
  static const int statusCodeBadGateway = 502;
  static const int statusCodeServerError = 500;

  static const int timeoutDurationNormalAPIs = 30000;

  /// 30 seconds
  static const int timeoutDurationMultipartAPIs = 120000;

  /// 120 seconds

  static String get prefixVersionSocket => "/v3/chat";
  static String get baseDomainSocket {
    switch (env) {
      case Environment.dev:
        return 'http://202.131.117.92:7160';
      case Environment.prod:
        return 'https://isonetchat.admindd.com';
      default:
        return "";
    }
  }

  static String get prefixVersion => "/recent_chat_list/";

  static String getEvent(EventType type) {
    switch (type) {
      case EventType.connect:
        return "client-user-connected";
      case EventType.userList:
        return "client-user-listing";
      case EventType.sendMessage:
        return "client-send-message";
      case EventType.chatHistory:
        return "client-chat-history";
      case EventType.chatList:
        return "client-chat-listing";
      case EventType.messageStatus:
        return "client-change-message-status-all";
      case EventType.serverMessageStatus:
        return "server-change-message-status-all";
      case EventType.receiveMessage:
        return "server-receive-message";
      case EventType.userTyping:
        return "client-user-typing";
      case EventType.startTyping:
        return "server-typing-start";
      case EventType.stopTyping:
        return "server-typing-stop";
      case EventType.disConnected:
        return "client-disconnected";
    }
  }
}
