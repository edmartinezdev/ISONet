import 'dart:ui';

import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<void> checkPermissions({
    required Permission permission,
    VoidCallback? onGranted,
    VoidCallback? onLimited,
    VoidCallback? onDenied,
    VoidCallback? onPermanentlyDenied,
    Function(PermissionStatus status)? onOtherStatus,
  }) async {
    PermissionStatus permissionStatus = await permission.status;
    if (permissionStatus == PermissionStatus.granted) {
      if (onGranted != null) onGranted();
    } else if (permissionStatus == PermissionStatus.limited) {
      if (onLimited != null) onLimited();
    } else {
      final status = await permission.request();
      if (status == PermissionStatus.granted) {
        if (onGranted != null) onGranted();
      } else if (status == PermissionStatus.limited) {
        if (onLimited != null) onLimited();
      } else if (status == PermissionStatus.denied) {
        if (onDenied != null) onDenied();
      } else if (status == PermissionStatus.permanentlyDenied) {
        if (onPermanentlyDenied != null) onPermanentlyDenied();
      } else {
        if (onOtherStatus != null) onOtherStatus(status);
      }
    }
  }
}
