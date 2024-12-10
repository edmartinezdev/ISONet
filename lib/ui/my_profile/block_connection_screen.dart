import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/my_profile/block_connection_controller.dart';
import 'package:iso_net/ui/style/dialog_components.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/showloader_component.dart';
import 'package:iso_net/utils/app_common_stuffs/common_api_function.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../utils/app_common_stuffs/app_colors.dart';
import '../../utils/app_common_stuffs/strings_constants.dart';
import '../style/appbar_components.dart';
import '../style/text_style.dart';

class BlockConnectionScreen extends StatefulWidget {
  const BlockConnectionScreen({Key? key}) : super(key: key);

  @override
  State<BlockConnectionScreen> createState() => _BlockConnectionScreenState();
}

class _BlockConnectionScreenState extends State<BlockConnectionScreen> {
  BlockConnectionController blockConnectionController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowLoaderDialog.showLoaderDialog(context);
      blockConnectionController.apiCallBlockUserList(isShowLoader: true);
    });
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
      titleWidget: Text(
        AppStrings.blockConnection,
        style: ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.headingTitleColor),
      ),
      centerTitle: true,
    );
  }

  ///Scaffold Body
  Widget buildBody() {
    return Obx(
      () => (blockConnectionController.blockUserList.isEmpty && blockConnectionController.isApiResponseReceive.value)? Center(
        child: Text(
          AppStrings.noBlockConnection,
          style: ISOTextStyles.openSenseSemiBold(size: 16),
        ),
      ):ListView.builder(
        itemCount: blockConnectionController.blockUserList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ImageComponent.circleNetworkImage(
                      imageUrl: blockConnectionController.blockUserList[index].profileImg ?? '',
                      height: 36.w,
                      width: 36.w,
                    ),
                    14.sizedBoxW,
                    Text(
                      '${blockConnectionController.blockUserList[index].firstName ?? ''} ${blockConnectionController.blockUserList[index].lastName ?? ''}',
                      style: ISOTextStyles.openSenseSemiBold(size: 16),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: (){
                    handleUnblockUserEvent(index: index);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 4.0.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(4.0.r),
                    ),
                    child: Text(
                      AppStrings.unblock,
                      style: ISOTextStyles.openSenseSemiBold(size: 14),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  handleUnblockUserEvent({required index}) {
    var blockUserData = blockConnectionController.blockUserList[index];
    DialogComponent.showAlert(
      context,
      title: AppStrings.appName,
      message: '${AppStrings.unBlockMessage} ${blockUserData.firstName ?? ''} ${blockUserData.lastName ?? ''}?',
      arrButton: [
        AppStrings.cancel,
        AppStrings.unblock,
      ],
      callback: (btnIndex){
        if (btnIndex == 1){
          CommonApiFunction.unBlockUser(onErr: (msg){
           SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
          }, onSuccess: (msg){

            SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: msg);
            blockConnectionController.blockUserList.removeAt(index);
          }, userId: blockUserData.userId ?? -1);
        }

      },
      barrierDismissible: true,
    );
  }
}
