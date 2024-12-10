import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreenController extends GetxController{

  var roomId = Get.arguments;

  Future<void> sendMessage({
    required BuildContext context,
    required String roomId,
    required String message,
    required String imageId,
    Function()? onSentSuccess,
  }) async {
    final Map<String, dynamic> socketParams = {};
    socketParams["message"] = 'Ok';
    socketParams["type"] = 'text';
    //socketParams["media"] = message;
    // await SocketManager.sendMessageEvent(
    //   roomId,
    //   socketParams,
    //   onSent: (sendMessageResponse) {
    //
    //     SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: roomId);
    //     // userTyping(typeId: "0");
    //     // chatHistoryList.insert(0, sendMessageResponse.data);
    //     // if (onSentSuccess != null) {
    //     //   onSentSuccess();
    //     // }
    //   },
    //   onError: (message) {
    //     SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: roomId);
    //   },
    // );
  }
}