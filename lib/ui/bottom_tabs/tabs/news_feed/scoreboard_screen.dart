import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/scoreboard_controller.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../utils/app_common_stuffs/app_images.dart';
import '../../../../utils/app_common_stuffs/screen_routes.dart';
import '../../../style/appbar_components.dart';
import '../../../style/image_components.dart';
import '../../../style/text_style.dart';
import 'funder_broker_sorting.dart';

class ScoreBoard extends StatefulWidget {
  const ScoreBoard({Key? key}) : super(key: key);

  @override
  State<ScoreBoard> createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> with AutomaticKeepAliveClientMixin<ScoreBoard>, TickerProviderStateMixin {
  ScoreBoardController scoreBoardController = Get.find<ScoreBoardController>();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowLoaderDialog.showLoaderDialog(context);
      scoreBoardController.fetchLoanList(page: scoreBoardController.pageToShow.value, userType: 'FU', isShowLoader: true);
    });
    super.initState();
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
    return AppBarComponents.appBar(
      leadingWidget: IconButton(
        onPressed: () => Get.until((route) => route.settings.name == ScreenRoutesConstants.bottomTabsScreen),
        icon: ImageComponent.loadLocalImage(
          imageName: AppImages.arrow,
        ),
      ),
      centerTitle: true,
      titleWidget: Text(
        AppStrings.scoreBoard,
        style: ISOTextStyles.openSenseSemiBold(
          size: 17,
          color: AppColors.headingTitleColor,
        ),
      ),
      actionWidgets: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed(ScreenRoutesConstants.filterScoreboardLoanScreen);
              },
              child: ImageComponent.loadLocalImage(imageName: AppImages.filterFill, height: 28.w, width: 28.w, boxFit: BoxFit.contain),
            ),
            8.sizedBoxW,
            GestureDetector(
              onTap: () {
                Get.toNamed(ScreenRoutesConstants.loanApprovalScreen);
              },
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.greyColor,
                child: ImageComponent.loadLocalImage(imageName: AppImages.clockOutline, height: 18.w, width: 18.w, boxFit: BoxFit.contain, imageColor: AppColors.blackColor),
              ),
            ),
            8.sizedBoxW,
            GestureDetector(
              onTap: () async {
                var isSucess = await Get.toNamed(ScreenRoutesConstants.createScoreBoardScreen);
                if (isSucess) {
                  scoreBoardController.loanList.clear();
                  scoreBoardController.pageToShow.value = 1;
                  scoreBoardController.totalRecord.value = 0;
                  scoreBoardController.isAllDataLoaded.value = false;
                  userSingleton.userType == 'FU' ? scoreBoardController.currentPageIndex.value = 0 : scoreBoardController.currentPageIndex.value = 1;
                  scoreBoardController.fetchLoanList(page: scoreBoardController.pageToShow.value, userType: userSingleton.userType == 'FU' ? 'FU' : 'BR');
                }
              },
              child: ImageComponent.loadLocalImage(imageName: AppImages.plusFill, height: 28.w, width: 28.w, boxFit: BoxFit.contain),
            ),
          ],
        ),
        10.sizedBoxW,
      ],
    );
  }

  /// Main Body Widget
  Widget buildBody() {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          scoreBoardController.loanList.clear();
          scoreBoardController.pageToShow.value = 1;
          scoreBoardController.totalRecord.value = 0;
          scoreBoardController.isAllDataLoaded.value = false;

          scoreBoardController.forumFilter.value = scoreBoardController.currentPageIndex.value == 0 ? "FU" : "BR";
          await scoreBoardController.fetchLoanList(page: scoreBoardController.pageToShow.value, userType: scoreBoardController.forumFilter.value);
        },
        child: Column(
          children: [
            tabBody(),
            sortBy(),
            Expanded(child: scoreboardList2()),
          ],
        ),
      ),
    );
  }

  /// Filter Tab
  Widget tabBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Container(
          padding: EdgeInsets.only(left: 16.0.w, right: 16.0.w, bottom: 8.0.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Wrap(
                spacing: 20,
                children: [
                  ...List.generate(scoreBoardController.tabFilterList.length, (index) {
                    return GestureDetector(
                      onTap: () async {
                        ShowLoaderDialog.showLoaderDialog(context);
                        scoreBoardController.loanList.clear();
                        scoreBoardController.pageToShow.value = 1;
                        scoreBoardController.isAllDataLoaded.value = false;
                        scoreBoardController.currentPageIndex.value = index;
                        scoreBoardController.forumFilter.value = scoreBoardController.tabFilterList[index].apiFilterName ?? '';

                        await scoreBoardController.fetchLoanList(page: scoreBoardController.pageToShow.value, userType: scoreBoardController.forumFilter.value, isShowLoader: true);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.symmetric(vertical: 5.0.h, horizontal: 40.0.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0.r),
                          color: scoreBoardController.currentPageIndex.value == index ? AppColors.primaryColor : AppColors.greyColor,
                        ),
                        child: Text(
                          scoreBoardController.tabFilterList[index].tabName ?? '',
                          style: scoreBoardController.currentPageIndex.value == index
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

  /// SortBy Widget
  Widget sortBy() {
    return GestureDetector(
      onTap: () {
        Get.to(const FunderBrokerSorting());
      },
      child: Column(
        children: [
          const Divider(
            height: 2,
            color: AppColors.dividerColor,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.0.w),
            child: Obx(
              () => Row(
                children: [
                  Text(
                    scoreBoardController.scoreSortingData.value,
                    style: ISOTextStyles.openSenseBold(
                      color: AppColors.blackColor,
                      size: 18,
                    ),
                  ),
                  10.sizedBoxW,
                  ImageComponent.loadLocalImage(imageName: AppImages.downArrow)
                ],
              ),
            ),
          ),
          const Divider(
            height: 2,
            color: AppColors.dividerColor,
          ),
        ],
      ),
    );
  }

  /// Scoreboard Funder Broker List
  Widget scoreboardList() {
    return Obx(() => scoreBoardController.loanList.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: scoreBoardController.loanList.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index < scoreBoardController.loanList.length) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 20.0.w),
                  height: 90.0.h,
                  color: AppColors.whiteColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryColor, // Set border width
                                      borderRadius: BorderRadius.all(Radius.circular(50.0)), // Set rounded corner radius
                                    ),
                                    child: Text(
                                      '${index + 1}',
                                      style: ISOTextStyles.openSenseSemiBold(
                                        color: AppColors.whiteColor,
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                  7.sizedBoxW,
                                  // Text(
                                  //   '${scoreBoardController.loanList[index].loanAmount ?? 0}',
                                  //   style: ISOTextStyles.openSenseSemiBold(
                                  //     size: 20,
                                  //   ),
                                  // ),
                                  formatNumber('${scoreBoardController.loanList[index].loanAmount ?? 0}'),
                                ],
                              ),
                            ),
                          ),
                          ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      ImageComponent.circleNetworkImage(
                                        imageUrl: scoreBoardController.loanList[index].createdByUser?.profileImg ?? '',
                                        height: 19.w,
                                        width: 19.w,
                                      ),
                                      /*CircleAvatar(
                                        radius: 11.0.r,
                                        backgroundImage: CachedNetworkImageProvider(
                                          scoreBoardController.loanList[index].createdByUser?.profileImg ?? '',
                                        ),
                                      ),*/
                                      Visibility(
                                        visible: scoreBoardController.loanList[index].createdByUser?.isVerified == true,
                                        child: Positioned(
                                          top: 16,
                                          left: 16,
                                          child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, height: 10.h, width: 10.w, boxFit: BoxFit.contain),
                                        ),
                                      ),
                                      Positioned(
                                        top: 2,
                                        left: 2,
                                        child: ImageComponent.loadLocalImage(
                                            imageName: scoreBoardController.loanList[index].createdByUser?.userType == AppStrings.fu ? AppImages.funderBadge : AppImages.brokerBadge,
                                            height: 10.w,
                                            width: 10.w,
                                            boxFit: BoxFit.contain),
                                      ),
                                    ],
                                  ),
                                  14.sizedBoxW,
                                  Text(
                                    '${scoreBoardController.loanList[index].createdByUser?.firstName ?? ''} ${scoreBoardController.loanList[index].createdByUser?.lastName ?? ''}',
                                    style: ISOTextStyles.openSenseRegular(
                                      size: 12,
                                    ),
                                  ),
                                  20.sizedBoxW,
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          //physics: const NeverScrollableScrollPhysics(),
                          itemCount: scoreBoardController.loanList[index].selectedTags?.length,
                          itemBuilder: (BuildContext context, int subIndex) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 7.0),
                              child: Row(
                                children: [
                                  Container(
                                      height: 22.h,
                                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: AppColors.greyColor, // Set border width
                                        borderRadius: BorderRadius.all(Radius.circular(4.0)), // Set rounded corner radius
                                      ),
                                      child: Text(
                                        scoreBoardController.loanList[index].selectedTags?[subIndex] ?? '',
                                        style: ISOTextStyles.openSenseRegular(
                                          size: 12,
                                        ),
                                      )),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const Divider(
                        color: AppColors.dividerColor,
                        height: 2,
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          )
        : Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height / 1.5,
            child: Text(
              "No Scoreboard Available.",
              style: ISOTextStyles.openSenseSemiBold(size: 16),
            ),
          ));
  }

  /// Scoreboard Funder Broker List
  Widget scoreboardList2() {
    return CustomScrollView(
      slivers: [
        Obx(
          () => (scoreBoardController.loanList.isEmpty)
              ? SliverFillRemaining(
                  child: Center(
                    child: Text(
                      AppStrings.noScoreboardAvailable,
                      style: ISOTextStyles.openSenseSemiBold(size: 16),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.only(top: 0),
                  sliver: SliverSafeArea(
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                          addAutomaticKeepAlives: true,
                          childCount: scoreBoardController.isAllDataLoaded.value ? scoreBoardController.loanList.length + 1 : scoreBoardController.loanList.length, (context, index) {
                        if (index == scoreBoardController.loanList.length) {
                          Future.delayed(
                            const Duration(milliseconds: 100),
                            () async {
                              await _handleLoadMoreList();
                            },
                          );
                          return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
                        }
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 12.0.h, horizontal: 20.0.w),
                          height: 90.0.h,
                          color: AppColors.whiteColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Obx(
                                      () => Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                            decoration: const BoxDecoration(
                                              color: AppColors.scoreboardNumColor,
                                              // Set border width
                                              borderRadius: BorderRadius.all(Radius.circular(50.0)), // Set rounded corner radius
                                            ),
                                            child: Text(
                                              '${index + 1}',
                                              style: ISOTextStyles.openSenseSemiBold(
                                                color: AppColors.whiteColor,
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                          7.sizedBoxW,
                                          formatNumber('${scoreBoardController.loanList[index].loanAmount ?? 0}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  scoreBoardController.loanList[index].createByCompanyOwner == true
                                      ? Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(5.0),
                                              child: ImageComponent.circleNetworkImage(
                                                imageUrl: scoreBoardController.loanList[index].createdByUser?.companyImage ?? '',
                                                placeHolderImage: AppImages.backGroundDefaultImage,
                                                height: 19.w,
                                                width: 19.w,
                                              ),
                                            ),
                                            8.sizedBoxW,
                                            Container(
                                              constraints:  BoxConstraints(
                                                minWidth: 100.w,
                                                maxWidth: 100.w,
                                              ),
                                              child: Text(
                                                '${scoreBoardController.loanList[index].createdByUser?.companyName ?? ''}  ',
                                                style: ISOTextStyles.openSenseRegular(
                                                  size: 12,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          /*mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,*/
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: ImageComponent.circleNetworkImage(
                                                    imageUrl: scoreBoardController.loanList[index].createdByUser?.profileImg ?? '',
                                                    height: 19.w,
                                                    width: 19.w,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: scoreBoardController.loanList[index].createdByUser?.isVerified == true,
                                                  child: Positioned(
                                                    bottom: 5.h,
                                                    right: 5.w,
                                                    child: ImageComponent.loadLocalImage(imageName: AppImages.verifyLogo, height: 5.h, width: 5.w),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: scoreBoardController.loanList[index].createdByUser?.userType != null,
                                                  child: Positioned(
                                                    top: 3.h,
                                                    left: 2.w,
                                                    child: ImageComponent.loadLocalImage(
                                                        imageName: scoreBoardController.loanList[index].createdByUser?.userType == AppStrings.fu ? AppImages.funderBadge : AppImages.brokerBadge,
                                                        height: 8.h,
                                                        width: 8.w,
                                                        boxFit: BoxFit.contain),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            8.sizedBoxW,
                                            Container(
                                              constraints:  BoxConstraints(
                                                minWidth: 100.w,
                                                maxWidth: 100.w,
                                              ),
                                              child: Text(
                                                '${scoreBoardController.loanList[index].createdByUser?.firstName ?? ''} ${scoreBoardController.loanList[index].createdByUser?.lastName ?? ''}',
                                                style: ISOTextStyles.openSenseRegular(
                                                  size: 12,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        )
                                ],
                              ),
                              Expanded(
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  //physics: const NeverScrollableScrollPhysics(),
                                  itemCount: scoreBoardController.loanList[index].selectedTags?.length,
                                  itemBuilder: (BuildContext context, int subIndex) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 7.0),
                                      child: Row(
                                        children: [
                                          Container(
                                              height: 22.h,
                                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                color: AppColors.greyColor, // Set border width
                                                borderRadius: BorderRadius.all(Radius.circular(4.0)), // Set rounded corner radius
                                              ),
                                              child: Text(
                                                scoreBoardController.loanList[index].selectedTags?[subIndex] ?? '',
                                                style: ISOTextStyles.openSenseRegular(
                                                  size: 12,
                                                ),
                                              )),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const Divider(
                                color: AppColors.dividerColor,
                                height: 2,
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
        )
      ],
    );
  }

  Future _handleLoadMoreList() async {
    if (!scoreBoardController.isAllDataLoaded.value) return;
    if (scoreBoardController.isLoadMoreRunningForViewAll) return;
    scoreBoardController.isLoadMoreRunningForViewAll = true;
    await scoreBoardController.scoreBoardPagination();
  }

  /// Number Formatter
  formatNumber(String myNumber) {
    // Convert number into a string if it was not a string previously
    String stringNumber = myNumber.toString();

    // Convert number into double to be formatted.
    // Default to zero if unable to do so
    double doubleNumber = double.tryParse(stringNumber) ?? 0;

    // Set number format to use
    NumberFormat numberFormat = NumberFormat.compactCurrency(locale: "en_US", symbol: '\$', name: 'NGN');

    return Text(
      numberFormat.format(doubleNumber),
      style: ISOTextStyles.sfProTextMedium(size: 16),
    );
  }
}
