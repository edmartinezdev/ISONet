import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/bottom_tabs_controller.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/forum/forum_tab_controller.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/messenger_tab_controller.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/network/network_tab_controller.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/news_feed_tab_controller.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/recent_chat_list_controller.dart';
import 'package:iso_net/controllers/my_profile/my_profile_controller.dart';
import 'package:iso_net/controllers/my_profile/notification_listing_controller.dart';

class BottomTabsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BottomTabsController());
    Get.lazyPut(() => NewsFeedController());
    Get.lazyPut(() => ForumController(), fenix: true);
    Get.lazyPut(() => NetworkController(), fenix: true);
    Get.lazyPut(() => NotificationListingController(), fenix: true);
    Get.lazyPut(() => RecentChatListController());
    Get.lazyPut(() => MyProfileController(), fenix: true);
  }
}

class ChatBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MessengerController());
  }
}
