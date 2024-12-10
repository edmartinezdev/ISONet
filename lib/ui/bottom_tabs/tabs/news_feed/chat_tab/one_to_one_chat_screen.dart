// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/chat/add_group_name_controller.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/chat/one_to_one_chat_controller.dart';
import 'package:iso_net/helper_manager/socket_manager/socket_manager_new.dart';
import 'package:iso_net/ui/style/ImageWidget.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../../bindings/bottom_tabs/feed_detail_binding.dart';
import '../../../../../bindings/bottom_tabs/forum_detail_binding.dart';
import '../../../../../helper_manager/media_selector_manager/media_selector_manager.dart';
import '../../../../../helper_manager/network_manager/api_const.dart';
import '../../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../../../utils/network_util.dart';
import '../../../../common_ui/video_play_screen.dart';
import '../../../../style/dialog_components.dart';
import '../../../../style/image_components.dart';
import '../../../../style/showloader_component.dart';
import '../../../../style/text_style.dart';
import '../../forum/forum_detail_screen.dart';
import '../feed_detail_screen.dart';
import 'image_fullscreen.dart';

enum AttachMenuEnum { itemOne, itemTwo, itemThree }

class OneToOneChatScreen extends StatefulWidget {
  int? messageIndex;
  bool? isSearch;
  String? searchQuery;
  int? totalChatHistoryRecords;

  OneToOneChatScreen({Key? key, this.messageIndex, this.isSearch, this.searchQuery, this.totalChatHistoryRecords}) : super(key: key);

  @override
  State<OneToOneChatScreen> createState() => _OneToOneChatScreenState();
}

class _OneToOneChatScreenState extends State<OneToOneChatScreen> {
  OneToOneChatController oneToOneChatController = Get.find<OneToOneChatController>();
  AddGroupNameController addGroupNameController = Get.find<AddGroupNameController>();

  XFile? selectedImage;
  final ImagePicker picker = ImagePicker();
  CroppedFile? croppedImage;
  List<AppMultiPartFile> arrFile = [];

  @override
  void initState() {
    super.initState();
    _initChatScreen();
  }

  Future<void> _initChatScreen() async {
    /*if (widget.isSearch == true) {
      if ((widget.totalChatHistoryRecords ?? 0) < 20) {
        oneToOneChatController.minPage = 0;
        oneToOneChatController.maxPage = 0;
      } else if (((widget.totalChatHistoryRecords ?? 0) - (widget.messageIndex ?? 0)) < 20 && ((widget.totalChatHistoryRecords ?? 0) - (widget.messageIndex ?? 0)) != 0) {
        if ((widget.messageIndex ?? 0) - 10 > 0) {
          oneToOneChatController.minPage = (widget.messageIndex ?? 0) - 10;
          oneToOneChatController.maxPage = (widget.messageIndex ?? 0);
        } else {
          oneToOneChatController.minPage = (widget.messageIndex ?? 0);
          oneToOneChatController.maxPage = (widget.messageIndex ?? 0);
        }
      } else {
        oneToOneChatController.minPage = (widget.messageIndex ?? 0);
        oneToOneChatController.maxPage = (widget.messageIndex ?? 0);
      }

      oneToOneChatController.isFromSearch = widget.isSearch ?? false;
    }*/
    oneToOneChatController.roomName = Get.arguments[0];
    oneToOneChatController.groupName = Get.arguments[1];
    oneToOneChatController.isGroup = Get.arguments[2];
    SocketManagerNew().isChatScreenOpened = true;

    _isFromSearch();
    _getChatHistoryEvent();
    _createRoomSendMessageMethod();

    await _chatRoomPagination();
  }

  ///****[_isFromSearch] Function is use when user came from the search screen ******///
  void _isFromSearch() {
    ///[widget.isSearch == true] Dev when user come from the search screen dev hase to manage pagination according to totalRecord & messageIndex
    ///[widget.isSearch] flag true while user came from search screen
    ///[widget.messageIndex] is search message index no in list
    ///[widget.searchQuery] has message user search text while they came from search screen
    ///[widget.totalChatHistoryRecords] has how many record is in the chat room
    if (widget.isSearch == true) {
      final totalRecords = widget.totalChatHistoryRecords ?? 0;
      final messageIndex = widget.messageIndex ?? 0;

      /// if the [widget.totalChatHistoryRecords] less then 20 so dev has to set [minPage,maxPage] = 0
      /// And the page set accordingly in chatHistory socket event
      if (totalRecords < 20) {
        oneToOneChatController.minPage = 0;
        oneToOneChatController.maxPage = 0;
      }

      /// If total record > 20 & my message index is in first 20 records
      /// Dev has to minus [messageIndex] to 10 but if  minus result is 0 or negative so we have to pass [messageIndex] into [minPage]
      else if (totalRecords - messageIndex < 20 && totalRecords - messageIndex != 0) {
        final newMinPage = messageIndex - 10 > 0 ? messageIndex - 10 : messageIndex;
        oneToOneChatController.minPage = newMinPage;
        oneToOneChatController.maxPage = messageIndex;
      }

      ///If total record > 20 & my message index is not in first 20 records
      else {
        oneToOneChatController.minPage = messageIndex;
        oneToOneChatController.maxPage = messageIndex;
      }

      oneToOneChatController.isFromSearch = widget.isSearch ?? false;
    }
  }

  ///***** Chat room pagination function [_chatRoomPagination]*******///
  Future<void> _chatRoomPagination() async {
    oneToOneChatController.scrollController.addListener(
      () {
        if (oneToOneChatController.isFromSearch == false) {
          if ((oneToOneChatController.scrollController.position.pixels == oneToOneChatController.scrollController.position.maxScrollExtent) &&
              (oneToOneChatController.historyList.length < oneToOneChatController.totalRecords.value)) {
            oneToOneChatController.isPaginationActiveFromBottom.value = false;
            oneToOneChatController.minPage = oneToOneChatController.historyList.length;
            Future.delayed(
              const Duration(milliseconds: 100),
              () async {
                await _handleLoadMoreList();
              },
            );
          }
        } else {
          ///In the chat room history list view is in reverse order so when user scroll towards to down if condition will be in use other wise else condition in use
          if ((oneToOneChatController.scrollController.position.pixels == oneToOneChatController.scrollController.position.minScrollExtent) &&
              (oneToOneChatController.historyList.length < oneToOneChatController.totalRecords.value)) {
            oneToOneChatController.isPaginationActiveFromBottom.value = true;
            calculateMaximumPagination();
          } else if ((oneToOneChatController.scrollController.position.pixels == oneToOneChatController.scrollController.position.maxScrollExtent) &&
              (oneToOneChatController.historyList.length < oneToOneChatController.totalRecords.value)) {
            oneToOneChatController.isPaginationActiveFromBottom.value = false;
            calculateMinimumPagination();
          }
        }
      },
    );
  }

  ///[_createRoomSendMessageMethod] function for if user creating oneToOne chat but the room already exist
  ///In that function message will be send first time after the get chat history event call
  void _createRoomSendMessageMethod() {
    if (oneToOneChatController.chatMessage.value.isNotEmpty) {
      oneToOneChatController.sendMessageToChat(type: "text", messageValue: oneToOneChatController.chatMessage.value, searchQuery: widget.searchQuery ?? '');
      oneToOneChatController.chatMessage.value = '';
    }
  }

  ///[_getChatHistoryEvent] function for get room chat history socket event called while user user enter the chat room
  _getChatHistoryEvent() async {
    await oneToOneChatController.getChatHistoryEvent(searchQuery: widget.searchQuery ?? '');
  }

  ///[calculateMinimumPagination] while user scrolling towards to up this function will be called in pagination
  ///[calculateMinimumPagination] function use while user enter the room screen while searching otherwise normal pagination will be use
  calculateMinimumPagination() {
    /// In if condition is true than dev has to check chat total record minus current [historyList] length is match to [widget.messageIndex]

    if ((oneToOneChatController.totalRecords.value - oneToOneChatController.minPage) < defaultFetchLimit) {
      var temp = oneToOneChatController.totalRecords.value - oneToOneChatController.historyList.length;

      /// If condition true we don't need to call load more chat history list because we already have record in our list

      if (widget.messageIndex == temp) {
        return;
      }

      ///If [widget.messageIndex] & [temp] count is not match in that case there is more data in chat history list so
      ///Simply we add [minPage] + [historyList.length] assign to minPage and call loadMore history chat

      else {
        oneToOneChatController.minPage = oneToOneChatController.minPage + oneToOneChatController.historyList.length;
        Future.delayed(
          const Duration(milliseconds: 100),
          () async {
            await _handleLoadMoreList();
          },
        );
      }
    } else {
      oneToOneChatController.minPage = oneToOneChatController.minPage + oneToOneChatController.historyList.length;
      Future.delayed(
        const Duration(milliseconds: 100),
        () async {
          await _handleLoadMoreList();
        },
      );
    }
  }

  ///[calculateMaximumPagination] while user scrolling towards to down this function will be called in pagination
  ///[calculateMaximumPagination] function use while user enter the room screen while searching otherwise normal pagination will be use

  calculateMaximumPagination() {
    /// If maxPage > than defaultFetchLimit(20) the dev has to minus the maxPage with defaultFetchLimit & set maxPage value
    if ((oneToOneChatController.maxPage > defaultFetchLimit) == true) {
      oneToOneChatController.maxPage = oneToOneChatController.maxPage - defaultFetchLimit;
      Future.delayed(
        const Duration(milliseconds: 100),
        () async {
          await _handleLoadMoreList();
        },
      );
    } else {
      /// If maxPage > than 0 & < than 20 in this scenario we have to pass [limit] as [maxPage] and [skip] will be 0 while calling chatHistory event
      /// Example : {userId: userId, room_name: roomName, skip: 0, limit: limit} i added maxValue in limit variable and pass in to loadMoreFunction
      /// In this scenario chatList has few record left near to total records that's why we pass the 0 as [skip] & limit will be your [maxPage]
      if (oneToOneChatController.maxPage > 0) {
        var limit = oneToOneChatController.maxPage;
        oneToOneChatController.maxPage = 0;
        Future.delayed(
          const Duration(milliseconds: 100),
          () async {
            await _handleLoadMoreList(
              limit: limit,
            );
          },
        );
      }

      ///At last chat list length match to history total record & no data further in list so no need to call chatList LoadMore function simply return;
      else {
        return;
      }
    }
  }

  @override
  void dispose() {
    SocketManagerNew().isChatScreenOpened = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (oneToOneChatController.isFirstTimeSend.value) {
          oneToOneChatController.isFirstTimeSend.value = false;
          Get.back();
        }
        Get.back(result: true);
        return true;
      },
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.globalPosition.dx < 50 && Platform.isIOS) {
            if (oneToOneChatController.isFirstTimeSend.value) {
              oneToOneChatController.isFirstTimeSend.value = false;
              Get.back();
            }
            Get.back(result: true);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: appBarBody(),
          body: buildBody(),
          floatingActionButton: Obx(
            () => oneToOneChatController.isReceiveMessage.value
                ? Padding(
                    padding: EdgeInsets.only(bottom: 50.0.h),
                    child: GestureDetector(
                      onTap: () {
                        _downArrowTap();
                      },
                      child: Container(
                        color: AppColors.transparentColor,
                        child: Stack(
                          children: [
                            ImageComponent.loadLocalImage(imageName: AppImages.messageDown, height: 32.h, width: 32.h, boxFit: BoxFit.contain, imageColor: AppColors.primaryColor),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: ImageComponent.loadLocalImage(imageName: AppImages.redDot, height: 10.h, width: 10.h, boxFit: BoxFit.contain),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
          ),
        ),
      ),
    );
  }

  ///[_downArrowTap] the down arrow visible while user enter chat
  void _downArrowTap() {
    oneToOneChatController.isFromSearch = false;
    oneToOneChatController.isPaginationActiveFromBottom.value = false;
    oneToOneChatController.scrollController.animateTo(0, duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
    oneToOneChatController.historyList.clear();
    oneToOneChatController.getChatHistoryEvent(searchQuery: widget.searchQuery ?? '', skip: 0);
    oneToOneChatController.isReceiveMessage.value = false;
  }

  ///**** Appbar widget *****///
  PreferredSizeWidget appBarBody() {
    return AppBar(
      leading: GestureDetector(
        child: ImageComponent.loadLocalImage(imageName: AppImages.arrow),
        onTap: () {
          if (oneToOneChatController.isFirstTimeSend.value) {
            oneToOneChatController.isFirstTimeSend.value = false;
            Get.back();
          }
          Get.back(result: true);
        },
      ),
      centerTitle: true,
      title: Obx(
        () => Text(
          addGroupNameController.group.isEmpty ? addGroupNameController.groupName : addGroupNameController.group.value,
          style: ISOTextStyles.openSenseRegular(size: 17),
        ),
      ),
      actions: [
        oneToOneChatController.isGroup == true
            ? PopupMenuButton<String>(
                onSelected: (value) {
                  Get.toNamed(ScreenRoutesConstants.addGroupNameScreen, arguments: [oneToOneChatController.roomName, oneToOneChatController.groupName]);
                },
                color: AppColors.searchBackgroundColor,
                itemBuilder: (BuildContext context) {
                  return {AppStrings.addGroupName}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(
                        choice,
                        style: ISOTextStyles.sfProTextLight(size: 15),
                      ),
                    );
                  }).toList();
                },
              )
            : Container(),
      ],
    );
  }

  Widget buildBody() {
    return SafeArea(
        child: Column(
      children: [
        Expanded(child: chatList()),
        Container(
          height: 1,
          color: AppColors.dividerColor,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: GestureDetector(
                  onTap: () {
                    _handlePlusButtonTap();
                  },
                  child: Image.asset(AppImages.plusBlack, width: 17.w, height: 17.w),
                ),
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  autocorrect: false,
                  controller: oneToOneChatController.textEditingController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: AppStrings.writeAMessage,
                    hintStyle: ISOTextStyles.openSenseRegular(size: 16, color: AppColors.chatMessageSuggestionColor),
                    labelStyle: ISOTextStyles.openSenseRegular(size: 16, color: AppColors.blackColor),
                  ),
                  onChanged: (value) {},
                ),
              ),
              GestureDetector(
                  onTap: () async {
                    if (await NetworkUtil.isNetworkConnected() == true) {
                      if (oneToOneChatController.postImageVideoList.isEmpty) {
                        if (oneToOneChatController.textEditingController.text.trim().isNotEmpty && oneToOneChatController.isBlockByMe.value == false) {
                          oneToOneChatController.sendMessageToChat(type: "text", searchQuery: widget.searchQuery ?? '');
                          oneToOneChatController.textEditingController.clear();
                        } else if (oneToOneChatController.isBlockByMe.value) {
                          _userUnblockFunc();
                        }
                      } else {
                        await oneToOneChatController.convertXFile();
                        await oneToOneChatController.uploadFileAPICall(
                          onError: (data) {},
                        );
                      }
                    } else {
                      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: AppStrings.noInternetMsg);
                    }
                  },
                  child: Padding(padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 16.w), child: Image.asset(AppImages.sendYellowFill))),
            ],
          ),
        ),
      ],
    ));
  }

  ///[_handlePlusButtonTap] function use for media sharing in chat
  ///First it will check if user is block by you or not , if user is block first user have to unblock the user then after he send image,video in chat
  void _handlePlusButtonTap() {
    if (oneToOneChatController.isBlockByMe.value) {
      _userUnblockFunc();
    } else {
      showPopupForMediaSelection();
    }
  }

  ///[_userUnblockFunc] this function handle unblock event
  void _userUnblockFunc() {
    CommonUtils.unBlockUserDialog(
      userId: oneToOneChatController.recieverId,
      isChatOpen: true,
      userName: oneToOneChatController.groupName,
      context: context,
      apiMessage: '${AppStrings.alreadyBlockMessage} ${oneToOneChatController.groupName}.',
      onSuccess: (msg) {
        SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
        oneToOneChatController.isBlockByMe.value = false;
        oneToOneChatController.recieverId = -1.obs;
        Logger().i(oneToOneChatController.recieverId);
        SocketManagerNew().isChatScreenOpened = true;
      },
    );
  }

  ///***** [_handleLoadMoreList] this function use while pagination call & chat history list have more data *****///
  Future _handleLoadMoreList({int? limit}) async {
    if (!oneToOneChatController.isAllDataLoaded.value) return;
    if (oneToOneChatController.isLoadMoreRunningForViewAll) return;
    oneToOneChatController.isLoadMoreRunningForViewAll = true;
    await oneToOneChatController.getChatHistoryEvent(searchQuery: widget.searchQuery ?? '', limit: limit ?? defaultFetchLimit);
  }

  Widget chatList() {
    return Obx(
      () => ListView.builder(
        reverse: true,
        controller: oneToOneChatController.scrollController,
        addAutomaticKeepAlives: true,
        padding: EdgeInsets.all(16.w),
        itemCount: oneToOneChatController.historyList.length,
        itemBuilder: (context, index) {
          if (oneToOneChatController.historyList[index].type != AppStrings.strChatTypeInitial) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50.h,
                    width: 50.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.h),
                      child: ImageWidget(
                        url: oneToOneChatController.historyList[index].senderProfile ?? '',
                        fit: BoxFit.cover,
                        placeholder: AppImages.imagePlaceholder,
                      ),
                    ),
                  ),
                  8.sizedBoxW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              maxLines: 1,
                              oneToOneChatController.historyList[index].senderName ?? '',
                              style: ISOTextStyles.sfProTextMedium(size: 14),
                            ),
                            8.sizedBoxW,
                            Text(
                              oneToOneChatController.historyList[index].getTimesAgo,
                              style: ISOTextStyles.sfProTextLight(size: 12),
                            ),
                          ],
                        ),
                        3.sizedBoxH,
                        (oneToOneChatController.historyList[index].type == AppStrings.strChatTypeMedia)
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: oneToOneChatController.historyList[index].chatMedia?.length,
                                  itemBuilder: (BuildContext context, int subIndex) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: subIndex == (oneToOneChatController.historyList[index].chatMedia!.length - 1) ? 0 : 5.h),
                                      child: SizedBox(
                                        height: MediaQuery.of(context).size.width * 0.5,
                                        width: MediaQuery.of(context).size.width * 0.7,
                                        child: oneToOneChatController.historyList[index].chatMedia?[subIndex].mediaType == "video"
                                            ? Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  ClipRRect(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      child: ImageWidget(
                                                        url: oneToOneChatController.historyList[index].chatMedia?[subIndex].thumbnail ?? '',
                                                        fit: BoxFit.cover,
                                                        placeholder: AppImages.imagePlaceholder,
                                                      )),
                                                  InkWell(
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
                                                      child: Icon(
                                                        Icons.play_circle,
                                                        color: AppColors.whiteColor,
                                                        size: 42.w,
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      Get.to(
                                                        VideoPlayScreen(
                                                          video: oneToOneChatController.historyList[index].chatMedia?[subIndex].chatMedia ?? '',
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  Get.to(ImageFullScreen(image: oneToOneChatController.historyList[index].chatMedia?[subIndex].chatMedia ?? ''));
                                                },
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10.w),
                                                    child: ImageWidget(
                                                      url: oneToOneChatController.historyList[index].chatMedia?[subIndex].chatMedia ?? '',
                                                      fit: BoxFit.cover,
                                                      placeholder: AppImages.imagePlaceholder,
                                                    )),
                                              ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : (oneToOneChatController.historyList[index].type == AppStrings.strChatTypeFeed)
                                ? GestureDetector(
                                    onTap: () {
                                      Get.to(
                                          FeedDetailScreen(
                                            feedId: oneToOneChatController.historyList[index].feedId?.feedId ?? 0,
                                          ),
                                          binding: FeedDetailBinding());
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.w),
                                      child: Container(
                                        color: AppColors.dropDownColor,
                                        width: MediaQuery.of(context).size.width * 0.7,
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8.w),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    height: 25.w,
                                                    width: 25.w,
                                                    child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(25.w),
                                                        child: ImageWidget(
                                                          url: oneToOneChatController.historyList[index].feedId?.postedBy?.profileImg ?? '',
                                                          fit: BoxFit.cover,
                                                          placeholder: AppImages.imagePlaceholder,
                                                        )),
                                                  ),
                                                  5.sizedBoxW,
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          oneToOneChatController.historyList[index].feedId?.postedBy?.firstName ?? '',
                                                          style: ISOTextStyles.sfProText(size: 12),
                                                        ),
                                                        Text(
                                                          oneToOneChatController.historyList[index].feedId?.description ?? '',
                                                          overflow: TextOverflow.ellipsis,
                                                          style: ISOTextStyles.sfProTextLight(size: 12),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            (oneToOneChatController.historyList[index].feedId?.feedMedia?.length ?? 0) > 0
                                                ? ImageWidget(
                                                    url: () {
                                                      if (oneToOneChatController.historyList[index].feedId?.feedMedia?.isNotEmpty ?? false) {
                                                        if (oneToOneChatController.historyList[index].feedId?.feedMedia?[0].mediaType == 'video') {
                                                          return feedForumUrl(imagePath:oneToOneChatController.historyList[index].feedId?.feedMedia?[0].thumbnail ?? '');
                                                        } else {
                                                          return feedForumUrl(imagePath: oneToOneChatController.historyList[index].feedId?.feedMedia?[0].feedMedia ?? '');
                                                        }
                                                      } else {
                                                        return '';
                                                      }
                                                    }(),
                                                    fit: BoxFit.cover,
                                                    height: 120.w,
                                                    width: double.infinity,
                                                    placeholder: AppImages.imagePlaceholder,
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : (oneToOneChatController.historyList[index].type == AppStrings.strChatTypeForum)
                                    ? GestureDetector(
                                        onTap: () {
                                          Get.to(ForumDetailScreen(forumId: oneToOneChatController.historyList[index].forumId?.forumId ?? 0), binding: ForumDetailBinding());
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10.w),
                                          child: Container(
                                            color: AppColors.dropDownColor,
                                            width: MediaQuery.of(context).size.width * 0.7,
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(8.w),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        height: 25.w,
                                                        width: 25.w,
                                                        child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(25.w),
                                                            child: ImageWidget(
                                                              url: oneToOneChatController.historyList[index].forumId?.postedBy?.profileImg ?? '',
                                                              fit: BoxFit.cover,
                                                              placeholder: AppImages.imagePlaceholder,
                                                            )),
                                                      ),
                                                      5.sizedBoxW,
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              oneToOneChatController.historyList[index].forumId?.postedBy?.firstName ?? '',
                                                              style: ISOTextStyles.sfProText(size: 12),
                                                            ),
                                                            Text(
                                                              oneToOneChatController.historyList[index].forumId?.description ?? '',
                                                              overflow: TextOverflow.ellipsis,
                                                              style: ISOTextStyles.sfProTextLight(size: 12),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                (oneToOneChatController.historyList[index].forumId?.forumMedia?.length ?? 0) > 0
                                                    ? ImageWidget(
                                                        url: () {
                                                          if (oneToOneChatController.historyList[index].forumId?.forumMedia?.isNotEmpty ?? false) {
                                                            if(oneToOneChatController.historyList[index].forumId?.forumMedia?[0].mediaType == 'video'){
                                                              return feedForumUrl(imagePath: oneToOneChatController.historyList[index].forumId?.forumMedia?[0].thumbnail ?? '');
                                                            }else{
                                                              return feedForumUrl(imagePath: oneToOneChatController.historyList[index].forumId?.forumMedia?[0].forumMedia ?? '');
                                                            }
                                                          }else{
                                                            return '';
                                                          }
                                                        }(),

                                                        height: 120.w,
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                        placeholder: AppImages.imagePlaceholder,
                                                      )
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : RichText(
                                        text: oneToOneChatController.historyList[index].highlightedText ?? TextSpan(text: oneToOneChatController.historyList[index].message ?? ''),
                                      ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return RichText(
              text: oneToOneChatController.historyList[index].highlightedText ?? TextSpan(text: oneToOneChatController.historyList[index].message ?? ''),
            );
          }
        },
      ),
    );
  }

  showPopupForMediaSelection() {
    return DialogComponent.showAttachmentDialog(
      context: context,
      arrButton: Platform.isAndroid
          ? <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                    chooseImageDialog();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppImages.photo, width: 26.w, height: 26.w, fit: BoxFit.contain),
                      10.sizedBoxH,
                      Text(
                        AppStrings.strImages,
                        style: ISOTextStyles.sfProDisplayMedium(size: 16),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                    chooseVideoDialog();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppImages.videCamera, width: 26.w, height: 26.w, fit: BoxFit.contain),
                      10.sizedBoxH,
                      Text(
                        AppStrings.strVideos,
                        style: ISOTextStyles.sfProDisplayMedium(size: 16),
                      ),
                    ],
                  ),
                ),
              )
            ]
          : <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(
                onPressed: () {
                  Get.back();
                  chooseImageDialog();
                },
                child: const Text(AppStrings.strImages),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  Get.back();
                  chooseVideoDialog();
                },
                child: const Text(AppStrings.strVideos),
              ),
            ],
    );
  }

  chooseImageDialog() {
    return DialogComponent.showAlertDialog(
      context: context,
      title: AppStrings.strSelectImagesUsing,
      content: AppStrings.chooseCameraGalleryImages,
      barrierDismissible: true,
      arrButton: Platform.isAndroid
          ? <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await selectImageUsingCamera();
                    },
                    child: Text(
                      AppStrings.strCamera,
                      style: ISOTextStyles.sfProDisplayMedium(size: 14),
                    ),
                  ),
                  20.sizedBoxW,
                  GestureDetector(
                    onTap: () async {
                      await selectImagesFromGallery();
                    },
                    child: Text(
                      AppStrings.strGallery,
                      style: ISOTextStyles.sfProDisplayMedium(size: 14),
                    ),
                  ),
                ],
              )
            ]
          : <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: const Text(AppStrings.strCamera),
                onPressed: () async {
                  await selectImageUsingCamera();
                },
              ),
              CupertinoDialogAction(
                child: const Text(AppStrings.strGallery),
                onPressed: () async {
                  await selectImagesFromGallery();
                },
              ),
            ],
    );
  }

  Future<void> selectImageUsingCamera() async {
    await MediaSelectorManager.chooseCameraImage(
        imageSource: ImageSource.camera,
        context: context,
        multipleImage: oneToOneChatController.postImageVideoList,
        tempDisplayList: oneToOneChatController.tempDisplayList,
        cameraCallBack: () async {
          if (oneToOneChatController.postImageVideoList.isNotEmpty) {
            ShowLoaderDialog.showLinearProgressIndicatorForFileUpload(context: context);
            await oneToOneChatController.convertXFile();

            //ShowLoaderDialog.showLoaderDialog(context);
            await oneToOneChatController.uploadFileAPICall(
              onError: (data) {
                Get.back();
                SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: data);
              },
            );
            Get.back();
          }
        });
    Get.back();
  }

  Future<void> selectImagesFromGallery() async {
    MediaSelectorManager.chooseMultipleImage(
        imageSource: ImageSource.gallery,
        context: context,
        multipleImages: oneToOneChatController.postImageVideoList,
        tempDisplayList: oneToOneChatController.tempDisplayList,
        imageVideoCallBack: () async {
          if (oneToOneChatController.postImageVideoList.isNotEmpty) {
            ShowLoaderDialog.showLinearProgressIndicatorForFileUpload(context: context);
            await oneToOneChatController.convertXFile();
            /*ShowLoaderDialog.showLoaderDialog(context);*/
            await oneToOneChatController.uploadFileAPICall(
              onError: (data) {
                SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: data);
              },
            );
            Get.back();
          }
        });
    Get.back();
  }

  chooseVideoDialog() {
    return DialogComponent.showAlertDialog(
      context: context,
      title: AppStrings.strSelectVideosUsing,
      content: AppStrings.chooseCameraGalleryVideos,
      barrierDismissible: true,
      arrButton: Platform.isAndroid
          ? <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await selectVideoUsingCamera();
                    },
                    child: Text(
                      AppStrings.strCamera,
                      style: ISOTextStyles.sfProDisplayMedium(size: 14),
                    ),
                  ),
                  20.sizedBoxW,
                  GestureDetector(
                    onTap: () async {
                      await selectVideosFromGallery();
                    },
                    child: Text(
                      AppStrings.strGallery,
                      style: ISOTextStyles.sfProDisplayMedium(size: 14),
                    ),
                  ),
                ],
              )
            ]
          : <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: const Text(AppStrings.strCamera),
                onPressed: () async {
                  await selectVideoUsingCamera();
                },
              ),
              CupertinoDialogAction(
                child: const Text(AppStrings.strGallery),
                onPressed: () async {
                  await selectVideosFromGallery();
                },
              ),
            ],
    );
  }

  Future<void> selectVideoUsingCamera() async {
    MediaSelectorManager.recordVideo(
      imageSource: ImageSource.camera,
      context: context,
      multipleVideoList: oneToOneChatController.postImageVideoList,
      tempDisplayList: oneToOneChatController.tempDisplayList,
      thumbnails: oneToOneChatController.thumbnail,
      videoCallBack: () async {
        if (oneToOneChatController.postImageVideoList.isNotEmpty) {
          ShowLoaderDialog.showLinearProgressIndicatorForFileUpload(context: context);
          //ShowLoaderDialog.showLoaderDialog(context);
          await oneToOneChatController.convertXFile();
          await oneToOneChatController.uploadFileAPICall(
            onError: (data) {
              Get.back();
              SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: data);
            },
          );
          Get.back();
        }
      },
    );
    Get.back();
  }

  Future<void> selectVideosFromGallery() async {
    MediaSelectorManager.chooseVideoFromGallery(
      imageSource: ImageSource.gallery,
      context: context,
      multipleVideoList: oneToOneChatController.postImageVideoList,
      tempDisplayList: oneToOneChatController.tempDisplayList,
      thumbnails: oneToOneChatController.thumbnail,
      cameraVideoCallBack: () async {
        if (oneToOneChatController.postImageVideoList.isNotEmpty) {
          // ShowLoaderDialog.showLoaderDialog(context);
          ShowLoaderDialog.showLinearProgressIndicatorForFileUpload(context: context);
          await oneToOneChatController.convertXFile();

          await oneToOneChatController.uploadFileAPICall(
            onError: (data) {
              SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: data);
            },
          );
          Get.back();
        }
      },
    );
    Get.back();
  }

  String feedForumUrl({required String imagePath}) {
    return imagePath.isNotEmpty
        ? imagePath.startsWith('http')
            ? (imagePath)
            : ("${oneToOneChatController.messageHistoryData.value?.imageUrl ?? ''}/$imagePath")
        : imagePath;
  }
}
