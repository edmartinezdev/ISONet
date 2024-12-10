import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/messenger_tab_controller.dart';
import 'package:iso_net/helper_manager/socket_manager/socket_manager_new.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';

class NetworkUtil {
  static Future<bool> isNetworkConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }
}

class Reachability extends Object {
  final Connectivity _connectivity = Connectivity();

  // network change subscription
  // ignore: cancel_subscriptions
  StreamSubscription<ConnectivityResult>? connectivitySubscription;

  // current network status
  String _connectStatus = 'Unknown';

  String get connectStatus => _connectStatus;

  //Constant for check network status
  static const String _connectivityMobile = "ConnectivityResult.mobile";
  static const String _connectivityWifi = "ConnectivityResult.wifi";

  factory Reachability() {
    return _singleton;
  }

  static final Reachability _singleton = Reachability._internal();

  Reachability._internal() {
    connectivitySubscription = _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectStatus = result.toString();
      Logger().v("ConnectionStatus :: = $_connectStatus");
      if ((_connectStatus == Reachability._connectivityMobile) || (_connectStatus == Reachability._connectivityWifi)) {
        if (Get.isRegistered<MessengerController>() == true) {
          SocketManagerNew().connectToServer();
        }

      }else{
        if(Get.context != null ){
          SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: AppStrings.noInternetMsg);
        }
      }
    });
  }

  dispose() async {
    await connectivitySubscription?.cancel();
  }

  //cancel subscription for network change
  unregisterReachbilityChange() async {
    await dispose();
  }

  // set up initial
  Future<void> setUpConnectivity() async {
    String connectionStatus;

    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
      Logger().v("ConnectionStatus :: => $connectionStatus");
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      connectionStatus = 'Failed to get connectivity.';
    }

    _connectStatus = connectionStatus;
    Logger().v("ConnectionStatus :: => $_connectStatus");
  }

  // check for network available
  bool isInterNetAvaialble() {
    Logger().v("ConnectionStatus :: => $_connectStatus");
    return (_connectStatus == Reachability._connectivityMobile) || (_connectStatus == Reachability._connectivityWifi);
  }
}
