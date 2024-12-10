import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/my_profile/my_allfeed_controller.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/news_feed/feed_post_adapter/feed_post_adaptor.dart';
import 'package:iso_net/utils/app_common_stuffs/send_functionality.dart';

import '../../bindings/bottom_tabs/feed_detail_binding.dart';
import '../../utils/app_common_stuffs/app_colors.dart';
import '../../utils/app_common_stuffs/app_logger.dart';
import '../../utils/app_common_stuffs/commom_utils.dart';
import '../../utils/app_common_stuffs/common_api_function.dart';
import '../../utils/app_common_stuffs/snackbar_util.dart';
import '../../utils/app_common_stuffs/strings_constants.dart';
import '../bottom_tabs/tabs/news_feed/feed_detail_screen.dart';
import '../common_ui/view_photo_video_screen.dart';
import '../style/appbar_components.dart';

class MyAllFeedScreen extends StatefulWidget {
  const MyAllFeedScreen({Key? key}) : super(key: key);

  @override
  State<MyAllFeedScreen> createState() => _MyAllFeedScreenState();
}

class _MyAllFeedScreenState extends State<MyAllFeedScreen> {
  MyAllFeedController myAllFeedController = Get.find<MyAllFeedController>();

  @override
  void initState() {
    myAllFeedController.myFeedApiCall(pageToShow: myAllFeedController.pageToShow.value);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBody(),
      body: buildBody(),
    );
  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      bottomWidget: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(
          color: AppColors.dropDownColor,
          height: 1.0,
        ),
      ),
    );
  }

  ///Scaffold Body
  Widget buildBody() {
    return Obx(
          () =>
          ListView.builder(
            controller: myAllFeedController.scrollController,
            itemCount: myAllFeedController.isAllDataLoaded.value ? myAllFeedController.myAllFeedList.length + 1 : myAllFeedController.myAllFeedList.length,
            physics: const ClampingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              if (index == myAllFeedController.myAllFeedList.length) {
                Future.delayed(
                  const Duration(milliseconds: 100),
                      () async {
                    await _handleLoadMoreList();
                  },
                );
                return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
              }
              var myFeedData = myAllFeedController.myAllFeedList[index].obs;
              return Column(
                children: [
                  FeedPostAdapter(feedData: myFeedData.value,
                      isUserProfileOpen: false,
                      screenRoutes: () async {
                        var callBackData = await Get.to(
                            FeedDetailScreen(
                              feedId: myFeedData.value.feedId ?? 0,
                            ),
                            binding: FeedDetailBinding());
                        if (callBackData != null && callBackData != true) {
                          myFeedData.value = callBackData;
                          myAllFeedController.update();
                        } else if (callBackData == true) {
                          myAllFeedController.myAllFeedList.removeAt(index);
                          myAllFeedController.update();
                        }
                      },
                      commentButton: () async {
                        var callBackData = await Get.to(
                            FeedDetailScreen(
                              feedId: myFeedData.value.feedId ?? 0,
                            ),
                            binding: FeedDetailBinding());
                        if (callBackData != null && callBackData != true) {
                          myFeedData.value = callBackData;
                          myAllFeedController.update();
                        } else if (callBackData == true) {
                          myAllFeedController.myAllFeedList.removeAt(index);
                          myAllFeedController.update();
                        }
                      },
                      pageController: myAllFeedController.pageController,
                      threeDotTap: () {
                        CommonUtils.showMyBottomSheet(
                          context,
                          arrButton: [AppStrings.sendPost,AppStrings.deletePost,],
                          callback: (btnIndex) async {
                            if (btnIndex == 0) {
                              SendFunsctionality.sendBottomSheet(  feedId:  myFeedData.value.feedId, context: context,headingText: AppStrings.sendPost);

                            }else if(btnIndex == 1){
                              var deleteApi = await CommonApiFunction.feedDeleteApi(
                                  onErr: (msg) {
                                    SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                  },
                                  onSuccess: (msg) {
                                    SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                                  },
                                  feedId: myFeedData.value.feedId);
                              if (deleteApi) {
                                myAllFeedController.myAllFeedList.removeAt(index);
                                if (myAllFeedController.myAllFeedList.isEmpty) {
                                  myAllFeedController.pageToShow.value = 1;
                                  myAllFeedController.totalRecord.value = 0;
                                  myAllFeedController.isAllDataLoaded.value = false;
                                  myAllFeedController.isLoadMore = myAllFeedController.isAllDataLoaded.value;
                                  myAllFeedController.myFeedApiCall(pageToShow: myAllFeedController.pageToShow.value);
                                }
                              }
                            }
                          },
                        );
                      },
                      onPostImageTap: (value) async {
                        var callBack = await Get.to(PhotoVideoScreen(), arguments: [myFeedData.value, value]);
                        if (callBack != null && callBack != true) {
                          myFeedData.value = callBack;
                        } else if (callBack == true) {
                          myAllFeedController.myAllFeedList.removeAt(index);
                          myAllFeedController.update();
                        }
                        Logger().i(value);
                      },),
                ],
              );
              /*Obx(
                  () => FeedPostWidget(
                  userProfilePage: () {},
                  profileImageUrl: myFeedData.value.user?.profileImg ?? '',
                  fName: myFeedData.value.user?.firstName ?? '',
                  lName: myFeedData.value.user?.lastName ?? '',
                  companyName: myFeedData.value.user?.companyName ?? '',
                  timeAgo: myFeedData.value.getHoursAgo,
                  postContent: myFeedData.value.description ?? '',
                  screenRoutes: () async {
                    var callBackData = await Get.to(
                        FeedDetailScreen(
                          feedId: myFeedData.value.feedId ?? 0,
                        ),
                        binding: FeedDetailBinding());
                    if (callBackData != null && callBackData != true) {
                      myFeedData.value = callBackData;
                      myAllFeedController.update();
                    } else if (callBackData == true) {
                      myAllFeedController.myAllFeedList.removeAt(index);
                      myAllFeedController.update();
                    }
                  },
                  onThreeDotTap: () {
                    CommonUtils.showMyBottomSheet(
                      context,
                      arrButton: [AppStrings.deletePost],
                      callback: (btnIndex) async {
                        if (btnIndex == 0) {
                          var deleteApi = await CommonApiFunction.feedDeleteApi(
                              onErr: (msg) {
                                SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                              },
                              onSuccess: (msg) {
                                SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                              },
                              feedId: myFeedData.value.feedId);
                          if (deleteApi) {
                            myAllFeedController.myAllFeedList.removeAt(index);
                            if (myAllFeedController.myAllFeedList.length == 0) {
                              myAllFeedController.pageToShow.value = 1;
                              myAllFeedController.totalRecord.value = 0;
                              myAllFeedController.isAllDataLoaded.value = false;
                              myAllFeedController.isLoadMore = myAllFeedController.isAllDataLoaded.value;
                              myAllFeedController.myFeedApiCall(pageToShow: myAllFeedController.pageToShow.value);
                            }
                          }
                        }
                      },
                    );
                  },
                  isUserConnected: myFeedData.value.user?.isConnected ?? AppStrings.notConnected.obs,
                  */ /*connectText: myFeedData.value.user?.isConnected.value == 'NotConnected' ? 'Connect' : 'Requested',
                connectIcon: myFeedData.value.user?.isConnected.value == 'NotConnected' ? AppImages.plus : AppImages.check,*/ /*
                  onConnectButtonPress: () async {},
                  isExpandText: myFeedData.value.showMore,
                  postImages: myFeedData.value.feedMedia ?? [],
                  pageController: myAllFeedController.pageController,
                  onPostImageTap: (value) async {
                    var callBack = await Get.to(PhotoVideoScreen(), arguments: [myFeedData.value, value]);
                    if (callBack != null && callBack != true) {
                      myFeedData.value = callBack;
                    } else if (callBack == true) {
                      myAllFeedController.myAllFeedList.removeAt(index);
                      myAllFeedController.update();
                    }
                    Logger().i(value);
                  },
                  likeCounts: myFeedData.value.likesCounters.value,
                  commentCounts: myFeedData.value.comment ?? 0,
                  onLikeButtonPressed: () async {
                    handleLikeButtonTap(index: index);
                  },
                  likedIcon: myFeedData.value.isLikeFeed.value == true ? AppImages.dollarFill : AppImages.dollar,
                  onCommentButtonPressed: () async {
                    var callBackData = await Get.to(
                        FeedDetailScreen(
                          feedId: myFeedData.value.feedId ?? 0,
                        ),
                        binding: FeedDetailBinding());
                    if (callBackData != null && callBackData != true) {
                      myFeedData.value = callBackData;
                      myAllFeedController.update();
                    } else if (callBackData == true) {
                      myAllFeedController.myAllFeedList.removeAt(index);
                      myAllFeedController.update();
                    }
                  },
                  onSendButtonPressed: () {
                    SendFunsctionality.sendBottomSheet(feedId: myFeedData.value.feedId ?? 0, context: context);
                  },
                  isShareIconVisible: false.obs,
                  isUserMe: CommonUtils.isUserMe(id: myFeedData.value.user?.userId ?? 0),
                  isUserVerify: myFeedData.value.user?.isVerified ?? false),
            );*/
            },
          ),
    );
  }

  ///Like button handle function
  handleLikeButtonTap({required int index}) async {
    var myFeed = myAllFeedController.myAllFeedList[index];
    if (myFeed.isLikeFeed.value == false) {
      var likeResponse = await CommonApiFunction.likePostApi(
        feedId: myFeed.feedId ?? 0,
        onSuccess: (value) {
          myFeed.likesCounters.value = value;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
        },
      );
      if (likeResponse) {
        myFeed.isLikeFeed.value = true;
      }
    } else {
      var likeResponse = await CommonApiFunction.unlikePostApi(
        feedId: myFeed.feedId ?? 0,
        onSuccess: (value) {
          myFeed.likesCounters.value = value;
        },
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
        },
      );
      if (likeResponse) {
        myFeed.isLikeFeed.value = false;
      }
    }
  }

  Future _handleLoadMoreList() async {
    if (!myAllFeedController.isAllDataLoaded.value) return;
    if (myAllFeedController.isLoadMoreRunningForViewAllCategory) return;
    myAllFeedController.isLoadMoreRunningForViewAllCategory = true;
    await myAllFeedController.feedPagination();
  }
}
