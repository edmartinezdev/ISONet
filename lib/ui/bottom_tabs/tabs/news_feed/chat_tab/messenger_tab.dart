import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:iso_net/bindings/bottom_tabs/chat_tab/search_message_binding.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/messenger_tab_controller.dart';
import 'package:iso_net/helper_manager/socket_manager/socket_manager_new.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/chat_tab/chat_list_adaptor/chat_list_adaptor.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/chat_tab/search_message_screen.dart';
import 'package:iso_net/ui/style/ImageWidget.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_fonts.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';
import 'package:iso_net/utils/app_common_stuffs/send_functionality.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../../style/image_components.dart';
import '../../../../style/text_style.dart';
import 'chat_filter_screen.dart';

final updateChatHistorySubject = PublishSubject<bool>();

Stream<bool> get updateChatHistoryStream => updateChatHistorySubject.stream;

class MessengerTab extends StatefulWidget {
  const MessengerTab({Key? key}) : super(key: key);

  @override
  State<MessengerTab> createState() => _MessengerTabState();
}

class _MessengerTabState extends State<MessengerTab> with WidgetsBindingObserver, AutomaticKeepAliveClientMixin<MessengerTab>, AfterLayoutMixin {
  MessengerController messengerController = Get.find<MessengerController>();
  TextEditingController searchTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  FocusNode focusNode = FocusNode();

  @override
  bool get wantKeepAlive => true;

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    /// Get Chat Conversations
    messengerController.updateRecentChatList(context, isPullToRefresh: true);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    /// Todo:- Change this as per new socket manager
    messengerController.chatList.clear();
    AwesomeNotifications().cancelAll();
    SocketManagerNew().isSendRecentUpdateList.value = false;
    super.initState();
    messengerController.filterType.value = '';
    _scrollController.addListener(() {
      CommonUtils.scopeUnFocus(context);
    });

    recentChatListStream.listen((event) {
      messengerController.filterType.value = '';
      messengerController.updateRecentChatList(context);
    });
  }

  /// Check socket connection when app is coming from  background to foreground
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      SocketManagerNew().connectToServer();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appBarBody(),
      body: RefreshIndicator(
        onRefresh: () async {
          _handleOnRefreshEvent();
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            /*SliverToBoxAdapter(
              child: searchBar(),
            ),*/
            SliverPadding(
              padding: const EdgeInsets.only(top: 0),
              sliver: SliverSafeArea(
                bottom: true,
                top: false,
                sliver: Obx(
                  () => (messengerController.chatList.isEmpty && messengerController.isApiResponseReceive.value == true)
                      ? SliverFillRemaining(
                          child: Center(
                              child: Text(
                            AppStrings.noMessageFound,
                            style: ISOTextStyles.openSenseSemiBold(size: 16),
                          )),
                        )
                      : SlidableAutoCloseBehavior(
                          child: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              addAutomaticKeepAlives: true,
                              childCount: messengerController.isAllDataLoaded.value ? (messengerController.chatList.length) + 1 : (messengerController.chatList.length),
                              (BuildContext context, int index) {
                                if (index == (messengerController.chatList.length)) {
                                  Future.delayed(
                                    const Duration(milliseconds: 100),
                                    () async {
                                      await _handleLoadMoreList();
                                    },
                                  );
                                  return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center);
                                }
                                final chatData = messengerController.chatList[index].obs;

                                return ChatListAdaptor(
                                  isSearchEnable: false,
                                  chatData: chatData,
                                  deleteItem: () {
                                    messengerController.chatList.remove(chatData.value);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleOnRefreshEvent() {
    messengerController.isAllDataLoaded.value = false;
    /*messengerController.chatList.clear();*/

    messengerController.totalRecord.value = 0;
    SocketManagerNew().isSendRecentUpdateList.value = false;

    /// Todo:- Change this as per new socket manager

    if (messengerController.filterIndex.value != null) {
      messengerController.filterIndex.value = null;
      for (var element in messengerController.filterSelectionList) {
        element.isFilterSelected.value = false;
      }
      messengerController.filterType.value = '';
    }

    /// Todo:- Change this as per new socket manager
    messengerController.isApiResponseReceive.value = false;
    messengerController.updateRecentChatList(context, isPullToRefresh: true);
  }

  Future _handleLoadMoreList() async {
    if (!messengerController.isAllDataLoaded.value) return;
    if (messengerController.isLoadMoreRunningForViewAll) return;
    messengerController.isLoadMoreRunningForViewAll = true;
    messengerController.updateRecentChatList(context);
  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBar(
      centerTitle: false,
      title: Text(
        AppStrings.messenger,
        style: ISOTextStyles.openSenseBold(size: 24),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  CommonUtils.scopeUnFocus(context);
                  Get.to(const ChatFilterScreen());
                },
                child: Image.asset(AppImages.sort),
              ),
              10.sizedBoxW,
              GestureDetector(
                onTap: () {
                  Get.to(const SearchMessageScreen(), binding: SearchMessageBinding());
                },
                child: ImageComponent.loadLocalImage(imageName: AppImages.searchCircle, height: 29.w, width: 29.w, boxFit: BoxFit.contain),
              ),
              10.sizedBoxW,
              GestureDetector(
                onTap: () async {
                  CommonUtils.scopeUnFocus(context);
                  Get.toNamed(ScreenRoutesConstants.chatNewMessageScreen);
                },
                child: Image.asset(AppImages.create),
              ),
            ],
          ),
        )
      ],

    );
  }

  /// Search bar Widget
  Widget searchBar() {
    return Container(
        color: AppColors.searchBackgroundColor,
        child: InkWell(
          onTap: () {
            Get.to(const SearchMessageScreen(), binding: SearchMessageBinding());
          },
          child: Container(
            color: AppColors.transparentColor,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: IgnorePointer(
              child: CupertinoSearchTextField(
                enabled: true,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.w),
                placeholderStyle: TextStyle(fontFamily: AppFont.openSenseRegular, fontSize: 17, color: AppColors.refferalText),
                style: TextStyle(fontFamily: AppFont.openSenseRegular, fontSize: 17),
                placeholder: AppStrings.searchMessages,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppColors.whiteColor,

                ),
                controller: searchTextController,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 4.w),
                  child: Image.asset(
                    AppImages.search,
                    height: 20.w,
                    width: 20.w,
                    fit: BoxFit.contain,
                    color: AppColors.scoreboardNumColor,
                  ),
                ),
                focusNode: focusNode,
                onChanged: (value) {},
                onSuffixTap: () {
                  searchTextController.clear();
                },
              ),
            ),
          ),
        ));
  }

  Widget getSingleImageUI({required String imageURL, bool isUserVerified = false}) {
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
            child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, height: 14.w, width: 14.w, boxFit: BoxFit.contain),
          ),
        ),
      ],
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    searchTextController.dispose();
    super.dispose();
  }
}
