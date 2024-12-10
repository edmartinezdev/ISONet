import 'package:get/get.dart';

class SubscribtionPlanModel {
  int? id;
  String? type;
  String? price;
  String? description;
  int? totalDays;
  int? offerValue;
  String? plan;
  String? savePercentage;
  String? createdAt;
  String? updatedAt;
  RxBool isCardSelected = false.obs;


  SubscribtionPlanModel(
      {this.id,
        this.type,
        this.price,
        this.description,
        this.totalDays,
        this.offerValue,
        this.plan,
        this.savePercentage,
        this.createdAt,
        this.updatedAt,
     });

  SubscribtionPlanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    price = json['price'];
    description = json['description'];
    totalDays = json['totalDays'];
    offerValue = json['offer_value'];
    plan = json['plan'] ;

    savePercentage = json['save_percentage'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['price'] = price;
    data['description'] = description;
    data['totalDays'] = totalDays;
    data['offer_value'] = offerValue;
    data['plan'] = plan;
    data['save_percentage'] = savePercentage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
