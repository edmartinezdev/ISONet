import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/search/search_tab_controller.dart';
import 'package:iso_net/model/bottom_navigation_models/news_feed_models/feed_list_model.dart';
import 'package:iso_net/ui/bottom_tabs/tabs/search/search_adaptor.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../bindings/bottom_tabs/feed_detail_binding.dart';
import '../../../bindings/bottom_tabs/forum_detail_binding.dart';
import '../../../bindings/bottom_tabs/user_binding/user_profile_binding.dart';
import '../../../model/bottom_navigation_models/search_model/global_search_model.dart';
import '../../../singelton_class/auth_singelton.dart';
import '../../../utils/app_common_stuffs/app_colors.dart';
import '../../../utils/app_common_stuffs/app_images.dart';
import '../../../utils/app_common_stuffs/app_logger.dart';
import '../../../utils/app_common_stuffs/common_api_function.dart';
import '../../../utils/app_common_stuffs/screen_routes.dart';
import '../../../utils/app_common_stuffs/send_functionality.dart';
import '../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../utils/app_common_stuffs/strings_constants.dart';
import '../../common_ui/forum_common_ui/forum_image_video_screen.dart';
import '../../common_ui/forum_common_ui/forum_post_widget.dart';
import '../../common_ui/view_photo_video_screen.dart';
import '../../style/button_components.dart';
import '../../style/image_components.dart';
import '../../style/text_style.dart';
import '../tabs/forum/forum_detail_screen.dart';
import '../tabs/news_feed/article_adaptor/article_adaptor.dart';
import '../tabs/news_feed/feed_detail_screen.dart';
import '../tabs/news_feed/feed_post_adapter/feed_post_adaptor.dart';
import '../tabs/news_feed/user_screens/user_profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with AutomaticKeepAliveClientMixin<SearchScreen> {
  SearchController searchController = Get.find();
  TextEditingController searchTextController = TextEditingController();
  FocusNode focusNode = FocusNode();
  ScrollController scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

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

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: CupertinoSearchTextField(
        controller: searchTextController,
        focusNode: focusNode,
        onTap: () {},
        prefixIcon: Icon(
          CupertinoIcons.search,
          color: AppColors.scoreboardNumColor,
          size: 17.sp,
        ),
        onChanged: (value) {
          _onSearchChanged(value);
        },
        onSuffixTap: () async {
          searchController.searchListController.clear();
          searchController.searchPostFormList.clear();
          searchTextController.clear();
          searchController.searchText.value = '';
          searchController.isAllDataLoaded.value = false;
          searchController.isSearching.value = true;
          searchController.isDataLoaded.value = true;

          searchController.userType.value = searchController.filterSearchList[searchController.currentTabIndex.value].apiSearchParam ?? '';
          focusNode.unfocus();

          await searchController.searchApiCall(isShowLoader: false);
        },
        onSubmitted: (value) {
          focusNode.unfocus();
        },
      ),
      centerTitle: false,
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

  ///Handle on search function
  _onSearchChanged(String query) {
    searchController.isFilterEnable.value = false;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      searchController.searchText.value = query;
      searchController.pageToShow.value = 1;
      searchController.isAllDataLoaded.value = false;
      searchController.isLoadMoreRunningForViewAll = false;
      //searchController.isDataLoaded.value = false;
      searchController.totalRecords.value = 0;
      searchController.searchPostFormList.clear();
      searchController.isSearching.value = true;
      //ShowLoaderDialog.showLoaderDialog(context);
      await searchController.searchApiCall(isShowLoader: false);
    });
  }

  Widget buildBody() {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          tabBody(),
          Visibility(visible: searchController.isFilterEnable.value == true, child: searchIconTextWidget()),
          searchController.isFilterEnable.value == true
              ? Container()
              : Expanded(
                  child: feedForumArticleWidget(),
                ),
        ],
      ),
    );
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
            AppStrings.searchScreenMessage,
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

  /// Filter Tab
  Widget tabBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      child: Obx(
        () => Container(
          padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w, bottom: 8.0.h, top: 8.0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Wrap(
                spacing: 20,
                children: [
                  ...List.generate(searchController.filterSearchList.length, (index) {
                    return GestureDetector(
                      onTap: () async {
                        if (searchController.isSearching.value) {
                          return;
                        } else {
                          /*ShowLoaderDialog.showLoaderDialog(context);*/
                          searchController.searchListController.clear();
                          searchController.searchPostFormList.clear();
                          searchController.isAllDataLoaded.value = false;
                          searchController.isSearching.value = true;
                          searchController.isDataLoaded.value = true;
                          searchController.currentTabIndex.value = index;
                          searchController.userType.value = searchController.filterSearchList[index].apiSearchParam ?? '';
                          focusNode.unfocus();
                          if (index == 1 || index == 2 || index == 3) {
                            searchController.isFilterEnable.value = false;
                          }

                          await searchController.searchApiCall(isShowLoader: false);
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(vertical: 5.0.h, horizontal: 16.0.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.0.r),
                          color: searchController.currentTabIndex.value == index ? AppColors.primaryColor : AppColors.greyColor,
                        ),
                        child: Text(
                          searchController.filterSearchList[index].search ?? '',
                          style: searchController.currentTabIndex.value == index
                              ? ISOTextStyles.openSenseSemiBold(size: 16, color: AppColors.headingTitleColor)
                              : ISOTextStyles.openSenseRegular(size: 16, color: AppColors.headingTitleColor),
                        ),
                      ),
                    );
                  }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget feedForumArticleWidget() {
    return Obx(
      () => searchController.isSearching.value
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            )
          : searchController.isDataLoaded.value == false
              ? Center(
                  child: Text(
                    AppStrings.noRecordFound,
                    style: ISOTextStyles.openSenseSemiBold(size: 16),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(top: 4.0.h),
                  child: ListView.builder(
                    controller: searchController.scrollController,
                    addAutomaticKeepAlives: true,
                    itemCount: searchController.isAllDataLoaded.value ? searchController.searchPostFormList.length + 1 : searchController.searchPostFormList.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == searchController.searchPostFormList.length) {
                        Future.delayed(
                          const Duration(milliseconds: 100),
                          () async {
                            await _handleLoadMoreList();
                          },
                        );
                        return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
                      }

                      var searchPostData = searchController.searchPostFormList[index].obs;

                      if (searchPostData.value.feedType == 'Post' || searchPostData.value.feedType == 'Article' || searchPostData.value.feedData.value != null) {
                        return postArticleWidget(searchPostData, index);
                      } else if (searchPostData.value.feedType == 'Forum' || searchPostData.value.forumData.value != null) {
                        return Obx(
                          () => ForumPostWidget(
                            isAdmin: searchPostData.value.forumData.value?.user?.isAdmin,
                            userProfileImageUrl: searchPostData.value.forumData.value?.user?.profileImg ?? '',
                            userProfileImageTap: () async {
                              routeToOtherUserProfileScreen(
                                  userId: searchPostData.value.forumData.value?.user?.userId ?? -1,
                                  connectStatus: searchPostData.value.forumData.value?.user?.isConnected.value ?? AppStrings.notConnected,
                                  isAdmin: searchPostData.value.forumData.value?.user?.isAdmin ?? false);
                            },
                            fName: searchPostData.value.forumData.value?.user?.firstName ?? '',
                            lName: searchPostData.value.forumData.value?.user?.lastName ?? '',
                            userType: searchPostData.value.forumData.value?.user?.userType ?? '',
                            companyName: searchPostData.value.forumData.value?.user?.companyName ?? '',
                            forumPostTimeAgo: searchPostData.value.forumData.value?.getHoursAgo ?? '',
                            onThreeDotTap: () {
                              if (userSingleton.id == searchPostData.value.forumData.value?.user?.userId) {
                                CommonUtils.showMyBottomSheet(
                                  context,
                                  arrButton: [AppStrings.sendForum, AppStrings.deleteForum],
                                  callback: (btnIndex) async {
                                    if (btnIndex == 0) {
                                      SendFunsctionality.sendBottomSheet(forumId: searchPostData.value.forumData.value?.forumId, context: context, headingText: AppStrings.sendForum);
                                    } else if (btnIndex == 1) {
                                      var deleteApi = await CommonApiFunction.forumDeleteApi(
                                          onErr: (msg) {
                                            SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                          },
                                          onSuccess: (msg) {
                                            SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                                          },
                                          forumId: searchPostData.value.forumData.value?.forumId);
                                      if (deleteApi) {
                                        searchController.searchPostFormList.removeAt(index);
                                      }
                                    }
                                  },
                                );
                              } else {
                                CommonUtils.reportWidget(
                                  context: context,
                                  forumId: searchPostData.value.forumData.value?.forumId ?? 0,
                                  isReportForum: true,
                                  buttonText: [
                                    AppStrings.sendForum,
                                    AppStrings.reportForum,
                                    AppStrings.flagForum,
                                  ],
                                  reportTyp: AppStrings.forum,
                                );
                              }
                            },
                            isUserConnected: searchPostData.value.forumData.value?.user?.isConnected.value ?? 'NotConnected',
                            onConnectButtonPress: () async {
                              var apiResult = await CommonApiFunction.commonConnectApi(
                                  userId: searchPostData.value.forumData.value?.user?.userId ?? 0,
                                  onErr: (msg) {
                                    SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                                  });
                              if (apiResult) {
                                searchPostData.value.forumData.value?.user?.isConnected.value = 'Requested';
                              }
                            },
                            isUserMe: CommonUtils.isUserMe(id: searchPostData.value.forumData.value?.user?.userId ?? 0, isAdmin: searchPostData.value.forumData.value?.user?.isAdmin ?? false),
                            screenRoutes: () async {
                              var callBackData = await Get.to(
                                  ForumDetailScreen(
                                    forumId: searchPostData.value.forumData.value?.forumId ?? 0,
                                  ),
                                  binding: ForumDetailBinding());
                              if (callBackData != null && callBackData != true) {
                                searchPostData.value.forumData.value = callBackData;
                                searchController.update();
                              } else if (callBackData == true) {
                                searchController.searchPostFormList.removeAt(index);
                                searchController.update();
                              }
                            },
                            postContent: searchPostData.value.forumData.value?.description ?? '',
                            isExpandText: searchPostData.value.forumData.value?.showMore ?? false.obs,
                            postImages: searchPostData.value.forumData.value?.forumMedia ?? [],
                            pageController: searchController.pageController,
                            onPostImageTap: (value) async {
                              var callBack = await Get.to(ForumPhotoVideoView(), arguments: [searchPostData.value.forumData.value, value]);
                              if (callBack != null && callBack != true) {
                                searchPostData.value.forumData.value = callBack;
                                searchController.update();
                              } else {
                                searchController.searchPostFormList.removeAt(index);
                                searchController.update();
                              }
                            },
                            likeCounts: searchPostData.value.forumData.value?.likeCount.value ?? 0,
                            commentCounts: searchPostData.value.forumData.value?.commentCounter.value ?? 0,
                            onLikeButtonPressed: () {},
                            onUpArrowTap: () {
                              //TODO
                              searchController.handleUpArrowTap(index: index);
                            },
                            onDownArrowTap: () {
                              //TODO
                              searchController.handleDownArrowTap(index: index);
                            },
                            onSendButtonPress: () {
                              SendFunsctionality.sendBottomSheet(context: context, forumId: searchPostData.value.forumData.value?.forumId ?? 0);
                            },
                            onCommentButtonPressed: () async {
                              var callBackData = await Get.to(
                                ForumDetailScreen(
                                  forumId: searchPostData.value.forumData.value?.forumId ?? 0,
                                ),
                                binding: ForumDetailBinding(),
                              );
                              if (callBackData != null && callBackData != true) {
                                searchPostData.value.forumData.value = callBackData;
                                searchController.update();
                              } else if (callBackData == true) {
                                searchController.searchPostFormList.removeAt(index);
                                searchController.update();
                              }
                            },
                            isShareIconVisible: false.obs,
                            disLikeCount: searchPostData.value.forumData.value?.disLikeCount.value ?? 0,
                            forumCategoryName: searchPostData.value.forumData.value?.forumCategoryName ?? '',
                            isUserVerify: searchPostData.value.forumData.value?.user?.isVerified ?? false,
                            isLikeForum: searchPostData.value.forumData.value?.isLikeForum.value,
                            isUnlikeForum: searchPostData.value.forumData.value?.isUnlikeForum.value,
                            onTapCategoryName: () {
                              Get.toNamed(ScreenRoutesConstants.categoryForumListScreen,
                                  arguments: [searchPostData.value.forumData.value?.forumCategoryId ?? 0, searchPostData.value.forumData.value?.forumCategoryName ?? '']);
                            },
                          ),
                        );
                      } else if (searchPostData.value.feedType == null) {
                        if (searchController.searchPostFormList[index].globalSearchData?.isCompany == true) {
                          return SearchCompanyAdaptor(
                              companyProfileTapEvent: () {
                                handleCompanyProfileTap(index: index);
                              },
                              searchData: searchPostData.value);
                        } else {
                          return SearchBrokerFunderAdaptor(
                            searchData: searchPostData.value,
                            userProfileTapEvent: () {
                              handleUserProfileTap(index: index);
                            },
                          );
                        }
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
    );
  }

  Future _handleLoadMoreList() async {
    if (!searchController.isAllDataLoaded.value) return;
    if (searchController.isLoadMoreRunningForViewAll) return;
    searchController.isLoadMoreRunningForViewAll = true;
    await searchController.searchPagination();
  }

  ///Handle Company profile tap function
  handleCompanyProfileTap({required int index}) {
    CommonUtils.scopeUnFocus(context);
    Get.toNamed(ScreenRoutesConstants.companyProfileScreen, arguments: searchController.searchPostFormList[index].globalSearchData?.companyId ?? -1);
    Logger().i('Hii');
  }

  ///Handle User profile tap function
  handleUserProfileTap({required int index}) async {
    CommonUtils.scopeUnFocus(context);
    if (userSingleton.id == searchController.searchPostFormList[index].globalSearchData?.userId) {
      null;
    } else {
      Logger().i(searchController.searchPostFormList[index].globalSearchData?.userId);
      var callBack = await Get.to(
        UserProfileScreen(
          userId: searchController.searchPostFormList[index].globalSearchData?.userId,
        ),
        binding: UserProfileBinding(),
      );
      if (callBack != null && callBack != true) {
        searchController.searchPostFormList[index].globalSearchData?.isConnected.value = callBack;
        searchController.update();
      }
    }
  }

  /// ***** Post & Article Search widget *******///
  Widget postArticleWidget(Rx<GlobalForumFeedArticle> searchPostData, int index) {
    return searchPostData.value.feedType?.toLowerCase() == AppStrings.article
        ? ListView.builder(
            addAutomaticKeepAlives: true,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: searchPostData.value.feedData.value?.article?.length,
            itemBuilder: (BuildContext context, int subIndex) {
              /// ******* Article Adaptor ******///
              return ArticleAdaptor(
                model: searchPostData.value.feedData.value ?? FeedData(),
                articleMedia: searchPostData.value.feedData.value?.article![subIndex] ?? ArticleMedia(),
                isSearchScreenOpen: true,
              );
            },
          )
        :

        /// ******* Feed Adaptor ******///
        Obx(
            () => FeedPostAdapter(
              feedData: searchPostData.value.feedData.value ?? FeedData(),
              userProfileCallBack: () {
                routeToOtherUserProfileScreen(
                    userId: searchPostData.value.feedData.value?.user?.userId ?? -1,
                    connectStatus: searchPostData.value.feedData.value?.user?.isConnected.value ?? AppStrings.notConnected,
                    isAdmin: false);
              },
              screenRoutes: () async {
                var callBackData = await Get.to(
                    FeedDetailScreen(
                      feedId: searchPostData.value.feedData.value?.feedId ?? 0,
                    ),
                    binding: FeedDetailBinding());
                if (callBackData != null && callBackData != true) {
                  searchPostData.value.feedData.value = callBackData;

                  searchController.update();
                } else if (callBackData == true) {
                  searchController.searchPostFormList.removeAt(index);
                  searchController.update();
                }
              },
              commentButton: () async {
                var callBackData = await Get.to(
                    FeedDetailScreen(
                      feedId: searchPostData.value.feedData.value?.feedId ?? 0,
                    ),
                    binding: FeedDetailBinding());
                if (callBackData != null && callBackData != true) {
                  searchPostData.value.feedData.value = callBackData;
                  searchController.update();
                } else if (callBackData == true) {
                  searchController.searchPostFormList.removeAt(index);
                  searchController.update();
                }
                Logger().i(searchPostData.value);
                Logger().i(callBackData);
              },
              pageController: searchController.pageController,
              threeDotTap: () {
                handleThreeDotTapPost(index: index);
              },
              onPostImageTap: (value) async {
                var callBack = await Get.to(PhotoVideoScreen(), arguments: [searchPostData.value.feedData.value, value]);
                if (callBack != null && callBack != true) {
                  searchPostData.value.feedData.value = callBack;
                } else if (callBack == true) {
                  searchController.searchPostFormList.removeAt(index);
                  searchController.update();
                }
                Logger().i(value);
              },
            ),
          );
  }

  ///Handle event of  Report other user post & delete our own feed while tapping on three dot icon
  handleThreeDotTapPost({required int index}) {
    var model = searchController.searchPostFormList[index].obs;
    if (userSingleton.id == model.value.feedData.value?.user?.userId) {
      CommonUtils.showMyBottomSheet(
        context,
        arrButton: [
          AppStrings.sendPost,
          AppStrings.deletePost,
        ],
        callback: (btnIndex) async {
          if (btnIndex == 0) {
            SendFunsctionality.sendBottomSheet(feedId: model.value.feedData.value?.feedId ?? 0, context: context, headingText: AppStrings.sendPost);
          } else if (btnIndex == 1) {
            var deleteApi = await CommonApiFunction.feedDeleteApi(
                onErr: (msg) {
                  SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                },
                onSuccess: (msg) {
                  SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                },
                feedId: model.value.feedData.value?.feedId);
            if (deleteApi) {
              searchController.searchPostFormList.removeAt(index);
            }
          }
        },
      );
    } else {
      CommonUtils.reportWidget(
          feedId: model.value.feedData.value?.feedId ?? 0, context: context, buttonText: [AppStrings.sendPost, AppStrings.reportPost, AppStrings.flagPost], reportTyp: AppStrings.feed);
    }
  }

  ///Handle event of  Report other user forum & delete our own forum while tapping on three dot icon
  handleThreeDotTapForum({required int index}) {
    var forumData = searchController.searchPostFormList[index].forumData;
    if (userSingleton.id == forumData.value?.user?.userId) {
      CommonUtils.showMyBottomSheet(
        context,
        arrButton: [AppStrings.sendForum, AppStrings.deleteForum],
        callback: (btnIndex) async {
          if (btnIndex == 0) {
            SendFunsctionality.sendBottomSheet(forumId: forumData.value?.forumId, context: context, headingText: AppStrings.sendForum);
          } else if (btnIndex == 1) {
            var deleteApi = await CommonApiFunction.forumDeleteApi(
                onErr: (msg) {
                  SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
                },
                onSuccess: (msg) {
                  SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
                },
                forumId: forumData.value?.forumId);
            if (deleteApi) {
              searchController.searchPostFormList.removeAt(index);
            }
          }
        },
      );
    } else {
      CommonUtils.reportWidget(
        context: context,
        forumId: forumData.value?.forumId,
        isReportForum: true,
        buttonText: [
          AppStrings.sendForum,
          AppStrings.reportForum,
          AppStrings.flagForum,
        ],
        reportTyp: AppStrings.forum,
      );
    }
  }

  ///Route to see other user profile screen while tapping on user profile image tap feed post
  routeToOtherUserProfileScreen({required int userId, required String connectStatus, required isAdmin}) async {
    var isUserOrAdmin = CommonUtils.isUserMe(id: userId, isAdmin: isAdmin);
    if (isUserOrAdmin.value) {
      var callBackData = await Get.to(
        UserProfileScreen(
          userId: userId,
        ),
        binding: UserProfileBinding(),
      );
      if (callBackData != null && callBackData != true) {
        connectStatus = callBackData;
        searchController.update();
      }
    } else {
      Get.toNamed(ScreenRoutesConstants.myProfileScreen, arguments: userSingleton.id);
    }
  }
}
