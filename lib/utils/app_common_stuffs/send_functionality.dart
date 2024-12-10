import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/recent_chat_list_controller.dart';
import 'package:iso_net/helper_manager/socket_manager/socket_manager_new.dart';
import 'package:iso_net/ui/style/ImageWidget.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';
import 'package:rxdart/rxdart.dart';

import '../../controllers/bottom_tabs/tabs/network/viewmy_network_controller.dart';
import '../../singelton_class/auth_singelton.dart';
import '../../ui/style/image_components.dart';
import '../../ui/style/text_style.dart';
import 'app_colors.dart';
import 'app_logger.dart';

final _recentChatlistSubject = PublishSubject<bool>();

Stream<bool> get recentChatListStream => _recentChatlistSubject.stream;

class SendFunsctionality {
  static Future sendBottomSheet({
    int? feedId,
    int? forumId,
    String? headingText,
    required BuildContext context,
  }) {
    ViewMyNetworkController viewMyNetworkController = Get.put(ViewMyNetworkController());
    viewMyNetworkController.totalRecord.value = 0;
    viewMyNetworkController.pageToShow.value = 1;
    viewMyNetworkController.isAllDataLoaded.value = false;
    viewMyNetworkController.isDataLoad.value = true;
    viewMyNetworkController.myNetworkList.clear();
    viewMyNetworkController.getMyNetworkApi(pageToShow: viewMyNetworkController.pageToShow.value, isShowLoader: false);
    RecentChatListController rcentChatListController = Get.find();
    rcentChatListController.chatList.clear();

    /// Todo:- Change this as per new socket manager
    SocketManagerNew().isSendRecentUpdateList.value = true;
    rcentChatListController.updateRecentChatList(context);

    return Get.bottomSheet(
        Container(
          height: MediaQuery.of(context).size.height * 0.80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0.r),
              topRight: Radius.circular(12.0.r),
            ),
            color: AppColors.whiteColor,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                headingText ?? '',
                style: ISOTextStyles.openSenseBold(
                  size: 22,
                ),
              ),
              18.sizedBoxH,
              Expanded(
                child: ListView(
                  controller: viewMyNetworkController.scrollController,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Visibility(
                            visible: rcentChatListController.chatList.isNotEmpty,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recent Chat List',
                                  style: ISOTextStyles.openSenseBold(
                                    size: 16,
                                  ),
                                ),
                                8.sizedBoxH,
                                Obx(
                                  () => ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: rcentChatListController.chatList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      if (rcentChatListController.chatList[index].isBlockedByYou == true) {
                                        return Container();
                                      } else {
                                        return Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.0.h),
                                          child: Row(
                                            children: [
                                              Row(
                                                children: [
                                                  rcentChatListController.chatList[index].isGroup == true
                                                      ? (rcentChatListController.chatList[index].participate?.length ?? 0) > 2
                                                          ? SizedBox(
                                                              width: 38.w,
                                                              height: 38.w,
                                                              child: Stack(
                                                                children: [
                                                                  Positioned(
                                                                    left: 0,
                                                                    top: 2.w,
                                                                    child: getGroupProfileImageUI(rcentChatListController.chatList[index].participate?[0].profileImg ?? ''),
                                                                  ),
                                                                  Positioned(
                                                                    right: 0,
                                                                    top: 2.w,
                                                                    child: getGroupProfileImageUI(rcentChatListController.chatList[index].participate?[1].profileImg ?? ''),
                                                                  ),
                                                                  Positioned(
                                                                    left: 10.5.w,
                                                                    top: 15.w,
                                                                    child: getGroupProfileImageUI(rcentChatListController.chatList[index].participate?[2].profileImg ?? ''),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          : (rcentChatListController.chatList[index].participate?.length ?? 0) == 2
                                                              ? SizedBox(
                                                                  width: 38.w,
                                                                  height: 38.w,
                                                                  child: Stack(
                                                                    children: [
                                                                      Positioned(
                                                                        left: 0,
                                                                        top: 2.w,
                                                                        child: getGroupProfileImageUI(rcentChatListController.chatList[index].participate?[0].profileImg ?? ''),
                                                                      ),
                                                                      Positioned(
                                                                        right: 0,
                                                                        top: 2.w,
                                                                        child: getGroupProfileImageUI(rcentChatListController.chatList[index].participate?[1].profileImg ?? ''),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : getSingleImageUI(rcentChatListController.chatList[index].participate?[0].profileImg ?? '')
                                                      : (rcentChatListController.chatList[index].participate!.isNotEmpty &&
                                                              userSingleton.id != rcentChatListController.chatList[index].participate?[0].id)
                                                          ? getSingleImageUI(rcentChatListController.chatList[index].participate?[0].profileImg ?? '')
                                                          : (rcentChatListController.chatList[index].participate!.length > 1 &&
                                                                  userSingleton.id != rcentChatListController.chatList[index].participate?[1].id)
                                                              ? getSingleImageUI(rcentChatListController.chatList[index].participate?[1].profileImg ?? '')
                                                              : Container(child: getSingleImageUI(rcentChatListController.chatList[index].groupImage ?? '')),
                                                ],
                                              ),
                                              8.sizedBoxW,
                                              Expanded(
                                                child: Text(rcentChatListController.chatList[index].groupName ?? ''),
                                              ),
                                              8.sizedBoxH,
                                              Obx(
                                                () => InkWell(
                                                  onTap: rcentChatListController.chatList[index].isSend.value != true
                                                      ? () async {
                                                          if (rcentChatListController.chatList[index].roomName != null) {
                                                            if (feedId != null && rcentChatListController.chatList[index].isSend.value != true) {
                                                              Logger().i('Send Feed Event Call');
                                                              rcentChatListController.isRefreshRecentChatList.value = false;
                                                              rcentChatListController.sendMessageToChat(type: "feed", feedId: feedId, roomId: rcentChatListController.chatList[index].id ?? -1);
                                                              sendRecentChatAutoSentInNetwork(viewMyNetworkController.myNetworkList, rcentChatListController.chatList[index]);

                                                              rcentChatListController.chatList[index].isSend.value = true;
                                                            } else if (forumId != null && rcentChatListController.chatList[index].isSend.value != true) {
                                                              Logger().i('Send Forum Event Call');
                                                              rcentChatListController.isRefreshRecentChatList.value = false;
                                                              rcentChatListController.sendMessageToChat(type: "forum", feedId: forumId, roomId: rcentChatListController.chatList[index].id ?? -1);
                                                              sendRecentChatAutoSentInNetwork(viewMyNetworkController.myNetworkList, rcentChatListController.chatList[index]);
                                                              rcentChatListController.chatList[index].isSend.value = true;
                                                            } else {
                                                              null;
                                                            }
                                                          }
                                                        }
                                                      : () {},
                                                  child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.0.h),
                                                      decoration: BoxDecoration(
                                                        color: rcentChatListController.chatList[index].isSend.value ? AppColors.greyColor : AppColors.primaryColor,
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                      child: Text(
                                                        rcentChatListController.chatList[index].isSend.value ? 'Sent' : 'Send',
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        rcentChatListController.chatList.isNotEmpty ? 18.sizedBoxH : Container(),
                        Text(
                          'My Network List',
                          style: ISOTextStyles.openSenseBold(size: 16),
                        ),
                        14.sizedBoxH,
                        Obx(
                          () => ListView.builder(
                            itemCount: viewMyNetworkController.isAllDataLoaded.value ? viewMyNetworkController.myNetworkList.length + 1 : viewMyNetworkController.myNetworkList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == viewMyNetworkController.myNetworkList.length) {
                                Future.delayed(
                                  const Duration(milliseconds: 100),
                                  () async {
                                    await _handleLoadMoreList();
                                  },
                                );
                                return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
                              }
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.0.h),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: CachedNetworkImageProvider(viewMyNetworkController.myNetworkList[index].profileImg ?? ''),
                                    ),
                                    8.sizedBoxW,
                                    Expanded(child: Text('${viewMyNetworkController.myNetworkList[index].firstName ?? ''} ${viewMyNetworkController.myNetworkList[index].lastName ?? ''}')),
                                    Obx(() => InkWell(
                                          onTap: viewMyNetworkController.myNetworkList[index].isSend.value != true
                                              ? () async {
                                                  if (viewMyNetworkController.myNetworkList[index].roomId != null) {
                                                    if (feedId != null) {
                                                      Logger().i('Send Feed Event Call');
                                                      rcentChatListController.isRefreshRecentChatList.value = false;

                                                      /// Done:- Change this as per new socket manager
                                                      rcentChatListController.sendMessageToChat(type: "feed", feedId: feedId, roomId: viewMyNetworkController.myNetworkList[index].roomId ?? -1);
                                                      sendNetworkAutoSentInRecentChat(viewMyNetworkController.myNetworkList, rcentChatListController.chatList, index);
                                                      // viewMyNetworkController.myNetworkList[index].isSend.value = true;
                                                    } else if (forumId != null) {
                                                      Logger().i('Send Forum Event Call');
                                                      rcentChatListController.isRefreshRecentChatList.value = false;

                                                      /// Done:- Change this as per new socket manager
                                                      rcentChatListController.sendMessageToChat(type: "forum", feedId: forumId, roomId: viewMyNetworkController.myNetworkList[index].roomId ?? -1);
                                                      sendNetworkAutoSentInRecentChat(viewMyNetworkController.myNetworkList, rcentChatListController.chatList, index);
                                                      viewMyNetworkController.myNetworkList[index].isSend.value = true;
                                                    }
                                                  } else {
                                                    if (feedId != null) {
                                                      rcentChatListController.isRefreshRecentChatList.value = false;

                                                      /// Done:- Change this as per new socket manager
                                                      rcentChatListController.createNewGroupChat(type: "feed", feedForumId: feedId, userId: viewMyNetworkController.myNetworkList[index].userId ?? 0);
                                                      // SocketManager().sendMessageFeed(
                                                      //     feedId: feedId, roomName: viewMyNetworkController.roomName.value, senderId: viewMyNetworkController.myNetworkList[index].userId ?? 0);
                                                      sendNetworkAutoSentInRecentChat(viewMyNetworkController.myNetworkList, rcentChatListController.chatList, index);
                                                      viewMyNetworkController.myNetworkList[index].isSend.value = true;
                                                    } else if (forumId != null) {
                                                      rcentChatListController.isRefreshRecentChatList.value = false;

                                                      /// Done:- Change this as per new socket manager
                                                      rcentChatListController.createNewGroupChat(type: "forum", feedForumId: forumId, userId: viewMyNetworkController.myNetworkList[index].userId ?? 0);
                                                      sendNetworkAutoSentInRecentChat(viewMyNetworkController.myNetworkList, rcentChatListController.chatList, index);
                                                      viewMyNetworkController.myNetworkList[index].isSend.value = true;
                                                    }
                                                  }
                                                }
                                              : () {},
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.0.h),
                                            decoration: BoxDecoration(
                                              color: viewMyNetworkController.myNetworkList[index].isSend.value ? AppColors.greyColor : AppColors.primaryColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              viewMyNetworkController.myNetworkList[index].isSend.value ? 'Sent' : 'Send',
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              );
                              /* if (index < viewMyNetworkController.myNetworkList.length) {


                              } else {
                                if (viewMyNetworkController.paginationLoadData()) {
                                  return const Divider();
                                } else {
                                  return Container(
                                    padding: EdgeInsets.symmetric(vertical: 16.0.h),
                                    alignment: Alignment.center,
                                    child: const CupertinoActivityIndicator(),
                                  );
                                }
                              }*/
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        isScrollControlled: true);
  }

  static Future _handleLoadMoreList() async {
    ViewMyNetworkController viewMyNetworkController = Get.put(ViewMyNetworkController());
    if (!viewMyNetworkController.isAllDataLoaded.value) return;
    if (viewMyNetworkController.isLoadMoreRunningForViewAll) return;
    viewMyNetworkController.isLoadMoreRunningForViewAll = true;
    await viewMyNetworkController.viewMyNetworkPagination();
  }

  static sendRecentChatAutoSentInNetwork(networkList, chatList) {
    for (int i = 0; i < networkList.length; i++) {
      for (int j = 0; j < (chatList.participate?.length ?? 0); j++) {
        if (networkList[i].userId == chatList.participate?[j].id && chatList.isGroup == false) {
          networkList[i].isSend.value = true;
          networkList.refresh();
        }
      }
    }
  }

  static sendNetworkAutoSentInRecentChat(networkList, chatList, index) {
    for (int i = 0; i < chatList.value.length; i++) {
      for (int j = 0; j < (chatList[i].participate?.length ?? 0); j++) {
        if (chatList[i].participate?[j].id == networkList[index].userId && chatList[i].isGroup == false) {
          chatList[i].isSend.value = true;

          chatList.refresh();
        }
      }
    }
    networkList[index].isSend.value = true;
    networkList.refresh();
    _recentChatlistSubject.sink.add(true);
  }

  static Container getGroupProfileImageUI(String imageURL) {
    return Container(
      height: 20.13.w,
      width: 20.13.w,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.whiteColor, width: 1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: ImageWidget(
            url: imageURL,
            fit: BoxFit.cover,
            placeholder: AppImages.imagePlaceholder,
          )),
    );
  }

  static ClipRRect getSingleImageUI(String imageURL) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(46.w / 2),
      child: ImageComponent.circleNetworkImage(
        imageUrl: imageURL,
        width: 45.w,
        height: 45.w,
      ),
    );
  }
}
