import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/network/viewmy_network_controller.dart';
import 'package:iso_net/helper_manager/network_manager/api_const.dart';
import 'package:iso_net/helper_manager/socket_manager/socket_manager_new.dart';
import 'package:iso_net/model/bottom_navigation_models/chat_model/recent_chat_model.dart';
import 'package:iso_net/model/response_model/responese_datamodel.dart';
import 'package:iso_net/ui/style/appbar_components.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../bindings/bottom_tabs/user_binding/user_profile_binding.dart';
import '../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../utils/app_common_stuffs/app_images.dart';
import '../news_feed/user_screens/user_profile_screen.dart';

class ViewMyNetworkScreen extends StatefulWidget {
  const ViewMyNetworkScreen({Key? key}) : super(key: key);

  @override
  State<ViewMyNetworkScreen> createState() => _ViewMyNetworkScreenState();
}

class _ViewMyNetworkScreenState extends State<ViewMyNetworkScreen> with AutomaticKeepAliveClientMixin<ViewMyNetworkScreen> {
  ViewMyNetworkController viewMyNetworkController = Get.find<ViewMyNetworkController>();
  Timer? _debounce;
  FocusNode focusNode = FocusNode();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowLoaderDialog.showLoaderDialog(context);
    });
    viewMyNetworkController.getMyNetworkApi(pageToShow: viewMyNetworkController.pageToShow.value, isShowLoader: true);
    viewMyNetworkController.scrollController.addListener(() {
      focusNode.unfocus();
    });
    /*viewMyNetworkController.viewMyNetworkPagination();*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => CommonUtils.scopeUnFocus(context),
      child: Scaffold(
        appBar: appBarBody(),
        body: buildBody(),
      ),
    );
  }

  ///AppBar
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      titleWidget: Obx(
        () => viewMyNetworkController.isSearchEnable.value
            ? CupertinoSearchTextField(
              focusNode: focusNode,
              onChanged: (value) {
                _handleSearchOnChange(value: value);
              },
              onSuffixTap: () {
                _handleCancelSearch();
              },
            )
            : Text(
                AppStrings.network,
                style: ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.headingTitleColor),
              ),
      ),
      centerTitle: true,
      actionWidgets: [
        Obx(
          () => Visibility(
            visible: viewMyNetworkController.isSearchEnable.value == false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w),
              child: GestureDetector(
                onTap: () {
                  _handleSearchIconTap();
                },
                child: ImageComponent.loadLocalImage(imageName: AppImages.searchCircle, height: 29.w, width: 29.w, boxFit: BoxFit.contain),
              ),
            ),
          ),
        ),
        8.sizedBoxW,
      ],
    );
  }

  Future _handleLoadMoreList() async {
    if (!viewMyNetworkController.isAllDataLoaded.value) return;
    if (viewMyNetworkController.isLoadMoreRunningForViewAll) return;
    viewMyNetworkController.isLoadMoreRunningForViewAll = true;
    await viewMyNetworkController.viewMyNetworkPagination();
  }

  ///scaffold Body
  Widget buildBody() {
    return SafeArea(
      child: Obx(
        () => Padding(
          padding: EdgeInsets.only(top: 18.0.h),
          child: viewMyNetworkController.isTotalRecord.value == false
              ? Center(
                  child: Text(
                    AppStrings.noRecordFound,
                    style: ISOTextStyles.openSenseSemiBold(size: 16),
                  ),
                )
              : ListView.builder(
                  addAutomaticKeepAlives: true,
                  controller: viewMyNetworkController.scrollController,
                  itemCount: viewMyNetworkController.isAllDataLoaded.value ? viewMyNetworkController.myNetworkList.length + 1 : viewMyNetworkController.myNetworkList.length,
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
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              right: 14.0.w,
                              left: 11.0.w,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _handleUserProfileTap(userId: viewMyNetworkController.myNetworkList[index].userId ?? 0);
                              },
                              child: Container(
                                color: AppColors.transparentColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IgnorePointer(
                                      child: Stack(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(5),
                                            child: ImageComponent.circleNetworkImage(
                                              imageUrl: viewMyNetworkController.myNetworkList[index].profileImg ?? '',
                                              height: 36.h,
                                              width: 36.h,
                                            ),
                                          ),
                                          Visibility(
                                            visible: viewMyNetworkController.myNetworkList[index].isVerify == true,
                                            child: Positioned(
                                              bottom: 5.h,
                                              right: 5.w,
                                              child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, width: 10.h, height: 10.w, boxFit: BoxFit.contain),
                                            ),
                                          ),
                                          Visibility(
                                            visible: viewMyNetworkController.myNetworkList[index].userType != null,
                                            child: Positioned(
                                              top: 4.h,
                                              left: 4.w,
                                              child: ImageComponent.loadLocalImage(
                                                  imageName: viewMyNetworkController.myNetworkList[index].userType == AppStrings.fu ? AppImages.funderBadge : AppImages.brokerBadge,
                                                  height: 10.h,
                                                  width: 10.w,
                                                  boxFit: BoxFit.contain),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    12.sizedBoxW,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${viewMyNetworkController.myNetworkList[index].firstName ?? ''} ${viewMyNetworkController.myNetworkList[index].lastName ?? ''}',
                                            style: ISOTextStyles.openSenseRegular(size: 14, color: AppColors.chatHeadingName),
                                          ),
                                          Text(
                                            viewMyNetworkController.myNetworkList[index].companyName ?? '',
                                            style: ISOTextStyles.openSenseRegular(size: 12, color: AppColors.chatMessageSuggestionColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        if (viewMyNetworkController.myNetworkList[index].roomId != null) {
                                          Get.toNamed(
                                            ScreenRoutesConstants.oneToOneChatScreen,
                                            arguments: [
                                              viewMyNetworkController.myNetworkList[index].roomId ?? '',
                                              '${viewMyNetworkController.myNetworkList[index].firstName ?? ''} ${viewMyNetworkController.myNetworkList[index].lastName ?? ''}',
                                              false
                                            ],
                                          );
                                        } else {
                                          /// Done:- Change this as per new socket manager
                                          SocketManagerNew().createGroupEvent(
                                              roomType: ApiParams.oneToOne,
                                              participate: [viewMyNetworkController.myNetworkList[index].userId ?? 0],
                                              onlyGroupCreated: true,
                                              onSend: (ResponseModel<ChatDataa> obj) {},
                                              onError: (msg) {
                                                SnackBarUtil.showSnackBar(context: Get.context!, type: SnackType.error, message: msg);
                                              });
                                          // SocketManagerNew().createGroup(roomType: ApiParams.oneToOne, participate: [viewMyNetworkController.myNetworkList[index].userId ?? 0], messageText: '');
                                        }
                                      },
                                      child: ImageComponent.loadLocalImage(imageName: AppImages.chatCircle, height: 26.w, width: 26.w, boxFit: BoxFit.contain),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 18.0.w, right: 18.0.w),
                            child: const Divider(),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  ///Handle UserProfile Navigation Function
  _handleUserProfileTap({required int userId}) {
    Get.to(
      UserProfileScreen(
        userId: userId,
      ),
      binding: UserProfileBinding(),
    );
  }

  ///Handle Search Icon Tap Function
  _handleSearchIconTap() {
    viewMyNetworkController.isSearchEnable.value = true;
    focusNode.requestFocus();
  }

  ///Handle search event
  _handleSearchOnChange({required String value}) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      viewMyNetworkController.myNetworkList.clear();
      viewMyNetworkController.searchText.value = value;
      viewMyNetworkController.pageToShow.value = 1;
      viewMyNetworkController.totalRecord.value = 0;
      viewMyNetworkController.isAllDataLoaded.value = false;
      await viewMyNetworkController.getMyNetworkApi(pageToShow: viewMyNetworkController.pageToShow.value, isShowLoader: false);
    });
  }

  ///Handle on search cancel event
  _handleCancelSearch() async {
    viewMyNetworkController.myNetworkList.clear();
    viewMyNetworkController.isSearchEnable.value = false;
    viewMyNetworkController.searchText.value = '';
    viewMyNetworkController.pageToShow.value = 1;
    viewMyNetworkController.totalRecord.value = 0;
    viewMyNetworkController.isAllDataLoaded.value = false;
    await viewMyNetworkController.getMyNetworkApi(pageToShow: viewMyNetworkController.pageToShow.value, isShowLoader: false);
  }
}
