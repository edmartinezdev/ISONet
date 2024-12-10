// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/create_feed_controller.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/news_feed_tab_controller.dart';
import 'package:iso_net/helper_manager/media_selector_manager/media_selector_manager.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/style/button_components.dart';
import 'package:iso_net/ui/style/dialog_components.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../utils/app_common_stuffs/app_images.dart';
import '../../../style/appbar_components.dart';

class CreateFeedScreen extends StatefulWidget {
  bool isCreateForum;

  bool isCreateForumCategory;
  bool? isFromFeed;
  String? categoryName;
  int? categoryId;

  CreateFeedScreen({Key? key, this.isCreateForum = false, this.isCreateForumCategory = false, this.categoryName, this.categoryId, this.isFromFeed}) : super(key: key);

  @override
  State<CreateFeedScreen> createState() => _CreateFeedScreenState();
}

class _CreateFeedScreenState extends State<CreateFeedScreen> {
  CreateFeedController createFeedController = Get.find<CreateFeedController>();
  NewsFeedController newsFeedController = Get.find();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    createFeedController.fetchFeedCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: false);
        return true;
      },
      child: GestureDetector(
        onTap: () => CommonUtils.scopeUnFocus(context),
        onHorizontalDragUpdate: (details) {
          if (details.globalPosition.dx < 50 && Platform.isIOS) {
            // Only trigger swipe back from the left edge of the screen

            Get.back(result: false);
          }
        },
        child: Scaffold(
          appBar: appBarBody(),
          body: buildBody(),
        ),
      ),
    );
  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      leadingWidget: IconButton(
        onPressed: () {
          Get.back(result: false);
        },
        icon: ImageComponent.loadLocalImage(
          imageName: AppImages.arrow,
        ),
      ),
      titleWidget: Align(
        alignment: Alignment.center,
        child: Text(
          widget.isCreateForum || widget.isCreateForumCategory ? AppStrings.newForum : AppStrings.newPost,
          style: ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.headingTitleColor),
        ),
      ),
      actionWidgets: [
        Obx(
          () => ButtonComponents.textButton(
            context: context,
            onTap: () async {
              _handlePostButtonPress();
            },
            title: AppStrings.post,
            textStyle: createFeedController.isPostButtonEnable.value
                ? ISOTextStyles.openSenseBold(
                    size: 15,
                    color: AppColors.headingTitleColor,
                  )
                : ISOTextStyles.openSenseRegular(
                    size: 15,
                    color: AppColors.disableTextColor,
                  ),
          ),
        ),
      ],
    );
  }

  ///handle post button press
  _handlePostButtonPress() async {
    var validationResult = createFeedController.isValidCreatePost(isFromFeed: widget.isFromFeed ?? false);
    if (!validationResult.item1) {
      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: validationResult.item2);
    } else {
      /*ShowLoaderDialog.showLoaderDialog(context);*/
      focusNode.unfocus();

      await createFeedController.convertXFile();
      if (createFeedController.temp.isNotEmpty) {
        ShowLoaderDialog.showLinearProgressIndicatorForFileUpload(context: context);
      } else {
        ShowLoaderDialog.showLoaderDialog(context);
      }
      var createPostApiResult = widget.isCreateForum || widget.isCreateForumCategory
          ? await createFeedController.createForumApiCalling(onErr: (msg) {
              SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
            })
          : await createFeedController.createFeedApiCalling(
              onErr: (msg) {
                SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
              },
            );
      if (createPostApiResult) {
        if (!widget.isCreateForum && !widget.isCreateForumCategory) {
          Get.back(result: true);
        } else if (widget.isCreateForumCategory) {
          Get.back(result: true);
        } else {
          Get.back(result: true);
        }
      }
    }
  }

  ///Scaffold body
  Widget buildBody() {
    return SafeArea(
      child: CommonUtils.constrainedBody(children: [
        Column(
          children: [
            userTile(),
            Padding(
              padding: EdgeInsets.only(right: 16.0.w, left: 16.0.w),
              child: TextField(
                focusNode: focusNode,
                textCapitalization: TextCapitalization.sentences,
                style: ISOTextStyles.openSenseRegular(size: 16, color: AppColors.blackColor),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter post here',
                ),
                onChanged: (value) {
                  createFeedController.description.value = value;
                  createFeedController.validateButton(isFromFeed: widget.isFromFeed ?? false);
                },
                minLines: 5,
                maxLines: 10,
              ),
            ),
          ],
        ),
        Column(
          children: [
            postContent(),
            chooseMedia(),
          ],
        ),
      ]),
    );
  }

  ///Userdetail tile body
  Widget userTile() {
    return Container(
      padding: EdgeInsets.only(left: 9.w, bottom: 8.h),
      child: Row(
        children: [
          ImageComponent.circleNetworkImage(
            imageUrl: userSingleton.profileImg ?? "",
            height: 46.h,
            width: 46.h,
          ),
          7.sizedBoxW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${userSingleton.firstName} ${userSingleton.lastName}',
                  style: ISOTextStyles.openSenseRegular(size: 16, color: AppColors.headingTitleColor),
                ),
                2.sizedBoxH,
                InkWell(
                  onTap: () {
                    _handleCategoryButton();
                  },
                  child: IntrinsicWidth(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.hintTextColor,
                        ),
                        borderRadius: BorderRadius.circular(50.0.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 17.0.w, vertical: 2.h),
                      child: Row(
                        children: [
                          Flexible(
                            child: Obx(() => Text(
                                  /*createFeedController.selectedCategoriesName.isEmpty ? AppStrings.category : createFeedController.selectedCategoriesName.value,*/
                                  categoryName(),
                                  style: ISOTextStyles.openSenseRegular(
                                    size: 14,
                                    color: AppColors.hintTextColor,
                                  ),

                                )),
                          ),
                          5.sizedBoxW,
                          ImageComponent.loadLocalImage(imageName: AppImages.downArrowFill, height: 5, width: 7, boxFit: BoxFit.contain),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  ///handle categories button press
  _handleCategoryButton() {
    createFeedController.loadFeedCategoryList();
    Get.bottomSheet(
      Container(
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
              AppStrings.categories,
              style: ISOTextStyles.openSenseBold(
                size: 22,
              ),
            ),
            24.sizedBoxH,
            CupertinoSearchTextField(
              onChanged: (value) => createFeedController.onSearch(value),
            ),
            Obx(
              () => createFeedController.searchFeedCategoryList.isEmpty
                  ? Center(
                      child: Text(
                        'No Feed Category data found',
                        style: ISOTextStyles.openSenseBold(size: 16),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: createFeedController.searchFeedCategoryList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              createFeedController.selectedCategoriesName.value = createFeedController.searchFeedCategoryList[index].categoryName ?? '';
                              createFeedController.selectedCategoryId.value = createFeedController.searchFeedCategoryList[index].id;
                              Logger().i(createFeedController.selectedCategoryId.value);
                              createFeedController.validateButton(isFromFeed: widget.isFromFeed ?? false);
                              Get.back();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
                              child: Text(
                                createFeedController.searchFeedCategoryList[index].categoryName ?? '',
                                style: ISOTextStyles.openSenseSemiBold(size: 16),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  ///post content
  Widget postContent() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0.w,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => createFeedController.tempDisplayList.isEmpty
                  ? Container()
                  : Container(
                      child: createFeedController.tempDisplayList.length == 1
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0.r),
                                  child: SizedBox(
                                    //width: MediaQuery.of(context).size.width,
                                    //height: MediaQuery.of(context).size.width,
                                    child: Image.file(
                                      File(createFeedController.tempDisplayList[0].path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: IconButton(
                                    onPressed: () {
                                      createFeedController.postImageVideoList.remove(createFeedController.postImageVideoList[0]);
                                      createFeedController.tempDisplayList.remove(createFeedController.tempDisplayList[0]);
                                      Logger().i('display list length ==> ${createFeedController.tempDisplayList.length}');
                                      Logger().i('actual list length ==> ${createFeedController.postImageVideoList.length}');
                                    },
                                    icon: ImageComponent.loadLocalImage(imageName: AppImages.cancelRed),
                                  ),
                                ),
                              ],
                            )
                          : MasonryGridView.count(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: createFeedController.tempDisplayList.length,
                              shrinkWrap: true,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              crossAxisCount: 2,
                              itemBuilder: (BuildContext context, int index) {
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0.r),
                                      child: Image.file(
                                        File(createFeedController.tempDisplayList[index].path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: IconButton(
                                        onPressed: () {
                                          createFeedController.postImageVideoList.remove(createFeedController.postImageVideoList[index]);
                                          createFeedController.tempDisplayList.remove(createFeedController.tempDisplayList[index]);
                                          Logger().i('display list length ==> ${createFeedController.tempDisplayList.length}');
                                          Logger().i('actual list length ==> ${createFeedController.postImageVideoList.length}');
                                        },
                                        icon: ImageComponent.loadLocalImage(imageName: AppImages.cancelRed),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),

                      // GridView.count(
                      //     crossAxisCount: 2,
                      //     crossAxisSpacing: 10.0,
                      //     mainAxisSpacing: 10.0,
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     shrinkWrap: true,
                      //     children: List.generate(
                      //       createFeedController.tempDisplayList.length,
                      //       (index) {
                      //         return Stack(
                      //           fit: StackFit.expand,
                      //           children: [
                      //             ClipRRect(
                      //               borderRadius: BorderRadius.circular(12.0.r),
                      //               child: Image.file(
                      //                 File(createFeedController.tempDisplayList[index].path),
                      //                 fit: BoxFit.cover,
                      //               ),
                      //             ),
                      //             Positioned(
                      //                 right: 0,
                      //                 top: 0,
                      //                 child: IconButton(
                      //                   onPressed: () {
                      //                     createFeedController.postImageVideoList
                      //                         .remove(createFeedController.postImageVideoList[index]);
                      //                     createFeedController.tempDisplayList
                      //                         .remove(createFeedController.tempDisplayList[index]);
                      //                     Logger().i(
                      //                         'display list length ==> ${createFeedController.tempDisplayList.length}');
                      //                     Logger().i(
                      //                         'actual list length ==> ${createFeedController.postImageVideoList.length}');
                      //                   },
                      //                   icon: ImageComponent.loadLocalImage(imageName: AppImages.cancelRed),
                      //                 )),
                      //           ],
                      //         );
                      //       },
                      //     ),
                      //   ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  ///choose media for post
  Widget chooseMedia() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0.w,
      ),
      child: Column(
        children: [
          40.sizedBoxH,
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  await MediaSelectorManager.chooseCameraImage(
                      imageSource: ImageSource.camera, context: context, multipleImage: createFeedController.postImageVideoList, tempDisplayList: createFeedController.tempDisplayList);
                },
                icon: ImageComponent.loadLocalImage(imageName: AppImages.camera),
              ),
              // 22.sizedBoxW,
              IconButton(
                onPressed: () {
                  MediaSelectorManager.recordVideo(
                      imageSource: ImageSource.camera,
                      context: context,
                      multipleVideoList: createFeedController.postImageVideoList,
                      tempDisplayList: createFeedController.tempDisplayList,
                      thumbnails: createFeedController.thumbnail);
                },
                icon: ImageComponent.loadLocalImage(imageName: AppImages.videCamera),
              ),
              // 22.sizedBoxW,
              IconButton(
                onPressed: () {
                  chooseMediaOption();
                },
                icon: ImageComponent.loadLocalImage(imageName: AppImages.photo),
              ),
            ],
          ),
          40.sizedBoxH,
          Visibility(
            visible: widget.isCreateForum == false && widget.isCreateForumCategory == false,
            child: Obx(
              () => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0.r),
                  color: AppColors.disableButtonColor,
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0.h, horizontal: 16.0.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.postTo,
                      style: ISOTextStyles.openSenseBold(size: 18, color: AppColors.headingTitleColor),
                    ),
                    14.sizedBoxH,
                    ...List.generate(createFeedController.createSelectionList.length, (index) {
                      return GestureDetector(
                        onTap: () => createFeedController.onCreateFeedTypeSelect(index: index),
                        child: Container(
                          color: AppColors.transparentColor,
                          padding: EdgeInsets.symmetric(vertical: 8.0.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                createFeedController.createSelectionList[index].createFeedType ?? '',
                                style: ISOTextStyles.openSenseSemiBold(size: 16, color: AppColors.chatHeadingName),
                              ),
                              createFeedController.createSelectionList[index].isTypeSelected.value
                                  ? ImageComponent.loadLocalImage(imageName: AppImages.doneFill, height: 22.w, width: 22.w, boxFit: BoxFit.contain)
                                  : Container(),
                            ],
                          ),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
          ),
          15.sizedBoxH,
          /*postContent()*/
        ],
      ),
    );
  }

  ///choose media option
  chooseMediaOption() {
    return DialogComponent.showAlert(
      context,
      arrButton: [AppStrings.strImages, AppStrings.strVideos],
      callback: (btnIndex) {
        if (btnIndex == 0) {
          MediaSelectorManager.chooseMultipleImage(
            imageSource: ImageSource.gallery,
            context: context,
            multipleImages: createFeedController.postImageVideoList,
            tempDisplayList: createFeedController.tempDisplayList,
          );
        } else if (btnIndex == 1) {
          MediaSelectorManager.chooseVideoFromGallery(
              imageSource: ImageSource.gallery,
              context: context,
              multipleVideoList: createFeedController.postImageVideoList,
              tempDisplayList: createFeedController.tempDisplayList,
              thumbnails: createFeedController.thumbnail);
        }
      },
      barrierDismissible: true,
      title: AppStrings.chooseMedia,
      message: AppStrings.chooseMediaMessage,
    );
    /*return DialogComponent.showAlertDialog(
      context: context,
      title: AppStrings.chooseMedia,
      barrierDismissible: true,
      content: AppStrings.chooseMediaMessage,
      arrButton: Platform.isAndroid
          ? <Widget>[
              ButtonComponents.textIconButton(
                onTap: () {
                  MediaSelectorManager.chooseMultipleImage(
                    imageSource: ImageSource.gallery,
                    context: context,
                    multipleImages: createFeedController.postImageVideoList,
                    tempDisplayList: createFeedController.tempDisplayList,
                  );
                  Get.back();
                },
                icon: AppImages.photo,
                labelText: 'Images',
              ),
              ButtonComponents.textIconButton(
                onTap: () {
                  MediaSelectorManager.chooseVideoFromGallery(
                      imageSource: ImageSource.gallery,
                      context: context,
                      multipleVideoList: createFeedController.postImageVideoList,
                      tempDisplayList: createFeedController.tempDisplayList,
                      thumbnails: createFeedController.thumbnail);
                  Get.back();
                },
                icon: AppImages.videCamera,
                labelText: 'Videos',
              ),
            ]
          : <CupertinoDialogAction>[
              CupertinoDialogAction(
                child: const Text('Images'),
                onPressed: () {
                  MediaSelectorManager.chooseMultipleImage(
                    imageSource: ImageSource.gallery,
                    context: context,
                    multipleImages: createFeedController.postImageVideoList,
                    tempDisplayList: createFeedController.tempDisplayList,
                  );
                  Get.back();
                },
              ),
              CupertinoDialogAction(
                child: const Text('Videos'),
                onPressed: () {
                  MediaSelectorManager.chooseVideoFromGallery(
                      imageSource: ImageSource.gallery,
                      context: context,
                      multipleVideoList: createFeedController.postImageVideoList,
                      tempDisplayList: createFeedController.tempDisplayList,
                      thumbnails: createFeedController.thumbnail);
                  Get.back();
                },
              ),
            ],
    );*/
  }

  String categoryName() {
    if (createFeedController.selectedCategoriesName.isEmpty && (widget.categoryName ?? '').isEmpty) {
      return AppStrings.category;
    } else if (createFeedController.selectedCategoriesName.isNotEmpty) {
      return createFeedController.selectedCategoriesName.value;
    } else if ((widget.categoryName ?? '').isNotEmpty) {
      createFeedController.selectedCategoriesName.value = widget.categoryName ?? '';
      createFeedController.selectedCategoryId.value = widget.categoryId ?? -1;
      return createFeedController.selectedCategoriesName.value;
    } else {
      return '';
    }
  }
}
