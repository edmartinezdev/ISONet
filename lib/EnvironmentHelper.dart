import 'package:iso_net/utils/app_common_stuffs/app_logger.dart';

class EnvironmentHelper {
  Map<String, dynamic> environmentMap = {};

  factory EnvironmentHelper() {
    return _singleton;
  }

  EnvironmentHelper._internal() {
    Logger().v("Instance created Environmenthelper");
  }

  static final EnvironmentHelper _singleton = EnvironmentHelper._internal();
}
