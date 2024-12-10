import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfo {
  static Future<String?> getDeviceId() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String? deviceId;

    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor;
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      if (kDebugMode) {
        print("Android Device info ${androidDeviceInfo.model}");
      }
      if (kDebugMode) {
        print(
          "Android Device info ${androidDeviceInfo.model} and Android version: ${androidDeviceInfo.version} and Android deviceID: ${androidDeviceInfo.id}");
      }
      deviceId = androidDeviceInfo.id;
    }
    return deviceId;
  }
}