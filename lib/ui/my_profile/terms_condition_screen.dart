import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/my_profile/terms_privacy_controller.dart';
import 'package:iso_net/ui/style/appbar_components.dart';



import '../../utils/app_common_stuffs/commom_utils.dart';
import '../../utils/app_common_stuffs/strings_constants.dart';

import '../style/showloader_component.dart';
import '../style/text_style.dart';

class TermsConditionScreen extends StatefulWidget {
  const TermsConditionScreen({Key? key}) : super(key: key);

  @override
  State<TermsConditionScreen> createState() => _TermsConditionScreenState();
}

class _TermsConditionScreenState extends State<TermsConditionScreen> {
  TermsPrivacyController termsPrivacyController = Get.find();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowLoaderDialog.showLoaderDialog(context);
    });
    termsPrivacyController.getTermsPrivacy();
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
        AppStrings.termsOfUseText,
        style: ISOTextStyles.openSenseSemiBold(size: 17),
      ),
      centerTitle: true,
    );
  }

  Widget buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          child: Obx(() => Html(data: termsPrivacyController.termsPrivacyText.value,onLinkTap: (url, _, __, ___) {
            CommonUtils.websiteLaunch(url ?? '');
          },)),
        ),
      ),
    );
  }
}
