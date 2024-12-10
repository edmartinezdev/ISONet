

import 'package:get/get.dart';

class InterestChipListModel {
  int? pk;
  String? tagName;
  RxBool isSelected = false.obs;

  InterestChipListModel({this.pk, this.tagName});

  InterestChipListModel.fromJson(Map<String, dynamic> json) {
    pk = json['pk'];
    tagName = json['tag_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pk'] = pk;
    data['tag_name'] = tagName;
    return data;
  }
}
