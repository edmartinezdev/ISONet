import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/network/viewall_suggestion_controller.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/Network/viewall_suggestion_adaptor.dart';
import 'package:iso_net/utils/swipe_back.dart';

import '../../../../bindings/bottom_tabs/user_binding/user_profile_binding.dart';
import '../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../utils/app_common_stuffs/common_api_function.dart';
import '../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../style/appbar_components.dart';
import '../../../style/image_components.dart';
import '../../../style/showloader_component.dart';
import '../../../style/text_style.dart';
import '../news_feed/user_screens/user_profile_screen.dart';

class ViewAllSuggestionScreen extends StatefulWidget {
  const ViewAllSuggestionScreen({Key? key}) : super(key: key);

  @override
  State<ViewAllSuggestionScreen> createState() => _ViewAllSuggestionScreenState();
}

class _ViewAllSuggestionScreenState extends State<ViewAllSuggestionScreen> with AutomaticKeepAliveClientMixin<ViewAllSuggestionScreen> {
  ViewAllSuggestionController viewAllSuggestionController = Get.find();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowLoaderDialog.showLoaderDialog(context);
    });
    viewAllSuggestionController.viewAllSuggestionApiCall(pageOfSuggestionToShow: viewAllSuggestionController.pageOfSuggestionToShow.value);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: true);
        return true;
      },
      child: SwipeBackWidget(
        result: true,
        child: Scaffold(
          appBar: appBarBody(),
          body: buildBody(),
        ),
      ),
    );
  }

  ///AppBar Body
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      titleWidget: Text(
        AppStrings.suggestionScreen,
        style: ISOTextStyles.openSenseSemiBold(size: 18),
      ),
      leadingWidget: IconButton(
        onPressed: () {
          //Get.back<List<ConnectionSuggestion>>(result: viewAllSuggestionController.suggestionList);
          Get.back(result: true);
        },
        icon: ImageComponent.loadLocalImage(
          imageName: AppImages.arrow,
        ),
      ),
      centerTitle: true,
    );
  }

  ///Scaffold Body
  Widget buildBody() {
    return Obx(
      () => GridView.builder(
        addAutomaticKeepAlives: true,
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
        controller: viewAllSuggestionController.suggestionScrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 35.0, childAspectRatio: 0.75),
        itemCount: viewAllSuggestionController.isAllSuggestionDataLoaded.value ? viewAllSuggestionController.suggestionList.length + 1 : viewAllSuggestionController.suggestionList.length,
        itemBuilder: (context, index) {
          if (index == viewAllSuggestionController.suggestionList.length) {
            Future.delayed(
              const Duration(milliseconds: 100),
              () async {
                await _handleLoadMoreList();
              },
            );
            return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
          }
          var suggestionData = viewAllSuggestionController.suggestionList[index];
          return ViewAllSuggestionAdaptor(
            suggestionData: suggestionData,
            userProfileOnTap: () async {
              var callBack = await handleUserProfileTap(userId: suggestionData.userId ?? 0);
              viewAllSuggestionController.suggestionList[index].connectStatus.value = callBack;
              viewAllSuggestionController.update();
            },
            connectButtonTap: () {
              _handleConnectRequest(index: index);
            },
          );
        },
      ),
    );
  }

  ///Handle Connect Request
  _handleConnectRequest({required int index}) async {
    var apiResult = await CommonApiFunction.commonConnectApi(
        userId: viewAllSuggestionController.suggestionList[index].userId ?? 0,
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
        });
    if (apiResult) {
      viewAllSuggestionController.suggestionList[index].connectStatus.value = 'Requested';
    }
  }

  ///Handle UserProfile Navigation Function
  Future<String> handleUserProfileTap({required int userId}) async {
    String callBack = await Get.to(
      UserProfileScreen(
        userId: userId,
      ),
      binding: UserProfileBinding(),
    );
    return callBack;
  }

  ///LoadMore Functionality
  Future _handleLoadMoreList() async {
    viewAllSuggestionController.isLoaderShow.value = false;
    if (!viewAllSuggestionController.isAllSuggestionDataLoaded.value) return;
    if (viewAllSuggestionController.isLoadMoreRunningForViewAll) return;
    viewAllSuggestionController.isLoadMoreRunningForViewAll = true;
    await viewAllSuggestionController.viewAllSuggestionPagination();
  }
}
