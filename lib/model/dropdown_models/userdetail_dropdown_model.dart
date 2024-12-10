class StatesDropDown{
  int? stateId;
  String? stateName;
  String? stateAlias;
  StatesDropDown({this.stateId,this.stateName,this.stateAlias});
}



class ExperienceDropDownModel {
  int? id;
  String? expName;
  int? expValue;
  String? expType;
  String? createdAt;
  String? updatedAt;

  ExperienceDropDownModel({this.id, this.expName,this.expValue,this.expType, this.createdAt, this.updatedAt});

  ExperienceDropDownModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    expName = json['exp_name'];
    expValue = json['exp_value'];
    expType = json['exp_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['exp_name'] = expName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
