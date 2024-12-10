import 'package:get/get.dart';

class CreditRequirementModel {
  int? id;
  String? reqScore;
  String? createdAt;
  String? updatedAt;

  CreditRequirementModel({this.id, this.reqScore, this.createdAt, this.updatedAt});

  CreditRequirementModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reqScore = json['req_score'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['req_score'] = reqScore;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class MinimumMonthRevenueListModel {
  int? id;
  String? revenue;
  String? createdAt;
  String? updatedAt;

  MinimumMonthRevenueListModel({this.id, this.revenue, this.createdAt, this.updatedAt});

  MinimumMonthRevenueListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    revenue = json['revenue'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['revenue'] = revenue;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class MinimumTimeListModel {
  int? id;
  String? bussinessTime;
  String? createdAt;
  String? updatedAt;

  MinimumTimeListModel({this.id, this.bussinessTime, this.createdAt, this.updatedAt});

  MinimumTimeListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bussinessTime = json['bussiness_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bussiness_time'] = bussinessTime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}



class GetAllIndustryListModel {
  int? id;
  String? industryName;
  String? createdAt;
  String? updatedAt;
  RxBool isPrefIndustryChecked = false.obs;
  RxBool isResIndustryChecked = false.obs;

  GetAllIndustryListModel({this.id, this.industryName, this.createdAt, this.updatedAt});

  GetAllIndustryListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    industryName = json['industry_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['industry_name'] = industryName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}


class MinimumNSFListModel {
  int? id;
  int? nsfCount;
  String? createdAt;
  String? updatedAt;

  MinimumNSFListModel({this.id, this.nsfCount, this.createdAt, this.updatedAt});

  MinimumNSFListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nsfCount = json['nsf_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nsf_count'] = nsfCount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class GetStatesListModel {
  int? id;
  String? stateName;
  String? createdAt;
  String? updatedAt;
  RxBool isStateChecked = false.obs;

  GetStatesListModel({this.id, this.stateName, this.createdAt, this.updatedAt});

  GetStatesListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stateName = json['state_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['state_name'] = stateName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class MaxFundingAmountListModel {
  int? id;
  String? fundingAmount;
  String? createdAt;
  String? updatedAt;

  MaxFundingAmountListModel({this.id, this.fundingAmount, this.createdAt, this.updatedAt});

  MaxFundingAmountListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fundingAmount = json['funding_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['funding_amount'] = fundingAmount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class MaxTermLengthListModel {
  int? id;
  int? maxTerm;
  String? type;
  String? createdAt;
  String? updatedAt;

  MaxTermLengthListModel({this.id, this.maxTerm, this.type,this.createdAt, this.updatedAt});

  MaxTermLengthListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    maxTerm = json['max_term'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['max_term'] = maxTerm;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class StartingBuyRatesListModel {
  int? id;
  String? maxBuyRates;
  String? createdAt;
  String? updatedAt;

  StartingBuyRatesListModel({this.id, this.maxBuyRates, this.createdAt, this.updatedAt});

  StartingBuyRatesListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    maxBuyRates = json['max_buy_rates'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['max_buy_rates'] = maxBuyRates;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class MaxUpSellPointsListModel {
  int? id;
  String? sellPoints;
  String? createdAt;
  String? updatedAt;

  MaxUpSellPointsListModel({this.id, this.sellPoints, this.createdAt, this.updatedAt});

  MaxUpSellPointsListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sellPoints = json['sell_points'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sell_points'] = sellPoints;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
