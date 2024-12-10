import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/chat/search_message_controller.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../../utils/app_common_stuffs/app_fonts.dart';
import '../../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../../style/button_components.dart';
import '../../../../style/image_components.dart';
import '../../../../style/text_style.dart';
import 'chat_list_adaptor/chat_list_adaptor.dart';

class SearchMessageScreen extends StatefulWidget {
  const SearchMessageScreen({Key? key}) : super(key: key);

  @override
  State<SearchMessageScreen> createState() => _SearchMessageScreenState();
}

class _SearchMessageScreenState extends State<SearchMessageScreen>  with AfterLayoutMixin{
  SearchMessageController searchMessageController = Get.find();
  TextEditingController searchTextController = TextEditingController();
  FocusNode focusNode = FocusNode();
  Timer? _debounce;
@override
  void initState() {
    super.initState();
  }
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> CommonUtils.scopeUnFocus(context),
      child: Scaffold(
        appBar: appBarBody(),
        body: CustomScrollView(
          //controller: searchMessageController.scrollController,
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
                  () => searchMessageController.isSearchEnable.value == false ? SliverFillRemaining(
                    child: searchIconTextWidget(),
                  ) : searchMessageController.isSearching.value ? const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                        child: CircularProgressIndicator(color: AppColors.primaryColor,)),
                  ) :  (searchMessageController.chatList.isEmpty /*&& searchMessageController.isApiResponseReceive.value == true*/)
                      ? SliverFillRemaining(
                          child: Center(
                              child: Text(
                            AppStrings.noRecordFound,
                            style: ISOTextStyles.openSenseSemiBold(size: 16),
                          )),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            addAutomaticKeepAlives: true,
                            childCount: searchMessageController.isAllDataLoaded.value ? (searchMessageController.chatList.length) + 1 : (searchMessageController.chatList.length),
                            (BuildContext context, int index) {
                              if (index == (searchMessageController.chatList.length)) {
                                Future.delayed(
                                  const Duration(milliseconds: 100),
                                  () async {
                                    await _handleLoadMoreList();
                                  },
                                );
                                return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center);
                              }
                              final chatData = searchMessageController.chatList[index].obs;

                              return ChatListAdaptor(
                                isSearchEnable: true,
                                chatData: chatData,
                                searchQuery: searchTextController.text,
                                deleteItem: () {
                                  searchMessageController.chatList.remove(chatData.value);
                                },
                              );
                            },
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

  ///Search message appbar
  PreferredSizeWidget appBarBody() {
    return AppBar(
      centerTitle: false,
      automaticallyImplyLeading: false,

      title:  CupertinoSearchTextField(
        controller: searchTextController,
        focusNode: focusNode,
        onTap: () {},
        prefixIcon: Icon(
          CupertinoIcons.search,
          color: AppColors.scoreboardNumColor,
          size: 17.sp,
        ),
        onChanged: (value) {
          _handleSearchOnChange(value: value);
        },
        onSuffixTap: () async {
          searchMessageController.chatList.clear();
          searchTextController.clear();
          searchMessageController.isSearchEnable.value = false;
        },
        onSubmitted: (value) {
          focusNode.unfocus();
        },
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 12.0.w),
          child: GestureDetector(
            onTap: () {},
            child: ButtonComponents.textButton(
                context: context,
                onTap: () {
                  Get.back();
                },
                title: AppStrings.cancel,
                textColor: AppColors.blackColor),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(
          color: AppColors.dropDownColor,
          height: 1.0,
        ),
      ),
    );
  }

  /// Search bar Widget
  Widget searchBar() {
    return Container(
        color: AppColors.searchBackgroundColor,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: CupertinoTheme(
            data: const CupertinoThemeData(
              primaryColor: AppColors.blackColor,
            ),
            child: CupertinoSearchTextField(
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
              onChanged: (value) {
                _handleSearchOnChange(value: value);
              },
              onSuffixTap: () {
                searchMessageController.chatList.clear();
                searchTextController.clear();
                searchMessageController.isSearchEnable.value = false;

              },
              onSubmitted: (value){
                focusNode.unfocus();
              },
            ),
          ),
        ));
  }

  Future _handleLoadMoreList() async {
    if (!searchMessageController.isAllDataLoaded.value) return;
    if (searchMessageController.isLoadMoreRunningForViewAll) return;
    searchMessageController.isLoadMoreRunningForViewAll = true;
    searchMessageController.apiCallSearchMessages(searchText: searchTextController.text,isShowLoader: false);
  }

  _handleSearchOnChange({required String value}) {

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      searchMessageController.isAllDataLoaded.value = false;
      searchMessageController.chatList.clear();
      if(value.isEmpty){
        return;
      }else{
        /*ShowLoaderDialog.showLoaderDialog(context);*/
        searchMessageController.isSearchEnable.value = true;
        searchMessageController.isSearching.value = true;
        await searchMessageController.apiCallSearchMessages(searchText: value,isShowLoader: false);
      }

    });
  }
  ///Search Message Widget
  Widget searchIconTextWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageComponent.loadLocalImage(imageName: AppImages.searchYellow, height: 56.w, width: 56.w, boxFit: BoxFit.contain),
          29.sizedBoxH,
          Text(
            AppStrings.searchMessageScreen,
            style: ISOTextStyles.sfProBold(
              size: 16,
              color: AppColors.blackColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
