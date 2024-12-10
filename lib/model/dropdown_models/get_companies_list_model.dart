class GetCompaniesListModel {
  int? id;
  String? companyName;
  String? address;
  String? city;
  String? state;
  String? zipcode;
  String? phoneNumber;
  String? website;
  String? description;
  String? companyImage;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  int? creditScore;
  String? minMonthlyRev;
  int? minTimeBusiness;
  int? nsfId;
  String? maxFundAmount;
  int? maxTermLength;
  String? buyingRates;
  int? maxUpsellPoints;
  List<int>? restrIndusties;
  List<int>? restrState;
  List<int>? prefIndustries;

  GetCompaniesListModel(
      {this.id,
      this.companyName,
      this.address,
      this.city,
      this.state,
      this.zipcode,
      this.phoneNumber,
      this.website,
      this.description,
      this.companyImage,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.creditScore,
      this.minMonthlyRev,
      this.minTimeBusiness,
      this.nsfId,
      this.maxFundAmount,
      this.maxTermLength,
      this.buyingRates,
      this.maxUpsellPoints,
      this.restrIndusties,
      this.restrState,
      this.prefIndustries});

  GetCompaniesListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyName = json['company_name'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
    phoneNumber = json['phone_number'];
    website = json['website'];
    description = json['description'];
    companyImage = json['company_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    createdBy = json['created_by'];
    creditScore = json['credit_score'];
    minMonthlyRev = json['min_monthly_rev'];
    minTimeBusiness = json['min_time_business'];
    nsfId = json['nsf_id'];
    maxFundAmount = json['max_fund_amount'];
    maxTermLength = json['max_term_length'];
    buyingRates = json['buying_rates'];
    maxUpsellPoints = json['max_upsell_points'];
    restrIndusties = json['restr_industies'].cast<int>();
    restrState = json['restr_state'].cast<int>();
    prefIndustries = json['pref_industries'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_name'] = companyName;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['zipcode'] = zipcode;
    data['phone_number'] = phoneNumber;
    data['website'] = website;
    data['description'] = description;
    data['company_image'] = companyImage;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['created_by'] = createdBy;
    data['credit_score'] = creditScore;
    data['min_monthly_rev'] = minMonthlyRev;
    data['min_time_business'] = minTimeBusiness;
    data['nsf_id'] = nsfId;
    data['max_fund_amount'] = maxFundAmount;
    data['max_term_length'] = maxTermLength;
    data['buying_rates'] = buyingRates;
    data['max_upsell_points'] = maxUpsellPoints;
    data['restr_industies'] = restrIndusties;
    data['restr_state'] = restrState;
    data['pref_industries'] = prefIndustries;
    return data;
  }
}
