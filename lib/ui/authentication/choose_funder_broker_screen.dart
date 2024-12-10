import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/authentication/choose_funder_broker_controller.dart';
import 'package:iso_net/ui/style/container_components.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';

import '../../utils/app_common_stuffs/app_colors.dart';
import '../../utils/app_common_stuffs/commom_utils.dart';
import '../../utils/app_common_stuffs/strings_constants.dart';
import '../style/appbar_components.dart';
import '../style/image_components.dart';
import '../style/text_style.dart';

class ChooseFunderBrokerScreen extends StatefulWidget {
  const ChooseFunderBrokerScreen({Key? key}) : super(key: key);

  @override
  State<ChooseFunderBrokerScreen> createState() => _ChooseFunderBrokerScreenState();
}

class _ChooseFunderBrokerScreenState extends State<ChooseFunderBrokerScreen> {
  FunderBrokerController funderBrokerController = Get.find<FunderBrokerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBody(),
      body: buildBody(),
    );
  }

  ///AppBar Widget
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
      leadingWidget: IconButton(
        onPressed: () => Get.back(),
        icon: ImageComponent.loadLocalImage(imageName: AppImages.x, height: 14.w, width: 14.w, boxFit: BoxFit.contain),
      ),
    );
  }

  ///Scaffold Body Widget
  Widget buildBody() {
    return SafeArea(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headingBody(),
        funderBrokerCardBody(),
      ],
    ));
  }

  ///Top title/heading
  Widget headingBody() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0.h, horizontal: 16.0.w),
      child: CommonUtils.headingLabelBody(
        headingText: AppStrings.describesYou,
      ),
    );
  }

  ///Funder & Broker Card
  Widget funderBrokerCardBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0.w),
      child: Wrap(
        runSpacing: 28,
        children: [
          ...List.generate(
            funderBrokerController.funderBrokerCardList.length,
            (index) {
              return ContainerComponents.elevatedContainer(
                onTap: () {
                 handleOnFunderBrokerCardTap(listIndex: index);
                },
                height: 90.0.h,
                backGroundColor: AppColors.whiteColor,
                borderRadius: 12.0.r,
                alignment: Alignment.center,
                context: context,
                child: Text(
                  funderBrokerController.funderBrokerCardList[index].name ?? '',
                  style: ISOTextStyles.openSenseBold(size: 20, color: AppColors.headingTitleColor),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  handleOnFunderBrokerCardTap({required listIndex}){
    Get.toNamed(ScreenRoutesConstants.getStartedScreen, arguments: funderBrokerController.funderBrokerCardList[listIndex].alias);
  }
}
