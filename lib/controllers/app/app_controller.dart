import 'package:get/get.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/network_util.dart';

import '../../utils/app_common_stuffs/app_logger.dart';

class AppController extends GetxController {
  bool isLoggedIn = false;
  String route = '';

  initUserData() async {

    Reachability reachability = Reachability();
    await reachability.setUpConnectivity();
    Logger().v("Network status : ${reachability.connectStatus}");

    await userSingleton.loadUserData();
    routes();
  }

  routes() async {
    if (userSingleton.userStage == 0 || userSingleton.userStage == null || userSingleton.userStage == 1) {
      route = ScreenRoutesConstants.startupScreen;
    } else if (userSingleton.userStage == 2) {
      route = ScreenRoutesConstants.detailScreen;
    } else if (userSingleton.userStage == 3) {
      route = ScreenRoutesConstants.userProfileImageScreen;
    } else if (userSingleton.userStage == 4) {
      if (userSingleton.isApproved == 'approved') {
        if (userSingleton.isSubscribed == false) {
          route = ScreenRoutesConstants.subscribeScreen;
        } else {
          route = ScreenRoutesConstants.bottomTabsScreen;
        }
      } else {
        route = ScreenRoutesConstants.startupScreen;
      }
    }
    update();
  }

}
