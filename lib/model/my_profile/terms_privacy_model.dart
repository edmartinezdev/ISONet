class TermsPrivacyModel{
  String? cmsText;

  TermsPrivacyModel({this.cmsText});

  TermsPrivacyModel.fromJson(Map<String,dynamic> json){
    cmsText = json['cms_text'];
  }
}