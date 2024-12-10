import 'package:get/get.dart';

class DropDownModel {
  int? id;
  String? companyName;
  String? experience;
  RxBool isChecked = false.obs;

  DropDownModel({this.companyName, this.id, this.experience});

  // @override
  // String toString() {
  //   return companyName ?? '';
  // }
}

class UserInterestModel {

  String? userInterest;

  RxBool isChecked = false.obs;

  UserInterestModel({this.userInterest,});

// @override
// String toString() {
//   return companyName ?? '';
// }
}