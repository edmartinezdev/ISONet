import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:iso_net/bindings/bottom_tabs/chat_tab/one_to_one_chat_binding.dart';
import 'package:iso_net/helper_manager/socket_manager/socket_manager_new.dart';
import 'package:iso_net/model/bottom_navigation_models/chat_model/recent_chat_model.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/chat_tab/one_to_one_chat_screen.dart';
import 'package:iso_net/ui/style/ImageWidget.dart';
import 'package:iso_net/ui/style/dialog_components.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_map_keys.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

// ignore: must_be_immutable
class ChatListAdaptor extends StatefulWidget {
  VoidCallback deleteItem;
  Rx<ChatDataa> chatData;
  bool isSearchEnable;
  String? searchQuery;

  ChatListAdaptor({Key? key, required this.chatData, required this.deleteItem, required this.isSearchEnable,this.searchQuery }) : super(key: key);

  @override
  State<ChatListAdaptor> createState() => _ChatListAdaptorState();
}

class _ChatListAdaptorState extends State<ChatListAdaptor> with AutomaticKeepAliveClientMixin<ChatListAdaptor> {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => widget.isSearchEnable == true
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GestureDetector(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  await Get.to(
                      OneToOneChatScreen(
                        totalChatHistoryRecords: widget.chatData.value.totalHistoryRecords,
                        messageIndex: widget.chatData.value.index,
                        isSearch: widget.isSearchEnable,
                        //searchQuery: widget.chatData.value.lastMessage.value?.message ?? '',
                        searchQuery: widget.searchQuery ?? '',
                      ),
                      arguments: [widget.chatData.value.id ?? -1, widget.chatData.value.groupName, widget.chatData.value.isGroup],
                      binding: OneToOneChatBinding());
                  widget.chatData.value.isReadByYou.value = true;
                  // widget.messengerController.chatList[index].isReadByYou.value = true;
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 16.w)),
                      Row(
                        children: [
                          widget.chatData.value.isGroup == true
                              ? (widget.chatData.value.participate?.length ?? 0) > 2
                                  ? SizedBox(
                                      width: 38.w,
                                      height: 38.w,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 0,
                                            top: 2.w,
                                            child: getGroupProfileImageUI(widget.chatData.value.participate?[0].profileImg ?? ''),
                                          ),
                                          Positioned(
                                            right: 0,
                                            top: 2.w,
                                            child: getGroupProfileImageUI(widget.chatData.value.participate?[1].profileImg ?? ''),
                                          ),
                                          Positioned(
                                            left: 10.5.w,
                                            top: 15.w,
                                            child: getGroupProfileImageUI(widget.chatData.value.participate?[2].profileImg ?? ''),
                                          ),
                                        ],
                                      ),
                                    )
                                  : (widget.chatData.value.participate?.length ?? 0) == 2
                                      ? SizedBox(
                                          width: 38.w,
                                          height: 38.w,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 0,
                                                top: 2.w,
                                                child: getGroupProfileImageUI(widget.chatData.value.participate?[0].profileImg ?? ''),
                                              ),
                                              Positioned(
                                                right: 0,
                                                top: 2.w,
                                                child: getGroupProfileImageUI(widget.chatData.value.participate?[1].profileImg ?? ''),
                                              ),
                                            ],
                                          ),
                                        )
                                      : getSingleImageUI(imageURL: widget.chatData.value.participate?[0].profileImg ?? '', isUserVerified: widget.chatData.value.isConnectionVerified ?? false,userType: widget.chatData.value.userType ?? '')
                              : Container(
                                  child: getSingleImageUI(imageURL: widget.chatData.value.groupImage ?? '', isUserVerified: widget.chatData.value.isConnectionVerified ?? false,userType: widget.chatData.value.userType ?? ''),
                                ),
                          8.sizedBoxW,
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          (widget.chatData.value.groupName?.length ?? 0) > 22
                                              ? SizedBox(
                                                  width: 145.w,
                                                  child: Text(
                                                    widget.chatData.value.groupName ?? "",
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: ISOTextStyles.openSenseRegular(
                                                      color: AppColors.blackColor,
                                                      size: 14,
                                                    ),
                                                  ),
                                                )
                                              : Text(
                                                  widget.chatData.value.groupName ?? "",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: ISOTextStyles.openSenseRegular(
                                                    color: AppColors.blackColor,
                                                    size: 14,
                                                  ),
                                                ),
                                          widget.chatData.value.isChatPinned.value == true ? 4.sizedBoxW : Container(),
                                          Obx(() => widget.chatData.value.isChatPinned.value == true ? ImageComponent.loadLocalImage(imageName: AppImages.pinChat) : Container()),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      widget.chatData.value.lastMessage.value?.getTimesRecentAgo ?? "",
                                      style: ISOTextStyles.openSenseLight(
                                        color: AppColors.chatTimeColor,
                                        size: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          maxLines: 1,
                                          widget.chatData.value.lastMessage.value?.message ?? '',
                                          style: ISOTextStyles.openSenseRegular(
                                            color: AppColors.chatMessageSuggestionColor,
                                            size: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    widget.isSearchEnable == true
                                        ? Container()
                                        : widget.chatData.value.isReadByYou.value == false
                                            ? ImageComponent.loadLocalImage(imageName: AppImages.redDot)
                                            : Container(),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        margin: EdgeInsets.only(top: 14.w),
                        color: AppColors.greyColor,
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Slidable(
              groupTag: '0',
              closeOnScroll: true,
              endActionPane: ActionPane(
                extentRatio: 0.4,
                motion: const ScrollMotion(),
                children: [
                  CustomSlidableAction(
                    backgroundColor: AppColors.primaryColor,
                    onPressed: (context) {
                      widget.chatData.value.isChatPinned.value = !widget.chatData.value.isChatPinned.value;
                      Map<String, dynamic> socketParams = <String, dynamic>{};
                      socketParams[AppMapKeys.room_name] = widget.chatData.value.id ?? "";
                      socketParams[AppMapKeys.user_Id] = userSingleton.id ?? -1;

                      SocketManagerNew().pinGroupEvent(socketParams, onSend: (ChatDataa objOfChatList) {}, onError: (msg) {
                        SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
                      });
                    },
                    child: SizedBox(height: 26, width: 26, child: ImageComponent.loadLocalImage(imageName: AppImages.pinTransparent, boxFit: BoxFit.contain)),
                  ),
                  CustomSlidableAction(
                      backgroundColor: AppColors.redColorDelete,
                      onPressed: (context) {
                        DialogComponent.showAlert(context,
                            message: (widget.chatData.value.isGroup ?? false) == true ? AppStrings.leftGroupMsg : AppStrings.leftChatMsg,
                            arrButton: [AppStrings.btnNo, AppStrings.btnYes], callback: (btnIndex) {
                          if (btnIndex == 1) {
                            SocketManagerNew().leftGroupEvent(
                                roomName: widget.chatData.value.id ?? -1,
                                onSend: (chatData) {
                                  /// below if condition is used for left group call back.
                                  widget.deleteItem();
                                },
                                onError: (msg) {
                                  SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                });
                          }
                        });
                      },
                      child: SizedBox(height: 19, width: 22, child: ImageComponent.loadLocalImage(imageName: AppImages.trash, height: 22, boxFit: BoxFit.contain))),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    await Get.to(OneToOneChatScreen(totalChatHistoryRecords: widget.chatData.value.totalHistoryRecords, messageIndex: widget.chatData.value.index, isSearch: widget.isSearchEnable),
                        arguments: [widget.chatData.value.id ?? -1, widget.chatData.value.groupName, widget.chatData.value.isGroup], binding: OneToOneChatBinding());
                    widget.chatData.value.isReadByYou.value = true;
                    // widget.messengerController.chatList[index].isReadByYou.value = true;
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 16.w)),
                        Row(
                          children: [
                            widget.chatData.value.isGroup == true
                                ? (widget.chatData.value.participate?.length ?? 0) > 2
                                    ? SizedBox(
                                        width: 38.w,
                                        height: 38.w,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              left: 0,
                                              top: 2.w,
                                              child: getGroupProfileImageUI(widget.chatData.value.participate?[0].profileImg ?? ''),
                                            ),
                                            Positioned(
                                              right: 0,
                                              top: 2.w,
                                              child: getGroupProfileImageUI(widget.chatData.value.participate?[1].profileImg ?? ''),
                                            ),
                                            Positioned(
                                              left: 10.5.w,
                                              top: 15.w,
                                              child: getGroupProfileImageUI(widget.chatData.value.participate?[2].profileImg ?? ''),
                                            ),
                                          ],
                                        ),
                                      )
                                    : (widget.chatData.value.participate?.length ?? 0) == 2
                                        ? SizedBox(
                                            width: 38.w,
                                            height: 38.w,
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  left: 0,
                                                  top: 2.w,
                                                  child: getGroupProfileImageUI(widget.chatData.value.participate?[0].profileImg ?? ''),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  top: 2.w,
                                                  child: getGroupProfileImageUI(widget.chatData.value.participate?[1].profileImg ?? ''),
                                                ),
                                              ],
                                            ),
                                          )
                                        : getSingleImageUI(imageURL: widget.chatData.value.participate?[0].profileImg ?? '', isUserVerified: widget.chatData.value.isConnectionVerified ?? false,userType: widget.chatData.value.userType ?? '')
                                : Container(
                                    child: getSingleImageUI(imageURL: widget.chatData.value.groupImage ?? '', isUserVerified: widget.chatData.value.isConnectionVerified ?? false,userType: widget.chatData.value.userType ?? ''),
                                  ),
                            8.sizedBoxW,
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            (widget.chatData.value.groupName?.length ?? 0) > 22
                                                ? SizedBox(
                                                    width: 145.w,
                                                    child: Text(
                                                      widget.chatData.value.groupName ?? "",
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: ISOTextStyles.openSenseRegular(
                                                        color: AppColors.blackColor,
                                                        size: 14,
                                                      ),
                                                    ),
                                                  )
                                                : Text(
                                                    widget.chatData.value.groupName ?? "",
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: ISOTextStyles.openSenseRegular(
                                                      color: AppColors.blackColor,
                                                      size: 14,
                                                    ),
                                                  ),
                                            widget.chatData.value.isChatPinned.value == true ? 4.sizedBoxW : Container(),
                                            Obx(() => widget.chatData.value.isChatPinned.value == true ? ImageComponent.loadLocalImage(imageName: AppImages.pinChat) : Container()),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        widget.chatData.value.lastMessage.value?.getTimesRecentAgo ?? "",
                                        style: ISOTextStyles.openSenseLight(
                                          color: AppColors.chatTimeColor,
                                          size: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            maxLines: 1,
                                            widget.chatData.value.lastMessage.value?.message ?? '',
                                            style: ISOTextStyles.openSenseRegular(
                                              color: AppColors.chatMessageSuggestionColor,
                                              size: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      widget.isSearchEnable == true
                                          ? Container()
                                          : widget.chatData.value.isReadByYou.value == false
                                              ? ImageComponent.loadLocalImage(imageName: AppImages.redDot)
                                              : Container(),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 1,
                          margin: EdgeInsets.only(top: 14.w),
                          color: AppColors.greyColor,
                        ),
                      ],
                    ),
                  ),
                ),
              )),
    );
  }

  Container getGroupProfileImageUI(String imageURL) {
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

  Widget getSingleImageUI({required String imageURL, bool isUserVerified = false,String userType = ''}) {
    return Stack(
      children: [
        ImageComponent.circleNetworkImage(
          imageUrl: imageURL,
          height: 45.w,
          width: 45.w,
        ),
        Visibility(
          visible: isUserVerified == true,
          child: Positioned(
            bottom: 0,
            right: 0,
            child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, height: 14.h, width: 14.w, boxFit: BoxFit.contain),
          ),
        ),
        Visibility(
          visible: userType.isNotEmpty,
          child: Positioned(
            top: 0,
            left: 0,
            child: ImageComponent.loadLocalImage(imageName: userType == AppStrings.fu ? AppImages.funderBadge : AppImages.brokerBadge, height: 14.h, width: 14.w, boxFit: BoxFit.contain),
          ),
        ),
      ],
    );
  }
}
