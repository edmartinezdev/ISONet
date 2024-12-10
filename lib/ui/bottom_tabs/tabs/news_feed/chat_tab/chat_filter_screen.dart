import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/helper_manager/socket_manager/socket_manager_new.dart';
import 'package:iso_net/model/bottom_navigation_models/chat_model/recent_chat_model.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';

import '../../../../../controllers/bottom_tabs/tabs/messenger_tab_controller.dart';
import '../../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../style/appbar_components.dart';
import '../../../../style/image_components.dart';
import '../../../../style/text_style.dart';

class ChatFilterScreen extends StatefulWidget {
  const ChatFilterScreen({Key? key}) : super(key: key);

  @override
  State<ChatFilterScreen> createState() => _ChatFilterScreenState();
}

class _ChatFilterScreenState extends State<ChatFilterScreen> {

  MessengerController messengerController = Get.find<MessengerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBody(),
      body: buildBody(),
    );
  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      leadingWidget: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: ImageComponent.loadLocalImage(imageName: AppImages.arrow),
      ),
      titleWidget: Text(
        AppStrings.sortBy,
        style: ISOTextStyles.openSenseSemiBold(size: 17),
      ),
      centerTitle: true,
    );
  }

  void updateRecentChatList(BuildContext context) {
    SocketManagerNew().chatListEvent(filterType: messengerController.filterType.value, onChatList:(ChatListData objRecentChatList){
      messengerController.isApiResponseReceive.value = true;

      if (SocketManagerNew().isSendRecentUpdateList.value == false) {
        messengerController.totalRecord.value = objRecentChatList.totalRecord ?? 0;
        if (messengerController.chatList.isEmpty || messengerController.chatList.length == messengerController.totalRecord.value) {
          messengerController.chatList.value = objRecentChatList.data ?? [];
        } else {
          messengerController.chatList.addAll(objRecentChatList.data ?? []);
        }
        messengerController.isAllDataLoaded.value = ((messengerController.chatList.length) < (messengerController.totalRecord.value)) ? true : false;
        messengerController.isLoadMoreRunningForViewAll = false;
      }
    }, onError: (msg){
      messengerController.isApiResponseReceive.value = true;
      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
    });
  }

  Widget buildBody() {
    return Obx(
      () => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: messengerController.filterSelectionList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () async {
              for (var element in messengerController.filterSelectionList) {
                element.isFilterSelected.value = false;
              }
              if (index == 4) {
                messengerController.isFilterEnable.value = false;
                messengerController.filterIndex.value = null;
                messengerController.filterType.value = "";
              } else {
                messengerController.filterSelectionList[index].isFilterSelected.value = true;
                messengerController.filterType.value = messengerController.filterSelectionList[index].apiChatParam!;
                messengerController.isFilterEnable.value = true;
                messengerController.filterIndex.value = index;
              }


              messengerController.totalRecord.value = 0;
              messengerController.isAllDataLoaded.value = false;
              messengerController.chatList.clear();
              messengerController.isApiResponseReceive.value = false;
              updateRecentChatList(context);
              Get.back();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    messengerController.filterSelectionList[index].chat ?? '',
                    style: ISOTextStyles.openSenseSemiBold(size: 17),
                  ),
                  messengerController.filterSelectionList[index].isFilterSelected.value ? ImageComponent.loadLocalImage(imageName: AppImages.doneFill) : Container(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
