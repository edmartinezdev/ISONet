import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/company_controller/employee_profile_controller.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/feed_post_adapter/feed_post_adaptor.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';

import '../../../../../bindings/bottom_tabs/feed_detail_binding.dart';
import '../../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../../utils/app_common_stuffs/common_api_function.dart';
import '../../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../../common_ui/view_photo_video_screen.dart';
import '../../../../style/appbar_components.dart';
import '../../../../style/image_components.dart';
import '../feed_detail_screen.dart';

class EmployeeFeedScreen extends StatefulWidget {
  const EmployeeFeedScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EmployeeFeedScreen> createState() => _EmployeeFeedScreenState();
}

class _EmployeeFeedScreenState extends State<EmployeeFeedScreen> {
  EmployeeProfileController employeeProfileController = Get.find();

  @override
  void initState() {
    employeeProfileController.pageToShow.value = 1;
    employeeProfileController.totalFeedRecord.value = 0;
    employeeProfileController.isAllDataLoaded.value = false;
    employeeProfileController.employeeFeedApiCall(page: employeeProfileController.pageToShow.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBody(),
      body: buildBody(),
    );
  }

  ///AppBar Body
  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      leadingWidget: GestureDetector(
        onTap: () {
          Get.back();
          employeeProfileController.employeeAllFeedList.clear();
        },
        child: ImageComponent.loadLocalImage(
          imageName: AppImages.arrow,
        ),
      ),
    );
  }

  Future _handleLoadMoreList() async {
    if (!employeeProfileController.isAllDataLoaded.value) return;
    if (employeeProfileController.isLoadMoreRunningForViewAll) return;
    employeeProfileController.isLoadMoreRunningForViewAll = true;
    await employeeProfileController.feedPagination();
  }

  ///Scaffold Body
  Widget buildBody() {
    return Obx(
      () => ListView.builder(
        controller: employeeProfileController.scrollController,
        itemCount: employeeProfileController.isAllDataLoaded.value ? employeeProfileController.employeeAllFeedList.length + 1 : employeeProfileController.employeeAllFeedList.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          if (index == employeeProfileController.employeeAllFeedList.length) {
            Future.delayed(
              const Duration(milliseconds: 100),
              () async {
                await _handleLoadMoreList();
              },
            );
            return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
          }
          if (index < employeeProfileController.employeeAllFeedList.length) {
            var userFeed = employeeProfileController.employeeAllFeedList[index].obs;
            return Obx(
              () => FeedPostAdapter(
                isUserProfileOpen: false,
                feedData: userFeed.value,
                screenRoutes: ()async{
                  var callBackData = await Get.to(
                      FeedDetailScreen(
                        feedId: userFeed.value.feedId ?? 0,
                      ),
                      binding: FeedDetailBinding());
                  if (callBackData != null) {
                    userFeed.value = callBackData;
                    employeeProfileController.update();
                  }
                },
                commentButton:  () async {
                  var callBackData = await Get.to(
                      FeedDetailScreen(
                        feedId: userFeed.value.feedId ?? 0,
                      ),
                      binding: FeedDetailBinding());
                  if (callBackData != null) {
                    userFeed.value = callBackData;
                    employeeProfileController.update();
                  }
                },
                pageController: employeeProfileController.pageController,
                threeDotTap: (){
                  CommonUtils.reportWidget(feedId: userFeed.value.feedId ?? 0, context: context, buttonText: [AppStrings.sendPost,AppStrings.reportPost,AppStrings.flagPost,],reportTyp: AppStrings.feed,);
                },
                onPostImageTap:  (value) async {
                  var callBack = await Get.to(PhotoVideoScreen(), arguments: [userFeed.value, value]);
                  if (callBack != null) {
                    userFeed.value = callBack;
                  }
                },
                onConnectButtonPress: () async {
                  var apiResult = await CommonApiFunction.commonConnectApi(
                      userId: employeeProfileController.employeeProfileData.value?.userId ?? 0,
                      onErr: (msg) {
                        SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                      });
                  if (apiResult) {
                    userFeed.value.user?.isConnected.value = AppStrings.requested;
                    employeeProfileController.employeeProfileData.value?.isConnected.value = AppStrings.requested;

                  }
                },
              ),
              /*FeedPostWidget(
                userProfilePage: () {},
                profileImageUrl: employeeProfileController.employeeProfileData.value?.profileImg ?? '',
                fName: employeeProfileController.employeeProfileData.value?.firstName ?? '',
                lName: employeeProfileController.employeeProfileData.value?.lastName ?? '',
                companyName: employeeProfileController.employeeProfileData.value?.companyName ?? '',
                timeAgo: userFeed.value.getHoursAgo,
                postContent: userFeed.value.description ?? '',
                screenRoutes: () async {
                  var callBackData = await Get.to(
                      FeedDetailScreen(
                        feedId: userFeed.value.feedId ?? 0,
                      ),
                      binding: FeedDetailBinding());
                  if (callBackData != null) {
                    userFeed.value = callBackData;
                    employeeProfileController.update();
                  }
                },
                onThreeDotTap: () {
                  CommonUtils.reportWidget(feedId: userFeed.value.feedId ?? 0, context: context, buttonText: AppStrings.reportPost);
                },
                isUserConnected: employeeProfileController.employeeProfileData.value?.isConnected ?? AppStrings.notConnected.obs,

                onConnectButtonPress: () async {
                  var apiResult = await CommonApiFunction.commonConnectApi(
                      userId: employeeProfileController.employeeProfileData.value?.userId ?? 0,
                      onErr: (msg) {
                        SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                      });
                  if (apiResult) {
                    employeeProfileController.employeeProfileData.value?.isConnected.value = 'Requested';

                  }
                },
                isExpandText: userFeed.value.showMore,
                postImages: userFeed.value.feedMedia ?? [],
                pageController: employeeProfileController.pageController,
                onPostImageTap: (value) async {
                  var callBack = await Get.to(PhotoVideoScreen(), arguments: [userFeed.value, value]);
                  if (callBack != null) {
                    userFeed.value = callBack;
                  }
                },
                likeCounts: userFeed.value.likesCounters.value,
                commentCounts: userFeed.value.comment ?? 0,
                onLikeButtonPressed: () async {
                  if (userFeed.value.isLikeFeed.value == false) {
                    var likeResponse = await employeeProfileController.likePostApi(
                      feedId: '${userFeed.value.feedId ?? 0}',
                      onSuccess: (value) {
                        userFeed.value.likesCounters.value = value;
                      },
                    );
                    if (likeResponse) {
                      userFeed.value.isLikeFeed.value = true;
                    }
                  } else {
                    var likeResponse = await employeeProfileController.unlikePostApi(
                      feedId: '${userFeed.value.feedId ?? 0}',
                      onSuccess: (value) {
                        userFeed.value.likesCounters.value = value;
                      },
                    );
                    if (likeResponse) {
                      userFeed.value.isLikeFeed.value = false;
                    }
                  }
                },
                likedIcon: userFeed.value.isLikeFeed.value == true ? AppImages.dollarFill : AppImages.dollar,
                onCommentButtonPressed: () async {
                  var callBackData = await Get.to(
                      FeedDetailScreen(
                        feedId: userFeed.value.feedId ?? 0,
                      ),
                      binding: FeedDetailBinding());
                  if (callBackData != null) {
                    userFeed.value = callBackData;
                    employeeProfileController.update();
                  }
                },
                onSendButtonPressed: () {
                  SendFunsctionality.sendBottomSheet(feedId: userFeed.value.feedId ?? 0, context: context);
                },
                isShareIconVisible: false.obs,
                isUserMe: CommonUtils.isUserMe(id: employeeProfileController.employeeProfileData.value?.userId ?? 0),
                isUserVerify: userFeed.value.user?.isVerified ?? false,
              ),*/
            );
          } else {
            if (employeeProfileController.paginationLoadData()) {
              return const Divider();
            } else {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 16.0.h),
                alignment: Alignment.center,
                child: const CupertinoActivityIndicator(),
              );
            }
          }
        },
      ),
    );
  }
}
