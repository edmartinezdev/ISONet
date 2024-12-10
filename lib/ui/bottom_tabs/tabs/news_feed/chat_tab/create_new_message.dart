// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/chat/one_to_one_chat_controller.dart';
import 'package:iso_net/helper_manager/media_selector_manager/media_selector_manager.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/chat_tab/create_new_message_Adaptor.dart';
import 'package:iso_net/ui/style/dialog_components.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';
import 'package:iso_net/utils/network_util.dart';

import '../../../../../controllers/bottom_tabs/tabs/chat/create_new_chat_controller.dart';
import '../../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../../utils/app_common_stuffs/screen_routes.dart';
import '../../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../../style/image_components.dart';
import '../../../../style/showloader_component.dart';
import '../../../../style/text_style.dart';

class CreateNewMessage extends StatefulWidget {
  const CreateNewMessage({Key? key}) : super(key: key);

  @override
  State<CreateNewMessage> createState() => _CreateNewMessageState();
}

class _CreateNewMessageState extends State<CreateNewMessage> with AutomaticKeepAliveClientMixin<CreateNewMessage> {
  NewMessageController messengerController = Get.find<NewMessageController>();
  OneToOneChatController oneToOneChatController = Get.find<OneToOneChatController>();
  ScrollController taglistController = ScrollController();
  Timer? _debounce;

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    messengerController.sendNetworkList.clear();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ShowLoaderDialog.showLoaderDialog(context);
      },
    );
    messengerController.getMyNetworkApi();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appBarBody(),
      body: buildBody(),
    );
  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBar(
      leading: IconButton(
        icon: ImageComponent.loadLocalImage(imageName: AppImages.x),
        onPressed: () {
          Get.back(result: false);
        },
      ),
      centerTitle: true,
      title: Text(
        AppStrings.newMessageText,
        style: ISOTextStyles.openSenseRegular(size: 17),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: Column(
          children: [
            const Divider(
              height: 2,
            ),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 6, top: 16, bottom: 16),
                    child: Text(
                      'To:',
                      style: ISOTextStyles.openSenseRegular(size: 16),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: taglistController,
                      scrollDirection: Axis.horizontal,
                      children: [
                        Obx(
                          () => Center(
                            child: Wrap(
                              children: List.generate(messengerController.sendNetworkList.length, (index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 30.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.greyColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      messengerController.sendNetworkList[index].firstName ?? "",
                                      style: ISOTextStyles.openSenseRegular(size: 15),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),

                        // SizedBox(width: 10), // Add some spacing between the tag view and the search field
                        SizedBox(
                          width: 200,
                          child: Center(
                            child: TextFormField(
                              controller: messengerController.textEditingController,
                              textInputAction: TextInputAction.go,
                              autocorrect: false,
                              onEditingComplete: () {
                                FocusScope.of(context).unfocus();
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search a name',
                                hintStyle: ISOTextStyles.openSenseLight(size: 16, color: AppColors.chatMessageSuggestionColor),
                                labelStyle: ISOTextStyles.openSenseLight(size: 16, color: AppColors.chatMessageSuggestionColor),
                              ),
                              onChanged: (value) {
                                _handleSearchOnChange(value: value);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: AppColors.dividerColor,
            ),
            Container(
              padding: const EdgeInsets.all(7),
              color: AppColors.searchBackgroundColor,
              width: double.infinity,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  AppStrings.network,
                  style: ISOTextStyles.openSenseSemiBold(size: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Expanded(child: networkAndItsList()),
        Container(
          height: 1,
          color: AppColors.dividerColor,
        ),
        SafeArea(
          child: Row(
            children: [
              Obx(
                () => Visibility(
                  visible: messengerController.sendNetworkList.isNotEmpty,
                  child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: GestureDetector(
                        onTap: () {
                          showPopupForMediaSelection();
                        },
                        child: Image.asset(AppImages.plusBlack, width: 17.w, height: 17.w),
                      )),
                ),
              ),
              Obx(() => SizedBox(
                    width: messengerController.sendNetworkList.isNotEmpty ? 0 : 20,
                  )),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  controller: oneToOneChatController.textEditingController,
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: AppStrings.writeAMessage,
                    hintStyle: ISOTextStyles.openSenseRegular(size: 16, color: AppColors.chatMessageSuggestionColor),
                    labelStyle: ISOTextStyles.openSenseRegular(size: 16, color: AppColors.blackColor),
                  ),
                  onChanged: (value) {},
                ),
              ),
              Obx(
                () => Visibility(
                  visible: messengerController.sendNetworkList.isNotEmpty,
                  child: GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        if (await NetworkUtil.isNetworkConnected() == true) {
                          if (messengerController.sendNetworkList.isNotEmpty && oneToOneChatController.textEditingController.text.trim().isNotEmpty) {
                            oneToOneChatController.isFirstTimeSend.value = true;
                            if (messengerController.sendNetworkList.length == 1 && (messengerController.sendNetworkList.first.roomId ?? -1 ) != -1) {
                              Logger().i('Already have room');
                              /// Todo:- Change this as per new socket manager
                              // isSendAgainMessageFromNewMessage.value = true;
                              var roomName = messengerController.sendNetworkList.first.roomId ?? "";
                              oneToOneChatController.chatMessage.value = oneToOneChatController.textEditingController.text.trim();
                              Get.toNamed(ScreenRoutesConstants.oneToOneChatScreen, arguments: [roomName,'${ messengerController.sendNetworkList.first.firstName} ${ messengerController.sendNetworkList.first.lastName}', false]);
                              /*await SocketManager().sendMessageText(sendMessage: oneToOneChatController.textEditingController.text.trim(), roomName: roomName);*/
                            }else {
                              Logger().i('Create group room');
                              /// Todo:- Change this as per new socket manager
                              messengerController.createNewGroupChat(text: oneToOneChatController.textEditingController.text);
                            }

                            oneToOneChatController.textEditingController.text = "";
                          }
                        } else {
                          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: AppStrings.noInternetMsg);
                        }
                      },
                      child: Padding(padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 16.w), child: Image.asset(AppImages.sendYellowFill))),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  sendMessageToPersonalChat(int index) async {
    if (await NetworkUtil.isNetworkConnected() == false) {
      SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: AppStrings.noInternetMsg);
      return;
    }
    if (messengerController.sendNetworkList[index].roomId != null) {
      //Get.toNamed(ScreenRoutesConstants.oneToOneChatScreen, arguments: [messengerController.myNetworkList[index].roomName, messengerController.myNetworkList[index].firstName, '']);

      Get.toNamed(ScreenRoutesConstants.oneToOneChatScreen,
          arguments: [messengerController.sendNetworkList[index].roomId, '${messengerController.sendNetworkList[index].firstName} ${messengerController.sendNetworkList[index].lastName}', false]);

    } else {
      /// Todo:- Change this as per new socket manager
      // SocketManager().createGroup(participate: [messengerController.sendNetworkList[index].userId ?? -1], roomType: ApiParams.oneToOne, messageText: messengerController.textEditingController.text);
    }
  }

  _handleSearchOnChange({required String value}) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      messengerController.myNetworkList.clear();
      messengerController.searchText.value = value;
      messengerController.pageToShow.value = 1;
      messengerController.totalRecord.value = 0;
      messengerController.isAllDataLoaded.value = false;
      await messengerController.getMyNetworkApi(isLoaderShow: false);
    });
  }

  Widget networkAndItsList() {
    return Obx(
      () => messengerController.isDataLoaded.value == false ? Center(
        child: Text(
          AppStrings.noRecordFound,
          style: ISOTextStyles.openSenseSemiBold(size: 16),
        ),
      ):ListView.builder(
        addAutomaticKeepAlives: true,
        itemCount: messengerController.isAllDataLoaded.value ? messengerController.myNetworkList.length + 1 : messengerController.myNetworkList.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == messengerController.myNetworkList.length) {
            Future.delayed(
              const Duration(milliseconds: 100),
              () async {
                await _handleLoadMoreList();
              },
            );
            return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
          }

          return Obx(
            ()=> Container(
              margin: EdgeInsets.only(top: 4.0.h),
              padding: EdgeInsets.symmetric(
                horizontal: 8.0.w,
                vertical: 8.0.h
              ),
              decoration:  BoxDecoration(
                border: const Border( bottom: BorderSide(width: 1.5, color: AppColors.greyColor),),

                color: messengerController.myNetworkList[index].isSelected.value == true ||
                    messengerController.sendNetworkList.any((element) => element.userId == messengerController.myNetworkList[index].userId)
                    ? AppColors.greyColor
                    : AppColors.whiteColor,
              ),

              child: CreateNewMessageAdaptor(
                objOfCreateMessage: messengerController.myNetworkList[index],
                callback: () {
                  _handleNetworkListClickEvent(index: index);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future _handleLoadMoreList() async {
    if (!messengerController.isAllDataLoaded.value) return;
    if (messengerController.isLoadMoreRunningForViewAll) return;
    messengerController.isLoadMoreRunningForViewAll = true;
    await messengerController.paginationLoadData();
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
            oneToOneChatController.isFirstTimeSend.value = true;
            await oneToOneChatController.convertXFile();
            //ShowLoaderDialog.showLoaderDialog(context);
            ShowLoaderDialog.showLinearProgressIndicatorForFileUpload(context: context);
            await oneToOneChatController.uploadFileAPICall(
                onError: (data) {
                  Get.back();
                  SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: data);
                },
                isCreateGroup: isAlreadyHasRoomNameAndNotGroup(),
                groupIDs: messengerController.sendNetworkList.map((p0) => (p0.userId ?? 0)).toList());
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
            oneToOneChatController.isFirstTimeSend.value = true;
            await oneToOneChatController.convertXFile();
            //ShowLoaderDialog.showLoaderDialog(context);
            ShowLoaderDialog.showLinearProgressIndicatorForFileUpload(context: context);
            await oneToOneChatController.uploadFileAPICall(
                onError: (data) {
                  SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: data);
                },
                isCreateGroup: isAlreadyHasRoomNameAndNotGroup(),
                groupIDs: messengerController.sendNetworkList.map((p0) => (p0.userId ?? 0)).toList());
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
            oneToOneChatController.isFirstTimeSend.value = true;
            //ShowLoaderDialog.showLoaderDialog(context);
            ShowLoaderDialog.showLinearProgressIndicatorForFileUpload(context: context);
            await oneToOneChatController.convertXFile();
            await oneToOneChatController.uploadFileAPICall(
                onError: (data) {
                  Get.back();
                  SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: data);
                },
                isCreateGroup: isAlreadyHasRoomNameAndNotGroup(),
                groupIDs: messengerController.sendNetworkList.map((p0) => (p0.userId ?? 0)).toList());
            Get.back();
          }
        });
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
            oneToOneChatController.isFirstTimeSend.value = true;
            await oneToOneChatController.convertXFile();
            //ShowLoaderDialog.showLoaderDialog(context);
            ShowLoaderDialog.showLinearProgressIndicatorForFileUpload(context: context);
            await oneToOneChatController.uploadFileAPICall(
                onError: (data) {
                  SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: data);
                },
                isCreateGroup: isAlreadyHasRoomNameAndNotGroup(),
                groupIDs: messengerController.sendNetworkList.map((p0) => (p0.userId ?? 0)).toList());
            Get.back();
          }
        });
    Get.back();
  }

  bool isAlreadyHasRoomNameAndNotGroup() {
    if (messengerController.sendNetworkList.length == 1 && (messengerController.sendNetworkList.first.roomId ?? -1 ) != -1) {
      /// Todo:- Change this as per new socket manager
      // isSendAgainMessageFromNewMessage.value = true;
      oneToOneChatController.roomName = messengerController.sendNetworkList.first.roomId ?? "";
      return false;
    } else {
      oneToOneChatController.roomName = null;
      return true;
    }
  }

  _handleNetworkListClickEvent({required int index}) {
    messengerController.myNetworkList[index].isSelected.value = !messengerController.myNetworkList[index].isSelected.value;
    var isContaineSentList = messengerController.sendNetworkList.where((element) => (element.userId ?? 0) == (messengerController.myNetworkList[index].userId ?? 0)).toList().isNotEmpty.obs;
    if (isContaineSentList.value) {
      messengerController.myNetworkList[index].isSelected.value = false;
      messengerController.sendNetworkList.removeWhere((element) => (element.userId ?? 0) == (messengerController.myNetworkList[index].userId ?? 0));
    } else {
      messengerController.sendNetworkList.add(messengerController.myNetworkList[index]);
    }

    if (messengerController.searchText.value.isNotEmpty) {
      messengerController.textEditingController.clear();
      messengerController.searchText.value = "";
      messengerController.myNetworkList.clear();
      messengerController.getMyNetworkApi(isLoaderShow: false);
    }
    Future.delayed(const Duration(milliseconds: 100), () {
      taglistController.animateTo(taglistController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    });
  }
}
