import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iso_net/controllers/bottom_tabs/tabs/news_feed/company_controller/company_profile_controller.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../../../../utils/app_common_stuffs/app_colors.dart';
import '../../../../../utils/app_common_stuffs/snackbar_util.dart';
import '../../../../../utils/app_common_stuffs/strings_constants.dart';
import '../../../../../utils/app_common_stuffs/text_input_formatters.dart';
import '../../../../style/appbar_components.dart';
import '../../../../style/button_components.dart';
import '../../../../style/showloader_component.dart';
import '../../../../style/text_style.dart';
import '../../../../style/textfield_components.dart';

class LeaveReviewScreen extends StatefulWidget {
  const LeaveReviewScreen({Key? key}) : super(key: key);

  @override
  State<LeaveReviewScreen> createState() => _LeaveReviewScreenState();
}

class _LeaveReviewScreenState extends State<LeaveReviewScreen> {
  CompanyProfileController companyProfileController = Get.find<CompanyProfileController>();
  TextEditingController reviewController = TextEditingController();

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

  ///title-heading body
  Widget headingBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.leaveAReview,
          style: ISOTextStyles.openSenseBold(size: 20),
        ),
        4.sizedBoxH,
        Text(
          AppStrings.shareExp,
          style: ISOTextStyles.openSenseLight(color: AppColors.hintTextColor, size: 14),
        ),
      ],
    );
  }

  ///Scaffold Body
  Widget buildBody() {
    return CommonUtils.constrainedBody(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.0.h, horizontal: 16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headingBody(),
              14.sizedBoxH,
              bioTextFieldBody(),
            ],
          ),
        ),
        leaveReviewButtonBody(),
      ],
    );
  }

  ///Bio text Field
  Widget bioTextFieldBody() {
    return TextFieldComponents(
      textEditingController: reviewController,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.done,
      textInputFormatter: [
        NoLeadingSpaceFormatter(),
      ],
      maxLines: 16,
      context: context,
      hint: AppStrings.addReview,
      onChanged: (value) {
        companyProfileController.companyReview.value = value;
        if (companyProfileController.companyReview.value.isNotEmpty) {
          companyProfileController.isEnable.value = true;
        } else {
          companyProfileController.isEnable.value = false;
        }
        // companyProfileController.validateButton();
      },
    );
  }

  ///Leave a review button
  Widget leaveReviewButtonBody() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
        child: ButtonComponents.cupertinoButton(
          width: double.infinity,
          context: context,
          title: AppStrings.leaveReview,
          backgroundColor: companyProfileController.isEnable.value ? AppColors.primaryColor : AppColors.disableButtonColor,
          textStyle: companyProfileController.isEnable.value ? ISOTextStyles.openSenseSemiBold(size: 17,color: AppColors.blackColor) :ISOTextStyles.openSenseRegular(size: 17,color: AppColors.disableTextColor),
          onTap: () {
            nextButtonPress();
          },
        ),
      ),
    );
  }

  /// Function on next button will go here
  nextButtonPress() async {
    if (companyProfileController.companyReview.value.isEmpty || companyProfileController.isEnable.value == false) {
      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: AppStrings.reviewValidate);
    } else {
      ShowLoaderDialog.showLoaderDialog(context);
      var addReviewApi = await companyProfileController.addCompanyReviewApi(
        onErr: (msg) {
          SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
        },
      );
      if (addReviewApi) {
        reviewController.clear();
        companyProfileController.isEnable.value = false;
        companyProfileController.isAllCompanyDataLoaded.value = true;
        SnackBarUtil.showSnackBar(context: context, type: SnackType.success, message: AppStrings.reviewAddSuccessMessage);
        await companyProfileController.companyProfileApiCall();
      }
    }
  }
}
