import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iso_net/controllers/user/company_image_controller.dart';
import 'package:iso_net/controllers/user/create_company_controller.dart';
import 'package:iso_net/controllers/user/detail_info_controller.dart';
import 'package:iso_net/singelton_class/auth_singelton.dart';
import 'package:iso_net/ui/style/button_components.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/screen_routes.dart';

import '../../helper_manager/media_selector_manager/media_selector_manager.dart';
import '../../utils/app_common_stuffs/app_images.dart';
import '../../utils/app_common_stuffs/commom_utils.dart';
import '../../utils/app_common_stuffs/snackbar_util.dart';
import '../../utils/app_common_stuffs/strings_constants.dart';
import '../style/appbar_components.dart';
import '../style/text_style.dart';

class CompanyImageScreen extends StatefulWidget {
  const CompanyImageScreen({Key? key}) : super(key: key);

  @override
  State<CompanyImageScreen> createState() => _CompanyImageScreenState();
}

class _CompanyImageScreenState extends State<CompanyImageScreen> {
  CompanyImageController companyImageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarBody(),
      body: CommonUtils.constrainedBody(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              headingBody(),
              selectCompanyImageBody(),
            ],
          ),
          nextButtonBody(),
        ],
      ),
    );
  }

  ///Appbar
  PreferredSizeWidget appBarBody() {
    return AppBarComponents.appBar(
    actionWidgets: [
      Align(alignment: Alignment.center,child: skipButton()),
    ],
    );
  }


  /// Skip button body
  Widget skipButton() {
    return GestureDetector(
      onTap: () async{
       handleNextButtonPress(isSkip: true);
      },
      child: Container(
        color: AppColors.transparentColor,
        padding: EdgeInsets.symmetric(
          horizontal: 12.0.w,
        ),
        child: Text(
          userSingleton.userType == AppStrings.fu ? AppStrings.skip : '${AppStrings.skip} & ${AppStrings.createCompanyProfile}',
          style: ISOTextStyles.openSenseRegular(size: 14, color: AppColors.disableTextColor),
        ),
      ),
    );

  }

  ///title-heading body
  Widget headingBody() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0.h, horizontal: 16.0.w),
      child: CommonUtils.headingLabelBody(headingText: AppStrings.companyImage),
    );
  }

  ///select Company image widget
  Widget selectCompanyImageBody() {
    return Obx(
      () => GestureDetector(
        onTap: () {
          onTapImage();
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0.w),
          //height: 212.h,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyColor),
            borderRadius: BorderRadius.circular(10.0.r),
            color: AppColors.transparentColor,
          ),
          width: double.infinity,
          child: companyImageController.companyBackgroundImage.value == null
              ? ImageComponent.loadLocalImage(
                  imageName: AppImages.imageUpload,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10.0.r),
                  child: Image.file(
                    File(
                      companyImageController.companyBackgroundImage.value!.path,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ),
    );
  }

  ///onTap Select company profile image function
  onTapImage() {
    MediaSelectorManager.chooseProfileImage(
      imageSource: ImageSource.gallery,
      profileImage: companyImageController.companyBackgroundImage,
      context: context,
    );
  }

  ///Next ButtonBody
  Widget nextButtonBody() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(vertical: 16.0.h, horizontal: 16.0.w),
        child: ButtonComponents.cupertinoButton(
            context: context,
            title: userSingleton.userType == AppStrings.fu ? AppStrings.bNext : AppStrings.createCompanyProfile,
            backgroundColor: companyImageController.companyBackgroundImage.value == null ? AppColors.disableButtonColor : AppColors.primaryColor,
            textStyle: companyImageController.companyBackgroundImage.value == null
                ? ISOTextStyles.openSenseRegular(size: 17, color: AppColors.disableTextColor)
                : ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.blackColor),
            onTap: () {
              handleNextButtonPress(isSkip: false);
            },
            width: double.infinity),
      ),
    );
  }

  ///on next button function
  ///1.if user not select any image then button is disable & onTap function show error snackBar
  ///2.First check user added image then after button enable
  handleNextButtonPress({bool isSkip = false}) async {
    if (companyImageController.companyBackgroundImage.value == null && isSkip == false) {
      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: AppStrings.validateCompanyImage);
    } else {
      /*companyImageController.convertXFile();*/
      if(companyImageController.file.isNotEmpty && isSkip == false){

        companyImageController.file.value = await CommonUtils.convertXFileSingle(imageFile: companyImageController.companyBackgroundImage.value!);
      }else{
        companyImageController.file.value = [];
      }

      if (userSingleton.userType == AppStrings.fu) {
        Get.toNamed(ScreenRoutesConstants.loanPreferenceScreen);
      } else {
        CreateCompanyController createCompanyController = Get.find<CreateCompanyController>();

        var createCompApiResult = await companyImageController.apiCallCreateBrokerCompany(
            companyName: createCompanyController.companyNameChange.value,
            address: createCompanyController.addressTextController.text,
            city: createCompanyController.cityTextController.text,
            state: createCompanyController.stateTextController.text,
            zipcode: createCompanyController.zipCodeTextController.text,
            phoneNumber: createCompanyController.phoneNoForApi.value,
            website: createCompanyController.websiteChange.value,
            description: createCompanyController.descriptionChange.value,

            isSkip: isSkip,
            onErr: (msg) {
              SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: msg);
            },
            longitude: "${createCompanyController.longitude}",
            latitude: '${createCompanyController.latitude}');
        if (createCompApiResult) {
          DetailInfoController detailInfoController = Get.find<DetailInfoController>();
          await detailInfoController.detailInfoApiCall();
          userSingleton.loadUserData();
          Get.until((route) => route.settings.name == ScreenRoutesConstants.detailScreen);
        }
      }
    }
  }
}
