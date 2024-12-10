import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/my_profile/my_allloanlist_controller.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../utils/app_common_stuffs/app_colors.dart';
import '../../utils/app_common_stuffs/commom_utils.dart';
import '../style/appbar_components.dart';

class MyAllLoanListScreen extends StatefulWidget {
  const MyAllLoanListScreen({Key? key}) : super(key: key);

  @override
  State<MyAllLoanListScreen> createState() => _MyAllLoanListScreenState();
}

class _MyAllLoanListScreenState extends State<MyAllLoanListScreen> {
  MyLoanListController myLoanListController = Get.find<MyLoanListController>();

  @override
  void initState() {
    myLoanListController.myLoanApiCall(pageToShow: myLoanListController.pageToShow.value);
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
    return AppBarComponents.appBar();
  }

  ///scaffold Body
  Widget buildBody() {
    return SafeArea(
      child: Obx(
        () => ListView.separated(
          itemCount: myLoanListController.isAllDataLoaded.value ? myLoanListController.myLoanList.length + 1 : myLoanListController.myLoanList.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == myLoanListController.myLoanList.length) {
              Future.delayed(
                const Duration(milliseconds: 100),
                    () async {
                  await _handleLoadMoreList();
                },
              );
              return Container(padding: EdgeInsets.symmetric(vertical: 16.0.h), alignment: Alignment.center, child: const CupertinoActivityIndicator());
            }
            var myLoanData = myLoanListController.myLoanList[index];
            return Container(
              padding: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 16.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CommonUtils.amountFormat(number: '${myLoanData.loanAmount}'),
                      ),
                      Text(myLoanData.getTagTime),
                    ],
                  ),
                  10.sizedBoxH,
                  SizedBox(
                    height: 30,
                    child: ListView.builder(
                      itemCount: myLoanData.selectedTags?.length ?? 0,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int subIndex) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                              decoration: BoxDecoration(
                                color: AppColors.greyColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(myLoanData.selectedTags?[subIndex] ?? '')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );

          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              color: AppColors.dividerColor,
            );
          },
        ),
      ),
    );
  }

  Future _handleLoadMoreList() async {
    if (!myLoanListController.isAllDataLoaded.value) return;
    if (myLoanListController.isLoadMoreRunningForViewAllCategory) return;
    myLoanListController.isLoadMoreRunningForViewAllCategory = true;
    await myLoanListController.loanListPagination();
  }
}
