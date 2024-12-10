import 'dart:io';

import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


import '../../helper_manager/network_manager/api_const.dart';
import '../../helper_manager/network_manager/remote_service.dart';

import '../../model/response_model/responese_datamodel.dart';
import '../../singelton_class/auth_singelton.dart';
import '../../ui/style/showloader_component.dart';
import '../../utils/app_common_stuffs/app_logger.dart';
import '../../utils/app_common_stuffs/commom_utils.dart';


class CompanyImageController extends GetxController {
  ///********* variables declaration ********///
  Rxn<XFile> companyBackgroundImage = Rxn<XFile>();

  var file = <File>[].obs;
  var percentageIndicatorValue = Rxn();

  ///*******************************************

  ///***** convert XFile to file function
  void convertXFile() async {
    var size = CommonUtils.calculateFileSize(File(companyBackgroundImage.value!.path));
    if (size > 2) {
      final File files = await CommonUtils.compressImage(image: File(companyBackgroundImage.value!.path));
      file.add(await FlutterExifRotation.rotateImage(
        path: files.path,
      ));
    } else {
      file.add(File(companyBackgroundImage.value?.path ?? ''));
    }
    Logger().i('companyImage ==== $file');
  }

  apiCallCreateBrokerCompany(
      {required String companyName,
      required String address,
      required String city,
      required String state,
      required String zipcode,
      required String phoneNumber,
      required String website,
      required String description,
      required String latitude,
      required String longitude,
      bool isSkip = false,
      Function(double value)? percentage,
      required onErr}) async {
    if(isSkip){
      ShowLoaderDialog.showLoaderDialog(Get.context!);
    }else{
      ShowLoaderDialog.showLinearProgressIndicatorForFileUpload(context:Get.context!);
    }

    Map<String, dynamic> requestParams = {
      'company_name': companyName,
      'address': address,
      'city': city,
      'state': state,
      'zipcode': zipcode,
      'phone_number': phoneNumber,
      'website': website,
       if(description.isNotEmpty || description != '')
         'description': description,
      'latitude': latitude,
      'longitude': longitude,
    };
    ResponseModel<UserModel>  responseModel = await sharedServiceManager.uploadRequest(
      ApiType.createCompanyBroker,
      params: requestParams,
      arrFile: isSkip == true
          ? []
          : [
              AppMultiPartFile(localFiles: file, key: 'company_image'),
            ],
      onFileUpload: (double progress) {
        if (percentage != null) {
          percentage(progress);
          percentageIndicatorValue.value = progress;
        } else {
          return null;
        }
      },
    );
    ShowLoaderDialog.dismissLoaderDialog();
    if (responseModel.status == ApiConstant.statusCodeSuccess) {
      await userSingleton.updateValue(
        responseModel.data?.toJson() ?? <String, dynamic>{},
      );

      ///***** Api Success *****//
      return true;
    } else {
      ///***** Api Error *****//
      onErr(responseModel.message);
      return false;
    }
  }
}
