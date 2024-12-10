import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_places_picker/google_places_picker.dart';
import 'package:iso_net/controllers/user/create_company_controller.dart';
import 'package:iso_net/controllers/user/detail_info_controller.dart';
import 'package:iso_net/ui/style/appbar_components.dart';
import 'package:iso_net/ui/style/button_components.dart';
import 'package:iso_net/ui/style/image_components.dart';
import 'package:iso_net/ui/style/text_style.dart';
import 'package:iso_net/ui/style/textfield_components.dart';
import 'package:iso_net/utils/app_common_stuffs/app_colors.dart';
import 'package:iso_net/utils/app_common_stuffs/app_images.dart';
import 'package:iso_net/utils/app_common_stuffs/commom_utils.dart';
import 'package:iso_net/utils/app_common_stuffs/snackbar_util.dart';
import 'package:iso_net/utils/app_common_stuffs/strings_constants.dart';
import 'package:iso_net/utils/app_common_stuffs/text_input_formatters.dart';
import 'package:iso_net/utils/extensions/sizedbox_extensions.dart';

import '../../utils/app_common_stuffs/app_logger.dart';
import '../../utils/app_common_stuffs/screen_routes.dart';

class CreateCompanyScreen extends StatefulWidget {
  const CreateCompanyScreen({Key? key}) : super(key: key);

  @override
  State<CreateCompanyScreen> createState() => _CreateCompanyScreenState();
}

class _CreateCompanyScreenState extends State<CreateCompanyScreen> {
  CreateCompanyController createCompanyController = Get.find<CreateCompanyController>();
  DetailInfoController detailInfoController = Get.find<DetailInfoController>();

  @override
  void initState() {
    createCompanyController.stateDropDownList2.value = detailInfoController.stateDropDownList;
    super.initState();
  }

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
      leadingWidget: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          color: AppColors.transparentColor,
          child: ImageComponent.loadLocalImage(
            imageName: AppImages.x,
          ),
        ),
      ),
    );
  }

  ///Scaffold body
  Widget buildBody() {
    return CommonUtils.constrainedBody(
      children: [
        detailsFormBody(),
        nextButtonBody(),
      ],
    );
  }

  ///Top title/heading
  Widget headingBody() {
    return CommonUtils.headingLabelBody(headingText: AppStrings.companyDetails);
  }

  ///detail text form body
  Widget detailsFormBody() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0.h, horizontal: 16.0.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headingBody(),
          companyNameTextFieldBody(),
          companyAddressTextFieldBody(),
          Row(
            children: [
              cityTextFieldBody(),
              8.sizedBoxW,
              stateTextFieldBody(),
            ],
          ),
          Row(
            children: [
              zipCodeTextFieldBody(),
              8.sizedBoxW,
              blankContainerBody(),
            ],
          ),
          phoneNumberTextFieldBody(),
          websiteTextFieldBody(),
          descriptionTextFieldBody(),
        ],
      ),
    );
  }

  ///company name text field body
  Widget companyNameTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.companyName, context: context),
        4.sizedBoxH,
        TextFieldComponents(
          context: context,
          hint: AppStrings.companyName,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          textInputFormatter: [
            NoLeadingSpaceFormatter(),
          ],
          onChanged: (value) {
            createCompanyController.companyNameChange.value = value;
            validateButton();
          },
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///company address text field body
  Widget companyAddressTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.address, context: context),
        4.sizedBoxH,
        GestureDetector(
          onTap: () {
            pickPlace();
          },
          child: TextFieldComponents(
            enable: false,
            textEditingController: createCompanyController.addressTextController,
            context: context,
            hint: AppStrings.address,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            textInputFormatter: [
              NoLeadingSpaceFormatter(),
              LengthLimitingTextInputFormatter(50),
            ],
            onChanged: (value) {
              createCompanyController.addressChange.value = createCompanyController.addressTextController.text;
              validateButton();
            },
          ),
        ),
        12.sizedBoxH,
      ],
    );
  }

  Future<void> pickPlace() async {
    createCompanyController.addressTextController.clear();
    Place place = await PluginGooglePlacePicker.showAutocomplete(
      mode: PlaceAutocompleteMode.MODE_OVERLAY,
    );

    if (place.address != null) Logger().d("===address========${place.address}");
    Logger().d("===address========${place.latitude} ${place.longitude}");
    createCompanyController.addressTextController.text = place.address!;
    List<Placemark> placemark = await placemarkFromCoordinates(place.latitude, place.longitude);

    createCompanyController.latitude = place.latitude;
    createCompanyController.longitude = place.longitude;
    Logger().d("===address========${createCompanyController.latitude} ${createCompanyController.longitude}");

    Logger().i(placemark[0].country);

    createCompanyController.cityTextController.text = placemark[0].locality!;
    createCompanyController.stateTextController.text = placemark[0].administrativeArea!;
    createCompanyController.zipCodeTextController.text = placemark[0].postalCode!;
    setState(() {});
  }

  ///city text field
  Widget cityTextFieldBody() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldComponents.buildLabelForTextField(text: AppStrings.city, context: context),
          4.sizedBoxH,
          TextFieldComponents(
            textEditingController: createCompanyController.cityTextController,
            context: context,
            hint: AppStrings.city,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            textInputFormatter: [
              NoLeadingSpaceFormatter(),
              FilteringTextInputFormatter.allow(
                RegExp(r"[a-zA-Z]+|\s"),
              ),
              LengthLimitingTextInputFormatter(20),
            ],
            onChanged: (value) {
              createCompanyController.cityChange.value = createCompanyController.cityTextController.text;
              validateButton();
            },
          ),
          12.sizedBoxH,
        ],
      ),
    );
  }

  ///state text field
  Widget stateTextFieldBody() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldComponents.buildLabelForTextField(text: AppStrings.state, context: context),
          4.sizedBoxH,
          TextFieldComponents(
            textEditingController: createCompanyController.stateTextController,
            context: context,
            hint: AppStrings.state,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            textInputFormatter: [
              NoLeadingSpaceFormatter(),
              FilteringTextInputFormatter.allow(
                RegExp(r"[a-zA-Z]+|\s"),
              ),
              LengthLimitingTextInputFormatter(20),
            ],
            onChanged: (value) {
              createCompanyController.stateChange.value = createCompanyController.stateTextController.text;
              validateButton();
            },
          ),
          12.sizedBoxH,
        ],
      ),
    );
  }

  ///zip code text field
  Widget zipCodeTextFieldBody() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldComponents.buildLabelForTextField(text: AppStrings.zipCode, context: context),
          4.sizedBoxH,
          TextFieldComponents(
            textEditingController: createCompanyController.zipCodeTextController,
            context: context,
            hint: AppStrings.zipCode,
            keyboardType: TextInputType.text,
            textInputFormatter: [
              NoLeadingSpaceFormatter(),
              LengthLimitingTextInputFormatter(5),
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              createCompanyController.zipCodeChange.value = createCompanyController.zipCodeTextController.text;
              validateButton();
            },
          ),
          12.sizedBoxH,
        ],
      ),
    );
  }

  ///blank container text field
  Widget blankContainerBody() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          12.sizedBoxH,
        ],
      ),
    );
  }

  ///phone number text field
  Widget phoneNumberTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.phoneNumber, context: context),
        4.sizedBoxH,
        TextFieldComponents(
          context: context,
          hint: AppStrings.phoneNumber,
          keyboardType: TextInputType.phone,
          textInputFormatter: [
            LengthLimitingTextInputFormatter(14),
            FilteringTextInputFormatter.digitsOnly,
            PhoneNumberTextInputFormatter(),
          ],
          onChanged: (value) {
            createCompanyController.phoneNumberChange.value = value;
            validateButton();
          },
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///website text field
  Widget websiteTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.website, context: context),
        4.sizedBoxH,
        TextFieldComponents(
          context: context,
          hint: AppStrings.website,
          keyboardType: TextInputType.url,
          textInputFormatter: [
            NoLeadingSpaceFormatter(),
            FilteringTextInputFormatter.deny(
              RegExp(r'\s'),
            ),
          ],
          onChanged: (value) {
            createCompanyController.websiteChange.value = value;
          },
        ),
        12.sizedBoxH,
      ],
    );
  }

  ///description text Field
  Widget descriptionTextFieldBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldComponents.buildLabelForTextField(text: AppStrings.description, context: context),
        4.sizedBoxH,
        TextFieldComponents(
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            textInputFormatter: [
              NoLeadingSpaceFormatter(),
              LengthLimitingTextInputFormatter(250),
            ],
            maxLines: 6,
            context: context,
            hint: AppStrings.description,
            onChanged: (value) {
              createCompanyController.descriptionChange.value = value;
              validateButton();
            }),
      ],
    );
  }

  /// next button body
  Widget nextButtonBody() {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 16.0.h),
        child: ButtonComponents.cupertinoButton(
          width: double.infinity,
          context: context,
          title: AppStrings.bNext,
          backgroundColor: createCompanyController.isButtonEnable.value ? AppColors.primaryColor : AppColors.disableButtonColor,
          textStyle: createCompanyController.isButtonEnable.value
              ? ISOTextStyles.openSenseSemiBold(size: 17, color: AppColors.blackColor)
              : ISOTextStyles.openSenseRegular(size: 17, color: AppColors.disableTextColor),
          onTap: () {

            handleNextButtonPress();
          },
        ),
      ),
    );
  }

  /// Function on next button will go here
  handleNextButtonPress() {
    var validationResult = createCompanyController.isValidCreateCompanyFormForDetails(
        state: createCompanyController.stateTextController.text,
        city: createCompanyController.cityTextController.text,
        zipCode: createCompanyController.zipCodeTextController.text,
        address: createCompanyController.addressTextController.text);
    if (!validationResult.item1) {
      SnackBarUtil.showSnackBar(context: context, type: SnackType.error, message: validationResult.item2);
    } else {
      createCompanyController.phoneNoForApi.value = CommonUtils.convertToPhoneNumber(updatedStr: createCompanyController.phoneNumberChange.value);
      Get.toNamed(ScreenRoutesConstants.companyImageScreen);
    }
  }

  ///validate button function
  validateButton() {
    createCompanyController.validateButton(
        address: createCompanyController.addressTextController.text,
        city: createCompanyController.cityTextController.text,
        state: createCompanyController.stateTextController.text,
        zipCode: createCompanyController.zipCodeTextController.text);
  }
}
