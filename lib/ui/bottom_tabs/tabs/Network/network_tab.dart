import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/bindings/bottom_tabs/network/viewall_suggestion_binding.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/network/network_tab_controller.dart';
import 'package:iso_net/controllers/my_profile/my_profile_controller.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/Network/viewall_request_adaptor.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/Network/viewall_suggestion_adaptor.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/Network/viewall_suggestion_screen.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../bindings/bottom_tabs/user_binding/user_profile_binding.dart';
import '../../../../bindings/user/loan_preference_binding.dart';
import '../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../utils/app_common_stuffs/common_api_function.dart';
import '../../../../utils/app_common_stuffs/screen_routes.dart';
import '../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../style/text_style.dart';
import '../news_feed/scoreboard_adaptor/scoreboard_adaptor.dart';
import '../news_feed/user_screens/user_profile_screen.dart';
import '../search/findfunder_loanform_screen.dart';

class NetworkTab extends StatefulWidget {
  const NetworkTab({Key? key}) : super(key: key);

  @override
  State<NetworkTab> createState() => _NetworkTabState();
}

class _NetworkTabState extends State<NetworkTab> with AutomaticKeepAliveClientMixin<NetworkTab> {
  NetworkController networkController = Get.find<NetworkController>();
  MyProfileController myProfileController = Get.find<MyProfileController>();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowLoaderDialog.showLoaderDialog(context);
      networkController.apiCallFetchScoreboardLoanList();
      networkController.networkTabApiCall(isShowLoader: true);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: appBarBody(),
      body: buildBody(),
      floatingActionButton: findFunderButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBar(
      title: Text(
        AppStrings.network,
        style: ISOTextStyles.openSenseBold(size: 24),
      ),
      centerTitle: false,
      actions: [
          GestureDetector(
            onTap: () {
              Get.toNamed(ScreenRoutesConstants.searchScreen);
            },
            child: ImageComponent.loadLocalImage(imageName: AppImages.searchCircle, height: 29.w, width: 29.w, boxFit: BoxFit.contain),
          ),
        5.sizedBoxW,
        GestureDetector(
          onTap: (){
            routeToMyProfileScreen();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(5.0),
                child: ImageComponent.circleNetworkImage(
                  imageUrl: myProfileController.myProfileData.value?.profileImg ?? '',
                  height: 29.w,
                  width: 29.w,
                ),
              ),
              Obx(
                    () => Visibility(
                  visible: myProfileController.myProfileData.value?.isVerified == true,
                  child: Positioned(
                    bottom: 10.h,
                    right: 2.w,
                    child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, height: 12.w, width: 12.w, boxFit: BoxFit.contain),
                  ),
                ),
              ),
              Positioned(
                top: 10.h,
                left: 2.w,
                child: ImageComponent.loadLocalImage(imageName: userSingleton.userType == AppStrings.fu ? AppImages.funderBadge : AppImages.brokerBadge, height: 12.h, width: 12.w),
              ),
            ],
          ),
        ),
        11.sizedBoxW,
      ],

    );
  }

  ///Scaffold body widget

  Widget buildBody() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () {
          return _handleOnRefresh();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
          child: Obx(
            () => Column(
              children: [
                scoreBoardBody(),
                const Divider(
                  color: AppColors.dividerColor,
                ),
                viewMyNetworkBody(),
                const Divider(
                  color: AppColors.dividerColor,
                ),
                requestBody(),
                const Divider(
                  color: AppColors.dividerColor,
                ),
                requestListBody(),
                suggestionBody(),
                suggestionGridBody(),
                Container(
                  height: userSingleton.userType == AppStrings.fu
                      ? 0
                      : networkController.suggestionList.isEmpty
                          ? 0
                          : 80.h,
                  color: AppColors.whiteColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///score board body
  Widget scoreBoardBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 16.0.w, top: 14.0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.scoreBoard,
                style: ISOTextStyles.openSenseSemiBold(size: 16, color: AppColors.headingTitleColor),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(ScreenRoutesConstants.scoreBoardScreen);
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 21.0.w),
                  child: Text(
                    AppStrings.viewAll,
                    style: ISOTextStyles.openSenseSemiBold(
                      size: 12,
                      color: AppColors.disableTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => SizedBox(
            height: networkController.loanList.length > 0 ? (MediaQuery.of(context).size.shortestSide < 300 ? 120.w : 115.w) : 20,
            /*padding: EdgeInsets.only(left: 0, right: 5.w),*/
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 15.h, top: 10.h, left: 10.w),
              scrollDirection: Axis.horizontal,
              itemCount: networkController.loanList.length > 4 ? 4 : networkController.loanList.length,
              itemBuilder: (context, index) {
                return ScoreBoardAdaptor(
                  index: index,
                  loanData: networkController.loanList[index],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget viewMyNetworkBody() {
    return GestureDetector(
      onTap: () {
        (networkController.networkTabData.value?.viewMyNetwork ?? 0) != 0 ? Get.toNamed(ScreenRoutesConstants.viewMyNetWorkScreen) : null;
      },
      child: Container(
        color: AppColors.transparentColor,
        padding: EdgeInsets.only(right: 16.0.w, top: 19.0.h, left: 19.0.w, bottom: 17.0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  AppStrings.viewMyNetwork,
                  style: ISOTextStyles.openSenseRegular(size: 15, color: AppColors.blackColorDetailsPage),
                ),
                11.sizedBoxW,
                Text(
                  '(${networkController.networkTabData.value?.viewMyNetwork ?? 0})',
                  style: ISOTextStyles.openSenseSemiBold(size: 15, color: AppColors.primaryColor),
                ),
              ],
            ),
            ImageComponent.loadLocalImage(imageName: AppImages.rightArrow, imageColor: AppColors.headingTitleColor),
          ],
        ),
      ),
    );
  }

  ///Request  Body
  Widget requestBody() {
    return Container(
      padding: EdgeInsets.only(right: 21.0.w, top: 12.0.h, left: 16.0.w, bottom: 12.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.request,
            style: ISOTextStyles.openSenseSemiBold(size: 16),
          ),
          networkController.requestList.length > 3
              ? GestureDetector(
                  onTap: () async {
                    var callBack = await Get.toNamed(ScreenRoutesConstants.viewAllRequestScreen);
                    if (callBack) {
                      _handleOnRefresh();
                    }
                  },
                  child: Text(
                    AppStrings.viewAll,
                    style: ISOTextStyles.openSenseSemiBold(
                      size: 12,
                      color: AppColors.disableTextColor,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget requestListBody() {
    return Obx(
      () => networkController.requestList.isEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Center(
                child: Text(
                  AppStrings.pendingRequest,
                  style: ISOTextStyles.openSenseSemiBold(size: 16),
                ),
              ),
            )
          : ListView.separated(
              itemCount: networkController.requestList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                var requestData = networkController.requestList[index];
                return ViewAllRequestAdaptor(
                  requestData: requestData,
                  acceptRequestCallBack: () async {
                    _handleAcceptButtonPress(index: index);
                  },
                  cancelRequestCallBack: () async {
                    _handleCancelButtonPress(index: index);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  color: AppColors.dividerColor,
                );
              },
            ),
    );
  }

  Widget suggestionBody() {
    return Container(
      padding: EdgeInsets.only(right: 16.0.w, left: 16.0.w, top: 22.0.h, bottom: 17.0.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              userSingleton.userType == 'FU' ? AppStrings.brokerYouKnow : AppStrings.funderYouKnow,
              style: ISOTextStyles.openSenseSemiBold(size: 16),
            ),
          ),
          networkController.suggestionList.length > 2
              ? GestureDetector(
                  onTap: () async {
                    var callBack = await Get.to(const ViewAllSuggestionScreen(), binding: ViewAllSuggestionBinding());
                    if (callBack) {
                      _handleOnRefresh();
                    }
                  },
                  child: Text(
                    AppStrings.viewAll,
                    style: ISOTextStyles.openSenseSemiBold(
                      size: 12,
                      color: AppColors.disableTextColor,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  ///Suggestion grid list
  Widget suggestionGridBody() {
    return Obx(
      () => GridView.builder(
        padding: EdgeInsets.only(right: 16.0.w, left: 16.0.w, top: 4.0.h, bottom: 20.0.h),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        addAutomaticKeepAlives: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 35.0, childAspectRatio: 0.75),
        itemCount: networkController.suggestionList.length,
        itemBuilder: (context, index) {
          var suggestionData = networkController.suggestionList[index];
          return ViewAllSuggestionAdaptor(
            suggestionData: suggestionData,
            userProfileOnTap: () async {
              var callBack = await handleUserProfileTap(userId: suggestionData.userId ?? 0);
              networkController.suggestionList[index].connectStatus.value = callBack;
              networkController.update();
            },
            connectButtonTap: () {
              _handleConnectRequest(index: index);
            },
          );
        },
      ),
    );
  }

  ///Find a funder button body
  Widget findFunderButton() {
    return userSingleton.userType == 'FU'
        ? Container()
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
            child: InkWell(
              onTap: () {
                Get.to(const LoanForumScreen(), binding: LoanPreferenceBinding());
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  color: AppColors.primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.findFunderB,
                      style: ISOTextStyles.openSenseBold(size: 16),
                    ),
                    ImageComponent.loadLocalImage(imageName: AppImages.rightArrow),
                  ],
                ),
              ),
            ),
          );
  }

  ///Handle Accept Request Function
  _handleAcceptButtonPress({required int index}) async {
    var acceptRequestApi = await networkController.acceptRequestApiCall(
      requestUserId: networkController.requestList[index].userId ?? 0,
      onErr: (msg) {
        SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
      },
    );
    if (acceptRequestApi) {
      SnackBarUtil.showSnackBar(
          context: context,
          type: SnackType.success,
          message: 'You are now connected with ${networkController.requestList[index].firstName ?? ''} ${networkController.requestList[index].lastName ?? ''}');

      networkController.networkTabApiCall();
    }
  }

  ///Handle Cancel Request Function
  _handleCancelButtonPress({required int index}) async {
    var acceptRequestApi = await networkController.cancelRequestApiCall(
      requestUserId: networkController.requestList[index].userId ?? 0,
      onErr: (msg) {
        SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
      },
    );
    if (acceptRequestApi) {
      networkController.networkTabApiCall();
    }
  }

  ///Handle OnRefresh Function
  _handleOnRefresh() async {
    networkController.isNetworkDataLoaded.value = true;
    networkController.apiCallFetchScoreboardLoanList();
    await networkController.networkTabApiCall();
  }

  _handleConnectRequest({required int index}) async {
    var apiResult = await CommonApiFunction.commonConnectApi(
        userId: networkController.suggestionList[index].userId ?? 0,
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
        });
    if (apiResult) {
      networkController.suggestionList[index].connectStatus.value = 'Requested';
    }
  }

  ///Handle UserProfile Navigation Function
  Future<String> handleUserProfileTap({
    required int userId,
  }) async {
    String callBack = await Get.to(
      UserProfileScreen(
        userId: userId,
      ),
      binding: UserProfileBinding(),
    );
    return callBack;
  }
  ///Route to my profile screen function
  routeToMyProfileScreen() {

    Get.toNamed(
      ScreenRoutesConstants.myProfileScreen,
      arguments: userSingleton.id,
    );
  }
}
