import 'dart:io';

import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';

import '../../utils/app_common_stuffs/commom_utils.dart';

class UserProfileImageController extends GetxController {
  ///********* variables declaration ********///
  Rxn<XFile> profileImage = Rxn<XFile>();
  ImagePicker imagePicker = ImagePicker();
  var file = <File>[].obs;
  ///*******************************************



  void convertXFile() async {
    var size = CommonUtils.calculateFileSize(File(profileImage.value!.path ));
    if (size > 2) {
      final File files = await CommonUtils.compressImage(image: File(profileImage.value!.path));
      file.add(await FlutterExifRotation.rotateImage(
        path: files.path,
      ));
    } else {
      file.add(await FlutterExifRotation.rotateImage(
        path: profileImage.value!.path ,
      ));
    }
    Logger().i('UserProfilePath ==== $file');
  }
}
